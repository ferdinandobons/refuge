import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rifugio/app/countries.dart';
import 'package:rifugio/features/prepare/paper_copy.dart';
import 'package:rifugio/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('i testi da stampare non perdono caratteri (nessun simbolo diventa ?)', () {
    final cards = (jsonDecode(File('assets/cards/cards.json').readAsStringSync()) as List).cast<Map<String, dynamic>>();
    final checklist = File('assets/supplies/checklist.json').readAsStringSync();
    for (final lang in ['it', 'en', 'fr', 'de', 'es']) {
      for (final c in cards) {
        final l = c[lang] as Map<String, dynamic>;
        for (final s in [l['title'] as String, ...(l['steps'] as List).cast<String>(), ...(l['never'] as List).cast<String>()]) {
          expect(clean(s).contains('?') && !s.contains('?'), isFalse, reason: '${c['id']} $lang: $s');
        }
      }
    }
    for (final s in RegExp(r'"(?:it|en|fr|de|es)": "([^"]*)"').allMatches(checklist).map((m) => m.group(1)!)) {
      expect(clean(s).contains('?') && !s.contains('?'), isFalse, reason: s);
    }
    expect(clean('≈ 5 L ✕ • «più» 1–2 „Ja“'), '~ 5 L x - «più» 1-2 "Ja"');
  });

  for (final lang in ['it', 'en', 'fr', 'de', 'es']) {
    test('il PDF si crea ($lang)', () async {
      SharedPreferences.setMockInitialValues({'plan:contacts': 'Anna 333 1234567'});
      await initializeDateFormatting(lang); // nell'app lo fanno le traduzioni di Flutter
      final t = lookupAppLocalizations(Locale(lang));
      final bytes = await buildPaperCopy(language: lang, country: countryByCode('IT'), t: t);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
      expect(bytes.length, greaterThan(20000));
    });
  }
}
