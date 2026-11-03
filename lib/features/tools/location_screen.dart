import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../app/settings.dart';
import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import '../maps/map_download.dart';
import '../maps/map_regions.dart';
import '../maps/offline_map.dart';
import '../maps/pins.dart';
import 'coords.dart';

enum _LocationProblem { serviceOff, denied, unavailable }

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late final Future<_LocationProblem?> _permission = _checkPermission();
  Stream<Position>? _stream;
  StreamSubscription<Position>? _sub;
  Position? _last;
  LatLng? _focus;
  List<LatLng>? _fit;

  @override
  void initState() {
    super.initState();
    MapPins.instance.load();
    _permission.then((problem) {
      if (problem != null || !mounted) return;
      final stream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 1),
      ).asBroadcastStream();
      // Il percorso si registra da qui, finché la schermata è aperta.
      _sub = stream.listen((p) {
        _last = p;
        MapPins.instance.addTrackPoint(LatLng(p.latitude, p.longitude), p.accuracy);
      });
      setState(() => _stream = stream);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

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

  Future<void> _addPin(AppLocalizations t, {LatLng? at}) async {
    final pin = await showDialog<Pin>(context: context, builder: (_) => _PinDialog(t: t, initial: at, here: _last));
    if (pin == null) return;
    MapPins.instance.add(pin);
    setState(() => _focus = pin.point);
  }

  void _showPins(AppLocalizations t) => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (c) => ListenableBuilder(
          listenable: MapPins.instance,
          builder: (c, _) {
            final m = MapPins.instance;
            final here = _last == null ? null : LatLng(_last!.latitude, _last!.longitude);
            return SafeArea(
              child: ListView(shrinkWrap: true, padding: const EdgeInsets.symmetric(vertical: 12), children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                  child: Text(t.savedPoints, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                if (m.pins.isEmpty)
                  Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 12), child: Text(t.pointsEmpty)),
                for (final pin in m.pins)
                  ListTile(
                    leading: Icon(Icons.location_on, color: pin == m.selected ? kDanger : Colors.white),
                    title: Text(pin.name),
                    subtitle: Text([
                      '${pin.point.latitude.toStringAsFixed(5)}, ${pin.point.longitude.toStringAsFixed(5)}',
                      if (here != null) formatDistance(distanceMeters(here, pin.point)),
                    ].join(' · ')),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: t.delete,
                      onPressed: () => m.remove(pin),
                    ),
                    onTap: () {
                      m.select(pin);
                      setState(() => _focus = pin.point);
                      Navigator.pop(c);
                    },
                  ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                  child: Text(t.trackTitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: Text(t.trackHelp, style: const TextStyle(color: Colors.white70)),
                ),
                if (m.track.length > 1)
                  ListTile(
                    leading: const Icon(Icons.timeline, color: Colors.lightBlueAccent),
                    title: Text(t.trackLength(formatDistance(m.trackMeters))),
                    subtitle: Text(t.trackShow),
                    trailing: TextButton(onPressed: m.clearTrack, child: Text(t.clearTrack)),
                    onTap: () {
                      setState(() => _fit = List.of(m.track));
                      Navigator.pop(c);
                    },
                  ),
              ]),
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.locationTitle),
        actions: [
          // Gestione delle mappe offline (scaricate, in corso, da scaricare).
          TextButton.icon(
            icon: const Icon(Icons.download_for_offline),
            label: Text(t.manageMaps),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MapDownloadScreen())),
          ),
        ],
      ),
      body: FutureBuilder<_LocationProblem?>(
        future: _permission,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          final problem = snap.data;
          return StreamBuilder<Position>(
            stream: _stream,
            builder: (context, pos) => ListenableBuilder(
              listenable: MapPins.instance,
              builder: (context, _) {
                final m = MapPins.instance;
                final p = pos.data;
                final here = p == null ? null : LatLng(p.latitude, p.longitude);
                return Column(children: [
                  Expanded(
                    flex: 6,
                    child: _MapArea(
                      position: p,
                      pins: m.pins,
                      selected: m.selected,
                      track: m.track,
                      focus: _focus,
                      fitTo: _fit,
                      onLongPress: (point) => _addPin(t, at: point),
                      onPinTap: (pin) => m.select(pin == m.selected ? null : pin),
                    ),
                  ),
                  if (m.selected != null) _TargetBar(pin: m.selected!, here: here, t: t),
                  _Toolbar(
                    t: t,
                    onAdd: () => _addPin(t),
                    onList: () => _showPins(t),
                    recording: m.recording,
                    canRecord: problem == null,
                    trackMeters: m.trackMeters,
                    onRecord: m.toggleRecording,
                  ),
                  const Divider(height: 1, color: Colors.white24),
                  Expanded(
                    flex: 5,
                    child: problem != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                switch (problem) {
                                  _LocationProblem.serviceOff => t.locServiceOff,
                                  _LocationProblem.denied => t.locDenied,
                                  _LocationProblem.unavailable => t.locUnavailable,
                                },
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : pos.hasError
                            ? Center(child: Text(t.gpsError('${pos.error}')))
                            : p == null
                                ? Center(child: Text(t.searchingSats, textAlign: TextAlign.center))
                                : _PositionView(p, t),
                  ),
                ]);
              },
            ),
          );
        },
      ),
    );
  }
}

