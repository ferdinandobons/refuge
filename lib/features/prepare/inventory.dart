import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Fabbisogno giornaliero per persona (valori indicativi per adulti).
const kWaterPerDay = 4.0; // litri: 2-3 da bere più cucina e igiene minima
const kKcalPerDay = 2000;
const kMealsPerCartridge = 9.0; // pasti caldi per una persona con una cartuccia da 220 g

/// Energia di una ricarica completa di uno smartphone (batteria di circa 4000 mAh a 3,85 V).
const kPhoneChargeWh = 15.0;

/// Ricariche del telefono a persona al giorno.
const kChargesPerDay = 1.0;

/// Tensione nominale delle celle dei power bank e quota che arriva davvero al telefono (conversione e perdite).
const kPowerBankVolts = 3.7;
const kPowerBankEfficiency = 0.65;

/// Quota dell'energia dichiarata di una power station utilizzabile dalle prese (inverter).
const kPowerStationEfficiency = 0.85;

/// Sezioni delle quantità: acqua, cibo ed energia (gas per cucinare, power bank, power station).
/// Le cose che si hanno o non si hanno sono nella lista "Da avere" ([have], [ownHome]).
enum SupplyCategory { water, food, energy }

/// Prodotto con i formati più comuni in commercio.
/// [sizes] sono i contenuti di una confezione: litri per l'acqua, grammi (o ml) per cibo e gas, pezzi per il resto.
class SupplyPreset {
  const SupplyPreset(this.key, this.category, this.sizes, this.unit, {this.kcalPer100 = 0});

  final String key;
  final SupplyCategory category;
  final List<double> sizes;
  final String unit; // L, g, ml, pz
  final double kcalPer100;

  double get size => sizes.first;
}

const kPresets = <SupplyPreset>[
  SupplyPreset('water', SupplyCategory.water, [0.5, 1, 1.5, 2, 5, 10], 'L'),
  SupplyPreset('pasta', SupplyCategory.food, [250, 500, 1000], 'g', kcalPer100: 360),
  SupplyPreset('rice', SupplyCategory.food, [500, 1000, 2000], 'g', kcalPer100: 360),
  SupplyPreset('dryLegumes', SupplyCategory.food, [500, 1000], 'g', kcalPer100: 340),
  SupplyPreset('cannedLegumes', SupplyCategory.food, [400, 800], 'g', kcalPer100: 90),
  SupplyPreset('tuna', SupplyCategory.food, [80, 160], 'g', kcalPer100: 190),
  SupplyPreset('cannedMeat', SupplyCategory.food, [90, 300], 'g', kcalPer100: 200),
  SupplyPreset('cannedVeg', SupplyCategory.food, [400, 800], 'g', kcalPer100: 30),
  SupplyPreset('nuts', SupplyCategory.food, [100, 200, 500], 'g', kcalPer100: 600),
  SupplyPreset('biscuits', SupplyCategory.food, [250, 500, 1000], 'g', kcalPer100: 430),
  SupplyPreset('bars', SupplyCategory.food, [25, 50], 'g', kcalPer100: 400),
  SupplyPreset('uhtMilk', SupplyCategory.food, [500, 1000], 'ml', kcalPer100: 64),
  SupplyPreset('powderMilk', SupplyCategory.food, [500, 1000], 'g', kcalPer100: 500),
  SupplyPreset('oil', SupplyCategory.food, [500, 1000, 5000], 'ml', kcalPer100: 820),
  SupplyPreset('sugar', SupplyCategory.food, [500, 1000], 'g', kcalPer100: 400),
  SupplyPreset('honey', SupplyCategory.food, [250, 500, 1000], 'g', kcalPer100: 300),
  SupplyPreset('customFood', SupplyCategory.food, [100, 250, 500, 1000], 'g', kcalPer100: 300),
  SupplyPreset('cartridge', SupplyCategory.energy, [190, 220, 230, 450], 'g'),
  SupplyPreset('powerBank', SupplyCategory.energy, [5000, 10000, 20000, 26800], 'mAh'),
  SupplyPreset('powerStation', SupplyCategory.energy, [300, 500, 1000, 2000], 'Wh'),
];

