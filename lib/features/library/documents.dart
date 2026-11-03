import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Documento ufficiale originale (vedi `assets/documents/catalog.json`).
///
/// Quelli con licenza aperta sono inclusi nell'app ([url] nullo); gli altri si scaricano
/// su richiesta dal sito ufficiale dell'ente, senza modifiche.
class OfficialDocument {
  const OfficialDocument({
    required this.id,
    required this.file,
    required this.url,
    required this.title,
    required this.author,
    required this.year,
    required this.language,
    required this.pages,
    required this.size,
    required this.descriptions,
    required this.license,
    required this.source,
  });

  factory OfficialDocument.fromJson(Map<String, dynamic> j) => OfficialDocument(
        id: j['id'] as String,
        file: j['file'] as String,
        url: j['url'] as String?,
        title: j['title'] as String,
        author: j['author'] as String,
        year: j['year'] as int,
        language: j['language'] as String,
        pages: j['pages'] as int,
        size: j['size'] as int,
        descriptions: (j['description'] as Map).cast<String, String>(),
        license: j['license'] as String,
        source: j['source'] as String,
      );

  /// Stesso [id] = stessa opera in lingue diverse.
  final String id, file, title, author, language, license, source;
  final String? url;
  final int year, pages, size;
  final Map<String, String> descriptions;

  bool get bundled => url == null;
  String get asset => 'assets/documents/$file';
  String description(String language) => descriptions[language] ?? descriptions['en']!;
}

Future<List<OfficialDocument>>? _cache;

Future<List<OfficialDocument>> loadAllDocuments() => _cache ??= rootBundle
    .loadString('assets/documents/catalog.json')
    .then((s) => [for (final j in jsonDecode(s) as List) OfficialDocument.fromJson(j as Map<String, dynamic>)]);

/// Un documento per opera: nella lingua scelta se esiste, altrimenti in inglese.
Future<List<OfficialDocument>> loadDocuments(String language) async {
  final all = await loadAllDocuments();
  final ids = {for (final d in all) d.id};
  return [
    for (final id in ids)
      ?(all.where((d) => d.id == id && d.language == language).firstOrNull ??
          all.where((d) => d.id == id && d.language == 'en').firstOrNull),
  ];
}

/// Documenti scaricati, nella cartella dell'app (si cancellano disinstallandola).
class DocumentFiles extends ChangeNotifier {
  DocumentFiles._();

  static final instance = DocumentFiles._();

  /// Avanzamento (0–1) dei download in corso, per file.
  final progress = <String, double>{};
  final _ready = <String>{};
  Directory? _dir;

  Future<Directory> _directory() async {
    if (_dir != null) return _dir!;
    final dir = Directory('${(await getApplicationDocumentsDirectory()).path}/documents');
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
        try {
          await const MethodChannel('rifugio/files').invokeMethod('excludeFromBackup', dir.path);
        } catch (_) {}
      }
    }
    return _dir = dir;
  }

  Future<File> file(OfficialDocument d) async => File('${(await _directory()).path}/${d.file}');

  /// Incluso nell'app o già scaricato.
  bool isAvailable(OfficialDocument d) => d.bundled || _ready.contains(d.file);

  Future<void> refresh(List<OfficialDocument> docs) async {
    for (final d in docs.where((d) => !d.bundled)) {
      if ((await file(d)).existsSync()) _ready.add(d.file);
    }
    notifyListeners();
  }

  /// Scarica dal sito ufficiale; restituisce false se non riesce.
  Future<bool> download(OfficialDocument d) async {
    if (progress.containsKey(d.file)) return false;
    progress[d.file] = 0;
    notifyListeners();
    final target = await file(d);
    final part = File('${target.path}.part');
    final client = HttpClient();
    try {
      final res = await (await client.getUrl(Uri.parse(d.url!))).close();
      final type = res.headers.contentType?.mimeType ?? '';
      if (res.statusCode != 200 || !type.contains('pdf')) throw HttpException('${res.statusCode} $type');
      final total = res.contentLength > 0 ? res.contentLength : d.size;
      final sink = part.openWrite();
      var received = 0;
      await for (final chunk in res) {
        sink.add(chunk);
        received += chunk.length;
        progress[d.file] = (received / total).clamp(0, 1);
        notifyListeners();
      }
      await sink.close();
      await part.rename(target.path);
      _ready.add(d.file);
      return true;
    } catch (_) {
      if (part.existsSync()) await part.delete();
      return false;
    } finally {
      client.close();
      progress.remove(d.file);
      notifyListeners();
    }
  }

  Future<void> delete(OfficialDocument d) async {
    final f = await file(d);
    if (f.existsSync()) await f.delete();
    _ready.remove(d.file);
    notifyListeners();
  }
}
