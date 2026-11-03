import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../app/settings.dart';
import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import '../prepare/inventory.dart';
import '../prepare/supply_checklist.dart';

/// Scorte: una sola pagina con tutto quello che serve sapere.
/// - Casa: fabbisogno (persone × giorni), le quattro quantità che decidono quanti giorni si resiste
///   (ognuna con le sue voci, da aggiornare con + e −) e la lista sì/no delle cose da avere.
/// - Zaino: per ogni cosa, se è già dentro, se si prende da casa al momento di uscire o se manca.
/// Cosa manca si vede con il filtro "Cosa manca" e si copia come lista della spesa.
class SuppliesScreen extends StatefulWidget {
  const SuppliesScreen({super.key, this.backpack = false});

  /// Apre direttamente la scheda Zaino.
  final bool backpack;

  @override
  State<SuppliesScreen> createState() => _SuppliesScreenState();
}

class _SuppliesScreenState extends State<SuppliesScreen> {
  final inv = Inventory.instance;
  late final Future<SupplyChecklist> _checklist = SupplyChecklist.load();
  bool _onlyMissing = false;
  final _open = <Need>{};

  @override
  void initState() {
    super.initState();
    inv.load();
  }

  String get _lang => AppSettings.instance.language;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DefaultTabController(
      length: 2,
      initialIndex: widget.backpack ? 1 : 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.suppliesTitle),
          actions: [
            FutureBuilder<SupplyChecklist>(
              future: _checklist,
              builder: (context, snap) => IconButton(
                icon: const Icon(Icons.shopping_cart),
                tooltip: t.copyShopping,
                onPressed: snap.data == null ? null : () => _copyShopping(t, snap.data!),
              ),
            ),
          ],
          bottom: TabBar(tabs: [
            Tab(icon: const Icon(Icons.home), text: t.suppliesHome),
            Tab(icon: const Icon(Icons.backpack), text: t.suppliesBackpack),
          ]),
        ),
        body: FutureBuilder<SupplyChecklist>(
          future: _checklist,
          builder: (context, snap) => ListenableBuilder(
            listenable: inv,
            builder: (context, _) {
              final c = snap.data;
              if (!inv.loaded || c == null) return const Center(child: CircularProgressIndicator());
              return TabBarView(children: [_home(context, t, c), _bag(context, t, c)]);
            },
          ),
        ),
      ),
    );
  }

  Widget _filter(AppLocalizations t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: SegmentedButton<bool>(
          segments: [
            ButtonSegment(value: false, label: Text(t.filterAll), icon: const Icon(Icons.list)),
            ButtonSegment(value: true, label: Text(t.filterMissing), icon: const Icon(Icons.shopping_cart)),
          ],
          selected: {_onlyMissing},
          onSelectionChanged: (v) => setState(() => _onlyMissing = v.first),
        ),
      );

  // ---- Casa ----

  Widget _home(BuildContext context, AppLocalizations t, SupplyChecklist c) {
    final nf = NumberFormat.decimalPattern(_lang);
    final needs = [for (final n in Need.values) _needInfo(t, n, nf)];
    final shown = _onlyMissing ? needs.where((n) => n.missing != null).toList() : needs;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      children: [
        Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(children: [
              _Stepper(label: t.people, value: inv.people, min: 1, max: 30, onChanged: (v) => inv.setNeeds(people: v)),
              _Stepper(label: t.days, value: inv.days, min: 1, max: 365, onChanged: (v) => inv.setNeeds(days: v)),
            ]),
          ),
        ),
        _filter(t),
        _Section(t.suppliesQuantities),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(t.suppliesQuantitiesHint, style: const TextStyle(color: Colors.white60)),
        ),
        if (shown.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(t.quantitiesEnough, style: const TextStyle(color: Colors.lightGreen)),
          ),
        for (final n in shown)
          _NeedCard(
            info: n,
            nf: nf,
            open: _open.contains(n.need),
            onToggle: () => setState(() => _open.contains(n.need) ? _open.remove(n.need) : _open.add(n.need)),
            items: inv.items.where((i) => needPresets(n.need).contains(i.preset)).toList(),
            onAdd: () => _addItem(context, t, n.need),
            onEdit: (item) => _editItem(context, t, item),
          ),
        const SizedBox(height: 16),
        _Section('${t.suppliesHaveTitle} · ${t.doneOf(c.homeDone(inv), c.homeTotal(inv))}'),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(t.suppliesHaveHint, style: const TextStyle(color: Colors.white60)),
        ),
        for (final g in c.home) _homeGroup(context, t, c, g),
        const SizedBox(height: 12),
        Text(t.suppliesNote, style: const TextStyle(color: Colors.white54)),
      ],
    );
  }

  Widget _homeGroup(BuildContext context, AppLocalizations t, SupplyChecklist c, CheckGroup g) {
    final own = inv.ownHome.where((o) => o.group == g.id).toList();
    final done = g.items.where((i) => c.atHome(inv, i)).length + own.where((o) => o.have).length;
    final total = g.items.length + own.length;
    final items = _onlyMissing ? g.items.where((i) => !c.atHome(inv, i)).toList() : g.items;
    final owns = _onlyMissing ? own.where((o) => !o.have).toList() : own;
    if (_onlyMissing && items.isEmpty && owns.isEmpty) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        key: PageStorageKey('home-${g.id}-$_onlyMissing'),
        initiallyExpanded: _onlyMissing,
        shape: const Border(),
        title: Text(g.name(_lang), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        trailing: _GroupCount(done: done, total: total, t: t),
        children: [
          for (final i in items)
            CheckboxListTile(
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              value: c.atHome(inv, i),
              title: Text(i.label(_lang), style: const TextStyle(fontSize: 16)),
              subtitle: c.onlyInBag(inv, i) ? Text(t.inBag, style: const TextStyle(color: kAccent)) : null,
              onChanged: (v) {
                if (c.onlyInBag(inv, i) && v == false) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.inBagChange)));
                  return;
                }
                inv.setHave(i.id, v ?? false, bagRefs: c.bagRefs(i.id));
              },
            ),
          for (final o in owns)
            CheckboxListTile(
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              value: o.have,
              title: Text(_ownName(t, o), style: const TextStyle(fontSize: 16)),
              secondary: IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                tooltip: t.delete,
                onPressed: () => inv.removeOwn(o),
              ),
              onChanged: (v) => inv.updateOwn(o, have: v ?? false),
            ),
          if (!_onlyMissing)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: Text(t.addOwnItem),
                onPressed: () => _addOwn(context, t, inBag: false, group: g.id),
              ),
            ),
        ],
      ),
    );
  }

  // ---- Zaino ----

  Widget _bag(BuildContext context, AppLocalizations t, SupplyChecklist c) {
    final grab = c.beforeLeaving(inv, _lang);
    final checked = inv.bagChecked;
    final due = checked == null || DateTime.now().difference(checked).inDays > 182;
    final df = DateFormat.yMd(_lang);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      children: [
        _filter(t),
        Text(t.bagLegend, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 10),
        Card(
          color: kAccent.withValues(alpha: 0.12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.directions_run, color: kAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(t.beforeLeaving, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                ),
              ]),
              const SizedBox(height: 6),
              for (final g in [...grab, t.beforeLeavingAlways])
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text('• $g', style: const TextStyle(fontSize: 16)),
                ),
            ]),
          ),
        ),
        const SizedBox(height: 8),
        _Section('${t.suppliesBackpack} · ${t.bagReady(c.bagDone(inv), c.bagTotal(inv))}'),
        for (final g in c.bag) _bagGroup(context, t, c, g),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: Icon(Icons.event_repeat, color: due ? kAccent : Colors.lightGreen),
            title: Text(t.bagCheckTitle),
            subtitle: Text(t.bagCheckBody(checked == null ? t.bagCheckNever : df.format(checked))),
            trailing: TextButton(onPressed: inv.markBagChecked, child: Text(t.bagCheckDone)),
          ),
        ),
      ],
    );
  }

  Widget _bagGroup(BuildContext context, AppLocalizations t, SupplyChecklist c, CheckGroup g) {
    final own = inv.ownBag.where((o) => o.group == g.id).toList();
    final done = g.items.where((i) => c.bagState(inv, i) != null).length + own.where((o) => o.bag != null).length;
    final total = g.items.length + own.length;
    final items = _onlyMissing ? g.items.where((i) => c.bagState(inv, i) == null).toList() : g.items;
    final owns = _onlyMissing ? own.where((o) => o.bag == null).toList() : own;
    if (_onlyMissing && items.isEmpty && owns.isEmpty) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        key: PageStorageKey('bag-${g.id}-$_onlyMissing'),
        initiallyExpanded: _onlyMissing,
        shape: const Border(),
        title: Text(g.name(_lang), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        trailing: _GroupCount(done: done, total: total, t: t),
        children: [
          for (final i in items)
            _BagRow(
              label: i.label(_lang),
              state: c.bagState(inv, i),
              canTakeFromHome: c.canTakeFromHome(inv, i),
              note: c.canTakeFromHome(inv, i) ? null : t.bagNoPowerBank,
              t: t,
              onChanged: (s) => inv.setBag(i.id, s, homeRef: i.home),
            ),
          for (final o in owns)
            _BagRow(
              label: _ownName(t, o),
              state: o.bag,
              canTakeFromHome: true,
              t: t,
              onChanged: (s) => inv.updateOwn(o, bag: s, clearBag: s == null),
              onDelete: () => inv.removeOwn(o),
            ),
          if (!_onlyMissing)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: Text(t.addOwnItem),
                onPressed: () => _addOwn(context, t, inBag: true, group: g.id),
              ),
            ),
        ],
      ),
    );
  }

  String _ownName(AppLocalizations t, OwnItem o) => o.name ?? presetName(t, o.preset ?? '');

  Future<void> _addOwn(BuildContext context, AppLocalizations t, {required bool inBag, required String group}) async {
    final name = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(t.addOwnItem),
        content: TextField(
          controller: name,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(labelText: t.itemName),
          onSubmitted: (_) => Navigator.pop(c, true),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(t.cancel)),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(t.save)),
        ],
      ),
    );
    if (ok == true && name.text.trim().isNotEmpty) inv.addOwn(inBag: inBag, group: group, name: name.text.trim());
    name.dispose();
  }

  // ---- Quantità ----

  _NeedInfo _needInfo(AppLocalizations t, Need n, NumberFormat nf) {
    // Con un decimale quando serve: 0,5 L non deve diventare "1 L".
    final nf1 = NumberFormat('#,##0.#', _lang);
    return switch (n) {
      Need.water => _NeedInfo(
          n,
          '${nf1.format(inv.waterLiters)} / ${nf1.format(inv.waterNeeded)} L',
          inv.waterLiters / inv.waterNeeded,
          inv.waterDays(),
          inv.waterLiters >= inv.waterNeeded
              ? null
              : t.missingWater(nf1.format(inv.waterNeeded - inv.waterLiters), ((inv.waterNeeded - inv.waterLiters) / 1.5).ceil()),
        ),
      Need.food => _NeedInfo(
          n,
          '${nf.format(inv.kcal.round())} / ${nf.format(inv.kcalNeeded.round())} kcal',
          inv.kcal / inv.kcalNeeded,
          inv.foodDays(),
          inv.kcal >= inv.kcalNeeded
              ? null
              : t.missingFood(
                  nf.format((inv.kcalNeeded - inv.kcal).ceil()), nf.format(((inv.kcalNeeded - inv.kcal) / 3600 * 2).ceil() / 2)),
        ),
      Need.cooking => _NeedInfo(
          n,
          t.mealsHave(inv.gasMeals.floor(), inv.mealsNeeded.round()),
          inv.gasMeals / inv.mealsNeeded,
          inv.gasDays(),
          inv.gasMeals >= inv.mealsNeeded ? null : t.missingGas(((inv.mealsNeeded - inv.gasMeals) / kMealsPerCartridge).ceil()),
        ),
      Need.electricity => _NeedInfo(
          n,
          t.chargesHave(inv.phoneCharges.floor(), inv.chargesNeeded.round()),
          inv.phoneCharges / inv.chargesNeeded,
          inv.chargeDays(),
          inv.phoneCharges >= inv.chargesNeeded
              ? null
              : t.missingCharges((inv.chargesNeeded - inv.phoneCharges).ceil(),
                  ((inv.chargesNeeded - inv.phoneCharges) / Inventory.chargesPer10k).ceil()),
          note: t.electricityBasis,
        ),
    };
  }

  /// Lista della spesa: quantità che mancano, cose da avere in casa e nello zaino. Ogni cosa una volta sola.
  void _copyShopping(AppLocalizations t, SupplyChecklist c) {
    final nf = NumberFormat.decimalPattern(_lang);
    final lines = <String>[
      '${t.shoppingList.toUpperCase()} · ${t.shopFor(inv.people, inv.days)}',
      '',
      t.suppliesHome.toUpperCase(),
    ];
    for (final n in Need.values) {
      final info = _needInfo(t, n, nf);
      if (info.missing != null) lines.add('• ${needName(t, n)}: ${info.missing}');
    }
    for (final e in c.missingHome(inv, _lang).entries) {
      lines.add('• ${e.key}: ${e.value.join(', ')}');
    }
    final bag = c.missingBag(inv, _lang);
    if (bag.isNotEmpty) {
      lines
        ..add('')
        ..add(t.suppliesBackpack.toUpperCase());
      for (final e in bag.entries) {
        lines.add('• ${e.key}: ${e.value.join(', ')}');
      }
    }
    if (lines.length == 3) lines.add(t.shopAllDone);
    Clipboard.setData(ClipboardData(text: lines.join('\n')));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.shopCopied)));
  }

  Future<void> _addItem(BuildContext context, AppLocalizations t, Need need) => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (c) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(c).viewInsets.bottom),
          child: _AddSheet(inv: inv, t: t, need: need),
        ),
      );

  Future<void> _editItem(BuildContext context, AppLocalizations t, SupplyItem item, {bool isNew = false}) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (c) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(c).viewInsets.bottom),
          child: _ItemEditor(item: item, isNew: isNew, inv: inv, t: t),
        ),
      );
}