/// Chiavi della prima versione (un tipo per formato), convertite al prodotto unico.
String _migrate(String key) => switch (key) {
      'water05' || 'water1' || 'water15' || 'water2' || 'waterTank5' || 'waterTank10' => 'water',
      'cartridge450' => 'cartridge',
      'batteries' || 'candles' || 'medicines' || 'firstAidKit' || 'bleach' || 'torch' => 'customOther',
      _ => key,
    };

SupplyPreset presetByKey(String key) => kPresets.firstWhere((p) => p.key == key);

bool isPreset(String key) => kPresets.any((p) => p.key == key);

/// Stato di una voce dello zaino: già dentro, oppure da prendere da casa al momento di uscire.
/// Se non c'è nessuno dei due, manca.
enum BagState { packed, fromHome }

/// Voce scritta dall'utente nella lista "Da avere" (casa) o in quella dello zaino.
class OwnItem {
  OwnItem({required this.id, required this.group, this.name, this.preset, this.have = false, this.bag});

  factory OwnItem.fromJson(Map<String, dynamic> j) => OwnItem(
        id: j['id'] as String,
        group: j['group'] as String,
        name: j['name'] as String?,
        preset: j['preset'] as String?,
        have: j['have'] as bool? ?? false,
        bag: switch (j['bag']) { 'packed' => BagState.packed, 'fromHome' => BagState.fromHome, _ => null },
      );

  final String id, group;

  /// Nome scritto dall'utente; per le voci convertite dalle versioni precedenti, il tipo di prodotto.
  final String? name, preset;

  /// Casa: c'è o non c'è.
  bool have;

  /// Zaino: dentro, da prendere da casa o (null) manca.
  BagState? bag;

  Map<String, dynamic> toJson() =>
      {'id': id, 'group': group, 'name': name, 'preset': preset, 'have': have, 'bag': bag?.name};
}

class SupplyItem {
  SupplyItem({required this.id, required this.preset, required this.size, this.qty = 0, this.name, this.kcalPer100});

  factory SupplyItem.fromJson(Map<String, dynamic> j) => SupplyItem(
        id: j['id'] as String,
        preset: _migrate(j['preset'] as String),
        size: (j['size'] as num).toDouble(),
        qty: j['qty'] as int,
        name: j['name'] as String?,
        kcalPer100: (j['kcal'] as num?)?.toDouble(),
      );

  final String id;
  final String preset;
  double size;
  int qty;

  /// Nome scelto dall'utente (voci personalizzate).
  String? name;

  /// kcal ogni 100 g scelte dall'utente; altrimenti quelle del tipo.
  double? kcalPer100;

  SupplyPreset get type => presetByKey(preset);

  double get kcalPerUnit => size * (kcalPer100 ?? type.kcalPer100) / 100;

  Map<String, dynamic> toJson() =>
      {'id': id, 'preset': preset, 'size': size, 'qty': qty, 'name': name, 'kcal': kcalPer100};
}

/// Scorte di casa e zaino, salvate sul dispositivo: quantità ([items]), cose che ci sono o no ([have]),
/// stato dello zaino ([bag]) e voci scritte dall'utente.
class Inventory extends ChangeNotifier {
  Inventory._();

  static final instance = Inventory._();

  static const _key = 'inventory:v1';
  SharedPreferences? _prefs;
  bool loaded = false;

  int people = 2;
  int days = 14;
  List<SupplyItem> items = [];

  /// Lista "Da avere" di casa: voci del catalogo (`assets/supplies/checklist.json`) che ci sono.
  Map<String, bool> have = {};

