import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'zim_archive.dart';
import 'zim_server.dart';

/// Un file ZIM presente sul dispositivo.
class ZimBook {
  ZimBook._(this.id, this.file, this.size, this.archive, this.title, this.description, this.language, this.icon);

  final String id;
  final File file;
  final int size;
  final ZimArchive archive;
  final String title, description, language;
  final Uint8List? icon;

  static Future<ZimBook> open(File file) async {
    final z = await ZimArchive.open(file.path);
    final name = file.uri.pathSegments.last;
    return ZimBook._(
      name.replaceAll(RegExp(r'\.zim$'), '').replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_'),
      file,
      z.size,
      z,
      await z.metadata('Title') ?? name,
      await z.metadata('Description') ?? '',
      await z.metadata('Language') ?? '',
      await z.illustration(),
    );
  }
}

/// Elenco dei file ZIM nella cartella `zim` dei documenti dell'app.
///
/// Su iPhone la cartella è visibile nell'app File e nel Finder del Mac, così i file grandi
/// si possono anche copiare dal computer invece di scaricarli dal telefono.
class ZimLibrary extends ChangeNotifier {
  ZimLibrary._();

  static final instance = ZimLibrary._();

  final _books = <String, ZimBook>{};
  final _broken = <String>{};
  bool _loaded = false;

  List<ZimBook> get books => _books.values.toList()..sort((a, b) => a.title.compareTo(b.title));

  bool get loaded => _loaded;

  static Future<Directory> directory() async {
    final dir = Directory('${(await getApplicationDocumentsDirectory()).path}/zim');
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
      await _excludeFromBackup(dir);
    }
    return dir;
  }

  /// Decine di GB non devono finire nel backup iCloud.
  static Future<void> _excludeFromBackup(Directory dir) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) return;
    try {
      await const MethodChannel('rifugio/files').invokeMethod('excludeFromBackup', dir.path);
    } catch (_) {}
  }

  Future<void> refresh() async {
    final dir = await directory();
    final files = dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.toLowerCase().endsWith('.zim'))
        .map((f) => f.path)
        .toSet();

    for (final b in _books.values.where((b) => !files.contains(b.file.path)).toList()) {
      _books.remove(b.id);
      ZimServer.instance.unregister(b.id);
      await b.archive.close();
    }
    for (final path in files) {
      if (_books.values.any((b) => b.file.path == path) || _broken.contains(path)) continue;
      try {
        final book = await ZimBook.open(File(path));
        _books[book.id] = book;
        ZimServer.instance.register(book.id, book.archive);
      } catch (_) {
        _broken.add(path); // file incompleto o non valido
      }
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> delete(ZimBook book) async {
    _books.remove(book.id);
    ZimServer.instance.unregister(book.id);
    await book.archive.close();
    if (book.file.existsSync()) await book.file.delete();
    notifyListeners();
  }
}