/// Conteggio di un gruppo (es. "3 di 15") con la freccia che indica che si apre.
class _GroupCount extends StatelessWidget {
  const _GroupCount({required this.done, required this.total, required this.t});

  final int done, total;
  final AppLocalizations t;

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Text(t.doneOf(done, total),
            style: TextStyle(color: done == total ? Colors.lightGreen : Colors.white60, fontWeight: FontWeight.w600)),
        const Icon(Icons.expand_more, color: Colors.white54),
      ]);
}

/// Le quattro quantità che decidono quanti giorni si resiste in casa.
enum Need { water, food, cooking, electricity }

/// Prodotti dell'inventario che contano per ogni quantità.
List<String> needPresets(Need n) => switch (n) {
      Need.water => const ['water'],
      Need.food => [for (final p in kPresets) if (p.category == SupplyCategory.food) p.key],
      Need.cooking => const ['cartridge'],
      Need.electricity => const ['powerBank', 'powerStation'],
    };

String needName(AppLocalizations t, Need n) => switch (n) {
      Need.water => t.catWater,
      Need.food => t.catFood,
      Need.cooking => t.catGas,
      Need.electricity => t.catElectricity,
    };

IconData needIcon(Need n) => switch (n) {
      Need.water => Icons.water_drop,
      Need.food => Icons.restaurant,
      Need.cooking => Icons.local_fire_department,
      Need.electricity => Icons.battery_charging_full,
    };

