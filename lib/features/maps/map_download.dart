import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/countries.dart';
import '../../app/settings.dart';
import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import '../library/zim/kiwix_catalog.dart' show formatBytes;
import 'map_regions.dart';

/// Scelta delle mappe da scaricare (usata nel primo avvio e in Prepararsi).
class MapPicker extends StatefulWidget {
  const MapPicker({super.key, this.onStarted});

  /// Chiamato dopo aver avviato il download (es. per passare al passo successivo).
  final VoidCallback? onStarted;

  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  final regions = MapRegions.instance;
  late final Set<String> _selected;

  List<(MapRegion, String, String, IconData)> _options(AppLocalizations t) {
    final country = AppSettings.instance.country;
    final cr = kCountryRegions[country.code];
    return [
      (kWorld, t.mapWorld, t.mapWorldBody, Icons.public),
      if (cr != null) (cr, t.mapCountry(country.name(t)), t.mapCountryBody, Icons.flag),
      (kEurope, t.mapEurope, t.mapEuropeBody, Icons.map),
    ];
  }

  @override
  void initState() {
    super.initState();
    final cr = kCountryRegions[AppSettings.instance.country.code];
    _selected = {kWorld.id, if (cr != null) cr.id};
    regions.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final options = _options(t);
    return ListenableBuilder(
      listenable: regions,
      builder: (context, _) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        for (final (region, title, body, icon) in options) _option(t, region, title, body, icon),
        const SizedBox(height: 8),
        Text(t.mapKeepOpen, style: const TextStyle(color: Colors.white54, fontSize: 14)),
        const SizedBox(height: 12),
        FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
          icon: const Icon(Icons.download),
          label: Text(t.mapDownloadSelected, style: const TextStyle(fontSize: 18)),
          onPressed: options.any((o) => _selected.contains(o.$1.id) && !regions.isInstalled(o.$1))
              ? () {
                  regions.download(options.map((o) => o.$1).where((r) => _selected.contains(r.id)));
                  widget.onStarted?.call();
                }
              : null,
        ),
      ]),
    );
  }

  Widget _option(AppLocalizations t, MapRegion r, String title, String body, IconData icon) {
    final job = regions.jobs[r.id];
    final installed = regions.isInstalled(r);
    final Widget status;
    if (installed) {
      status = Text(t.mapReady, style: const TextStyle(color: Colors.lightGreen));
    } else if (job != null && job.state != MapJobState.done) {
      status = switch (job.state) {
        MapJobState.failed => Text(t.mapFailed, style: const TextStyle(color: kDanger)),
        MapJobState.downloading => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            LinearProgressIndicator(value: job.progress),
            const SizedBox(height: 4),
            Text(t.mapDownloading((job.progress * 100).toStringAsFixed(0), formatBytes(job.total)),
                style: const TextStyle(fontSize: 13, color: Colors.white70)),
          ]),
        _ => Text(t.mapPreparing, style: const TextStyle(color: Colors.white70)),
      };
    } else {
      status = FutureBuilder<int>(
        future: regions.estimate(r),
        builder: (context, snap) => Text(
          snap.hasData && snap.data! > 0 ? '≈ ${formatBytes(snap.data!)}' : (snap.hasData ? t.mapSizeUnknown : t.mapSizeCalc),
          style: const TextStyle(color: Colors.white54),
        ),
      );
    }
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: CheckboxListTile(
        value: installed || _selected.contains(r.id),
        onChanged: installed ? null : (v) => setState(() => v == true ? _selected.add(r.id) : _selected.remove(r.id)),
        secondary: Icon(icon, color: kAccent, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(body),
          const SizedBox(height: 4),
          status,
        ]),
        isThreeLine: true,
      ),
    );
  }
}

/// Schermata "Mappe offline": mappe sul telefono (aggiorna, elimina), download in corso (annulla)
/// e tutte le zone disponibili da selezionare e scaricare.
class MapDownloadScreen extends StatefulWidget {
  const MapDownloadScreen({super.key});

  @override
  State<MapDownloadScreen> createState() => _MapDownloadScreenState();
}

class _MapDownloadScreenState extends State<MapDownloadScreen> {
  final regions = MapRegions.instance;
  final _selected = <String>{};

  /// Mondo, Europa, il paese scelto e poi gli altri paesi.
  List<MapRegion> get _all {
    final mine = kCountryRegions[AppSettings.instance.country.code];
    return [kWorld, ?mine, kEurope, ...kCountryRegions.values.where((r) => r != mine)];
  }

  @override
  void initState() {
    super.initState();
    regions.refresh();
  }