/// Punto selezionato: distanza e direzione in linea d'aria dalla posizione attuale.
class _TargetBar extends StatelessWidget {
  const _TargetBar({required this.pin, required this.here, required this.t});

  final Pin pin;
  final LatLng? here;
  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    final h = here;
    final deg = h == null ? null : bearingDegrees(h, pin.point);
    return Container(
      color: kDanger.withValues(alpha: 0.15),
      padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
      child: Row(children: [
        const Icon(Icons.location_on, color: kDanger),
        const SizedBox(width: 8),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(pin.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(
              h == null
                  ? '${pin.point.latitude.toStringAsFixed(5)}, ${pin.point.longitude.toStringAsFixed(5)}'
                  : t.distanceTo(formatDistance(distanceMeters(h, pin.point)), compassPoint(deg!, t.westLetter, east: AppSettings.instance.language == 'de' ? 'O' : 'E'), deg.round()),
              style: const TextStyle(color: Colors.white70),
            ),
          ]),
        ),
        IconButton(icon: const Icon(Icons.close), onPressed: () => MapPins.instance.select(null)),
      ]),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.t,
    required this.onAdd,
    required this.onList,
    required this.recording,
    required this.canRecord,
    required this.trackMeters,
    required this.onRecord,
  });

  final AppLocalizations t;
  final VoidCallback onAdd, onList, onRecord;
  final bool recording, canRecord;
  final double trackMeters;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(children: [
          Expanded(
            child: TextButton.icon(icon: const Icon(Icons.add_location_alt), label: Text(t.addPoint), onPressed: onAdd),
          ),
          Expanded(
            child: TextButton.icon(icon: const Icon(Icons.list), label: Text(t.pointsAndTrack), onPressed: onList),
          ),
          Expanded(
            child: TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: recording ? kDanger : null),
              icon: Icon(recording ? Icons.stop_circle : Icons.fiber_manual_record),
              label: Text(recording ? formatDistance(trackMeters) : t.recordTrack, maxLines: 1),
              onPressed: canRecord ? onRecord : null,
            ),
          ),
        ]),
      );
}

/// Nuovo punto: nome e coordinate (decimali o gradi, primi e secondi).
class _PinDialog extends StatefulWidget {
  const _PinDialog({required this.t, this.initial, this.here});

  final AppLocalizations t;
  final LatLng? initial;
  final Position? here;

  @override
  State<_PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<_PinDialog> {
  final _name = TextEditingController();
  late final _coords = TextEditingController(
      text: widget.initial == null
          ? ''
          : '${widget.initial!.latitude.toStringAsFixed(6)}, ${widget.initial!.longitude.toStringAsFixed(6)}');
  bool _invalid = false;

  @override
  void dispose() {
    _name.dispose();
    _coords.dispose();
    super.dispose();
  }

  void _save() {
    final point = parseCoordinates(_coords.text);
    if (point == null) return setState(() => _invalid = true);
    final name = _name.text.trim();
    Navigator.pop(context, Pin(name.isEmpty ? widget.t.pointDefaultName : name, point));
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    final here = widget.here;
    return AlertDialog(
      title: Text(t.addPoint),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: _name,
          autofocus: widget.initial != null,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(labelText: t.pointName, hintText: t.pointNameHint),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _coords,
          autofocus: widget.initial == null,
          decoration: InputDecoration(
            labelText: t.coordinates,
            hintText: '45.4642, 9.1900',
            helperText: t.coordinatesHelp,
            helperMaxLines: 3,
            errorText: _invalid ? t.coordsInvalid : null,
          ),
          onChanged: (_) => _invalid ? setState(() => _invalid = false) : null,
          onSubmitted: (_) => _save(),
        ),
        if (here != null)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              icon: const Icon(Icons.my_location),
              label: Text(t.useMyPosition),
              onPressed: () => _coords.text = '${here.latitude.toStringAsFixed(6)}, ${here.longitude.toStringAsFixed(6)}',
            ),
          ),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(t.cancel)),
        FilledButton(onPressed: _save, child: Text(t.save)),
      ],
    );
  }
}

/// "850 m", "1,2 km" (con il separatore decimale della lingua).
String formatDistance(double m) {
  final nf = NumberFormat.decimalPattern(AppSettings.instance.language);
  if (m < 1000) return '${m.round()} m';
  return '${(nf..maximumFractionDigits = m < 10000 ? 1 : 0).format(m / 1000)} km';
}

/// Punto cardinale a 8 direzioni; [west] è la lettera dell'ovest nella lingua scelta
/// (in tedesco anche l'est cambia: Ost).
String compassPoint(double deg, String west, {String east = 'E'}) {
  const points = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
  return points[((deg % 360) / 45).round() % 8].replaceAll('E', '#').replaceAll('W', west).replaceAll('#', east);
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
  const _MapArea({
    required this.position,
    required this.pins,
    required this.selected,
    required this.track,
    required this.focus,
    required this.fitTo,
    required this.onLongPress,
    required this.onPinTap,
  });

  final Position? position;
  final List<Pin> pins;
  final Pin? selected;
  final List<LatLng> track;
  final LatLng? focus;
  final List<LatLng>? fitTo;
  final void Function(LatLng) onLongPress;
  final void Function(Pin) onPinTap;

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
          pins: pins,
          selected: selected,
          track: track,
          focus: focus,
          fitTo: fitTo,
          onLongPress: onLongPress,
          onPinTap: onPinTap,
        );
      },
    );
  }
}