class _NeedInfo {
  const _NeedInfo(this.need, this.have, this.ratio, this.days, this.missing, {this.note});

  final Need need;
  final String have;
  final double ratio, days;
  final String? missing, note;
}

/// Una quantità: quanto c'è su quanto serve, giorni coperti, cosa manca. Toccandola si aprono le sue voci.
class _NeedCard extends StatelessWidget {
  const _NeedCard({
    required this.info,
    required this.nf,
    required this.open,
    required this.onToggle,
    required this.items,
    required this.onAdd,
    required this.onEdit,
  });

  final _NeedInfo info;
  final NumberFormat nf;
  final bool open;
  final VoidCallback onToggle, onAdd;
  final List<SupplyItem> items;
  final void Function(SupplyItem) onEdit;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final ok = info.missing == null;
    final color = ok ? Colors.lightGreen : (info.ratio >= 0.5 ? kAccent : kDanger);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(children: [
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(needIcon(info.need), color: color),
                const SizedBox(width: 10),
                Text(needName(t, info.need), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                Flexible(child: Text(info.have, textAlign: TextAlign.end, style: const TextStyle(color: Colors.white70))),
                Icon(open ? Icons.expand_less : Icons.expand_more, color: Colors.white54),
              ]),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                  value: info.ratio.clamp(0, 1), color: color, minHeight: 8, borderRadius: BorderRadius.circular(4)),
              const SizedBox(height: 8),
              Text(t.coversDays(nf.format((info.days * 10).floor() / 10)),
                  style: TextStyle(color: color, fontWeight: FontWeight.w600)),
              if (info.missing != null) Text(info.missing!, style: const TextStyle(color: Colors.white70)),
            ]),
          ),
        ),
        if (open)
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              if (items.isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
                  child: Text(t.emptySection, style: const TextStyle(color: Colors.white38)),
                ),
              for (final item in items) _ItemRow(item: item, nf: nf, onEdit: () => onEdit(item)),
              OutlinedButton.icon(icon: const Icon(Icons.add), label: Text(t.addItem), onPressed: onAdd),
              if (info.note != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(info.note!, style: const TextStyle(color: Colors.white38, fontSize: 13)),
                ),
            ]),
          ),
      ]),
    );
  }
}

