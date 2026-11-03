import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import 'heading.dart';

class CompassScreen extends StatelessWidget {
  const CompassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
        appBar: AppBar(title: Text(t.compassTitle)),
        body: StreamBuilder<double>(
          stream: headingStream(),
          builder: (context, snap) => StreamBuilder<AccelerometerEvent>(
            stream: _gravity,
            builder: (context, g) => _body(context, t, snap, g.data),
          ),
        ),
      );
  }

  /// Gravità smussata, usata per la livella.
  static final Stream<AccelerometerEvent> _gravity =
      accelerometerEventStream(samplingPeriod: SensorInterval.uiInterval).asBroadcastStream();

  Widget _body(BuildContext context, AppLocalizations t, AsyncSnapshot<double> snap, AccelerometerEvent? g) {
            final tilt = g == null ? null : _tiltDegrees(g);
            final flat = tilt == null || tilt < 15;
            if (snap.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(t.compassUnavailable, textAlign: TextAlign.center),
                ),
              );
            }
            final heading = snap.data;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    heading == null ? '—' : '${heading.round()}° ${cardinal(heading, t)}',
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.arrow_drop_down, color: kDanger, size: 48),
                  Expanded(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: flat ? 1 : 0.3,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Transform.rotate(
                          angle: -(heading ?? 0) * math.pi / 180,
                          child: CustomPaint(painter: _DialPainter(t.cardinals.split(','))),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (g != null) _Level(gravity: g, tilt: tilt!, t: t),
                  const SizedBox(height: 12),
                  Text(
                    heading == null ? t.compassWaiting : t.compassHint,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            );
  }

  /// Angolo tra lo schermo e il piano orizzontale.
  static double _tiltDegrees(AccelerometerEvent g) {
    final norm = math.sqrt(g.x * g.x + g.y * g.y + g.z * g.z);
    if (norm == 0) return 0;
    return math.acos((g.z.abs() / norm).clamp(0, 1)) * 180 / math.pi;
  }
}

/// Livella a bolla: la bolla va verso il lato più alto del telefono.
class _Level extends StatelessWidget {
  const _Level({required this.gravity, required this.tilt, required this.t});

  final AccelerometerEvent gravity;
  final double tilt;
  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    final color = tilt < 5 ? Colors.lightGreen : tilt < 15 ? kAccent : kDanger;
    final label = tilt < 5 ? t.levelFlat : tilt < 15 ? t.levelAlmost : t.levelTilted;
    const size = 72.0, bubble = 18.0;
    final norm = math.sqrt(gravity.x * gravity.x + gravity.y * gravity.y + gravity.z * gravity.z);
    // Asse x a destra, asse y verso l'alto del telefono; sullo schermo y cresce verso il basso.
    final dx = (norm == 0 ? 0 : gravity.x / norm).clamp(-1.0, 1.0) * (size - bubble) / 2 * 2.2;
    final dy = (norm == 0 ? 0 : -gravity.y / norm).clamp(-1.0, 1.0) * (size - bubble) / 2 * 2.2;
    final r = (size - bubble) / 2;
    final dist = math.sqrt(dx * dx + dy * dy);
    final k = dist > r ? r / dist : 1.0;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
        width: size,
        height: size,
        child: Stack(alignment: Alignment.center, children: [
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color, width: 2)),
          ),
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white38)),
          ),
          Transform.translate(
            offset: Offset(dx * k, dy * k),
            child: Container(
              width: bubble,
              height: bubble,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
          ),
        ]),
      ),
      const SizedBox(width: 16),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(t.tiltDegrees(tilt.round()), style: const TextStyle(color: Colors.white70)),
      ]),
    ]);
  }
}

class _DialPainter extends CustomPainter {
  _DialPainter(this.names);

  final List<String> names;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2;
    canvas.drawCircle(c, r, Paint()..color = kSurface);
    canvas.drawCircle(c, r, Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white24
      ..strokeWidth = 2);

    for (var d = 0; d < 360; d += 5) {
      final a = d * math.pi / 180;
      final major = d % 30 == 0;
      final len = major ? r * 0.12 : r * 0.05;
      final dir = Offset(math.sin(a), -math.cos(a));
      canvas.drawLine(
        c + dir * (r - 4),
        c + dir * (r - 4 - len),
        Paint()
          ..color = major ? Colors.white70 : Colors.white30
          ..strokeWidth = major ? 2 : 1,
      );
    }

    final labels = {0: names[0], 90: names[2], 180: names[4], 270: names[6]};
    for (final e in labels.entries) {
      final a = e.key * math.pi / 180;
      final tp = TextPainter(
        text: TextSpan(
          text: e.value,
          style: TextStyle(
            color: e.key == 0 ? kDanger : Colors.white,
            fontSize: r * 0.16,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final pos = c + Offset(math.sin(a), -math.cos(a)) * r * 0.7;
      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(a);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }

    final needle = Path()
      ..moveTo(c.dx, c.dy - r * 0.5)
      ..lineTo(c.dx - r * 0.06, c.dy)
      ..lineTo(c.dx + r * 0.06, c.dy)
      ..close();
    canvas.drawPath(needle, Paint()..color = kDanger);
    canvas.drawCircle(c, r * 0.04, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
