import 'dart:math' as math;
import 'dart:typed_data';

import 'package:latlong2/latlong.dart';
import 'package:pmtiles/pmtiles.dart';
import 'package:vector_tile/vector_tile.dart';

import 'map_regions.dart';
import 'pins.dart';

/// Ospedali vicini a un punto, letti dalle mappe già scaricate (dati OpenStreetMap), senza internet.
/// Nelle mappe Protomaps gli ospedali ci sono dallo zoom 12: servono le mappe di un paese (zoom 14).
/// Le farmacie compaiono solo a zoom più alti di quelli scaricati, quindi non si cercano.
const kNearbyZoom = 12;

class NearbyPlace {
  const NearbyPlace(this.name, this.point, this.meters);

  final String name;
  final LatLng point;
  final double meters;
}

/// I [limit] ospedali più vicini a [center], cercando nelle tessere intorno (circa 50 km a queste latitudini).
/// Null se nessuna mappa scaricata arriva allo zoom necessario.
Future<List<NearbyPlace>?> nearbyHospitals(LatLng center, {int radiusTiles = 2, int limit = 15}) async {
  final regions = MapRegions.instance;
  if (!regions.loaded) await regions.refresh();
  final maps = regions.installed.where((e) => e.$1.maxZoom >= kNearbyZoom).toList();
  if (maps.isEmpty) return null;

  final found = <String, NearbyPlace>{};
  for (final (_, file) in maps) {
    final archive = await PmTilesArchive.fromFile(file);
    try {
      for (final p in await hospitalsIn(archive, center, radiusTiles: radiusTiles)) {
        found['${p.name} ${p.point.latitude.toStringAsFixed(4)} ${p.point.longitude.toStringAsFixed(4)}'] = p;
      }
    } finally {
      await archive.close();
    }
  }
  final list = found.values.toList()..sort((a, b) => a.meters.compareTo(b.meters));
  return list.take(limit).toList();
}

/// Ospedali in un archivio PMTiles intorno a [center] (tessere a zoom [kNearbyZoom]).
Future<List<NearbyPlace>> hospitalsIn(PmTilesArchive archive, LatLng center, {int radiusTiles = 2}) async {
  const z = kNearbyZoom;
  final n = 1 << z;
  final cx = ((center.longitude + 180) / 360 * n).floor();
  final r = center.latitude * math.pi / 180;
  final cy = ((1 - math.log(math.tan(r) + 1 / math.cos(r)) / math.pi) / 2 * n).floor();
  final out = <NearbyPlace>[];
  for (var x = cx - radiusTiles; x <= cx + radiusTiles; x++) {
    for (var y = cy - radiusTiles; y <= cy + radiusTiles; y++) {
      if (x < 0 || y < 0 || x >= n || y >= n) continue;
      final List<int> bytes;
      try {
        bytes = (await archive.tile(ZXY(z, x, y).toTileId())).bytes();
      } catch (_) {
        continue; // tessera fuori dalla zona scaricata
      }
      final vt = VectorTile.fromBytes(bytes: Uint8List.fromList(bytes));
      for (final layer in vt.layers.where((l) => l.name == 'pois')) {
        for (final f in layer.features) {
          final props = f.decodeProperties();
          if (props['kind']?.dartStringValue != 'hospital') continue;
          final geo = f.toGeoJson(x: x, y: y, z: z);
          if (geo is! GeoJsonPoint || geo.geometry == null) continue;
          final c = geo.geometry!.coordinates;
          final point = LatLng(c[1], c[0]);
          out.add(NearbyPlace(props['name']?.dartStringValue ?? '', point, distanceMeters(center, point)));
        }
      }
    }
  }
  return out;
}
