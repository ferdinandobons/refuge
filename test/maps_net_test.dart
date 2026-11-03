import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pmtiles/pmtiles.dart';
import 'package:rifugio/features/maps/pmtiles_extract.dart';

/// Test con la rete (scarica dati reali da Protomaps). Avvio: MAP_NET_TEST=1 flutter test test/maps_net_test.dart
void main() {
  final enabled = Platform.environment['MAP_NET_TEST'] == '1';

  test('estrae una piccola zona e il file risultante si legge', () async {
    final url = await latestPlanetUrl();
    final ex = PmTilesExtractor(url);
    try {
      const rome = Bbox(12.40, 41.85, 12.55, 41.95);
      final plan = await ex.plan(rome, 13);
      // ignore: avoid_print
      print('Roma z0-13: ${plan.tiles} tile, ${(plan.bytes / 1e6).toStringAsFixed(1)} MB');
      final out = '${Directory.systemTemp.path}/rome.pmtiles';
      await ex.download(plan, out);

      final archive = await PmTilesArchive.from(out);
      expect(archive.maxZoom, 13);
      final tile = await archive.tile(ZXY(13, 4378, 3045).toTileId());
      expect(tile.bytes(), isNotEmpty);
      final world = await archive.tile(ZXY(0, 0, 0).toTileId());
      expect(world.bytes(), isNotEmpty);
      await archive.close();
    } finally {
      ex.close();
    }
  }, skip: !enabled, timeout: const Timeout(Duration(minutes: 5)));

  test('stima delle dimensioni di Italia, Europa e mondo', () async {
    final ex = PmTilesExtractor(await latestPlanetUrl());
    try {
      for (final (name, box, z) in [
        ('Mondo z0-6', const Bbox(-180, -85, 180, 85), 6),
        ('Europa z0-10', const Bbox(-25, 34, 45, 72), 10),
        ('Italia z0-14', const Bbox(6.6, 35.4, 18.6, 47.1), 14),
      ]) {
        final t = DateTime.now();
        final plan = await ex.plan(box, z);
        // ignore: avoid_print
        print('$name: ${(plan.bytes / 1e9).toStringAsFixed(2)} GB, ${plan.tiles} tile, '
            'piano in ${DateTime.now().difference(t).inSeconds}s');
      }
    } finally {
      ex.close();
    }
  }, skip: !enabled, timeout: const Timeout(Duration(minutes: 15)));
}