/// Voce dello zaino con i tre stati: nello zaino, da prendere da casa, manca.
class _BagRow extends StatelessWidget {
  const _BagRow({
    required this.label,
    required this.state,
    required this.canTakeFromHome,
    required this.t,
    required this.onChanged,
    this.note,
    this.onDelete,
  });

  final String label;
  final BagState? state;
  final bool canTakeFromHome;
  final String? note;
  final AppLocalizations t;
  final void Function(BagState? s) onChanged;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final status = switch (state) {
      BagState.packed => (t.bagPacked, Colors.lightGreen),
      BagState.fromHome => (t.bagFromHome, kAccent),
      null => (t.bagMissing, Colors.white38),
    };
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.only(left: 16, right: 8),
      title: Text(label, style: const TextStyle(fontSize: 16)),
      subtitle: Text(note ?? status.$1, style: TextStyle(color: note == null ? status.$2 : Colors.white38)),
      onLongPress: onDelete,
      trailing: SegmentedButton<int>(
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        segments: [
          ButtonSegment(value: 0, icon: const Icon(Icons.backpack, size: 18), tooltip: t.bagPacked),
          ButtonSegment(value: 1, icon: const Icon(Icons.home, size: 18), tooltip: t.bagFromHome, enabled: canTakeFromHome),
          ButtonSegment(value: 2, icon: const Icon(Icons.close, size: 18), tooltip: t.bagMissing),
        ],
        selected: {
          switch (state) {
            BagState.packed => 0,
            BagState.fromHome => 1,
            null => 2,
          }
        },
        onSelectionChanged: (v) => onChanged(switch (v.first) {
          0 => BagState.packed,
          1 => BagState.fromHome,
          _ => null,
        }),
      ),
    );
  }
}

