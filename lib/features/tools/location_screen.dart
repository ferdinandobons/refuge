import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import '../../app/settings.dart';
import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
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
            builder: (context, pos) {
              if (pos.hasError) return Center(child: Text(t.gpsError('${pos.error}')));
              if (!pos.hasData) return Center(child: Text(t.searchingSats, textAlign: TextAlign.center));
              return _PositionView(pos.data!, t);
            },
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
