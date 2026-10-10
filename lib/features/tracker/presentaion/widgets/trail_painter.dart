import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TrailPainter extends CustomPainter {
  TrailPainter({
    required this.points,
    required this.walked,
    required this.baseColor,
    required this.walkedColor,
  });

  final List<Offset> points;

  /// walked[i] colors the segment from points[i] to points[i + 1].
  final List<bool> walked;
  final Color baseColor;
  final Color walkedColor;

  @override
  void paint(Canvas canvas, Size size) {
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..color = baseColor;
    final done = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..color = walkedColor;

    for (var i = 0; i < points.length - 1; i++) {
      final a = points[i];
      final b = points[i + 1];
      final midY = (a.dy + b.dy) / 2;
      final path = Path()
        ..moveTo(a.dx, a.dy)
        ..cubicTo(a.dx, midY, b.dx, midY, b.dx, b.dy);
      canvas.drawPath(path, walked[i] ? done : base);
    }
  }

  @override
  bool shouldRepaint(TrailPainter old) =>
      !listEquals(old.points, points) ||
      !listEquals(old.walked, walked) ||
      old.baseColor != baseColor ||
      old.walkedColor != walkedColor;
}