/// Nome del prodotto; per l'acqua dipende dal formato (bottiglia o tanica).
String presetName(AppLocalizations t, String key, {double size = 1}) => switch (key) {
      'water' => size >= 5 ? t.pWaterTank : t.pWaterBottle,
      'pasta' => t.pPasta,
      'rice' => t.pRice,
      'dryLegumes' => t.pDryLegumes,
      'cannedLegumes' => t.pCannedLegumes,
      'tuna' => t.pTuna,
      'cannedMeat' => t.pCannedMeat,
      'cannedVeg' => t.pCannedVeg,
      'nuts' => t.pNuts,
      'biscuits' => t.pBiscuits,
      'bars' => t.pBars,
      'uhtMilk' => t.pUhtMilk,
      'powderMilk' => t.pPowderMilk,
      'oil' => t.pOil,
      'sugar' => t.pSugar,
      'honey' => t.pHoney,
      'customFood' => t.pCustomFood,
      'cartridge' => t.pCartridge,
      'powerBank' => t.pPowerBank,
      'powerStation' => t.pPowerStation,
      'solarPanel' => t.pSolarPanel,
      'batteriesAA' => t.pBatteriesAA,
      'batteriesAAA' => t.pBatteriesAAA,
      _ => t.pCustomOther,
    };

