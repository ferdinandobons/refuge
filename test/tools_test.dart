import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rifugio/features/guides/guide.dart';
import 'package:rifugio/features/tools/coords.dart';
import 'package:rifugio/features/tools/fallout.dart';
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
      expect(toDms(-12.25, isLat: false), "12° 15' 00.0\" O");
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
      for (final f in Directory(dir).listSync().whereType<File>().where((f) => f.path.endsWith('.md'))) {
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
}
