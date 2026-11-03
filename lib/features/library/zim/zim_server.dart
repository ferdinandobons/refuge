import 'dart:convert';
import 'dart:io';

import 'zim_archive.dart';

/// Mini server HTTP su 127.0.0.1 che serve le pagine dei file ZIM alla WebView
/// (stesso principio di kiwix-serve). Accetta solo connessioni dal telefono stesso.
///
/// URL: `http://127.0.0.1:<porta>/<idLibro>/<percorso nel file ZIM>`
class ZimServer {
  ZimServer._();

  static final instance = ZimServer._();

  final _books = <String, ZimArchive>{};
  HttpServer? _server;

  void register(String id, ZimArchive archive) => _books[id] = archive;

  void unregister(String id) => _books.remove(id);

  Future<Uri> urlFor(String bookId, [String? entryUrl]) async {
    final server = _server ??= await _start();
    return Uri(
      scheme: 'http',
      host: '127.0.0.1',
      port: server.port,
      pathSegments: [bookId, ...?entryUrl?.split('/')],
    );
  }

  bool isLocal(Uri uri) => uri.host == '127.0.0.1' && uri.port == _server?.port;

  Future<HttpServer> _start() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen(_handle);
    return server;
  }

  Future<void> _handle(HttpRequest req) async {
    final res = req.response;
    try {
      final segments = req.uri.pathSegments;
      final book = segments.isEmpty ? null : _books[segments.first];
      if (book == null) return _notFound(res, 'Archivio non trovato.');

      final path = segments.skip(1).join('/');
      final entry = path.isEmpty ? await book.mainEntry() : await book.findByUrl(path);
      if (entry == null) return _notFound(res, 'Questa pagina non è inclusa nel file scaricato.');

      final target = await entry.resolve();
      if (target.index != entry.index || path.isEmpty) {
        // Redirect vero, così i link relativi della pagina di destinazione funzionano.
        res.redirect(await urlFor(segments.first, target.url), status: HttpStatus.found);
        return;
      }

      final data = await target.data();
      if (data == null) return _notFound(res, 'Contenuto non disponibile.');
      res.headers
        ..contentType = ContentType.parse(target.mimeType)
        ..set(HttpHeaders.cacheControlHeader, 'max-age=86400');
      res.add(data);
    } catch (e) {
      res.statusCode = HttpStatus.internalServerError;
      res.write('Errore nella lettura del file: $e');
    } finally {
      await res.close();
    }
  }

  void _notFound(HttpResponse res, String message) {
    res
      ..statusCode = HttpStatus.notFound
      ..headers.contentType = ContentType.html
      ..write('<!doctype html><meta name="viewport" content="width=device-width">'
          '<body style="font-family:sans-serif;padding:24px;background:#000;color:#ddd">'
          '<h3>Pagina non disponibile</h3><p>${const HtmlEscape().convert(message)}</p></body>');
  }
}
