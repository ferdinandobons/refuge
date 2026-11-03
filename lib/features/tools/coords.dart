import 'dart:math' as math;

/// Conversioni di coordinate WGS84: gradi/minuti/secondi, UTM e MGRS.

String toDms(double deg, {required bool isLat}) {
  final hemi = isLat ? (deg >= 0 ? 'N' : 'S') : (deg >= 0 ? 'E' : 'O');
  var a = deg.abs();
  final d = a.floor();
  a = (a - d) * 60;
  final m = a.floor();
  final s = (a - m) * 60;
  return "$d° ${m.toString().padLeft(2, '0')}' ${s.toStringAsFixed(1).padLeft(4, '0')}\" $hemi";
}

class Utm {
  const Utm(this.zone, this.band, this.easting, this.northing);

  final int zone;
  final String band;
  final double easting;
  final double northing;

  @override
  String toString() => '$zone$band ${easting.round()} ${northing.round()}';
}

const _bands = 'CDEFGHJKLMNPQRSTUVWX';

/// Proiezione UTM (serie di Krüger, precisione sub-metrica). Valida tra 80°S e 84°N.
Utm? toUtm(double lat, double lon) {
  if (lat < -80 || lat > 84) return null;

  var zone = ((lon + 180) / 6).floor() + 1;
  if (zone > 60) zone = 60;
  // Eccezioni: Norvegia sud-occidentale e Svalbard.
  if (lat >= 56 && lat < 64 && lon >= 3 && lon < 12) zone = 32;
  if (lat >= 72) {
    if (lon >= 0 && lon < 9) zone = 31;
    if (lon >= 9 && lon < 21) zone = 33;
    if (lon >= 21 && lon < 33) zone = 35;
    if (lon >= 33 && lon < 42) zone = 37;
  }

  const a = 6378137.0;
  const f = 1 / 298.257223563;
  const k0 = 0.9996;
  const e2 = f * (2 - f);
  const ep2 = e2 / (1 - e2);
  final e4 = e2 * e2, e6 = e4 * e2;

  final phi = lat * math.pi / 180;
  final lam = lon * math.pi / 180;
  final lam0 = ((zone - 1) * 6 - 180 + 3) * math.pi / 180;

  final sinPhi = math.sin(phi), cosPhi = math.cos(phi), tanPhi = math.tan(phi);
  final n = a / math.sqrt(1 - e2 * sinPhi * sinPhi);
  final t = tanPhi * tanPhi;
  final c = ep2 * cosPhi * cosPhi;
  final A = cosPhi * (lam - lam0);

  final m = a *
      ((1 - e2 / 4 - 3 * e4 / 64 - 5 * e6 / 256) * phi -
          (3 * e2 / 8 + 3 * e4 / 32 + 45 * e6 / 1024) * math.sin(2 * phi) +
          (15 * e4 / 256 + 45 * e6 / 1024) * math.sin(4 * phi) -
          (35 * e6 / 3072) * math.sin(6 * phi));

  final easting = k0 *
          n *
          (A + (1 - t + c) * math.pow(A, 3) / 6 + (5 - 18 * t + t * t + 72 * c - 58 * ep2) * math.pow(A, 5) / 120) +
      500000;
  var northing = k0 *
      (m +
          n *
              tanPhi *
              (A * A / 2 +
                  (5 - t + 9 * c + 4 * c * c) * math.pow(A, 4) / 24 +
                  (61 - 58 * t + t * t + 600 * c - 330 * ep2) * math.pow(A, 6) / 720));
  if (lat < 0) northing += 10000000;

  final band = _bands[math.min(((lat + 80) / 8).floor(), 19)];
  return Utm(zone, band, easting, northing);
}

/// MGRS con precisione di 1 metro, es. "33T TG 91234 40567".
String? toMgrs(double lat, double lon) {
  final u = toUtm(lat, lon);
  if (u == null) return null;
  const colSets = ['ABCDEFGH', 'JKLMNPQR', 'STUVWXYZ'];
  const rowLetters = 'ABCDEFGHJKLMNPQRSTUV';
  final col = colSets[(u.zone - 1) % 3][(u.easting / 100000).floor() - 1];
  final row = rowLetters[((u.northing / 100000).floor() + (u.zone.isEven ? 5 : 0)) % 20];
  String five(double v) => (v.floor() % 100000).toString().padLeft(5, '0');
  return '${u.zone}${u.band} $col$row ${five(u.easting)} ${five(u.northing)}';
}
