import 'package:flutter/material.dart';

class DashedVerticalDivider extends StatelessWidget {
  final double height;
  final double dashWidth;
  final double dashSpace;

  const DashedVerticalDivider({
    super.key,
    this.height = 100.0,
    this.dashWidth = 5.0,
    this.dashSpace = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(1, height),
      painter: _DashedVerticalPainter(dashWidth, dashSpace),
    );
  }
}

class _DashedVerticalPainter extends CustomPainter {
  final double dashWidth;
  final double dashSpace;

  _DashedVerticalPainter(this.dashWidth, this.dashSpace);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
