import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rifugio/features/guides/guide.dart';
import 'package:rifugio/features/tools/coords.dart';
import 'package:rifugio/features/prepare/inventory.dart';
import 'package:rifugio/features/prepare/supply_checklist.dart';
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
    for (final dir in ['assets/guides']) {
      for (final f in Directory(dir).listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.md'))) {
        final g = Guide.parse('x', f.readAsStringSync());
        expect(g.title, isNot('x'), reason: f.path);
        expect(g.blocks, isNotEmpty, reason: f.path);
        expect(g.blocks.any((b) => b.text.startsWith('#')), isFalse, reason: f.path);
      }
    }
  });

  test('documenti: inclusi presenti, gli altri scaricabili dal sito ufficiale, in inglese e in 5 lingue', () {
    final list = (jsonDecode(File('assets/documents/catalog.json').readAsStringSync()) as List).cast<Map<String, dynamic>>();
    expect(list, isNotEmpty);
    for (final d in list) {
      final url = d['url'] as String?;
      if (url == null) {
        expect(File('assets/documents/${d['file']}').existsSync(), isTrue, reason: d['file'] as String);
      } else {
        expect(url, startsWith('https://'), reason: d['file'] as String);
      }
      expect(['it', 'en', 'fr', 'de', 'es'], contains(d['language']), reason: d['file'] as String);
      expect((d['description'] as Map).keys.toSet(), {'it', 'en', 'fr', 'de', 'es'}, reason: d['file'] as String);
      expect(d['license'], isNotEmpty);
      expect(d['source'], startsWith('https://'));
      expect(d['size'] as int, greaterThan(0));
    }
    // Ogni opera ha la versione inglese, usata quando manca la lingua scelta.
    for (final id in list.map((d) => d['id']).toSet()) {
      expect(list.any((d) => d['id'] == id && d['language'] == 'en'), isTrue, reason: '$id');
    }
    expect(list.map((d) => d['file']).toSet().length, list.length);
  });

  test('guide tradotte: stessa struttura dell\'italiano e fonte originale citata', () {
    for (final lang in ['en', 'fr', 'de', 'es']) {
      final files = Directory('assets/guides/$lang').listSync().whereType<File>().toList();
      expect(files.length, 7, reason: lang);
      for (final f in files) {
        final name = f.uri.pathSegments.last;
        final it = Guide.parse('x', File('assets/guides/$name').readAsStringSync());
        final tr = Guide.parse('x', f.readAsStringSync());
        int count(Guide g, BlockType t) => g.blocks.where((b) => b.type == t).length;
        for (final t in [BlockType.heading, BlockType.bullet]) {
          expect(count(tr, t), count(it, t), reason: '$lang/$name $t');
        }
        expect(tr.sources.join(' '), contains('Fonte: Io non rischio. Dipartimento della Protezione Civile'), reason: '$lang/$name');
        expect(tr.sources.join(' '), contains('CC BY 4.0'), reason: '$lang/$name');
      }
    }
  });

  test('schede in ordine: prima le rosse, poi le gialle, poi le blu', () {
    final groups = [
      for (final c in (jsonDecode(File('assets/cards/cards.json').readAsStringSync()) as List).cast<Map>()) c['group'] as String,
    ];
    const rank = {'body': 0, 'danger': 1, 'survive': 2};
    final ranks = [for (final g in groups) rank[g]!];
    expect(ranks, [...ranks]..sort());
  });

  test('i rimandi delle schede puntano a documenti e guide esistenti', () {
    final docs = (jsonDecode(File('assets/documents/catalog.json').readAsStringSync()) as List).cast<Map>();
    final keys = {for (final d in docs) d['file'], for (final d in docs) d['id']};
    final guides = Directory('assets/guides').listSync().map((f) => f.uri.pathSegments.last.replaceAll('.md', '')).toSet();
    for (final c in (jsonDecode(File('assets/cards/cards.json').readAsStringSync()) as List).cast<Map>()) {
      for (final r in (c['refs'] as List).cast<String>()) {
        if (r.startsWith('doc:')) expect(keys, contains(r.substring(4).split('#').first), reason: '${c['id']} $r');
        if (r.startsWith('guide:')) expect(guides, contains(r.substring(6)), reason: '${c['id']} $r');
      }
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
    for (final f in files) {
      final g = Guide.parse('x', f.readAsStringSync());
      for (final b in g.blocks.where((b) => b.target != null)) {
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

  test('catalogo delle cose da avere e dello zaino: 5 lingue, fonti, rimandi validi', () {
    final j = jsonDecode(File('assets/supplies/checklist.json').readAsStringSync()) as Map<String, dynamic>;
    final c = SupplyChecklist.fromJson(j);
    final homeIds = [for (final i in c.homeItems) i.id];
    final bagIds = [for (final i in c.bagItems) i.id];
    expect(homeIds.toSet().length, homeIds.length);
    expect(bagIds.toSet().length, bagIds.length);
    for (final g in [...c.home, ...c.bag]) {
      expect(g.names.keys.toSet(), {'it', 'en', 'fr', 'de', 'es'}, reason: g.id);
      for (final i in g.items) {
        expect(i.labels.values.every((l) => l.trim().isNotEmpty), isTrue, reason: i.id);
        expect(i.source, isNotEmpty, reason: i.id);
      }
    }
    for (final b in c.bagItems) {
      if (b.home != null) expect(homeIds, contains(b.home), reason: b.id);
      if (b.homePreset != null) expect(isPreset(b.homePreset!), isTrue, reason: b.id);
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
        expect(['L', 'g', 'ml', 'mAh', 'Wh'], contains(p.unit), reason: p.key);
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
