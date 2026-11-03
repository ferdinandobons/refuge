import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../app/settings.dart';
import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import '../maps/map_download.dart';
import '../maps/map_regions.dart';
import '../maps/offline_map.dart';
import 'coords.dart';

enum _LocationProblem { serviceOff, denied, unavailable }

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late final Future<_LocationProblem?> _permission = _checkPermission();

  Future<_LocationProblem?> _checkPermission() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return _LocationProblem.serviceOff;
      var p = await Geolocator.checkPermission();
      if (p == LocationPermission.denied) p = await Geolocator.requestPermission();
      if (p == LocationPermission.denied || p == LocationPermission.deniedForever) return _LocationProblem.denied;
      return null;
    } catch (_) {
      return _LocationProblem.unavailable;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.locationTitle)),
      body: FutureBuilder<_LocationProblem?>(
        future: _permission,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          if (snap.data != null) {
            final message = switch (snap.data!) {
              _LocationProblem.serviceOff => t.locServiceOff,
              _LocationProblem.denied => t.locDenied,
              _LocationProblem.unavailable => t.locUnavailable,
            };
            return Center(
              child: Padding(padding: const EdgeInsets.all(24), child: Text(message, textAlign: TextAlign.center)),
            );
          }
          return StreamBuilder<Position>(
            stream: Geolocator.getPositionStream(
              locationSettings: const LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 1),
            ),
            builder: (context, pos) => Column(children: [
              Expanded(flex: 6, child: _MapArea(position: pos.data)),
              const Divider(height: 1, color: Colors.white24),
              Expanded(
                flex: 5,
                child: pos.hasError
                    ? Center(child: Text(t.gpsError('${pos.error}')))
                    : !pos.hasData
                        ? Center(child: Text(t.searchingSats, textAlign: TextAlign.center))
                        : _PositionView(pos.data!, t),
              ),
            ]),
          );
        },
      ),
    );
  }
}

class _PositionView extends StatelessWidget {
  const _PositionView(this.p, this.t);

  final Position p;
  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    final rows = <(String, String)>[
      (t.fmtDecimal, '${p.latitude.toStringAsFixed(6)}, ${p.longitude.toStringAsFixed(6)}'),
      (t.fmtDms, '${toDms(p.latitude, isLat: true)}\n${toDms(p.longitude, isLat: false, west: t.westLetter)}'),
      ('UTM', toUtm(p.latitude, p.longitude)?.toString() ?? '—'),
      (t.fmtMgrs, toMgrs(p.latitude, p.longitude) ?? '—'),
      (t.altitude, '${p.altitude.round()} m'),
      (t.accuracy, '± ${p.accuracy.round()} m'),
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final (label, value) in rows)
          Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              title: Text(label, style: const TextStyle(color: Colors.white60, fontSize: 14)),
              subtitle: Text(value,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'monospace', height: 1.4)),
              trailing: IconButton(
                icon: const Icon(Icons.copy, color: kAccent),
                tooltip: t.copy,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: value));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.copied)));
                },
              ),
            ),
          ),
        Text(t.locHint(AppSettings.instance.country.emergency), style: const TextStyle(color: Colors.white54)),
      ],
    );
  }
}

/// Mappa offline con la posizione; se non ci sono mappe, invito a scaricarle.
class _MapArea extends StatelessWidget {
  const _MapArea({required this.position});

  final Position? position;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final regions = MapRegions.instance;
    return ListenableBuilder(
      listenable: regions,
      builder: (context, _) {
        if (!regions.loaded) {
          regions.refresh();
          return const SizedBox.shrink();
        }
        if (regions.installed.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.map, size: 48, color: kAccent),
                const SizedBox(height: 10),
                Text(t.mapNone, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                FilledButton.icon(
                  icon: const Icon(Icons.download),
                  label: Text(t.mapDownloadButton),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MapDownloadScreen())),
                ),
              ]),
            ),
          );
        }
        final p = position;
        final c = kCountryRegions[AppSettings.instance.country.code]?.bbox;
        return OfflineMap(
          // Ricrea la mappa quando cambia l'elenco delle zone scaricate.
          key: ValueKey(regions.installed.map((e) => '${e.$1.id}@${e.$2.lastModifiedSync()}').join(',')),
          position: p == null ? null : LatLng(p.latitude, p.longitude),
          accuracy: p?.accuracy,
          fallbackCenter: c == null ? const LatLng(48, 10) : LatLng((c.minLat + c.maxLat) / 2, (c.minLon + c.maxLon) / 2),
        );
      },
    );
  }
}
