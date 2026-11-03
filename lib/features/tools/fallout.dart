import 'dart:math' as math;

/// Modello di Way-Wigner: l'intensità del fallout decade come t^-1.2 (t = ore dopo l'esplosione).
/// Approssimazione valida da circa 30 minuti a circa 6 mesi. Da qui la "regola del 7-10":
/// ogni volta che il tempo si moltiplica per 7, l'intensità si divide per circa 10.

/// Intensità all'ora [t] partendo da una misura [rate] fatta all'ora [t0].
double falloutRate(double rate, double t0, double t) => rate * math.pow(t / t0, -1.2);

/// Dose accumulata restando esposti dall'ora [ta] all'ora [tb] (stesse unità di [rate] × ore).
double falloutDose(double rate, double t0, double ta, double tb) {
  final r1 = rate * math.pow(t0, 1.2); // intensità a 1 ora
  return r1 * (math.pow(ta, -0.2) - math.pow(tb, -0.2)) / 0.2;
}