String formatSize(double size, String unit, NumberFormat nf) {
  if (unit == 'pz') return '';
  if ((unit == 'g' || unit == 'ml') && size >= 1000) return '${nf.format(size / 1000)} ${unit == 'g' ? 'kg' : 'L'}';
  return '${nf.format(size)} $unit';
}

class _Section extends StatelessWidget {
  const _Section(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text.toUpperCase(),
            style: const TextStyle(color: kAccent, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
      );
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.label, required this.value, required this.min, required this.max, required this.onChanged});

  final String label;
  final int value, min, max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(children: [
            Text(label, style: const TextStyle(fontSize: 18)),
            const Spacer(),
            IconButton.outlined(icon: const Icon(Icons.remove), onPressed: value > min ? () => onChanged(value - 1) : null),
            SizedBox(
              width: 56,
              child: Text('$value',
                  textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            IconButton.outlined(icon: const Icon(Icons.add), onPressed: value < max ? () => onChanged(value + 1) : null),
          ]),
        ),
      );
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item, required this.nf, required this.onEdit});

  final SupplyItem item;
  final NumberFormat nf;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final empty = item.qty == 0;
    final size = formatSize(item.size, item.type.unit, nf);
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      color: empty ? Colors.transparent : kSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: empty ? Colors.white24 : Colors.transparent),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
          child: Row(children: [
            Icon(empty ? Icons.radio_button_unchecked : Icons.check_circle,
                color: empty ? Colors.white38 : Colors.lightGreen, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.name ?? presetName(t, item.preset, size: item.size),
                    style: TextStyle(fontSize: 16, color: empty ? Colors.white60 : Colors.white)),
                if (size.isNotEmpty) Text(size, style: const TextStyle(color: Colors.white54, fontSize: 13)),
              ]),
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              tooltip: t.consumeOne,
              onPressed: empty ? null : () => Inventory.instance.change(item, -1),
            ),
            SizedBox(
              width: 40,
              child: Text('${item.qty}',
                  textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: kAccent),
              tooltip: t.addOne,
              onPressed: () => Inventory.instance.change(item, 1),
            ),
          ]),
        ),
      ),
    );
  }
}

class _ItemEditor extends StatefulWidget {
  const _ItemEditor({required this.item, required this.isNew, required this.inv, required this.t});

  final SupplyItem item;
  final bool isNew;
  final Inventory inv;
  final AppLocalizations t;

  @override
  State<_ItemEditor> createState() => _ItemEditorState();
}

class _ItemEditorState extends State<_ItemEditor> {
  late final _name = TextEditingController(text: widget.item.name ?? '');
  late final _size = TextEditingController(text: _num(widget.item.size));
  late final _kcal = TextEditingController(text: _num(widget.item.kcalPer100 ?? widget.item.type.kcalPer100));
  late int _qty = widget.item.qty;

  static String _num(double v) => v == v.roundToDouble() ? v.round().toString() : v.toString();

  bool get _custom => widget.item.preset.startsWith('custom');


  @override
  void dispose() {
    _name.dispose();
    _size.dispose();
    _kcal.dispose();
    super.dispose();
  }

