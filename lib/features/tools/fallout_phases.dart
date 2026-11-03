import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';

/// Fasi dopo un'esplosione nucleare, in base al tempo trascorso.
///
/// Basate sulla regola del 7-10 (decadimento t^-1.2) e sulle indicazioni di protezione civile
/// (FEMA/Ready.gov, Protezione Civile): restare al riparo almeno 24 ore, poi seguire le autorità.
/// Sono indicazioni generali: quando uscire lo decidono le autorità e le misure reali.
enum FalloutPhase { immediate, shelter, essentialOnly, decreasing, low }

class PhaseInfo {
  const PhaseInfo(this.phase, this.fromHours, this.toHours, this.color, this.icon);

  final FalloutPhase phase;
  final double fromHours;
  final double? toHours;
  final Color color;
  final IconData icon;

  String title(AppLocalizations t) => switch (phase) {
        FalloutPhase.immediate => t.phase0Title,
        FalloutPhase.shelter => t.phase1Title,
        FalloutPhase.essentialOnly => t.phase2Title,
        FalloutPhase.decreasing => t.phase3Title,
        FalloutPhase.low => t.phase4Title,
      };

  List<String> actions(AppLocalizations t) => switch (phase) {
        FalloutPhase.immediate => [t.phase0a, t.phase0b, t.phase0c, t.phase0d],
        FalloutPhase.shelter => [t.phase1a, t.phase1b, t.phase1c, t.phase1d],
        FalloutPhase.essentialOnly => [t.phase2a, t.phase2b, t.phase2c],
        FalloutPhase.decreasing => [t.phase3a, t.phase3b, t.phase3c],
        FalloutPhase.low => [t.phase4a, t.phase4b, t.phase4c],
      };

  /// In questa fase si può uscire (solo se necessario e con protezione)?
  bool get canGoOut => phase.index >= FalloutPhase.essentialOnly.index;
}

const kPhases = <PhaseInfo>[
  PhaseInfo(FalloutPhase.immediate, 0, 1, kDanger, Icons.dangerous),
  PhaseInfo(FalloutPhase.shelter, 1, 24, kDanger, Icons.house),
  PhaseInfo(FalloutPhase.essentialOnly, 24, 48, Colors.orange, Icons.directions_walk),
  PhaseInfo(FalloutPhase.decreasing, 48, 336, kAccent, Icons.trending_down),
  PhaseInfo(FalloutPhase.low, 336, null, Colors.lightGreen, Icons.check_circle),
];

PhaseInfo phaseAt(double hours) => kPhases.lastWhere((p) => hours >= p.fromHours, orElse: () => kPhases.first);

/// Intensità residua rispetto a quella a 1 ora dall'esplosione (1 = 100%).
double remainingFraction(double hours) => hours <= 1 ? 1 : math.pow(hours, -1.2).toDouble();

/// Ora dell'esplosione, condivisa tra il timer e la barra in cima alla schermata Emergenza.
class FalloutTimer extends ChangeNotifier {
  FalloutTimer._();

  static final instance = FalloutTimer._();

  static const _key = 'fallout:start';
  SharedPreferences? _prefs;
  DateTime? _start;
  bool loaded = false;

  DateTime? get start => _start;

  bool get running => _start != null;

  Future<void> load() async {
    if (loaded) return;
    _prefs = await SharedPreferences.getInstance();
    final ms = _prefs!.getInt(_key);
    _start = ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
    loaded = true;
    notifyListeners();
  }

  void set(DateTime? start) {
    _start = start;
    start == null ? _prefs?.remove(_key) : _prefs?.setInt(_key, start.millisecondsSinceEpoch);
    notifyListeners();
  }

  double get hours => _start == null ? 0 : DateTime.now().difference(_start!).inSeconds / 3600;
}

/// Durata leggibile, es. "3 h 12 min" o "2 g 4 h 0 min".
String formatDuration(AppLocalizations t, Duration d) {
  if (d.isNegative) d = Duration.zero;
  final days = d.inDays, h = d.inHours % 24, m = d.inMinutes % 60;
  return days > 0 ? t.durationDHM(days, h, m) : t.durationHM(h, m);
}
