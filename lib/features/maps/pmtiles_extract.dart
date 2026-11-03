import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:pmtiles/pmtiles.dart' show ZXY;

/// Estrae una zona (riquadro + zoom massimo) da un archivio PMTiles remoto e la salva in un file locale.
///
/// Stesso principio di `pmtiles extract`: legge con richieste HTTP "Range" solo gli indici e le tile
/// necessarie, senza scaricare l'intero pianeta (oltre 130 GB).
/// Specifica: https://github.com/protomaps/PMTiles/blob/main/spec/v3/spec.md
class Bbox {
  const Bbox(this.minLon, this.minLat, this.maxLon, this.maxLat);

  final double minLon, minLat, maxLon, maxLat;
}

class _Header {
  _Header(ByteData d)
      : rootOffset = d.getUint64(8, Endian.little),
        rootLength = d.getUint64(16, Endian.little),
        metadataOffset = d.getUint64(24, Endian.little),
        metadataLength = d.getUint64(32, Endian.little),
        leafOffset = d.getUint64(40, Endian.little),
        tileDataOffset = d.getUint64(56, Endian.little),
        internalCompression = d.getUint8(97),
        tileCompression = d.getUint8(98),
        tileType = d.getUint8(99);

  final int rootOffset, rootLength, metadataOffset, metadataLength, leafOffset, tileDataOffset;
  final int internalCompression, tileCompression, tileType;
}

class _Entry {
  _Entry(this.tileId, this.offset, this.length, this.runLength);

  int tileId, offset, length, runLength;
}

/// Piano di estrazione: quali tile servono e quanto pesano, prima di scaricarle.
class ExtractPlan {
  ExtractPlan._(this._header, this._metadata, this._entries, this._unique, this.bbox, this.maxZoom);

  final _Header _header;
  final Uint8List _metadata;

  /// Voci di uscita (tileId, offset nel file sorgente, lunghezza, ripetizioni).
  final List<_Entry> _entries;

  /// Contenuti unici: offset sorgente → lunghezza, in ordine di offset.
  final List<(int, int)> _unique;
  final Bbox bbox;
  final int maxZoom;

  int get bytes => _unique.fold(0, (s, u) => s + u.$2);

  int get tiles => _entries.fold(0, (s, e) => s + e.runLength);
}

class PmTilesExtractor {
  PmTilesExtractor(this.url);

  final Uri url;
  final _client = HttpClient()..connectionTimeout = const Duration(seconds: 30);
  bool _cancelled = false;

  void cancel() => _cancelled = true;

  void close() => _client.close(force: true);

  Future<Uint8List> _range(int offset, int length) async {
    for (var attempt = 0;; attempt++) {
      try {
        final req = await _client.getUrl(url);
        req.headers.set(HttpHeaders.rangeHeader, 'bytes=$offset-${offset + length - 1}');
        final res = await req.close();
        if (res.statusCode != 206 && res.statusCode != 200) throw HttpException('HTTP ${res.statusCode}');
        final b = BytesBuilder(copy: false);
        await for (final chunk in res) {
          b.add(chunk);
        }
        final out = b.takeBytes();
        if (out.length < length) throw const HttpException('Risposta incompleta');
        return out.length == length ? out : Uint8List.sublistView(out, 0, length);
      } catch (_) {
        if (_cancelled || attempt >= 4) rethrow;
        await Future<void>.delayed(Duration(seconds: 2 << attempt));
      }
    }
  }

  static Uint8List _decompress(Uint8List data, int compression) =>
      compression == 2 ? Uint8List.fromList(gzip.decode(data)) : data;

