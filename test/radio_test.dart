import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rifugio/features/tools/radio.dart';

/// Controlli di plausibilità sui dati radio (che vengono da fonti ufficiali): bande, canali e fonti.
void main() {
  final data = jsonDecode(File('assets/radio/radio.json').readAsStringSync()) as Map<String, dynamic>;
  final countries = (data['countries'] as Map<String, dynamic>).cast<String, Map<String, dynamic>>();

  test('canali PMR446 (standard europeo)', () {
    expect(pmr446(1), closeTo(446.00625, 1e-9));
    expect(pmr446(8), closeTo(446.09375, 1e-9));
    expect(pmr446(16), closeTo(446.19375, 1e-9));
  });

  test('ci sono dati e una data di controllo', () {
    expect(countries, isNotEmpty);
    expect(DateTime.tryParse(data['updated'] as String), isNotNull);
  });

  for (final MapEntry(key: code, value: c) in countries.entries) {
    test('$code: fonti ufficiali e valori nelle bande corrette', () {
      List<Map<String, dynamic>> list(String k) => ((c[k] as List?) ?? const []).cast<Map<String, dynamic>>();
      for (final k in ['emergency', 'dab', 'am', 'fm']) {
        for (final e in list(k)) {
          expect(e['source'], startsWith('https://'), reason: '$code $k $e');
        }
      }
      for (final e in list('fm')) {
        expect(e['mhz'], inInclusiveRange(87.5, 108.0), reason: '$code ${e['city']}');
        // Le frequenze FM in Europa sono multipli di 0,05 MHz.
        expect(((e['mhz'] as num) * 100).round() % 5, 0, reason: '$code ${e['city']} ${e['mhz']}');
      }
      for (final e in list('am')) {
        final k = e['khz'] as num;
        final lw = k >= 148.5 && k <= 283.5, mw = k >= 526.5 && k <= 1606.5, sw = k >= 2300 && k <= 26100;
        expect(lw || mw || sw, isTrue, reason: '$code ${e['station']} $k kHz');
      }
      for (final e in list('dab')) {
        expect(RegExp(r'^(5[A-D]|6[A-D]|7[A-D]|8[A-D]|9[A-D]|10[A-D]|10N|11[A-D]|11N|12[A-D]|12N|13[A-F])$').hasMatch(e['channel'] as String),
            isTrue, reason: '$code ${e['channel']}');
      }
    });
  }
}