  void _save() {
    final item = widget.item;
    double? parse(TextEditingController c) => double.tryParse(c.text.replaceAll(',', '.'));
    item
      ..name = _custom && _name.text.trim().isNotEmpty ? _name.text.trim() : item.name
      ..size = parse(_size) ?? item.size
      ..qty = _qty;
    if (item.type.category == SupplyCategory.food) {
      final k = parse(_kcal);
      item.kcalPer100 = k == null || k == item.type.kcalPer100 ? null : k;
    }
    widget.inv.update(item);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    final type = widget.item.type;
    final unit = type.unit;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          Text(widget.item.name ?? presetName(t, widget.item.preset, size: widget.item.size),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (_custom) ...[
            TextField(
              controller: _name,
              decoration: InputDecoration(labelText: t.itemName, border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
          ],
          if (unit != 'pz') ...[
            TextField(
              controller: _size,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: t.unitSize, suffixText: unit, border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
          ],
          if (type.category == SupplyCategory.food) ...[
            TextField(
              controller: _kcal,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: t.kcalPer100, border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
          ],
          Row(children: [
            Text(t.quantity, style: const TextStyle(fontSize: 18)),
            const Spacer(),
            IconButton.outlined(icon: const Icon(Icons.remove), onPressed: _qty > 0 ? () => setState(() => _qty--) : null),
            SizedBox(
              width: 64,
              child: Text('$_qty', textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            ),
            IconButton.outlined(icon: const Icon(Icons.add), onPressed: () => setState(() => _qty++)),
          ]),
          const SizedBox(height: 20),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54)),
            onPressed: _save,
            child: Text(t.save, style: const TextStyle(fontSize: 18)),
          ),
          if (!widget.isNew)
            TextButton(
              style: TextButton.styleFrom(foregroundColor: kDanger),
              onPressed: () {
                widget.inv.remove(widget.item);
                Navigator.pop(context);
              },
              child: Text(t.delete),
            ),
        ]),
      ),
    );
  }
}

IconData presetIcon(SupplyPreset p) => switch (p.key) {
      'cartridge' => Icons.local_fire_department,
      'powerBank' || 'powerStation' => Icons.battery_charging_full,
      'water' => Icons.water_drop,
      _ => Icons.restaurant,
    };

/// Aggiunta in tre tocchi: prodotto, formato (quelli in commercio o uno a scelta), quantità.
class _AddSheet extends StatefulWidget {
  const _AddSheet({required this.inv, required this.t, required this.need});

  final Inventory inv;
  final AppLocalizations t;
  final Need need;

  @override
  State<_AddSheet> createState() => _AddSheetState();
}

class _AddSheetState extends State<_AddSheet> {
  SupplyPreset? _preset;
  double? _size;
  bool _customSize = false;
  int _qty = 1;
  final _name = TextEditingController();
  final _sizeField = TextEditingController();
  final _kcal = TextEditingController();

  AppLocalizations get t => widget.t;

  NumberFormat get nf => NumberFormat.decimalPattern(AppSettings.instance.language);

  @override
  void dispose() {
    _name.dispose();
    _sizeField.dispose();
    _kcal.dispose();
    super.dispose();
  }

  void _choose(SupplyPreset p, {String? name}) => setState(() {
        _preset = p;
        _size = p.sizes.length == 1 ? p.sizes.first : null;
        _customSize = false;
        _qty = 1;
        _name.text = name ?? '';
        _kcal.text = p.kcalPer100 > 0 ? p.kcalPer100.round().toString() : '';
      });

  double? get _chosenSize => _customSize ? double.tryParse(_sizeField.text.replaceAll(',', '.')) : _size;

  bool get _canAdd {
    final p = _preset;
    if (p == null || _chosenSize == null || _chosenSize! <= 0) return false;
    if (p.key.startsWith('custom') && _name.text.trim().isEmpty) return false;
    return true;
  }

