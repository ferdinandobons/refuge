import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Punto salvato sulla mappa (inserito a mano con le coordinate o tenendo premuto sulla mappa).
class Pin {
  const Pin(this.name, this.point);

  final String name;
  final LatLng point;

  Map<String, dynamic> toJson() => {'name': name, 'lat': point.latitude, 'lon': point.longitude};

  factory Pin.fromJson(Map<String, dynamic> j) =>
      Pin(j['name'] as String, LatLng((j['lat'] as num).toDouble(), (j['lon'] as num).toDouble()));
}

/// Punti salvati, punto selezionato (con distanza e direzione) e percorso registrato.
/// Tutto resta sul telefono.
class MapPins extends ChangeNotifier {
  MapPins._();

  static final instance = MapPins._();

  static const _pinsKey = 'map:pins', _trackKey = 'map:track';
  SharedPreferences? _prefs;
  List<Pin> pins = [];
  List<LatLng> track = [];
  Pin? selected;
  bool recording = false;

  Future<void> load() async {
    if (_prefs != null) return;
    _prefs = await SharedPreferences.getInstance();
    try {
      pins = [for (final j in jsonDecode(_prefs!.getString(_pinsKey) ?? '[]') as List) Pin.fromJson(j as Map<String, dynamic>)];
      track = [
        for (final p in jsonDecode(_prefs!.getString(_trackKey) ?? '[]') as List)
          LatLng(((p as List)[0] as num).toDouble(), (p[1] as num).toDouble()),
      ];
    } catch (_) {
      pins = [];
      track = [];
    }
    notifyListeners();
  }

  void add(Pin p) {
    pins = [...pins, p];
    selected = p;
    _savePins();
  }

  void remove(Pin p) {
    pins = pins.where((x) => x != p).toList();
    if (selected == p) selected = null;
    _savePins();
  }

  void select(Pin? p) {
    selected = p;
    notifyListeners();
  }

  void _savePins() {
    _prefs?.setString(_pinsKey, jsonEncode([for (final p in pins) p.toJson()]));
    notifyListeners();
  }

  void toggleRecording() {
    recording = !recording;
    notifyListeners();
  }

  /// Aggiunge una posizione al percorso, se è abbastanza precisa e distante dall'ultima.
  void addTrackPoint(LatLng p, double accuracy) {
    if (!recording || accuracy > 30) return;
    if (track.isNotEmpty && const Distance().as(LengthUnit.Meter, track.last, p) < 5) return;
    track = [...track, p];
    _prefs?.setString(_trackKey, jsonEncode([for (final q in track) [q.latitude, q.longitude]]));
    notifyListeners();
  }

  void clearTrack() {
    track = [];
    _prefs?.remove(_trackKey);
    notifyListeners();
  }

  double get trackMeters {
    var m = 0.0;
    for (var i = 1; i < track.length; i++) {
      m += const Distance().as(LengthUnit.Meter, track[i - 1], track[i]);
    }
    return m;
  }
}

/// Distanza in linea d'aria, in metri.
double distanceMeters(LatLng a, LatLng b) => const Distance().as(LengthUnit.Meter, a, b);

/// Direzione da [a] a [b], in gradi da 0 (nord) a 360, in senso orario.
double bearingDegrees(LatLng a, LatLng b) => (const Distance().bearing(a, b) + 360) % 360;

/// Legge coordinate scritte a mano: decimali ("45.4642, 9.1900", "45,4642 9,19", "-33.86; 151.21")
/// o in gradi, primi e secondi ("45°27'51\"N 9°11'24\"E"). Restituisce null se non sono valide.
LatLng? parseCoordinates(String input) {
  final s = input
      .trim()
      .toUpperCase()
      .replaceAll(RegExp('[′’‘`´]'), "'")
      .replaceAll(RegExp('[″“”]'), '"')
      .replaceAll("''", '"');
  if (s.isEmpty) return null;

  double sign(String? h, double v) => (h == 'S' || h == 'W' || h == 'O') ? -v.abs() : v;
  double num(String t) => double.parse(t.replaceAll(',', '.'));

  // Gradi, primi e secondi.
  final dms = RegExp(r'''([NSEWO])?\s*(\d+(?:[.,]\d+)?)\s*°\s*(?:(\d+(?:[.,]\d+)?)\s*'\s*)?(?:(\d+(?:[.,]\d+)?)\s*"\s*)?([NSEWO])?''')
      .allMatches(s)
      .toList();
  if (dms.length == 2) {
    final v = [
      for (final m in dms)
        (
          sign(m.group(1) ?? m.group(5),
              num(m.group(2)!) + (m.group(3) == null ? 0 : num(m.group(3)!) / 60) + (m.group(4) == null ? 0 : num(m.group(4)!) / 3600)),
          m.group(1) ?? m.group(5),
        ),
    ];
    // Se le lettere dicono che il primo valore è la longitudine, si scambiano.
    final swap = v[0].$2 == 'E' || v[0].$2 == 'W' || v[0].$2 == 'O' || v[1].$2 == 'N' || v[1].$2 == 'S';
    return _valid(swap ? v[1].$1 : v[0].$1, swap ? v[0].$1 : v[1].$1);
  }

  // Decimali: separati da ";", da spazi, o da una virgola (se i decimali usano il punto).
  final clean = s.replaceAll(RegExp(r'[NSEWO°]'), ' ').trim();
  List<String> parts;
  if (clean.contains(';')) {
    parts = clean.split(';');
  } else if (clean.split(RegExp(r'\s+')).length == 2) {
    parts = clean.split(RegExp(r'\s+')).map((p) => p.replaceAll(RegExp(r',$'), '')).toList();
  } else if (clean.contains(', ')) {
    parts = clean.split(', ');
  } else {
    parts = clean.split(',');
  }
  if (parts.length != 2) return null;
  final re = RegExp(r'^-?\d+(?:[.,]\d+)?$');
  final a = parts[0].trim(), b = parts[1].trim();
  if (!re.hasMatch(a) || !re.hasMatch(b)) return null;
  final letters = RegExp(r'[NSEWO]').allMatches(s).map((m) => m.group(0)).toList();
  var lat = num(a), lon = num(b);
  if (letters.length == 2) {
    lat = sign(letters[0], lat);
    lon = sign(letters[1], lon);
  }
  return _valid(lat, lon);
}

LatLng? _valid(double lat, double lon) =>
    lat.abs() <= 90 && lon.abs() <= 180 ? LatLng(lat, lon) : null;