  /// Zaino: stato delle voci del catalogo (quelle assenti mancano).
  Map<String, BagState> bag = {};

  /// Voci scritte dall'utente, in casa e nello zaino.
  List<OwnItem> ownHome = [], ownBag = [];

  /// Ultimo controllo dello zaino (cibo, farmaci e batterie scadono).
  DateTime? bagChecked;

  Future<void> load() async {
    if (loaded) return;
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs!.getString(_key);
    if (raw == null) {
      items = []; // si parte vuoti: ogni sezione ha il suo pulsante "Aggiungi"

    } else {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      people = j['people'] as int;
      days = j['days'] as int;
      have = {for (final e in ((j['have'] as Map?) ?? {}).entries) e.key as String: e.value as bool};
      bag = {
        for (final e in ((j['bag'] as Map?) ?? {}).entries)
          e.key as String: e.value == 'fromHome' ? BagState.fromHome : BagState.packed,
      };
      ownHome = [for (final o in (j['ownHome'] as List?) ?? []) OwnItem.fromJson(o as Map<String, dynamic>)];
      ownBag = [for (final o in (j['ownBag'] as List?) ?? []) OwnItem.fromJson(o as Map<String, dynamic>)];
      bagChecked = DateTime.tryParse(j['bagChecked'] as String? ?? '');
      items = [
        for (final e in (j['items'] as List).cast<Map<String, dynamic>>()) SupplyItem.fromJson(e),
      ]
        // Le voci precaricate a zero delle prime versioni confondevano: si tolgono.
        ..removeWhere((i) => i.id.startsWith('d') && i.qty == 0);
      _migrateCountedItems();
    }
    loaded = true;
    notifyListeners();
  }

  /// Le versioni precedenti contavano a pezzi anche batterie, pannelli solari e oggetti liberi:
  /// ora sono voci della lista "Da avere" (c'è / non c'è).
  void _migrateCountedItems() {
    for (final i in items.where((i) => !isPreset(i.preset)).toList()) {
      items.remove(i);
      if (i.preset == 'batteriesAA' || i.preset == 'batteriesAAA') {
        if (i.qty > 0) have['spareBatteries'] = true;
        continue;
      }
      final group = switch (i.preset) {
        'customHealth' => 'health',
        'customEnergy' || 'solarPanel' => 'light',
        _ => 'safety',
      };
      ownHome.add(OwnItem(
        id: i.id,
        group: group,
        name: i.name,
        preset: i.name == null ? i.preset : null,
        have: i.qty > 0,
      ));
    }
  }

  void _save() {
    notifyListeners();
    _prefs?.setString(
        _key,
        jsonEncode({
          'people': people,
          'days': days,
          'items': [for (final i in items) i.toJson()],
          'have': have,
          'bag': {for (final e in bag.entries) e.key: e.value.name},
          'ownHome': [for (final o in ownHome) o.toJson()],
          'ownBag': [for (final o in ownBag) o.toJson()],
          'bagChecked': bagChecked?.toIso8601String(),
        }));
  }

  // ---- Lista "Da avere" e zaino ----

  /// Segna una voce di casa. Se manca, non si può nemmeno "prendere da casa" per lo zaino:
  /// le voci dello zaino che la usano ([bagRefs]) tornano a mancare.
  void setHave(String id, bool value, {Iterable<String> bagRefs = const []}) {
    have[id] = value;
    if (!value) {
      for (final b in bagRefs) {
        if (bag[b] == BagState.fromHome) bag.remove(b);
      }
    }
    _save();
  }

  /// Stato di una voce dello zaino. "Da casa" vuol dire che in casa c'è: la voce di casa [homeRef] si segna.
  void setBag(String id, BagState? state, {String? homeRef}) {
    state == null ? bag.remove(id) : bag[id] = state;
    if (state == BagState.fromHome && homeRef != null) have[homeRef] = true;
    _save();
  }

