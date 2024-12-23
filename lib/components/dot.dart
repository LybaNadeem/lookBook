import 'package:flutter/material.dart';

class DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dotSpacing;

  DottedBorderPainter({
    required this.color,
    this.strokeWidth = 2.0,
    this.dotSpacing = 6.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawCircle(Offset(startX, 0), strokeWidth / 2, paint);
      startX += dotSpacing;
    }

    double startY = 0;
    while (startY < size.height) {
      canvas.drawCircle(Offset(size.width, startY), strokeWidth / 2, paint);
      startY += dotSpacing;
    }

    startX = size.width;
    while (startX > 0) {
      canvas.drawCircle(Offset(startX, size.height), strokeWidth / 2, paint);
      startX -= dotSpacing;
    }

    startY = size.height;
    while (startY > 0) {
      canvas.drawCircle(Offset(0, startY), strokeWidth / 2, paint);
      startY -= dotSpacing;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DottedBorderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 398, // Set the width to 398
          height: 399.39, // Set the height to 399.39
          child: CustomPaint(
            painter: DottedBorderPainter(
              color: Colors.red, // Choose your desired color
              strokeWidth: 2.0,
              dotSpacing: 6.0,
            ),
          ),
        ),
      ),
    );
  }
}


