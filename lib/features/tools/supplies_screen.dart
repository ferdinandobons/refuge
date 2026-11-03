import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/settings.dart';
import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import '../prepare/inventory.dart';

/// Scorte: fabbisogno (persone × giorni), riepilogo di cosa manca e inventario da aggiornare
/// man mano che si compra o si consuma.
class SuppliesScreen extends StatefulWidget {
  const SuppliesScreen({super.key});

  @override
  State<SuppliesScreen> createState() => _SuppliesScreenState();
}

class _SuppliesScreenState extends State<SuppliesScreen> {
  final inv = Inventory.instance;

  @override
  void initState() {
    super.initState();
    inv.load();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final nf = NumberFormat.decimalPattern(AppSettings.instance.language);
    return Scaffold(
      appBar: AppBar(title: Text(t.suppliesTitle)),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text(t.addItem),
        onPressed: () => _addItem(context, t),
      ),
      body: ListenableBuilder(
        listenable: inv,
        builder: (context, _) {
          if (!inv.loaded) return const Center(child: CircularProgressIndicator());
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              _Section(t.needsTitle),
              _Stepper(label: t.people, value: inv.people, min: 1, max: 30, onChanged: (v) => inv.setNeeds(people: v)),
              _Stepper(label: t.days, value: inv.days, min: 1, max: 365, onChanged: (v) => inv.setNeeds(days: v)),
              const SizedBox(height: 16),
              _Section(t.summaryTitle),
              _Summary(
                icon: Icons.water_drop,
                title: t.catWater,
                have: '${nf.format(inv.waterLiters.round())} / ${nf.format(inv.waterNeeded.round())} L',
                ratio: inv.waterLiters / inv.waterNeeded,
                days: inv.waterDays(),
                missing: inv.waterLiters >= inv.waterNeeded
                    ? null
                    : t.missingWater(nf.format((inv.waterNeeded - inv.waterLiters).ceil()),
                        ((inv.waterNeeded - inv.waterLiters) / 1.5).ceil()),
                nf: nf,
              ),
              _Summary(
                icon: Icons.restaurant,
                title: t.catFood,
                have: '${nf.format(inv.kcal.round())} / ${nf.format(inv.kcalNeeded.round())} kcal',
                ratio: inv.kcal / inv.kcalNeeded,
                days: inv.foodDays(),
                missing: inv.kcal >= inv.kcalNeeded
                    ? null
                    : t.missingFood(nf.format((inv.kcalNeeded - inv.kcal).ceil()),
                        nf.format(((inv.kcalNeeded - inv.kcal) / 3600 * 2).ceil() / 2)),
                nf: nf,
              ),
              _Summary(
                icon: Icons.local_fire_department,
                title: t.catGas,
                have: t.mealsHave(inv.gasMeals.floor(), inv.mealsNeeded.round()),
                ratio: inv.gasMeals / inv.mealsNeeded,
                days: inv.gasDays(),
                missing: inv.gasMeals >= inv.mealsNeeded
                    ? null
                    : t.missingGas(((inv.mealsNeeded - inv.gasMeals) / kMealsPerCartridge).ceil()),
                nf: nf,
              ),
              const SizedBox(height: 16),
              _Section(t.inventoryTitle),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(t.inventoryHint, style: const TextStyle(color: Colors.white60)),
              ),
              for (final cat in SupplyCategory.values) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
                  child: Text(categoryName(t, cat), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                for (final item in inv.inCategory(cat))
                  _ItemRow(item: item, nf: nf, onEdit: () => _editItem(context, t, item)),
              ],
              const SizedBox(height: 12),
              Text(t.suppliesNote, style: const TextStyle(color: Colors.white54)),
            ],
          );
        },
      ),
    );
  }

  Future<void> _addItem(BuildContext context, AppLocalizations t) => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (c) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(c).viewInsets.bottom),
          child: _AddSheet(inv: inv, t: t),
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

String categoryName(AppLocalizations t, SupplyCategory c) => switch (c) {
      SupplyCategory.water => t.catWater,
      SupplyCategory.food => t.catFood,
      SupplyCategory.gas => t.catGas,
      SupplyCategory.other => t.catOther,
    };

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

class _Summary extends StatelessWidget {
  const _Summary({
    required this.icon,
    required this.title,
    required this.have,
    required this.ratio,
    required this.days,
    required this.missing,
    required this.nf,
  });

  final IconData icon;
  final String title, have;
  final double ratio, days;
  final String? missing;
  final NumberFormat nf;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final ok = missing == null;
    final color = ok ? Colors.lightGreen : (ratio >= 0.5 ? kAccent : kDanger);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Spacer(),
            Text(have, style: const TextStyle(color: Colors.white70)),
          ]),
          const SizedBox(height: 10),
          LinearProgressIndicator(value: ratio.clamp(0, 1), color: color, minHeight: 8, borderRadius: BorderRadius.circular(4)),
          const SizedBox(height: 8),
          Text(t.coversDays(nf.format((days * 10).floor() / 10)), style: TextStyle(color: color, fontWeight: FontWeight.w600)),
          if (missing != null) Text(missing!, style: const TextStyle(color: Colors.white70)),
        ]),
      ),
    );
  }
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

IconData presetIcon(SupplyPreset p) => switch (p.category) {
      SupplyCategory.water => Icons.water_drop,
      SupplyCategory.food => Icons.restaurant,
      SupplyCategory.gas => Icons.local_fire_department,
      SupplyCategory.other => Icons.category,
    };

/// Aggiunta in tre tocchi: prodotto, formato (quelli in commercio o uno a scelta), quantità.
class _AddSheet extends StatefulWidget {
  const _AddSheet({required this.inv, required this.t});

  final Inventory inv;
  final AppLocalizations t;

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

  /// Passo 1: che cosa.
  Widget _products() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(t.chooseProduct, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        for (final cat in [SupplyCategory.water, SupplyCategory.food, SupplyCategory.gas]) ...[
          const SizedBox(height: 14),
          Text(categoryName(t, cat), style: const TextStyle(color: kAccent, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final p in kPresets.where((p) => p.category == cat))
              ActionChip(
                avatar: Icon(presetIcon(p), size: 18),
                label: Text(p.key == 'water' ? t.catWater : presetName(t, p.key), style: const TextStyle(fontSize: 16)),
                onPressed: () => _choose(p),
              ),
          ]),
        ],
        const SizedBox(height: 14),
        Text(t.catOther, style: const TextStyle(color: kAccent, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: _name,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: t.otherItemHint,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                if (_name.text.trim().isNotEmpty) _choose(presetByKey('customOther'), name: _name.text.trim());
              },
            ),
          ),
          onSubmitted: (v) {
            if (v.trim().isNotEmpty) _choose(presetByKey('customOther'), name: v.trim());
          },
        ),
        const SizedBox(height: 10),
        Text(t.suggestions, style: const TextStyle(color: Colors.white60)),
        const SizedBox(height: 6),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final s in t.otherSuggestions.split(','))
            ActionChip(label: Text(s.trim()), onPressed: () => _choose(presetByKey('customOther'), name: s.trim())),
        ]),
      ]);

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
