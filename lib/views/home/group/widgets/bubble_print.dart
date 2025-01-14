// lib/bubble_painter.dart
import 'package:mwc/utils/fisica_theme.dart';
import 'package:flutter/material.dart';
import 'package:social_share/social_share.dart';

class BubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = AppColors.DarkenGreen
      ..style = PaintingStyle.fill;

    var path = Path()
      ..moveTo(0, 10)
      ..quadraticBezierTo(0, 0, 10, 0)
      ..lineTo(size.width - 10, 0)
      ..quadraticBezierTo(size.width, 0, size.width, 10)
      ..lineTo(size.width, size.height - 20)
      ..quadraticBezierTo(size.width, size.height - 10, size.width - 10, size.height - 10)
      ..lineTo(size.width / 2 + 5, size.height - 10)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width / 2 - 5, size.height - 10)
      ..lineTo(10, size.height - 10)
      ..quadraticBezierTo(0, size.height - 10, 0, size.height - 20)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
