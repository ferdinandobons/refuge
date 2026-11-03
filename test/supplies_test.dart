import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rifugio/features/prepare/inventory.dart';
import 'package:rifugio/features/prepare/supply_checklist.dart';

/// Casa e zaino: ogni cosa esiste una volta sola, i due elenchi restano coerenti.
void main() {
  final c = SupplyChecklist.fromJson(
      jsonDecode(File('assets/supplies/checklist.json').readAsStringSync()) as Map<String, dynamic>);
  CheckItem home(String id) => c.homeItems.firstWhere((i) => i.id == id);
  CheckItem bag(String id) => c.bagItems.firstWhere((i) => i.id == id);

  late Inventory inv;
  setUp(() {
    inv = Inventory.instance
      ..items = []
      ..have = {}
      ..bag = {}
      ..ownHome = []
      ..ownBag = [];
  });

  test('una cosa già nello zaino risulta anche in casa', () {
    expect(c.atHome(inv, home('firstAidKit')), isFalse);
    inv.setBag('bagFirstAid', BagState.packed, homeRef: 'firstAidKit');
    expect(c.atHome(inv, home('firstAidKit')), isTrue);
    expect(c.onlyInBag(inv, home('firstAidKit')), isTrue);
  });

  test('"la prendo da casa" segna la cosa in casa; se in casa non c\'è più, nello zaino torna a mancare', () {
    inv.setBag('bagMedicines', BagState.fromHome, homeRef: 'medicines');
    expect(inv.have['medicines'], isTrue);
    expect(c.beforeLeaving(inv, 'it'), ['Farmaci personali']);
    inv.setHave('medicines', false, bagRefs: c.bagRefs('medicines'));
    expect(c.bagState(inv, bag('bagMedicines')), isNull);
    expect(c.beforeLeaving(inv, 'it'), isEmpty);
  });

  test('il power bank si prende da casa solo se l\'inventario ne conta almeno uno', () {
    final pb = bag('bagPowerBank');
    expect(c.canTakeFromHome(inv, pb), isFalse);
    inv.bag['bagPowerBank'] = BagState.fromHome;
    expect(c.bagState(inv, pb), isNull); // non c'è in casa: manca
    inv.items.add(SupplyItem(id: 'p', preset: 'powerBank', size: 10000, qty: 1));
    expect(c.canTakeFromHome(inv, pb), isTrue);
    expect(c.bagState(inv, pb), BagState.fromHome);
  });

  test('conteggi di casa e zaino, con le voci scritte dall\'utente', () {
    expect(c.homeDone(inv), 0);
    inv
      ..setHave('radio', true)
      ..addOwn(inBag: false, group: 'safety', name: 'Corda');
    expect(c.homeTotal(inv), c.homeItems.length + 1);
    expect(c.homeDone(inv), 1);
    inv.updateOwn(inv.ownHome.single, have: true);
    expect(c.homeDone(inv), 2);
    inv
      ..addOwn(inBag: true, group: 'docs', name: 'Foto dei familiari')
      ..updateOwn(inv.ownBag.single, bag: BagState.fromHome);
    expect(c.bagDone(inv), 1);
    expect(c.beforeLeaving(inv, 'it'), ['Foto dei familiari']);
  });
}
