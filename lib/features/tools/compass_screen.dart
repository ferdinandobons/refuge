import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'heading.dart';

class CompassScreen extends StatelessWidget {
  const CompassScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Bussola')),
        body: StreamBuilder<double>(
          stream: headingStream(),
          builder: (context, snap) {
            if (snap.hasError) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Bussola non disponibile su questo dispositivo.', textAlign: TextAlign.center),
                ),
              );
            }
            final heading = snap.data;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    heading == null ? '—' : '${heading.round()}° ${cardinal(heading)}',
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.arrow_drop_down, color: kDanger, size: 48),
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Transform.rotate(
                        angle: -(heading ?? 0) * math.pi / 180,
                        child: CustomPaint(painter: _DialPainter()),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    heading == null
                        ? 'In attesa del sensore… Sul simulatore la bussola non è disponibile.'
                        : 'Tieni il telefono in piano, lontano da metalli e magneti. '
                            'Se la direzione è strana, muovi il telefono disegnando un 8 per calibrarlo.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            );
          },
        ),
      );
}

class _DialPainter extends CustomPainter {
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

    const labels = {0: 'N', 90: 'E', 180: 'S', 270: 'O'};
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