  /// Primo passo: legge gli indici e calcola cosa scaricare (e quanto pesa).
  Future<ExtractPlan> plan(Bbox bbox, int maxZoom, {void Function(double)? onProgress}) async {
    final first = await _range(0, 16384);
    final h = _Header(ByteData.sublistView(first));
    if (String.fromCharCodes(first.sublist(0, 7)) != 'PMTiles' || first[7] != 3) {
      throw const FormatException('Non è un archivio PMTiles v3');
    }
    final metadata = h.metadataLength == 0 ? Uint8List(0) : await _range(h.metadataOffset, h.metadataLength);

    // Tile richieste, in ordine di tileId (curva di Hilbert per ogni zoom).
    final wanted = <int>[];
    for (var z = 0; z <= maxZoom; z++) {
      final (x0, y0) = _tileXY(bbox.minLon, bbox.maxLat, z);
      final (x1, y1) = _tileXY(bbox.maxLon, bbox.minLat, z);
      for (var x = x0; x <= x1; x++) {
        for (var y = y0; y <= y1; y++) {
          wanted.add(ZXY(z, x, y).toTileId());
        }
      }
    }
    wanted.sort();

    final out = <_Entry>[];
    final rootBytes = _decompress(Uint8List.sublistView(first, h.rootOffset, h.rootOffset + h.rootLength), h.internalCompression);
    var leavesDone = 0, leavesTotal = 1;

    Future<void> walk(List<_Entry> dir) async {
      final pendingLeaves = <Future<void>>[];
      for (var i = 0; i < dir.length; i++) {
        final e = dir[i];
        if (e.runLength == 0) {
          // Directory foglia: copre i tileId fino alla voce successiva.
          final end = i + 1 < dir.length ? dir[i + 1].tileId : 1 << 62;
          if (!_anyIn(wanted, e.tileId, end)) continue;
          leavesTotal++;
          pendingLeaves.add(() async {
            final leaf = _decompress(await _range(h.leafOffset + e.offset, e.length), h.internalCompression);
            await walk(_deserialize(leaf));
            leavesDone++;
            onProgress?.call(leavesDone / leavesTotal);
          }());
          if (pendingLeaves.length >= 8) {
            await Future.wait(pendingLeaves);
            pendingLeaves.clear();
          }
        } else {
          for (final id in _idsIn(wanted, e.tileId, e.tileId + e.runLength)) {
            out.add(_Entry(id, e.offset, e.length, 1));
          }
        }
        if (_cancelled) throw const _Cancelled();
      }
      await Future.wait(pendingLeaves);
    }

    await walk(_deserialize(rootBytes));
    out.sort((a, b) => a.tileId.compareTo(b.tileId));

    // Unisce tileId consecutivi con lo stesso contenuto (es. mare) in una sola voce ripetuta.
    final merged = <_Entry>[];
    for (final e in out) {
      final last = merged.isEmpty ? null : merged.last;
      if (last != null && last.offset == e.offset && last.tileId + last.runLength == e.tileId) {
        last.runLength++;
      } else {
        merged.add(e);
      }
    }
    final unique = <int, int>{for (final e in merged) e.offset: e.length};
    final uniqueSorted = unique.entries.map((e) => (e.key, e.value)).toList()..sort((a, b) => a.$1.compareTo(b.$1));
    onProgress?.call(1);
    return ExtractPlan._(h, metadata, merged, uniqueSorted, bbox, maxZoom);
  }

