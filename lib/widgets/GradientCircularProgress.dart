import 'package:flutter/material.dart';
import 'dart:math';

class GradientCircularProgress extends StatelessWidget {
  final double completion;

  const GradientCircularProgress({Key? key, required this.completion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer Shadow Effect
        // Container(
        //   width: 50,
        //   height: 50,
        //   decoration: BoxDecoration(
        //     shape: BoxShape.circle,
        //     boxShadow: [
        //       BoxShadow(
        //         color: Colors.white.withOpacity(0.4),
        //         blurRadius: 4,
        //         offset: const Offset(0, 4),
        //       ),
        //     ],
        //   ),
        // ),
        // CustomPaint for Progress
        CustomPaint(
          size: const Size(40, 40),
          painter: GradientProgressPainter(completion),
        ),
      ],
    );
  }
}

class GradientProgressPainter extends CustomPainter {
  final double completion;
  GradientProgressPainter(this.completion);

  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = 2;
    const double borderWidth = 3;
    final double radius = (size.width / 2) - (strokeWidth / 2);
    final Offset center = Offset(size.width / 2, size.height / 2);

    // **Gradient border**
    final Paint borderPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF654EA3), Color(0xFFEAAFC8)],
      ).createShader(Rect.fromCircle(center: center, radius: radius + borderWidth))
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth * 2;

    // **Background Circle with Inset Shadow**
    final Paint backgroundPaint = Paint()
      ..color = const Color(0xFF858585)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 4); // Inset Shadow Effect

    // **Progress Arc with Gradient**
    final Paint progressPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF654EA3), Color(0xFFEAAFC8)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    // Draw gradient border
    canvas.drawCircle(center, radius + borderWidth, borderPaint);
    // Draw background with inset shadow
    canvas.drawCircle(center, radius, backgroundPaint);
    // Draw progress arc
    double sweepAngle = 2 * pi * completion.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
