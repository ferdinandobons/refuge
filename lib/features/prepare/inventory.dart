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

/// Sezioni dell'inventario. Acqua, cibo e gas entrano nel riepilogo; il resto si conta a pezzi.
enum SupplyCategory { water, food, energy, health, other }

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
  SupplyPreset('solarPanel', SupplyCategory.energy, [10, 20, 60, 100], 'W'),
  SupplyPreset('batteriesAA', SupplyCategory.energy, [1], 'pz'),
  SupplyPreset('batteriesAAA', SupplyCategory.energy, [1], 'pz'),
  SupplyPreset('customEnergy', SupplyCategory.energy, [1], 'pz'),
  SupplyPreset('customHealth', SupplyCategory.health, [1], 'pz'),
  // "Altro": oggetti liberi scritti dall'utente o scelti tra i suggerimenti, contati a pezzi.
  SupplyPreset('customOther', SupplyCategory.other, [1], 'pz'),
];

/// Chiavi della prima versione (un tipo per formato), convertite al prodotto unico.
String _migrate(String key) => switch (key) {
      'water05' || 'water1' || 'water15' || 'water2' || 'waterTank5' || 'waterTank10' => 'water',
      'cartridge450' => 'cartridge',
      'batteries' || 'candles' || 'medicines' || 'firstAidKit' || 'bleach' || 'torch' => 'customOther',
      _ => key,
    };

SupplyPreset presetByKey(String key) => kPresets.firstWhere((p) => p.key == key, orElse: () => kPresets.last);

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

/// Inventario delle scorte di casa, salvato sul dispositivo.
class Inventory extends ChangeNotifier {
  Inventory._();

  static final instance = Inventory._();

  static const _key = 'inventory:v1';
  SharedPreferences? _prefs;
  bool loaded = false;

  int people = 2;
  int days = 14;
  List<SupplyItem> items = [];

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
      items = [
        for (final e in (j['items'] as List).cast<Map<String, dynamic>>()) SupplyItem.fromJson(e),
      ]
        // Le voci precaricate a zero delle prime versioni confondevano: si tolgono.
        ..removeWhere((i) => i.id.startsWith('d') && i.qty == 0);
    }
    loaded = true;
    notifyListeners();
  }

  void _save() {
    notifyListeners();
    _prefs?.setString(_key, jsonEncode({'people': people, 'days': days, 'items': [for (final i in items) i.toJson()]}));
  }

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

  Iterable<SupplyItem> inCategory(SupplyCategory c) => items.where((i) => i.type.category == c);

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

  /// Pannelli solari: ricaricano, ma quanto dipende dal sole, quindi restano fuori dal conto.
  int get solarPanels => items.where((i) => i.preset == 'solarPanel').fold(0, (s, i) => s + i.qty);

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
