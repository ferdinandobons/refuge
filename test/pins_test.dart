import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:rifugio/features/maps/pins.dart';
import 'package:rifugio/features/tools/coords.dart';
import 'package:rifugio/features/tools/location_screen.dart';

void main() {
  group('coordinate scritte a mano', () {
    void same(String input, double lat, double lon) {
      final p = parseCoordinates(input);
      expect(p, isNotNull, reason: input);
      expect(p!.latitude, closeTo(lat, 1e-4), reason: input);
      expect(p.longitude, closeTo(lon, 1e-4), reason: input);
    }

    test('decimali con punto, virgola, punto e virgola', () {
      same('45.4642, 9.1900', 45.4642, 9.19);
      same('45.4642,9.19', 45.4642, 9.19);
      same('45,4642 9,19', 45.4642, 9.19);
      same('45,4642, 9,19', 45.4642, 9.19);
      same('-33.8568; 151.2153', -33.8568, 151.2153);
      same('40.4168 -3.7038', 40.4168, -3.7038);
    });

    test('lettere dei punti cardinali', () {
      same('45.4642 N 9.19 E', 45.4642, 9.19);
      same('40.4168N 3.7038W', 40.4168, -3.7038);
      same('40.4168 N 3.7038 O', 40.4168, -3.7038);
    });

    test('gradi, primi e secondi', () {
      same('45°27\'51"N 9°11\'24"E', 45 + 27 / 60 + 51 / 3600, 9 + 11 / 60 + 24 / 3600);
      same('45° 27′ 51″ N, 9° 11′ 24″ E', 45 + 27 / 60 + 51 / 3600, 9 + 11 / 60 + 24 / 3600);
      same('33°51\'S 151°12\'E', -(33 + 51 / 60), 151 + 12 / 60);
      // Prima la longitudine: le lettere la riconoscono.
      same('9°11\'24"E 45°27\'51"N', 45 + 27 / 60 + 51 / 3600, 9 + 11 / 60 + 24 / 3600);
    });

    test('valori sbagliati', () {
      for (final s in ['', 'casa', '95, 10', '45, 200', '45', '1 2 3']) {
        expect(parseCoordinates(s), isNull, reason: s);
      }
    });
  });

  test('distanza e direzione in linea d\'aria', () {
    const roma = LatLng(41.9028, 12.4964), milano = LatLng(45.4642, 9.19);
    // Circa 477 km, verso nord-ovest.
    expect(distanceMeters(roma, milano) / 1000, closeTo(477, 5));
    final deg = bearingDegrees(roma, milano);
    expect(deg, inInclusiveRange(300, 340));
    expect(compassPoint(deg, 'O'), 'NO');
    expect(compassPoint(deg, 'W'), 'NW');
    expect(compassPoint(90, 'W', east: 'O'), 'O');
    expect(compassPoint(0, 'W'), 'N');
    expect(compassPoint(359, 'W'), 'N');
  });

  test('gradi, primi e secondi: mai 60 secondi', () {
    expect(toDms(9.2, isLat: false), "9° 12' 00.0\" E");
    expect(toDms(45.47, isLat: true), "45° 28' 12.0\" N");
    expect(toDms(-3.7038, isLat: false, west: 'O'), "3° 42' 13.7\" O");
    expect(toDms(10.999999, isLat: true), "11° 00' 00.0\" N");
  });
}
