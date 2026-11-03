import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rifugio/features/guides/guide.dart';
import 'package:rifugio/features/tools/coords.dart';
import 'package:rifugio/features/prepare/inventory.dart';
import 'package:rifugio/features/tools/fallout.dart';
import 'package:rifugio/features/tools/fallout_phases.dart';
import 'package:rifugio/features/tools/morse.dart';

void main() {
  group('coordinate', () {
    test('UTM all\'origine (0,0)', () {
      final u = toUtm(0, 0)!;
      expect(u.zone, 31);
      expect(u.band, 'N');
      expect(u.easting, closeTo(166021.44, 0.1));
      expect(u.northing, closeTo(0, 0.1));
    });

    test('MGRS di Roma è nel quadrato 33T TG', () {
      expect(toMgrs(41.8902, 12.4922), startsWith('33T TG'));
    });

    test('Norvegia usa la zona 32', () {
      expect(toUtm(60, 5)!.zone, 32);
    });

    test('DMS', () {
      expect(toDms(41.5, isLat: true), "41° 30' 00.0\" N");
      expect(toDms(-12.25, isLat: false, west: 'O'), "12° 15' 00.0\" O");
    });
  });

  group('morse', () {
    test('codifica', () {
      expect(encodeMorse('sos'), '... --- ...');
      expect(encodeMorse('Ciao è'), '-.-. .. .- --- / .');
    });

    test('tempi di SOS', () {
      final t = morseTimings('SOS');
      expect(t.take(6), [1, 1, 1, 1, 1, 3]);
      expect(t.last, 7);
      expect(t.length, 18);
    });
  });

  group('fallout', () {
    test('regola 7-10', () {
      expect(falloutRate(100, 1, 7), closeTo(9.7, 0.1));
      expect(falloutRate(100, 1, 49), closeTo(0.94, 0.05));
    });

    test('dose positiva e crescente', () {
      expect(falloutDose(10, 1, 1, 2), greaterThan(0));
      expect(falloutDose(10, 1, 1, 48), greaterThan(falloutDose(10, 1, 1, 24)));
    });
  });

  test('tutte le guide e checklist si leggono correttamente', () {
    for (final dir in ['assets/guides', 'assets/checklists']) {
      for (final f in Directory(dir).listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.md'))) {
        final g = Guide.parse('x', f.readAsStringSync());
        expect(g.title, isNot('x'), reason: f.path);
        expect(g.blocks, isNotEmpty, reason: f.path);
        expect(g.blocks.any((b) => b.text.startsWith('#')), isFalse, reason: f.path);
      }
    }
  });

  test('ogni documento del catalogo esiste e ha licenza e fonte', () {
    final list = jsonDecode(File('assets/documents/catalog.json').readAsStringSync()) as List;
    expect(list, isNotEmpty);
    for (final d in list.cast<Map<String, dynamic>>()) {
      expect(File('assets/documents/${d['file']}').existsSync(), isTrue, reason: d['file'] as String);
      expect(d['license'], isNotEmpty);
      expect(d['source'], isNotEmpty);
    }
  });

  test('le guide ufficiali riportano la dicitura di attribuzione', () {
    for (final f in Directory('assets/guides').listSync().whereType<File>().where((f) => f.path.contains('/pc-'))) {
      final g = Guide.parse('x', f.readAsStringSync());
      expect(g.status, GuideStatus.ufficiale, reason: f.path);
      expect(g.sources.first, startsWith('Fonte: Io non rischio.'), reason: f.path);
    }
  });

  test('i rimandi delle guide puntano a documenti, pagine e guide esistenti', () {
    final docs = {
      for (final d in (jsonDecode(File('assets/documents/catalog.json').readAsStringSync()) as List).cast<Map>())
        d['file'] as String: d['pages'] as int,
    };
    final files = Directory('assets/guides').listSync().whereType<File>().where((f) => f.path.endsWith('.md'));
    final ids = files.map((f) => f.uri.pathSegments.last.replaceAll('.md', '')).toSet();
    var links = 0;
    for (final f in files) {
      final g = Guide.parse('x', f.readAsStringSync());
      for (final b in g.blocks.where((b) => b.target != null)) {
        links++;
        final [kind, value] = b.target!.split(':');
        if (kind == 'doc') {
          final [file, page] = value.split('#');
          expect(docs, contains(file), reason: '${f.path}: $file');
          expect(int.parse(page), inInclusiveRange(1, docs[file]!), reason: '${f.path}: ${b.target}');
        } else if (kind == 'guide') {
          expect(ids, contains(value), reason: '${f.path}: ${b.target}');
        } else {
          expect(kind, 'zim', reason: '${f.path}: ${b.target}');
        }
      }
      if (g.status == GuideStatus.estratti) {
        expect(g.blocks.where((b) => b.type == BlockType.citation), isNotEmpty, reason: f.path);
      }
    }
    expect(links, greaterThan(20));
  });

  test('schede: tutte le lingue, stessi passi, solo segnaposto noti', () {
    final cards = (jsonDecode(File('assets/cards/cards.json').readAsStringSync()) as List).cast<Map<String, dynamic>>();
    expect(cards.length, greaterThanOrEqualTo(14));
    for (final c in cards) {
      final it = c['it'] as Map<String, dynamic>;
      for (final lang in ['it', 'en', 'fr', 'de', 'es']) {
        final l = c[lang] as Map<String, dynamic>?;
        expect(l, isNotNull, reason: '${c['id']} $lang');
        expect((l!['steps'] as List).length, (it['steps'] as List).length, reason: '${c['id']} $lang');
        expect((l['never'] as List).length, (it['never'] as List).length, reason: '${c['id']} $lang');
        expect(l['title'], isNotEmpty);
        final text = [...l['steps'] as List, ...l['never'] as List].join(' ');
        for (final m in RegExp(r'\{(\w+)\}').allMatches(text)) {
          expect(['emergency', 'alert'], contains(m.group(1)), reason: '${c['id']} $lang');
        }
      }
    }
  });

  test('liste: stessa struttura in tutte le lingue', () {
    for (final name in ['zaino-72-ore.md', 'scorte-casa.md']) {
      final it = Guide.parse('x', File('assets/checklists/it/$name').readAsStringSync());
      for (final lang in ['en', 'fr', 'de', 'es']) {
        final l = Guide.parse('x', File('assets/checklists/$lang/$name').readAsStringSync());
        int count(Guide g, BlockType t) => g.blocks.where((b) => b.type == t).length;
        expect(count(l, BlockType.bullet), count(it, BlockType.bullet), reason: '$lang/$name');
        expect(count(l, BlockType.heading), count(it, BlockType.heading), reason: '$lang/$name');
      }
    }
  });

  group('inventario', () {
    test('totali di acqua, calorie e gas', () {
      final inv = Inventory.instance
        ..people = 2
        ..days = 10
        ..items = [
          SupplyItem(id: 'a', preset: 'water', size: 1.5, qty: 10),
          SupplyItem(id: 'b', preset: 'water', size: 5, qty: 2),
          SupplyItem(id: 'c', preset: 'pasta', size: 500, qty: 4),
          SupplyItem(id: 'd', preset: 'customFood', size: 100, qty: 1, kcalPer100: 250),
          SupplyItem(id: 'e', preset: 'cartridge', size: 220, qty: 2),
          SupplyItem(id: 'f', preset: 'batteries', size: 1, qty: 8),
        ];
      expect(inv.waterLiters, 25);
      expect(inv.waterNeeded, 80);
      expect(inv.kcal, 4 * 1800 + 250);
      expect(inv.gasMeals, 18);
      expect(inv.waterDays(), closeTo(3.125, 1e-9));
      expect(inv.foodDays(), closeTo(7450 / 4000, 1e-9));
    });

    test('ogni tipo di scorta ha unità e valori sensati', () {
      for (final p in kPresets) {
        expect(['L', 'g', 'ml', 'pz'], contains(p.unit), reason: p.key);
        expect(p.sizes, isNotEmpty, reason: p.key);
        expect(p.sizes.every((s) => s > 0), isTrue, reason: p.key);
        if (p.category == SupplyCategory.food) expect(p.kcalPer100, greaterThan(0), reason: p.key);
      }
    });
  });

  group('fasi del fallout', () {
    test('confini delle fasi', () {
      expect(phaseAt(0).phase, FalloutPhase.immediate);
      expect(phaseAt(0.99).phase, FalloutPhase.immediate);
      expect(phaseAt(1).phase, FalloutPhase.shelter);
      expect(phaseAt(23.9).phase, FalloutPhase.shelter);
      expect(phaseAt(24).phase, FalloutPhase.essentialOnly);
      expect(phaseAt(100).phase, FalloutPhase.decreasing);
      expect(phaseAt(400).phase, FalloutPhase.low);
      expect(phaseAt(1).canGoOut, isFalse);
      expect(phaseAt(30).canGoOut, isTrue);
    });

    test('radiazione residua secondo la regola del 7-10', () {
      expect(remainingFraction(0.5), 1);
      expect(remainingFraction(7), closeTo(0.097, 0.002));
      expect(remainingFraction(49), closeTo(0.0094, 0.0005));
    });
  });
}
