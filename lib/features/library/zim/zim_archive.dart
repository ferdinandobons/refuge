import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:archive/archive.dart';

/// Lettore di file ZIM (formato openZIM, usato da Kiwix per Wikipedia, WikiMed…), in Dart puro.
///
/// Specifica: https://wiki.openzim.org/wiki/ZIM_file_format
/// Legge solo le parti necessarie con accesso casuale, quindi funziona anche con file da 100+ GB.
class ZimArchive {
  ZimArchive._(this.path, this._file, this.size);

  final String path;
  final RandomAccessFile _file;
  final int size;

  late final int majorVersion;
  late final int minorVersion;
  late final int entryCount;
  late final int clusterCount;
  late final int _pathPtrPos;
  late final int _titlePtrPos;
  late final int _clusterPtrPos;
  late final int _mainPage;
  late final int _checksumPos;
  late final List<String> mimeTypes;

  /// Dal formato 6.1 tutti i contenuti stanno nel namespace "C" e gli URL non includono il namespace.
  bool get usesNewNamespaces => majorVersion > 6 || (majorVersion == 6 && minorVersion >= 1);

  static const _noEntry = 0xffffffff;

  static Future<ZimArchive> open(String path) async {
    final file = File(path);
    final raf = await file.open();
    final z = ZimArchive._(path, raf, await raf.length());
    try {
      await z._readHeader();
    } catch (_) {
      await raf.close();
      rethrow;
    }
    return z;
  }

  Future<void> close() => _locked(_file.close);

  // ---- Accesso al file (serializzato: RandomAccessFile non supporta letture concorrenti) ----

  Future<void> _queue = Future.value();

  Future<T> _locked<T>(Future<T> Function() action) {
    final result = _queue.then((_) => action());
    _queue = result.then((_) {}, onError: (_) {});
    return result;
  }

  Future<Uint8List> _read(int pos, int length) => _locked(() async {
        await _file.setPosition(pos);
        return _file.read(length);
      });

  Future<int> _u64(int pos) async => ByteData.sublistView(await _read(pos, 8)).getUint64(0, Endian.little);

  Future<int> _u32(int pos) async => ByteData.sublistView(await _read(pos, 4)).getUint32(0, Endian.little);

  Future<void> _readHeader() async {
    final h = ByteData.sublistView(await _read(0, 80));
    if (h.lengthInBytes < 80 || h.getUint32(0, Endian.little) != 0x044D495A) {
      throw const FormatException('Non è un file ZIM');
    }
    majorVersion = h.getUint16(4, Endian.little);
    minorVersion = h.getUint16(6, Endian.little);
    entryCount = h.getUint32(24, Endian.little);
    clusterCount = h.getUint32(28, Endian.little);
    _pathPtrPos = h.getUint64(32, Endian.little);
    _titlePtrPos = h.getUint64(40, Endian.little);
    _clusterPtrPos = h.getUint64(48, Endian.little);
    final mimeListPos = h.getUint64(56, Endian.little);
    _mainPage = h.getUint32(64, Endian.little);
    _checksumPos = h.getUint64(72, Endian.little);

    // Lista dei MIME type: stringhe terminate da \0, chiusa da una stringa vuota.
    final raw = await _read(mimeListPos, (_pathPtrPos - mimeListPos).clamp(0, 64 * 1024));
    mimeTypes = [];
    var start = 0;
    for (var i = 0; i < raw.length; i++) {
      if (raw[i] != 0) continue;
      if (i == start) break;
      mimeTypes.add(latin1.decode(raw.sublist(start, i)));
      start = i + 1;
    }
  }

  // ---- Voci (directory entries) ----

  final _entryCache = _Lru<int, ZimEntry>(4096);

  Future<ZimEntry> entryAt(int index) async {
    final cached = _entryCache[index];
    if (cached != null) return cached;
    final pos = await _u64(_pathPtrPos + index * 8);
    var len = 512;
    while (true) {
      final b = await _read(pos, len);
      final e = ZimEntry._parse(this, index, b);
      if (e != null) return _entryCache[index] = e;
      if (b.length < len) throw const FormatException('Voce ZIM troncata');
      len *= 4;
    }
  }

  /// Ricerca binaria nella lista ordinata per namespace + percorso.
  Future<ZimEntry?> findByPath(String namespace, String path) async {
    final key = utf8.encode('$namespace$path');
    var lo = 0, hi = entryCount - 1;
    while (lo <= hi) {
      final mid = (lo + hi) >> 1;
      final e = await entryAt(mid);
      final c = _compareBytes(utf8.encode('${e.namespace}${e.path}'), key);
      if (c == 0) return e;
      c < 0 ? lo = mid + 1 : hi = mid - 1;
    }
    return null;
  }