  void _add() {
    final p = _preset!;
    final custom = p.key.startsWith('custom');
    final kcal = double.tryParse(_kcal.text.replaceAll(',', '.'));
    widget.inv.add(
      p.key,
      _chosenSize!,
      _qty,
      name: custom ? _name.text.trim() : null,
      kcalPer100: p.category == SupplyCategory.food && kcal != null && kcal != p.kcalPer100 ? kcal : null,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: _preset == null ? _products() : _details(),
          ),
        ),
      );

  /// Passo 1: che cosa, solo dentro la sezione toccata.
  Widget _products() {
    final need = widget.need;
    final keys = needPresets(need);
    // Solo il cibo ha una voce libera (con le sue kcal): il resto si sceglie tra i prodotti in commercio.
    final custom = keys.contains('customFood') ? 'customFood' : null;
    final products = kPresets.where((p) => keys.contains(p.key) && !p.key.startsWith('custom')).toList();
    void pickCustom(String name) {
      if (custom != null && name.trim().isNotEmpty) _choose(presetByKey(custom), name: name.trim());
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(needIcon(need), color: kAccent),
        const SizedBox(width: 8),
        Text(needName(t, need), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ]),
      if (products.isNotEmpty) ...[
        const SizedBox(height: 14),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final p in products)
            ActionChip(
              avatar: Icon(presetIcon(p), size: 18),
              label: Text(p.key == 'water' ? t.catWater : presetName(t, p.key), style: const TextStyle(fontSize: 16)),
              onPressed: () => _choose(p),
            ),
        ]),
      ],
      if (custom != null) ...[
        const SizedBox(height: 16),
        TextField(
          controller: _name,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: t.itemName,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(icon: const Icon(Icons.arrow_forward), onPressed: () => pickCustom(_name.text)),
          ),
          onSubmitted: pickCustom,
        ),
      ],
    ]);
  }

  /// Passo 2: formato e quantità.
  Widget _details() {
    final p = _preset!;
    final custom = p.key.startsWith('custom');
    final title = custom && _name.text.trim().isNotEmpty
        ? _name.text.trim()
        : (p.key == 'water' ? t.catWater : presetName(t, p.key));
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
      Row(children: [
        IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => setState(() => _preset = null)),
        Icon(presetIcon(p), color: kAccent),
        const SizedBox(width: 8),
        Expanded(child: Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
      ]),
      if (p.key == 'customFood') ...[
        const SizedBox(height: 12),
        TextField(
          controller: _name,
          decoration: InputDecoration(labelText: t.itemName, border: const OutlineInputBorder()),
          onChanged: (_) => setState(() {}),
        ),
      ],
      if (p.unit != 'pz') ...[
        const SizedBox(height: 16),
        Text(t.chooseSize, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final size in p.sizes)
            ChoiceChip(
              label: Text(formatSize(size, p.unit, nf), style: const TextStyle(fontSize: 17)),
              selected: !_customSize && _size == size,
              onSelected: (_) => setState(() {
                _size = size;
                _customSize = false;
              }),
            ),
          ChoiceChip(
            label: Text(t.otherSize, style: const TextStyle(fontSize: 17)),
            selected: _customSize,
            onSelected: (_) => setState(() => _customSize = true),
          ),
        ]),
        if (_customSize) ...[
          const SizedBox(height: 10),
          TextField(
            controller: _sizeField,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: t.unitSize, suffixText: p.unit, border: const OutlineInputBorder()),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ],
      if (p.category == SupplyCategory.food) ...[
        const SizedBox(height: 12),
        TextField(
          controller: _kcal,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: t.kcalPer100, border: const OutlineInputBorder()),
        ),
      ],
      const SizedBox(height: 16),
      Row(children: [
        Text(t.quantity, style: const TextStyle(fontSize: 18)),
        const Spacer(),
        IconButton.outlined(icon: const Icon(Icons.remove), onPressed: _qty > 1 ? () => setState(() => _qty--) : null),
        SizedBox(
          width: 64,
          child: Text('$_qty', textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        ),
        IconButton.outlined(icon: const Icon(Icons.add), onPressed: () => setState(() => _qty++)),
      ]),
      const SizedBox(height: 20),
      FilledButton.icon(
        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
        icon: const Icon(Icons.add),
        label: Text(t.addToInventory, style: const TextStyle(fontSize: 18)),
        onPressed: _canAdd ? _add : null,
      ),
    ]);
  }
}