  void addOwn({required bool inBag, required String group, required String name}) {
    // Una voce nuova parte come "manca": si spunta quando c'è.
    final o = OwnItem(id: newId(), group: group, name: name);
    (inBag ? ownBag : ownHome).add(o);
    _save();
  }

  void updateOwn(OwnItem o, {bool? have, BagState? bag, bool clearBag = false}) {
    if (have != null) o.have = have;
    if (bag != null || clearBag) o.bag = bag;
    _save();
  }

  void removeOwn(OwnItem o) {
    ownHome.remove(o);
    ownBag.remove(o);
    _save();
  }

  void markBagChecked([DateTime? when]) {
    bagChecked = when ?? DateTime.now();
    _save();
  }

  /// Quantità (somma delle confezioni) di un prodotto, es. quanti power bank ci sono in casa.
  int countOf(String preset) => items.where((i) => i.preset == preset).fold(0, (s, i) => s + i.qty);

  void setNeeds({int? people, int? days}) {
    if (people != null) this.people = people;
    if (days != null) this.days = days;
    _save();
  }

  void change(SupplyItem item, int delta) {
    item.qty = (item.qty + delta).clamp(0, 9999);
    _save();
  }

  void update(SupplyItem item) {
    if (!items.contains(item)) items.add(item);
    _save();
  }

  void remove(SupplyItem item) {
    items.remove(item);
    _save();
  }

  String newId() => 'u${DateTime.now().microsecondsSinceEpoch}';

  /// Aggiunge [qty] confezioni; se lo stesso prodotto nello stesso formato c'è già, somma la quantità.
  void add(String preset, double size, int qty, {String? name, double? kcalPer100}) {
    final same = items.where((i) => i.preset == preset && i.size == size && i.name == name).firstOrNull;
    if (same != null) {
      same.qty += qty;
    } else {
      items.add(SupplyItem(id: newId(), preset: preset, size: size, qty: qty, name: name, kcalPer100: kcalPer100));
    }
    _save();
  }

  Iterable<SupplyItem> inCategory(SupplyCategory c) => items.where((i) => isPreset(i.preset) && i.type.category == c);

  // ---- Totali e fabbisogno ----

  double get waterLiters => inCategory(SupplyCategory.water).fold(0, (s, i) => s + i.size * i.qty);

  double get kcal => inCategory(SupplyCategory.food).fold(0, (s, i) => s + i.kcalPerUnit * i.qty);

  /// Pasti caldi per una persona, in proporzione ai grammi di gas.
  double get gasMeals =>
      items.where((i) => i.preset == 'cartridge').fold(0, (s, i) => s + i.size / 220 * kMealsPerCartridge * i.qty);

  /// Energia elettrica utilizzabile per ricaricare (Wh), già al netto delle perdite.
  double get usableWh => items.fold(0, (s, i) => s + i.qty * switch (i.preset) {
        'powerBank' => i.size * kPowerBankVolts / 1000 * kPowerBankEfficiency,
        'powerStation' => i.size * kPowerStationEfficiency,
        _ => 0.0,
      });

  double get phoneCharges => usableWh / kPhoneChargeWh;

  double get chargesNeeded => people * days * kChargesPerDay;

  double chargeDays() => phoneCharges / (people * kChargesPerDay);

  /// Ricariche date da un power bank da 10.000 mAh, per suggerire quanti ne mancano.
  static double get chargesPer10k => 10000 * kPowerBankVolts / 1000 * kPowerBankEfficiency / kPhoneChargeWh;

  double get waterNeeded => people * days * kWaterPerDay;

  double get kcalNeeded => (people * days * kKcalPerDay).toDouble();

  /// Un pasto caldo al giorno a persona.
  double get mealsNeeded => (people * days).toDouble();

  double waterDays() => waterLiters / (people * kWaterPerDay);

  double foodDays() => kcal / (people * kKcalPerDay);

  double gasDays() => gasMeals / people;
}