  /// Secondo passo: scarica le tile e scrive il file PMTiles in [outPath].
  Future<void> download(ExtractPlan p, String outPath, {void Function(int done, int total)? onProgress}) async {
    final h = p._header;
    final tmp = File('$outPath.tiles');
    final raf = await tmp.open(mode: FileMode.write);
    try {
      // Nuovo offset di ogni contenuto: stesso ordine del sorgente (archivio "clustered").
      final newOffset = <int, int>{};
      var pos = 0;
      for (final (off, len) in p._unique) {
        newOffset[off] = pos;
        pos += len;
      }

      // Richieste raggruppate: tile vicine nel file sorgente in un'unica richiesta.
      final batches = <List<(int, int)>>[];
      for (final u in p._unique) {
        final b = batches.isEmpty ? null : batches.last;
        if (b != null) {
          final end = b.last.$1 + b.last.$2;
          final size = end - b.first.$1;
          if (u.$1 - end < 64 * 1024 && size < 8 * 1024 * 1024) {
            b.add(u);
            continue;
          }
        }
        batches.add([u]);
      }

      var done = 0;
      var writing = Future<void>.value();
      Future<void> fetch(List<(int, int)> batch) async {
        final start = batch.first.$1;
        final end = batch.last.$1 + batch.last.$2;
        final data = await _range(h.tileDataOffset + start, end - start);
        // Scritture in coda: RandomAccessFile non accetta operazioni concorrenti.
        writing = writing.then((_) async {
          for (final (off, len) in batch) {
            await raf.setPosition(newOffset[off]!);
            await raf.writeFrom(data, off - start, off - start + len);
          }
        });
        await writing;
        done += end - start;
        onProgress?.call(done, p.bytes);
      }

      final queue = [...batches];
      Future<void> worker() async {
        while (queue.isNotEmpty) {
          if (_cancelled) throw const _Cancelled();
          await fetch(queue.removeAt(0));
        }
      }

      await Future.wait([for (var i = 0; i < 4; i++) worker()]);
      await writing;
      await raf.close();

      final entries = [for (final e in p._entries) _Entry(e.tileId, newOffset[e.offset]!, e.length, e.runLength)];
      await _writeArchive(File(outPath), h, p, entries, tmp, pos);
    } finally {
      if (await tmp.exists()) await tmp.delete();
    }
  }

  static Future<void> _writeArchive(
      File out, _Header src, ExtractPlan p, List<_Entry> entries, File tileData, int tileDataLength) async {
    // Directory: tutto nella radice se ci sta, altrimenti foglie da N voci.
    var root = gzip.encode(_serialize(entries));
    var leaves = <int>[];
    if (root.length > 16384 - 127) {
      for (var size = 4096;; size *= 2) {
        final rootEntries = <_Entry>[];
        final leafBytes = BytesBuilder();
        for (var i = 0; i < entries.length; i += size) {
          final chunk = gzip.encode(_serialize(entries.sublist(i, i + size > entries.length ? entries.length : i + size)));
          rootEntries.add(_Entry(entries[i].tileId, leafBytes.length, chunk.length, 0));
          leafBytes.add(chunk);
        }
        root = gzip.encode(_serialize(rootEntries));
        if (root.length <= 16384 - 127) {
          leaves = leafBytes.takeBytes();
          break;
        }
      }
    }

    final metaOffset = 127 + root.length;
    final leafOffset = metaOffset + p._metadata.length;
    final tileOffset = leafOffset + leaves.length;
    final header = ByteData(127);
    final magic = 'PMTiles'.codeUnits;
    for (var i = 0; i < 7; i++) {
      header.setUint8(i, magic[i]);
    }
    header
      ..setUint8(7, 3)
      ..setUint64(8, 127, Endian.little)
      ..setUint64(16, root.length, Endian.little)
      ..setUint64(24, metaOffset, Endian.little)
      ..setUint64(32, p._metadata.length, Endian.little)
      ..setUint64(40, leafOffset, Endian.little)
      ..setUint64(48, leaves.length, Endian.little)
      ..setUint64(56, tileOffset, Endian.little)
      ..setUint64(64, tileDataLength, Endian.little)
      ..setUint64(72, entries.fold(0, (s, e) => s + e.runLength), Endian.little)
      ..setUint64(80, entries.length, Endian.little)
      ..setUint64(88, p._unique.length, Endian.little)
      ..setUint8(96, 1) // clustered
      ..setUint8(97, 2) // directory in gzip
      ..setUint8(98, src.tileCompression)
      ..setUint8(99, src.tileType)
      ..setUint8(100, 0)
      ..setUint8(101, p.maxZoom)
      ..setInt32(102, (p.bbox.minLon * 1e7).round(), Endian.little)
      ..setInt32(106, (p.bbox.minLat * 1e7).round(), Endian.little)
      ..setInt32(110, (p.bbox.maxLon * 1e7).round(), Endian.little)
      ..setInt32(114, (p.bbox.maxLat * 1e7).round(), Endian.little)
      ..setUint8(118, p.maxZoom < 6 ? p.maxZoom : 6)
      ..setInt32(119, ((p.bbox.minLon + p.bbox.maxLon) / 2 * 1e7).round(), Endian.little)
      ..setInt32(123, ((p.bbox.minLat + p.bbox.maxLat) / 2 * 1e7).round(), Endian.little);

    final part = File('${out.path}.part');
    final sink = part.openWrite();
    sink
      ..add(header.buffer.asUint8List())
      ..add(root)
      ..add(p._metadata)
      ..add(leaves);
    await sink.addStream(tileData.openRead());
    await sink.close();
    await part.rename(out.path);
  }
}

