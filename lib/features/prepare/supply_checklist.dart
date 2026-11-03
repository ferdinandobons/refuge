import 'dart:convert';

import 'package:flutter/services.dart';

import 'inventory.dart';

/// Voce del catalogo "Da avere" (casa) o dello zaino, da `assets/supplies/checklist.json`.
class CheckItem {
  const CheckItem({required this.id, required this.labels, required this.source, this.home, this.homePreset});

  factory CheckItem.fromJson(Map<String, dynamic> j) => CheckItem(
        id: j['id'] as String,
        labels: {for (final l in const ['it', 'en', 'fr', 'de', 'es']) l: j[l] as String},
        source: j['src'] as String,
        home: j['home'] as String?,
        homePreset: j['homePreset'] as String?,
      );

  final String id, source;
  final Map<String, String> labels;

  /// Zaino: la stessa cosa nella lista di casa, se c'è (così "da casa" e "manca" restano coerenti).
  final String? home;

  /// Zaino: il prodotto dell'inventario corrispondente (es. il power bank, che in casa si conta).
  final String? homePreset;

  String label(String language) => labels[language] ?? labels['en']!;
}

class CheckGroup {
  const CheckGroup(this.id, this.names, this.items);

  factory CheckGroup.fromJson(Map<String, dynamic> j) => CheckGroup(
        j['group'] as String,
        (j['name'] as Map).cast<String, String>(),
        [for (final i in j['items'] as List) CheckItem.fromJson(i as Map<String, dynamic>)],
      );

  final String id;
  final Map<String, String> names;
  final List<CheckItem> items;

  String name(String language) => names[language] ?? names['en']!;
}

/// Catalogo delle cose da avere in casa e nello zaino (fonti: UE, BBK, MCF, Denk vooruit, IFRC, OMS).
class SupplyChecklist {
  SupplyChecklist(this.home, this.bag);

  factory SupplyChecklist.fromJson(Map<String, dynamic> j) => SupplyChecklist(
        [for (final g in j['home'] as List) CheckGroup.fromJson(g as Map<String, dynamic>)],
        [for (final g in j['bag'] as List) CheckGroup.fromJson(g as Map<String, dynamic>)],
      );

  final List<CheckGroup> home, bag;

  static Future<SupplyChecklist>? _cache;

  static Future<SupplyChecklist> load() => _cache ??= rootBundle
      .loadString('assets/supplies/checklist.json')
      .then((s) => SupplyChecklist.fromJson(jsonDecode(s) as Map<String, dynamic>));

  Iterable<CheckItem> get homeItems => home.expand((g) => g.items);

  Iterable<CheckItem> get bagItems => bag.expand((g) => g.items);

  /// Voci dello zaino che corrispondono alla voce di casa [homeId].
  Iterable<String> bagRefs(String homeId) => bagItems.where((b) => b.home == homeId).map((b) => b.id);

  // ---- Stato, calcolato sempre dalle stesse informazioni: niente doppioni ----

  /// C'è in casa: segnata, oppure già nello zaino (se resti in casa, lo zaino è con te).
  bool atHome(Inventory inv, CheckItem item) => inv.have[item.id] == true || onlyInBag(inv, item);

  /// Segnata come presente solo perché è nello zaino.
  bool onlyInBag(Inventory inv, CheckItem item) =>
      inv.have[item.id] != true && bagItems.any((b) => b.home == item.id && inv.bag[b.id] == BagState.packed);

  /// "La prendo da casa" ha senso solo se in casa c'è (per il power bank: se l'inventario ne conta almeno uno).
  bool canTakeFromHome(Inventory inv, CheckItem bagItem) =>
      bagItem.homePreset == null || inv.countOf(bagItem.homePreset!) > 0;

  BagState? bagState(Inventory inv, CheckItem bagItem) {
    final s = inv.bag[bagItem.id];
    // Se nel frattempo in casa non c'è più, non si può prendere da casa.
    if (s == BagState.fromHome && !canTakeFromHome(inv, bagItem)) return null;
    return s;
  }

  int homeDone(Inventory inv) =>
      homeItems.where((i) => atHome(inv, i)).length + inv.ownHome.where((o) => o.have).length;

  int homeTotal(Inventory inv) => homeItems.length + inv.ownHome.length;

  int bagDone(Inventory inv) =>
      bagItems.where((i) => bagState(inv, i) != null).length + inv.ownBag.where((o) => o.bag != null).length;

  int bagTotal(Inventory inv) => bagItems.length + inv.ownBag.length;

  /// Cose da prendere da casa al momento di uscire (nell'ordine della lista).
  List<String> beforeLeaving(Inventory inv, String language) => [
        for (final i in bagItems)
          if (bagState(inv, i) == BagState.fromHome) i.label(language),
        for (final o in inv.ownBag)
          if (o.bag == BagState.fromHome) o.name ?? '',
      ];

  /// Voci di casa che mancano, per gruppo.
  Map<String, List<String>> missingHome(Inventory inv, String language) => {
        for (final g in home)
          g.name(language): [
            for (final i in g.items)
              if (!atHome(inv, i)) i.label(language),
            for (final o in inv.ownHome)
              if (o.group == g.id && !o.have) o.name ?? '',
          ],
      }..removeWhere((_, v) => v.isEmpty);

  /// Voci dello zaino che mancano, per gruppo. Se la stessa cosa manca anche in casa, è già nella lista
  /// di casa: non si ripete (si compra una volta, poi si decide dove tenerla).
  Map<String, List<String>> missingBag(Inventory inv, String language) => {
        for (final g in bag)
          g.name(language): [
            for (final i in g.items)
              if (bagState(inv, i) == null && !_missingAtHomeToo(inv, i)) i.label(language),
            for (final o in inv.ownBag)
              if (o.group == g.id && o.bag == null) o.name ?? '',
          ],
      }..removeWhere((_, v) => v.isEmpty);

  bool _missingAtHomeToo(Inventory inv, CheckItem bagItem) {
    if (bagItem.homePreset != null) return inv.countOf(bagItem.homePreset!) == 0;
    final h = homeItems.where((i) => i.id == bagItem.home).firstOrNull;
    return h != null && !atHome(inv, h);
  }
}
