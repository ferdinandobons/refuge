import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../l10n/app_localizations.dart';

/// Direzione in gradi (0 = nord, 90 = est) del lato superiore del telefono.
///
/// Su iOS usa la bussola di sistema (CLLocationManager, già calibrata).
/// Su Android calcola la direzione da magnetometro e accelerometro con compensazione dell'inclinazione.
Stream<double> headingStream() {
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
    return const EventChannel('rifugio/heading')
        .receiveBroadcastStream()
        .map((e) => ((e as Map)['heading'] as num).toDouble());
  }
  return _sensorHeading();
}

Stream<double> _sensorHeading() {
  late StreamController<double> controller;
  final subs = <StreamSubscription<dynamic>>[];
  List<double>? gravity;
  double sinAvg = 0, cosAvg = 1;

  void update(List<double> m) {
    final g = gravity;
    if (g == null) return;
    // East = M × G, North = G × East (come SensorManager.getRotationMatrix su Android).
    final ex = m[1] * g[2] - m[2] * g[1];
    final ey = m[2] * g[0] - m[0] * g[2];
    final ez = m[0] * g[1] - m[1] * g[0];
    final nY = g[2] * ex - g[0] * ez;
    // |North| = |G|·|East|: si scala East per |G| così i due vettori hanno la stessa norma.
    final gNorm = math.sqrt(g[0] * g[0] + g[1] * g[1] + g[2] * g[2]);
    final angle = math.atan2(ey * gNorm, nY);
    // Media circolare per smorzare il tremolio.
    sinAvg = sinAvg * 0.85 + math.sin(angle) * 0.15;
    cosAvg = cosAvg * 0.85 + math.cos(angle) * 0.15;
    controller.add((math.atan2(sinAvg, cosAvg) * 180 / math.pi + 360) % 360);
  }

  controller = StreamController<double>(
    onListen: () {
      subs
        ..add(accelerometerEventStream().listen((e) => gravity = [e.x, e.y, e.z], onError: controller.addError))
        ..add(magnetometerEventStream().listen((e) => update([e.x, e.y, e.z]), onError: controller.addError));
    },
    onCancel: () {
      for (final s in subs) {
        s.cancel();
      }
    },
  );
  return controller.stream;
}

String cardinal(double deg, AppLocalizations t) {
  final names = t.cardinals.split(',');
  return names[((deg + 22.5) % 360 ~/ 45)];
}