class _Cancelled implements Exception {
  const _Cancelled();
}

bool isCancellation(Object e) => e is _Cancelled;

(int, int) _tileXY(double lon, double lat, int z) {
  final n = 1 << z;
  final r = lat.clamp(-85.0511, 85.0511) * math.pi / 180;
  final x = ((lon + 180) / 360 * n).floor().clamp(0, n - 1);
  final y = ((1 - math.log(math.tan(r) + 1 / math.cos(r)) / math.pi) / 2 * n).floor().clamp(0, n - 1);
  return (x, y);
}

bool _anyIn(List<int> sorted, int from, int to) {
  final i = _lowerBound(sorted, from);
  return i < sorted.length && sorted[i] < to;
}

Iterable<int> _idsIn(List<int> sorted, int from, int to) sync* {
  for (var i = _lowerBound(sorted, from); i < sorted.length && sorted[i] < to; i++) {
    yield sorted[i];
  }
}

int _lowerBound(List<int> a, int v) {
  var lo = 0, hi = a.length;
  while (lo < hi) {
    final mid = (lo + hi) >> 1;
    a[mid] < v ? lo = mid + 1 : hi = mid;
  }
  return lo;
}

// ---- Varint e directory (formato PMTiles v3) ----

List<_Entry> _deserialize(Uint8List b) {
  var pos = 0;
  int read() {
    var result = 0, shift = 0;
    while (true) {
      final byte = b[pos++];
      result += (byte & 0x7f) * (1 << shift);
      if (byte < 0x80) return result;
      shift += 7;
    }
  }

  final n = read();
  final entries = List.generate(n, (_) => _Entry(0, 0, 0, 0));
  var last = 0;
  for (final e in entries) {
    last += read();
    e.tileId = last;
  }
  for (final e in entries) {
    e.runLength = read();
  }
  for (final e in entries) {
    e.length = read();
  }
  for (var i = 0; i < n; i++) {
    final v = read();
    entries[i].offset = v == 0 && i > 0 ? entries[i - 1].offset + entries[i - 1].length : v - 1;
  }
  return entries;
}

Uint8List _serialize(List<_Entry> entries) {
  final b = BytesBuilder();
  void write(int v) {
    while (v >= 0x80) {
      b.addByte((v & 0x7f) | 0x80);
      v = v ~/ 128;
    }
    b.addByte(v);
  }

  write(entries.length);
  var last = 0;
  for (final e in entries) {
    write(e.tileId - last);
    last = e.tileId;
  }
  for (final e in entries) {
    write(e.runLength);
  }
  for (final e in entries) {
    write(e.length);
  }
  for (var i = 0; i < entries.length; i++) {
    final prev = i > 0 ? entries[i - 1] : null;
    write(prev != null && entries[i].offset == prev.offset + prev.length ? 0 : entries[i].offset + 1);
  }
  return b.takeBytes();
}

/// Ultima versione del pianeta OpenStreetMap pubblicata da Protomaps (aggiornata ogni giorno).
Future<Uri> latestPlanetUrl() async {
  final client = HttpClient();
  try {
    final res = await (await client.getUrl(Uri.parse('https://build-metadata.protomaps.dev/builds.json'))).close();
    final builds = jsonDecode(await res.transform(utf8.decoder).join()) as List;
    final key = (builds.last as Map)['key'] as String;
    return Uri.parse('https://build.protomaps.com/$key');
  } finally {
    client.close();
  }
}
