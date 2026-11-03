import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:rifugio/features/prepare/inventory.dart';
import 'package:rifugio/features/tools/fallout.dart';
import 'package:rifugio/features/tools/supplies_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Ogni valore atteso qui è calcolato a mano, non ricavato dal codice.
void main() {
  setUp(() {
    Inventory.instance
      ..people = 3
      ..days = 10
      ..items = [
        SupplyItem(id: 'w1', preset: 'water', size: 0.5, qty: 3), // 1,5 L
        SupplyItem(id: 'w2', preset: 'water', size: 2, qty: 10), // 20 L
        SupplyItem(id: 'f1', preset: 'pasta', size: 500, qty: 2), // 1000 g × 3,6 = 3600 kcal
        SupplyItem(id: 'f2', preset: 'uhtMilk', size: 1000, qty: 1), // 1000 ml × 0,64 = 640 kcal
        SupplyItem(id: 'f3', preset: 'oil', size: 1000, qty: 1), // 1000 ml × 8,2 = 8200 kcal
        SupplyItem(id: 'f4', preset: 'customFood', size: 200, qty: 1, kcalPer100: 250), // 500 kcal
        SupplyItem(id: 'g1', preset: 'cartridge', size: 220, qty: 2), // 18 pasti
        SupplyItem(id: 'g2', preset: 'cartridge', size: 450, qty: 1), // 450/220 × 9 = 18,409 pasti
        SupplyItem(id: 'e1', preset: 'powerBank', size: 10000, qty: 1), // 37 Wh × 0,65 = 24,05 Wh
        SupplyItem(id: 'e2', preset: 'powerStation', size: 500, qty: 1), // 500 × 0,85 = 425 Wh
      ];
  });

  group('fabbisogno', () {
    test('3 persone per 10 giorni', () {
      final inv = Inventory.instance;
      expect(inv.waterNeeded, 120); // 3 × 10 × 4 L
      expect(inv.kcalNeeded, 60000); // 3 × 10 × 2000
      expect(inv.mealsNeeded, 30); // 1 pasto caldo al giorno a persona
      expect(inv.chargesNeeded, 30); // 1 ricarica al giorno a persona
    });
  });

  group('totali', () {
    test('acqua, con formati diversi', () {
      expect(Inventory.instance.waterLiters, closeTo(21.5, 1e-9));
      expect(Inventory.instance.waterDays(), closeTo(21.5 / 12, 1e-9));
    });

    test('cibo, in grammi e millilitri', () {
      expect(Inventory.instance.kcal, closeTo(3600 + 640 + 8200 + 500, 1e-9));
      expect(Inventory.instance.foodDays(), closeTo(12940 / 6000, 1e-9));
    });

    test('gas, proporzionale ai grammi', () {
      expect(Inventory.instance.gasMeals, closeTo(18 + 450 / 220 * 9, 1e-9));
    });

    test('elettricità, al netto delle perdite', () {
      final inv = Inventory.instance;
      expect(inv.usableWh, closeTo(24.05 + 425, 1e-9));
      expect(inv.phoneCharges, closeTo(449.05 / 15, 1e-9));
      expect(inv.chargeDays(), closeTo(449.05 / 15 / 3, 1e-9));
      expect(Inventory.chargesPer10k, closeTo(24.05 / 15, 1e-9));
    });

    test('le cose da avere (sì/no) e lo zaino non alterano i conti', () {
      final inv = Inventory.instance
        ..have = {}
        ..bag = {}
        ..ownHome = []
        ..ownBag = [];
      final before = (inv.waterLiters, inv.kcal, inv.gasMeals, inv.usableWh);
      inv
        ..have['radio'] = true
        ..bag['bagFood'] = BagState.packed
        ..ownHome.add(OwnItem(id: 'x', group: 'health', name: 'Sapone', have: true));
      expect((inv.waterLiters, inv.kcal, inv.gasMeals, inv.usableWh), before);
    });

    test('inventario vuoto: tutto a zero, nessuna divisione per zero', () {
      final inv = Inventory.instance..items = [];
      expect([inv.waterLiters, inv.kcal, inv.gasMeals, inv.usableWh], [0, 0, 0, 0]);
      expect([inv.waterDays(), inv.foodDays(), inv.gasDays(), inv.chargeDays()], [0, 0, 0, 0]);
    });
  });

  group('aggiunta e caricamento', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('stesso prodotto e formato: la quantità si somma', () async {
      final inv = Inventory.instance
        ..loaded = false
        ..items = [];
      await inv.load();
      inv
        ..add('water', 1.5, 6)
        ..add('water', 1.5, 4)
        ..add('water', 5, 1)
        ..add('customFood', 100, 2, name: 'Gallette')
        ..add('customFood', 100, 1, name: 'Gallette');
      expect(inv.items.length, 3);
      expect(inv.items.firstWhere((i) => i.size == 1.5).qty, 10);
      expect(inv.items.firstWhere((i) => i.name == 'Gallette').qty, 3);
      expect(inv.waterLiters, closeTo(20, 1e-9));
    });

    test('le vecchie voci precaricate a zero vengono tolte, le altre restano', () async {
      SharedPreferences.setMockInitialValues({
        'inventory:v1': jsonEncode({
          'people': 2,
          'days': 7,
          'items': [
            {'id': 'd0', 'preset': 'water15', 'size': 1.5, 'qty': 0},
            {'id': 'd1', 'preset': 'waterTank5', 'size': 5, 'qty': 3},
            {'id': 'u1', 'preset': 'pasta', 'size': 500, 'qty': 0},
          ],
        }),
      });
      final inv = Inventory.instance..loaded = false;
      await inv.load();
      expect(inv.items.map((i) => i.id), ['d1', 'u1']);
      expect(inv.items.first.preset, 'water'); // vecchio tipo convertito
      expect(inv.waterLiters, 15);
    });

    test('le voci contate a pezzi delle versioni precedenti diventano cose da avere', () async {
      SharedPreferences.setMockInitialValues({
        'inventory:v1': jsonEncode({
          'people': 2,
          'days': 7,
          'items': [
            {'id': 'u1', 'preset': 'water', 'size': 2, 'qty': 3},
            {'id': 'u2', 'preset': 'batteriesAA', 'size': 1, 'qty': 8},
            {'id': 'u3', 'preset': 'customHealth', 'size': 1, 'qty': 2, 'name': 'Sapone'},
            {'id': 'u4', 'preset': 'customOther', 'size': 1, 'qty': 0, 'name': 'Corda'},
            {'id': 'u5', 'preset': 'solarPanel', 'size': 60, 'qty': 1},
          ],
        }),
      });
      final inv = Inventory.instance..loaded = false;
      await inv.load();
      expect(inv.items.map((i) => i.id), ['u1']);
      expect(inv.waterLiters, 6);
      expect(inv.have['spareBatteries'], isTrue);
      expect([for (final o in inv.ownHome) (o.name ?? o.preset, o.group, o.have)], [
        ('Sapone', 'health', true),
        ('Corda', 'safety', false),
        ('solarPanel', 'light', true),
      ]);
      // Si salvano nel nuovo formato e si rileggono uguali.
      inv.markBagChecked(DateTime(2026, 11, 3));
      inv.loaded = false;
      await inv.load();
      expect(inv.ownHome.length, 3);
      expect(inv.bagChecked, DateTime(2026, 11, 3));
    });
  });

  group('formati mostrati', () {
    test('unità e separatori della lingua', () {
      final it = NumberFormat.decimalPattern('it');
      expect(formatSize(0.5, 'L', it), '0,5 L');
      expect(formatSize(1000, 'g', it), '1 kg');
      expect(formatSize(1500, 'ml', it), '1,5 L');
      expect(formatSize(400, 'g', it), '400 g');
      expect(formatSize(10000, 'mAh', it), '10.000 mAh');
      expect(formatSize(1, 'pz', it), '');
      expect(formatSize(1500, 'ml', NumberFormat.decimalPattern('en')), '1.5 L');
    });
  });

  group('fallout', () {
    test('la dose integrata coincide con un calcolo numerico', () {
      // Intensità 10 mSv/h misurata 2 ore dopo; dose tra 2 e 26 ore.
      const rate = 10.0, t0 = 2.0, ta = 2.0, tb = 26.0;
      var numeric = 0.0;
      const steps = 200000;
      const h = (tb - ta) / steps;
      for (var i = 0; i < steps; i++) {
        numeric += falloutRate(rate, t0, ta + (i + 0.5) * h) * h;
      }
      expect(falloutDose(rate, t0, ta, tb), closeTo(numeric, numeric * 1e-6));
    });

    test('intensità nel tempo secondo t^-1,2', () {
      expect(falloutRate(10, 2, 2), 10);
      expect(falloutRate(10, 2, 14), closeTo(10 * math.pow(7, -1.2), 1e-9));
    });
  });
}
