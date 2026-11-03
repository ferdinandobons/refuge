import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/settings.dart';
import '../../l10n/app_localizations.dart';
import '../maps/map_download.dart';
import '../maps/map_regions.dart';
import '../tools/supplies_screen.dart';
import 'family_plan_screen.dart';
import 'inventory.dart';
import 'paper_copy.dart';
import 'supply_checklist.dart';

const _kDone = Color(0xFF66BB6A);

/// Voci del piano che le linee guida UE chiedono di avere scritte (SWD(2026) 826 e 828):
/// contatti, due punti d'incontro, il rifugio più vicino.
const kPlanEssentials = ['contacts', 'meetNear', 'meetFar', 'shelter'];

/// Le voci essenziali del piano ancora vuote.
List<String> missingPlanFields(String? Function(String field) value) => [
      for (final f in kPlanEssentials)
        if ((value(f) ?? '').trim().isEmpty) f,
    ];

/// Acqua e cibo bastano quando coprono entrambi i giorni scelti nelle scorte.
bool waterAndFoodReady(Inventory inv) => inv.waterDays() >= inv.days && inv.foodDays() >= inv.days;

/// Quanto sei pronto: ogni voce dice cosa è fatto e cosa manca, e si apre con un tocco.
class ReadinessCard extends StatefulWidget {
  const ReadinessCard({super.key});

  @override
  State<ReadinessCard> createState() => _ReadinessCardState();
}

class _ReadinessCardState extends State<ReadinessCard> {
  SharedPreferences? _prefs;
  SupplyChecklist? _checklist;
  bool _makingPaper = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final checklist = await SupplyChecklist.load();
    await Inventory.instance.load();
    if (!MapRegions.instance.loaded) await MapRegions.instance.refresh();
    if (!mounted) return;
    setState(() {
      _prefs = prefs;
      _checklist = checklist;
    });
  }

  /// Al ritorno si ridisegna: il piano si salva nelle preferenze, che non avvisano.
  Future<void> _open(WidgetBuilder page) async {
    await Navigator.push(context, MaterialPageRoute(builder: page));
    if (mounted) setState(() {});
  }

  /// Crea il PDF e apre il pannello per stamparlo o salvarlo.
  Future<void> _paper(AppLocalizations t) async {
    setState(() => _makingPaper = true);
    final s = AppSettings.instance;
    try {
      await sharePaperCopy(language: s.language, country: s.country, t: t);
      await _prefs?.setString('paper:made', DateTime.now().toIso8601String());
    } finally {
      if (mounted) setState(() => _makingPaper = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final prefs = _prefs, checklist = _checklist;
    if (prefs == null || checklist == null) {
      return const Card(child: SizedBox(height: 96, child: Center(child: CircularProgressIndicator())));
    }
    return ListenableBuilder(
      listenable: Listenable.merge([Inventory.instance, MapRegions.instance]),
      builder: (context, _) {
        final inv = Inventory.instance;
        final s = AppSettings.instance;
        final nf = NumberFormat('#,##0.#', s.language);
        String days(double d) => nf.format((d * 10).floor() / 10); // come nelle scorte: mai per eccesso

        String? plan(String f) => prefs.getString('plan:$f');
        final missing = missingPlanFields(plan);
        final planStarted = kPlanFields.any((f) => (plan(f) ?? '').trim().isNotEmpty);

        final homeDone = checklist.homeDone(inv), homeTotal = checklist.homeTotal(inv);
        final bagDone = checklist.bagDone(inv), bagTotal = checklist.bagTotal(inv);

        // La mappa dettagliata del paese; fuori dai paesi previsti, quella d'Europa.
        final region = kCountryRegions[s.country.code] ?? kEurope;
        final mapReady = MapRegions.instance.isInstalled(region);

        final paper = DateTime.tryParse(prefs.getString('paper:made') ?? '');

        return Card(
          child: Column(children: [
            _Row(
              t: t,
              done: missing.isEmpty,
              title: t.planTitle,
              subtitle: missing.isEmpty
                  ? t.readyPlanDone
                  : planStarted
                      ? t.readyMissing(missing.map((f) => planField(t, f).$1).join(' · '))
                      : t.planSubtitle,
              onTap: () => _open((_) => const FamilyPlanScreen()),
            ),
            _Row(
              t: t,
              done: waterAndFoodReady(inv),
              title: t.readyWaterFood,
              subtitle: inv.waterLiters > 0 || inv.kcal > 0
                  ? t.readyDays(days(inv.waterDays()), days(inv.foodDays()), inv.days)
                  : t.readyWaterFoodEmpty(inv.days),
              onTap: () => _open((_) => const SuppliesScreen()),
            ),
            _Row(
              t: t,
              done: homeDone == homeTotal,
              title: t.readyHome,
              subtitle: t.readyOf(homeDone, homeTotal),
              onTap: () => _open((_) => const SuppliesScreen()),
            ),
            _Row(
              t: t,
              done: bagDone == bagTotal,
              title: t.suppliesBackpack,
              subtitle: t.bagReady(bagDone, bagTotal),
              onTap: () => _open((_) => const SuppliesScreen(backpack: true)),
            ),
            _Row(
              t: t,
              done: mapReady,
              title: t.mapsTitle,
              subtitle: mapReady ? '${t.mapReady}: ${regionName(t, region)}' : t.readyToDownload(regionName(t, region)),
              onTap: () => _open((_) => const MapDownloadScreen()),
            ),
            _Row(
              t: t,
              done: paper != null,
              title: t.paperTitle,
              subtitle: paper != null ? t.paperMade(DateFormat.yMd(s.language).format(paper)) : t.paperSubtitle,
              busy: _makingPaper,
              onTap: _makingPaper ? null : () => _paper(t),
            ),
          ]),
        );
      },
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.t,
    required this.done,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.busy = false,
  });

  final AppLocalizations t;
  final bool done, busy;
  final String title, subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          done ? Icons.check_circle : Icons.radio_button_unchecked,
          color: done ? _kDone : Colors.white38,
          size: 28,
          semanticLabel: done ? t.done : t.readyTodo,
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        subtitle: Text(subtitle),
        trailing: busy
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 3))
            : const Icon(Icons.chevron_right),
        onTap: onTap,
      );
}
