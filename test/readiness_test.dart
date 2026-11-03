import 'package:flutter_test/flutter_test.dart';
import 'package:rifugio/features/prepare/inventory.dart';
import 'package:rifugio/features/prepare/readiness_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test("piano: servono contatti, due punti d'incontro e rifugio", () {
    final plan = {'contacts': 'Anna 333 1234567', 'meetNear': 'Farmacia', 'meetFar': '  ', 'notes': 'Chiavi dal vicino'};
    expect(missingPlanFields((f) => plan[f]), ['meetFar', 'shelter']);
    final full = {...plan, 'meetFar': 'Parco', 'shelter': 'Palestra comunale'};
    expect(missingPlanFields((f) => full[f]), isEmpty);
  });

  test('acqua e cibo bastano solo se coprono entrambi i giorni scelti', () async {
    SharedPreferences.setMockInitialValues({});
    final inv = Inventory.instance;
    await inv.load();
    inv.setNeeds(people: 2, days: 3);
    inv.add('water', 1.5, 16); // 24 L = 2 persone × 3 giorni × 4 L
    expect(waterAndFoodReady(inv), isFalse); // manca il cibo
    inv.add('pasta', 500, 7); // 7 × 1800 kcal = 12.600 ≥ 2 × 3 × 2000
    expect(waterAndFoodReady(inv), isTrue);
    inv.setNeeds(days: 4); // l'acqua basta per 3 giorni, non per 4
    expect(waterAndFoodReady(inv), isFalse);
  });
}