  /// Trova la voce corrispondente a un URL relativo del contenuto (es. "Roma" o, nei vecchi ZIM, "A/Roma").
  Future<ZimEntry?> findByUrl(String url) {
    if (usesNewNamespaces) return findByPath('C', url);
    final slash = url.indexOf('/');
    if (slash != 1) return Future.value(null);
    return findByPath(url[0], url.substring(2));
  }

  Future<ZimEntry?> mainEntry() async {
    if (_mainPage != _noEntry && _mainPage < entryCount) return entryAt(_mainPage);
    return findByPath('W', 'mainPage');
  }

  /// Metadati (namespace "M"), es. Title, Description, Language, Creator, Date.
  Future<String?> metadata(String name) async {
    final e = await findByPath('M', name);
    if (e == null) return null;
    final data = await e.data();
    return data == null ? null : utf8.decode(data, allowMalformed: true);
  }

  Future<Uint8List?> illustration() async {
    final e = await findByPath('M', 'Illustration_48x48@1');
    return e?.data();
  }

  // ---- Ricerca per titolo ----

  _TitleIndex? _titleIndex;

  Future<_TitleIndex> _titles() async {
    if (_titleIndex != null) return _titleIndex!;
    // Formato recente: liste di indici nel namespace X. v1 contiene solo gli articoli "principali".
    for (final name in ['listing/titleOrdered/v1', 'listing/titleOrdered/v0']) {
      final e = await findByPath('X', name);
      if (e != null && !e.isRedirect) {
        final loc = await _blobLocation(e.clusterNumber, e.blobNumber);
        return _titleIndex = _TitleIndex(this, loc.$1, loc.$2, loc.$3 ~/ 4);
      }
    }
    if (_titlePtrPos != 0xffffffffffffffff && _titlePtrPos != 0) {
      return _titleIndex = _TitleIndex(this, null, _titlePtrPos, entryCount);
    }
    return _titleIndex = _TitleIndex(this, null, 0, 0);
  }

  /// Articoli il cui titolo inizia con [prefix]. Prova anche con l'iniziale maiuscola.
  Future<List<ZimEntry>> searchTitles(String prefix, {int limit = 30}) async {
    final q = prefix.trim();
    if (q.isEmpty) return [];
    final variants = <String>{q, q[0].toUpperCase() + q.substring(1)};
    final index = await _titles();
    final out = <ZimEntry>[];
    final seen = <int>{};
    for (final v in variants) {
      final key = utf8.encode(v);
      var i = await index.lowerBound(key);
      while (i < index.length && out.length < limit) {
        final e = await entryAt(await index.entryIndex(i));
        if (!_startsWith(utf8.encode(e.title), key)) break;
        if (_isArticle(e) && seen.add(e.index)) out.add(e);
        i++;
      }
    }
    out.sort((a, b) => a.title.length.compareTo(b.title.length));
    return out;
  }

  bool _isArticle(ZimEntry e) => usesNewNamespaces ? e.namespace == 'C' : e.namespace == 'A';

  // ---- Cluster e blob ----

  final _clusterCache = _Lru<int, _Cluster>(6);

  Future<(int, int)> _clusterRange(int n) async {
    final start = await _u64(_clusterPtrPos + n * 8);
    final end = n + 1 < clusterCount ? await _u64(_clusterPtrPos + (n + 1) * 8) : _checksumPos;
    return (start, end);
  }

  /// Posizione di un blob: (cluster decompresso in memoria, oppure null + offset nel file, lunghezza).
  Future<(_Cluster?, int, int)> _blobLocation(int cluster, int blob) async {
    final (start, _) = await _clusterRange(cluster);
    final info = (await _read(start, 1))[0];
    final extended = info & 0x10 != 0;
    final compression = info & 0x0f;
    if (compression <= 1) {
      // Non compresso: si legge direttamente dal file, senza caricare tutto il cluster.
      final w = extended ? 8 : 4;
      final offs = ByteData.sublistView(await _read(start + 1 + blob * w, 2 * w));
      final a = extended ? offs.getUint64(0, Endian.little) : offs.getUint32(0, Endian.little);
      final b = extended ? offs.getUint64(8, Endian.little) : offs.getUint32(4, Endian.little);
      return (null, start + 1 + a, b - a);
    }
    final c = await _cluster(cluster);
    final (a, b) = c.range(blob);
    return (c, a, b - a);
  }

  Future<_Cluster> _cluster(int n) async {
    final cached = _clusterCache[n];
    if (cached != null) return cached;
    final (start, end) = await _clusterRange(n);
    final raw = await _read(start, end - start);
    final info = raw[0];
    final compressed = Uint8List.sublistView(raw, 1);
    final data = switch (info & 0x0f) {
      4 => await Isolate.run(() => XZDecoder().decodeBytes(compressed)),
      5 => await Isolate.run(() => ZstdDecoder().decodeBytes(compressed)),
      _ => compressed,
    };
    return _clusterCache[n] = _Cluster(data, info & 0x10 != 0);
  }

