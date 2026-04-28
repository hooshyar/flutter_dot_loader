import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A loader featuring a geometric grid of triangles that pulses or waves.
class TriangleLoader extends StatefulWidget {
  final Color color;
  final double size;
  final double triangleSize;
  final Duration duration;
  final bool wireframe;

  const TriangleLoader({
    super.key,
    this.color = Colors.indigoAccent,
    this.size = 200,
    this.triangleSize = 30.0,
    this.duration = const Duration(seconds: 4),
    this.wireframe = false,
  });

  @override
  State<TriangleLoader> createState() => _TriangleLoaderState();
}

class _TriangleLoaderState extends State<TriangleLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _TrianglePainter(
              progress: _controller.value,
              color: widget.color,
              triangleSize: widget.triangleSize,
              wireframe: widget.wireframe,
            ),
          );
        },
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final double progress;
  final Color color;
  final double triangleSize;
  final bool wireframe;

  _TrianglePainter({
    required this.progress,
    required this.color,
    required this.triangleSize,
    required this.wireframe,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = wireframe ? PaintingStyle.stroke : PaintingStyle.fill
      ..strokeWidth = 1.0;

    final h = triangleSize * math.sqrt(3) / 2;
    final rows = (size.height / h).ceil() + 1;
    final cols = (size.width / (triangleSize / 2)).ceil() + 1;
    final center = Offset(size.width / 2, size.height / 2);

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        bool isUp = (row + col) % 2 == 0;
        double x = col * (triangleSize / 2);
        double y = row * h;

        final pos = Offset(x, y);
        final distance = (pos - center).distance;
        final double wave = math.sin((distance / 80.0) - (progress * 2 * math.pi));
        final double normalizedWave = (wave + 1) / 2;

        double scale = 0.4 + (normalizedWave * 0.6);
        paint.color = color.withValues(alpha: 0.1 + (normalizedWave * 0.7));

        _drawTriangle(canvas, x, y, triangleSize, isUp, scale, paint);
      }
    }
  }

  void _drawTriangle(Canvas canvas, double x, double y, double size, bool isUp, double scale, Paint paint) {
    final h = size * math.sqrt(3) / 2;
    final path = Path();
    
    canvas.save();
    // Translate to triangle center for rotation/scale
    canvas.translate(x, y + (isUp ? h / 2 : h / 3));
    canvas.scale(scale);
    canvas.translate(-x, -(y + (isUp ? h / 2 : h / 3)));

    if (isUp) {
      path.moveTo(x, y);
      path.lineTo(x - size / 2, y + h);
      path.lineTo(x + size / 2, y + h);
    } else {
      path.moveTo(x, y + h);
      path.lineTo(x - size / 2, y);
      path.lineTo(x + size / 2, y);
    }
    
    path.close();
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