  bool _active(MapRegion r) {
    final s = regions.jobs[r.id]?.state;
    return s == MapJobState.queued || s == MapJobState.planning || s == MapJobState.downloading;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.mapsTitle)),
      body: ListenableBuilder(
        listenable: regions,
        builder: (context, _) {
          final installed = _all.where(regions.isInstalled).toList();
          final active = _all.where(_active).toList();
          final available = _all.where((r) => !regions.isInstalled(r) && !_active(r)).toList();
          final lang = AppSettings.instance.language;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              Text(t.onbMapBody, style: const TextStyle(color: Colors.white70)),
              if (installed.isNotEmpty) ...[
                _Header(t.mapsOnPhone),
                for (final r in installed)
                  Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.check_circle, color: Colors.lightGreen),
                      title: Text(regionName(t, r), style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text([
                        formatBytes(regions.installed.firstWhere((e) => e.$1.id == r.id).$2.lengthSync()),
                        if (regions.installedAt(r) case final DateTime d) t.mapUpdatedOn(DateFormat.yMMMd(lang).format(d)),
                        if (regions.jobs[r.id]?.state == MapJobState.failed) t.mapFailed,
                      ].join(' · ')),
                      trailing: PopupMenuButton<String>(
                        onSelected: (v) => v == 'update' ? regions.update(r) : _delete(context, t, r),
                        itemBuilder: (_) => [
                          PopupMenuItem(value: 'update', child: Text(t.mapUpdate)),
                          PopupMenuItem(value: 'delete', child: Text(t.delete)),
                        ],
                      ),
                    ),
                  ),
              ],
              if (active.isNotEmpty) ...[
                _Header(t.mapsInProgress),
                for (final r in active)
                  Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.downloading, color: Colors.lightBlueAccent),
                      title: Text(regionName(t, r), style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: _JobProgress(job: regions.jobs[r.id]!, t: t),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: t.cancel,
                        onPressed: () => regions.cancel(r),
                      ),
                    ),
                  ),
                Text(t.mapKeepOpen, style: const TextStyle(color: Colors.white54, fontSize: 13)),
              ],
              if (available.isNotEmpty) ...[
                _Header(t.mapsAvailable),
                for (final r in available)
                  Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: CheckboxListTile(
                      value: _selected.contains(r.id),
                      onChanged: (v) => setState(() => v == true ? _selected.add(r.id) : _selected.remove(r.id)),
                      title: Text(regionName(t, r), style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(r == kWorld ? t.mapWorldBody : r == kEurope ? t.mapEuropeBody : t.mapCountryBody),
                        if (regions.jobs[r.id]?.state == MapJobState.failed)
                          Text(t.mapFailed, style: const TextStyle(color: kDanger))
                        // La dimensione si calcola solo per le zone selezionate (serve internet).
                        else if (_selected.contains(r.id))
                          FutureBuilder<int>(
                            future: regions.estimate(r),
                            builder: (context, snap) => Text(
                              snap.hasData && snap.data! > 0
                                  ? '≈ ${formatBytes(snap.data!)}'
                                  : (snap.hasData ? t.mapSizeUnknown : t.mapSizeCalc),
                              style: const TextStyle(color: Colors.white54),
                            ),
                          ),
                      ]),
                    ),
                  ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
                  icon: const Icon(Icons.download),
                  label: Text(t.mapDownloadSelected, style: const TextStyle(fontSize: 18)),
                  onPressed: _selected.isEmpty
                      ? null
                      : () {
                          regions.download(available.where((r) => _selected.contains(r.id)));
                          setState(_selected.clear);
                        },
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _delete(BuildContext context, AppLocalizations t, MapRegion r) async {
    final size = formatBytes(regions.installed.firstWhere((e) => e.$1.id == r.id).$2.lengthSync());
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(t.deleteQ(regionName(t, r))),
        content: Text(t.deleteBody(size)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(t.cancel)),
          TextButton(onPressed: () => Navigator.pop(c, true), child: Text(t.delete)),
        ],
      ),
    );
    if (ok == true) await regions.delete(r);
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
        child: Text(text.toUpperCase(),
            style: const TextStyle(color: kAccent, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
      );
}

class _JobProgress extends StatelessWidget {
  const _JobProgress({required this.job, required this.t});

  final MapJob job;
  final AppLocalizations t;

  @override
  Widget build(BuildContext context) => job.state == MapJobState.downloading
      ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 4),
          LinearProgressIndicator(value: job.progress),
          const SizedBox(height: 4),
          Text(t.mapDownloading((job.progress * 100).toStringAsFixed(0), formatBytes(job.total))),
        ])
      : Text(t.mapPreparing);
}

String regionName(AppLocalizations t, MapRegion r) {
  if (r.id == kWorld.id) return t.mapWorld;
  if (r.id == kEurope.id) return t.mapEurope;
  return t.mapCountry(countryByCode(r.id.replaceFirst('country-', '')).name(t));
}