  Future<Uint8List> _blob(int cluster, int blob) async {
    final (c, offset, length) = await _blobLocation(cluster, blob);
    if (c == null) return _read(offset, length);
    return Uint8List.sublistView(c.data, offset, offset + length);
  }
}

class ZimEntry {
  ZimEntry._(this.archive, this.index, this.mimeIndex, this.namespace, this.path, this.title,
      this.clusterNumber, this.blobNumber, this.redirectIndex);

  final ZimArchive archive;
  final int index;
  final int mimeIndex;
  final String namespace;
  final String path;
  final String title;
  final int clusterNumber, blobNumber, redirectIndex;

  bool get isRedirect => mimeIndex == 0xffff;

  String get mimeType => mimeIndex < archive.mimeTypes.length ? archive.mimeTypes[mimeIndex] : 'application/octet-stream';

  /// URL relativo usato dentro l'HTML del file ZIM.
  String get url => archive.usesNewNamespaces ? path : '$namespace/$path';

  static ZimEntry? _parse(ZimArchive z, int index, Uint8List b) {
    if (b.length < 12) return null;
    final d = ByteData.sublistView(b);
    final mime = d.getUint16(0, Endian.little);
    final ns = String.fromCharCode(b[3]);
    var cluster = 0, blob = 0, redirect = 0, p = 0;
    if (mime == 0xffff) {
      redirect = d.getUint32(8, Endian.little);
      p = 12;
    } else if (mime == 0xfffe || mime == 0xfffd) {
      p = 8; // link target / voce cancellata (non più usati)
    } else {
      if (b.length < 16) return null;
      cluster = d.getUint32(8, Endian.little);
      blob = d.getUint32(12, Endian.little);
      p = 16;
    }
    final pathEnd = b.indexOf(0, p);
    if (pathEnd < 0) return null;
    final titleEnd = b.indexOf(0, pathEnd + 1);
    if (titleEnd < 0) return null;
    final path = utf8.decode(b.sublist(p, pathEnd), allowMalformed: true);
    final title = utf8.decode(b.sublist(pathEnd + 1, titleEnd), allowMalformed: true);
    return ZimEntry._(z, index, mime, ns, path, title.isEmpty ? path : title, cluster, blob, redirect);
  }

  /// Segue i redirect (al massimo 10) fino alla voce con il contenuto.
  Future<ZimEntry> resolve() async {
    var e = this;
    for (var i = 0; i < 10 && e.isRedirect; i++) {
      e = await archive.entryAt(e.redirectIndex);
    }
    return e;
  }

  Future<Uint8List?> data() async {
    final e = await resolve();
    if (e.isRedirect || e.mimeIndex >= 0xfffd) return null;
    return archive._blob(e.clusterNumber, e.blobNumber);
  }
}

class _Cluster {
  _Cluster(this.data, this.extended);

  final Uint8List data;
  final bool extended;

  (int, int) range(int blob) {
    final d = ByteData.sublistView(data);
    final w = extended ? 8 : 4;
    int at(int i) => extended ? d.getUint64(i * w, Endian.little) : d.getUint32(i * w, Endian.little);
    return (at(blob), at(blob + 1));
  }
}

/// Lista di indici di voci ordinate per titolo (in un blob o, nei vecchi ZIM, nell'header).
class _TitleIndex {
  _TitleIndex(this.z, this.cluster, this.offset, this.length);

  final ZimArchive z;
  final _Cluster? cluster;
  final int offset;
  final int length;

  Future<int> entryIndex(int i) async {
    if (cluster != null) {
      return ByteData.sublistView(cluster!.data).getUint32(offset + i * 4, Endian.little);
    }
    return z._u32(offset + i * 4);
  }

  /// Primo indice il cui titolo è >= [key] (confronto byte per byte).
  Future<int> lowerBound(List<int> key) async {
    var lo = 0, hi = length;
    while (lo < hi) {
      final mid = (lo + hi) >> 1;
      final e = await z.entryAt(await entryIndex(mid));
      if (_compareBytes(utf8.encode(e.title), key) < 0) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    return lo;
  }
}

int _compareBytes(List<int> a, List<int> b) {
  final n = a.length < b.length ? a.length : b.length;
  for (var i = 0; i < n; i++) {
    if (a[i] != b[i]) return a[i] - b[i];
  }
  return a.length - b.length;
}

bool _startsWith(List<int> s, List<int> prefix) {
  if (s.length < prefix.length) return false;
  for (var i = 0; i < prefix.length; i++) {
    if (s[i] != prefix[i]) return false;
  }
  return true;
}

class _Lru<K, V> {
  _Lru(this.capacity);

  final int capacity;
  final _map = <K, V>{}; // mantiene l'ordine di inserimento

  V? operator [](K key) {
    final v = _map.remove(key);
    if (v != null) _map[key] = v;
    return v;
  }

  void operator []=(K key, V value) {
    _map.remove(key);
    _map[key] = value;
    if (_map.length > capacity) _map.remove(_map.keys.first);
  }
}
