import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rifugio/features/library/zim/zim_archive.dart';
import 'package:rifugio/features/library/zim/zim_server.dart';

/// Test sui file ZIM reali, che non sono nel repository (troppo grandi).
/// Scarica ad esempio wikivoyage_it_all_nopic e nhs.uk_en_medicines da download.kiwix.org
/// e avvia con: ZIM_TEST_DIR=/percorso/cartella flutter test test/zim_test.dart
void main() {
  final dir = Platform.environment['ZIM_TEST_DIR'];
  final files = dir == null
      ? <File>[]
      : Directory(dir).listSync().whereType<File>().where((f) => f.path.endsWith('.zim')).toList();

  test('file ZIM non valido', () async {
    final tmp = File('${Directory.systemTemp.path}/not-a-zim.zim')..writeAsBytesSync(List.filled(100, 1));
    expect(ZimArchive.open(tmp.path), throwsFormatException);
  });

  for (final f in files) {
    group(f.uri.pathSegments.last, () {
      late ZimArchive z;
      setUpAll(() async => z = await ZimArchive.open(f.path));
      tearDownAll(() => z.close());

      test('header e metadati', () async {
        expect(z.entryCount, greaterThan(0));
        expect(z.mimeTypes, contains('text/html'));
        final title = await z.metadata('Title');
        expect(title, isNotEmpty);
        // ignore: avoid_print
        print('v${z.majorVersion}.${z.minorVersion} "$title" ${z.entryCount} voci, lingua ${await z.metadata('Language')}');
      });

      test('pagina principale ha contenuto HTML', () async {
        final main = await (await z.mainEntry())!.resolve();
        final html = utf8.decode((await main.data())!, allowMalformed: true);
        expect(main.mimeType, startsWith('text/html'));
        expect(html, contains('<'));
        expect(await z.findByUrl(main.url), isNotNull);
      });

      test('ricerca per titolo', () async {
        final main = await (await z.mainEntry())!.resolve();
        final word = main.title.split(' ').first;
        final hits = await z.searchTitles(word.substring(0, word.length.clamp(1, 3)).toLowerCase());
        expect(hits, isNotEmpty);
        for (final h in hits.take(3)) {
          final data = await h.data();
          expect(data, isNotNull, reason: h.path);
        }
        // ignore: avoid_print
        print('ricerca "$word": ${hits.take(5).map((e) => e.title).join(', ')}');
      });

      test('il server locale serve la pagina principale e i suoi file', () async {
        ZimServer.instance.register('test', z);
        final client = HttpClient();
        try {
          final res = await (await client.getUrl(await ZimServer.instance.urlFor('test'))).close();
          final body = await res.transform(utf8.decoder).join();
          expect(res.statusCode, 200);
          expect(res.headers.contentType?.mimeType, 'text/html');
          expect(res.redirects, isNotEmpty); // "/" reindirizza alla pagina principale
          final missing = await (await client.getUrl(await ZimServer.instance.urlFor('test', 'non/esiste'))).close();
          expect(missing.statusCode, 404);
          await missing.drain<void>();
          // Il primo file collegato (CSS, immagine o script) deve essere servito.
          final link = RegExp(r'(?:src|href)="([^"#?:]+)"').allMatches(body).map((m) => m.group(1)!).first;
          final asset = await (await client.getUrl(res.redirects.last.location.isAbsolute
                  ? res.redirects.last.location.resolve(link)
                  : (await ZimServer.instance.urlFor('test')).resolve(link)))
              .close();
          await asset.drain<void>();
          expect(asset.statusCode, 200, reason: link);
        } finally {
          client.close();
        }
      });
    });
  }
}
