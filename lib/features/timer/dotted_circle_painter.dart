import 'dart:math';

import 'package:flutter/material.dart';
class DottedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final int dotsCount = 60;
    final double gap = 2 * 3.141592653589793 / dotsCount;

    for (int i = 0; i < dotsCount; i++) {
      final double x = size.width / 2 + (size.width / 2 - 10) * cos(i * gap);
      final double y = size.height / 2 + (size.height / 2 - 10) * sin(i * gap);
      canvas.drawCircle(Offset(x, y), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}