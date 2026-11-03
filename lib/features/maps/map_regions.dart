import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'pmtiles_extract.dart';

/// Zona di mappa scaricabile: riquadro e zoom massimo.
/// Il mondo e l'Europa hanno meno dettaglio; un paese arriva alle singole vie (zoom 14).
class MapRegion {
  const MapRegion(this.id, this.bbox, this.maxZoom, {this.order = 0});

  final String id;
  final Bbox bbox;
  final int maxZoom;

  /// Ordine di disegno: prima i più grandi, sopra i più dettagliati.
  final int order;

  String get fileName => '$id.pmtiles';
}

const kWorld = MapRegion('world', Bbox(-180, -85, 180, 85), 7);
const kEurope = MapRegion('europe', Bbox(-25, 34, 45, 72), 10, order: 1);

/// Confini (approssimati per eccesso) dei paesi previsti.
const kCountryRegions = <String, MapRegion>{
  'IT': MapRegion('country-IT', Bbox(6.6, 35.4, 18.6, 47.1), 14, order: 2),
  'FR': MapRegion('country-FR', Bbox(-5.2, 41.3, 9.6, 51.1), 14, order: 2),
  'DE': MapRegion('country-DE', Bbox(5.8, 47.2, 15.1, 55.1), 14, order: 2),
  'ES': MapRegion('country-ES', Bbox(-9.4, 35.9, 4.4, 43.8), 14, order: 2),
  'AT': MapRegion('country-AT', Bbox(9.5, 46.3, 17.2, 49.1), 14, order: 2),
  'CH': MapRegion('country-CH', Bbox(5.9, 45.8, 10.5, 47.9), 14, order: 2),
  'BE': MapRegion('country-BE', Bbox(2.5, 49.4, 6.4, 51.6), 14, order: 2),
  'NL': MapRegion('country-NL', Bbox(3.3, 50.7, 7.3, 53.6), 14, order: 2),
  'LU': MapRegion('country-LU', Bbox(5.7, 49.4, 6.6, 50.2), 14, order: 2),
  'PT': MapRegion('country-PT', Bbox(-9.6, 36.9, -6.1, 42.2), 14, order: 2),
  'GB': MapRegion('country-GB', Bbox(-8.7, 49.8, 1.9, 60.9), 14, order: 2),
  'IE': MapRegion('country-IE', Bbox(-10.7, 51.3, -5.9, 55.5), 14, order: 2),
};

enum MapJobState { queued, planning, downloading, done, failed }

class MapJob {
  MapJob(this.region);

  final MapRegion region;
  MapJobState state = MapJobState.queued;
  int done = 0, total = 0;

  /// Estrattore del download in corso, per poterlo annullare.
  PmTilesExtractor? extractor;

  double get progress => total == 0 ? 0 : done / total;
}

/// Mappe offline sul telefono e coda dei download.
class MapRegions extends ChangeNotifier {
  MapRegions._();

  static final instance = MapRegions._();

  final _installed = <String, File>{};
  final _sizes = <String, Future<int>>{};
  final jobs = <String, MapJob>{};
  Uri? _planet;
  PmTilesExtractor? _extractor;
  bool loaded = false;

  static Future<Directory> directory() async {
    final dir = Directory('${(await getApplicationDocumentsDirectory()).path}/maps');
    if (!dir.existsSync()) await dir.create(recursive: true);
    return dir;
  }

  /// File installati, dal meno al più dettagliato.
  List<(MapRegion, File)> get installed {
    final all = [kWorld, kEurope, ...kCountryRegions.values];
    return [
      for (final r in all..sort((a, b) => a.order.compareTo(b.order)))
        if (_installed[r.id] case final File f) (r, f),
    ];
  }

  bool isInstalled(MapRegion r) => _installed.containsKey(r.id);

  bool get downloading => jobs.values.any((j) => j.state == MapJobState.planning || j.state == MapJobState.downloading || j.state == MapJobState.queued);

  Future<void> refresh() async {
    final dir = await directory();
    _installed.clear();
    for (final f in dir.listSync().whereType<File>().where((f) => f.path.endsWith('.pmtiles'))) {
      _installed[f.uri.pathSegments.last.replaceAll('.pmtiles', '')] = f;
    }
    loaded = true;
    notifyListeners();
  }

  Future<PmTilesExtractor> _ex() async {
    _planet ??= await latestPlanetUrl();
    return _extractor ??= PmTilesExtractor(_planet!);
  }

  /// Dimensione stimata in byte (richiede internet; il risultato resta in memoria).
  Future<int> estimate(MapRegion r) => _sizes[r.id] ??= () async {
        final plan = await (await _ex()).plan(r.bbox, r.maxZoom);
        _plans[r.id] = plan;
        return plan.bytes;
      }()
        ..catchError((Object _) {
          _sizes.remove(r.id);
          return 0;
        });

  final _plans = <String, ExtractPlan>{};

  /// Mette in coda i download; restano attivi finché l'app è aperta.
  void download(Iterable<MapRegion> regions, {bool force = false}) {
    for (final r in regions) {
      if ((isInstalled(r) && !force) || (jobs[r.id]?.state.index ?? 99) <= MapJobState.downloading.index) continue;
      jobs[r.id] = MapJob(r);
    }
    notifyListeners();
    _run();
  }

  bool _running = false;

  Future<void> _run() async {
    if (_running) return;
    _running = true;
    await WakelockPlus.enable();
    try {
      while (true) {
        final job = jobs.values.where((j) => j.state == MapJobState.queued).firstOrNull;
        if (job == null) break;
        PmTilesExtractor? ex;
        try {
          job.state = MapJobState.planning;
          notifyListeners();
          _planet ??= await latestPlanetUrl();
          // Un estrattore per download, così si può annullare solo questo.
          ex = job.extractor = PmTilesExtractor(_planet!);
          final plan = _plans[job.region.id] ?? await ex.plan(job.region.bbox, job.region.maxZoom);
          job
            ..state = MapJobState.downloading
            ..total = plan.bytes;
          notifyListeners();
          final dir = await directory();
          await ex.download(plan, '${dir.path}/${job.region.fileName}', onProgress: (done, total) {
            job.done = done;
            notifyListeners();
          });
          job.state = MapJobState.done;
          await refresh();
        } catch (e) {
          if (isCancellation(e)) {
            jobs.remove(job.region.id);
          } else {
            job.state = MapJobState.failed;
          }
          notifyListeners();
        } finally {
          ex?.close();
          job.extractor = null;
        }
      }
    } finally {
      _running = false;
      await WakelockPlus.disable();
      notifyListeners();
    }
  }

  /// Annulla un download in coda o in corso.
  void cancel(MapRegion r) {
    final job = jobs[r.id];
    if (job == null) return;
    if (job.extractor != null) {
      job.extractor!.cancel();
    } else {
      jobs.remove(r.id);
    }
    notifyListeners();
  }

  /// Riscarica una mappa dall'ultima versione di OpenStreetMap (quella vecchia resta finché la nuova non è pronta).
  void update(MapRegion r) {
    _plans.remove(r.id);
    _sizes.remove(r.id);
    _planet = null;
    download([r], force: true);
  }

  DateTime? installedAt(MapRegion r) => _installed[r.id]?.lastModifiedSync();

  Future<void> delete(MapRegion r) async {
    final f = _installed.remove(r.id);
    if (f != null && f.existsSync()) await f.delete();
    jobs.remove(r.id);
    notifyListeners();
  }
}
