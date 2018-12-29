import 'package:flutter/material.dart';
import 'dart:math';

class RevealPainter extends CustomPainter {
  final double fraction;
  final Size screenSize;
  final Color fillColor;

  RevealPainter({
    @required this.fraction,
    @required this.screenSize,
    @required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final finalRadius = screenSize.width > screenSize.height
        ? screenSize.width
        : screenSize.height;
    var radius = finalRadius * fraction * sqrt2;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
  }

  @override
  bool shouldRepaint(RevealPainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }
}
