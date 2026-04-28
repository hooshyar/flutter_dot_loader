import 'dart:math' as math;
import 'package:flutter/material.dart';

enum MatrixShape { square, circular, triangle, custom }

enum MatrixPattern {
  // Predefined patterns from zzzzshawn/matrix
  square1, square2, square3, square4, square5, square6, square7, square8, square9, square10,
  square11, square12, square13, square14, square15, square16, square17, square18, square19, square20,
  circular1, circular2, circular3, circular4, circular5, circular6, circular7, circular8, circular9, circular10,
  circular11, circular12, circular13, circular14, circular15, circular16, circular17, circular18, circular19, circular20,
  triangle1, triangle2, triangle3, triangle4, triangle5, triangle6, triangle7, triangle8, triangle9, triangle10,
  triangle11, triangle12, triangle13, triangle14, triangle15, triangle16, triangle17, triangle18, triangle19, triangle20,
  custom,
}

/// A highly configurable, high-performance LED dot-matrix loader.
class MatrixLoader extends StatefulWidget {
  /// The geometric arrangement of dots.
  final MatrixShape shape;

  /// The animation pattern to display. Set to [MatrixPattern.custom] to use [customIntensity].
  final MatrixPattern pattern;

  /// Number of horizontal dots. Defaults to 5.
  final int columns;

  /// Number of vertical dots. Defaults to 5.
  final int rows;

  /// The color of active/lit dots.
  final Color activeColor;

  /// The color of inactive/dim dots.
  final Color inactiveColor;

  /// The size of the widget's bounding box.
  final double size;

  /// The diameter of each individual dot.
  final double dotSize;

  /// The space between dots. If null, it auto-calculates to fit [size].
  final double? spacing;

  /// Duration of one full animation cycle.
  final Duration duration;

  /// Whether to show a ripple effect on mouse hover (web/desktop).
  final bool hoverAnimated;

  /// The base opacity for unlit dots (default: 0.08).
  final double opacityBase;

  /// The intermediate opacity level for the "LED glow" effect (default: 0.34).
  final double opacityMid;

  /// The peak opacity for fully lit dots (default: 0.94).
  final double opacityPeak;

  /// A custom function to determine if a specific dot at (row, col) is part of the shape.
  final bool Function(int row, int col)? customMask;

  /// A custom function to determine the light intensity (0.0 to 1.0) of a dot at (row, col).
  /// [progress] goes from 0.0 to 1.0 based on [duration].
  final double Function(int row, int col, double progress)? customIntensity;

  const MatrixLoader({
    super.key,
    this.shape = MatrixShape.square,
    this.pattern = MatrixPattern.square1,
    this.columns = 5,
    this.rows = 5,
    this.activeColor = Colors.white,
    this.inactiveColor = const Color(0xFF27272A),
    this.size = 64,
    this.dotSize = 4.0,
    this.spacing,
    this.duration = const Duration(milliseconds: 1500),
    this.hoverAnimated = true,
    this.opacityBase = 0.08,
    this.opacityMid = 0.34,
    this.opacityPeak = 0.94,
    this.customMask,
    this.customIntensity,
  });

  @override
  State<MatrixLoader> createState() => _MatrixLoaderState();
}

class _MatrixLoaderState extends State<MatrixLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _MatrixPainter(
                progress: _controller.value,
                shape: widget.shape,
                pattern: widget.pattern,
                columns: widget.columns,
                rows: widget.rows,
                activeColor: widget.activeColor,
                inactiveColor: widget.inactiveColor,
                dotSize: widget.dotSize,
                spacing: widget.spacing ?? (widget.size - widget.dotSize * widget.columns) / (widget.columns - 1).clamp(1, 100),
                isHovered: _isHovered && widget.hoverAnimated,
                opacityBase: widget.opacityBase,
                opacityMid: widget.opacityMid,
                opacityPeak: widget.opacityPeak,
                customMask: widget.customMask,
                customIntensity: widget.customIntensity,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MatrixPainter extends CustomPainter {
  final double progress;
  final MatrixShape shape;
  final MatrixPattern pattern;
  final int columns;
  final int rows;
  final Color activeColor;
  final Color inactiveColor;
  final double dotSize;
  final double spacing;
  final bool isHovered;
  final double opacityBase;
  final double opacityMid;
  final double opacityPeak;
  final bool Function(int row, int col)? customMask;
  final double Function(int row, int col, double progress)? customIntensity;

  _MatrixPainter({
    required this.progress,
    required this.shape,
    required this.pattern,
    required this.columns,
    required this.rows,
    required this.activeColor,
    required this.inactiveColor,
    required this.dotSize,
    required this.spacing,
    required this.isHovered,
    required this.opacityBase,
    required this.opacityMid,
    required this.opacityPeak,
    this.customMask,
    this.customIntensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    final totalWidth = (columns * dotSize) + ((columns - 1) * spacing);
    final totalHeight = (rows * dotSize) + ((rows - 1) * spacing);
    final offset = Offset((size.width - totalWidth) / 2, (size.height - totalHeight) / 2);

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < columns; c++) {
        if (!_isInMask(r, c)) continue;

        final x = offset.dx + c * (dotSize + spacing) + dotSize / 2;
        final y = offset.dy + r * (dotSize + spacing) + dotSize / 2;

        double intensity = (pattern == MatrixPattern.custom && customIntensity != null)
            ? customIntensity!(r, c, progress)
            : _calculateIntensity(r, c);
        
        if (isHovered) {
          final dist = math.sqrt(math.pow(r - rows/2, 2) + math.pow(c - columns/2, 2));
          intensity = math.max(intensity, math.sin((dist * 0.8) - progress * math.pi * 2).clamp(0.0, 1.0));
        }

        double remapped = _remapOpacity(intensity.clamp(0.0, 1.0));
        paint.color = Color.lerp(inactiveColor.withValues(alpha: opacityBase), activeColor, remapped)!;
        
        canvas.drawCircle(Offset(x, y), dotSize / 2, paint);
      }
    }
  }

  double _remapOpacity(double val) {
    if (val <= 0.08) return (val / 0.08) * opacityBase;
    if (val <= 0.34) return opacityBase + ((val - 0.08) / (0.34 - 0.08)) * (opacityMid - opacityBase);
    return opacityMid + ((val - 0.34) / (1.0 - 0.34)) * (opacityPeak - opacityMid);
  }

  bool _isInMask(int r, int c) {
    if (customMask != null) return customMask!(r, c);
    if (shape == MatrixShape.square) return true;
    if (shape == MatrixShape.circular) {
      double dr = (r - (rows - 1) / 2.0);
      double dc = (c - (columns - 1) / 2.0);
      return math.sqrt(dr * dr + dc * dc) <= (math.min(rows, columns) / 2.0);
    }
    if (shape == MatrixShape.triangle) {
      double normR = r / (rows - 1);
      double normC = c / (columns - 1);
      return normC >= (0.5 - normR * 0.5) && normC <= (0.5 + normR * 0.5);
    }
    return true;
  }

  double _calculateIntensity(int r, int c) {
    double normR = r / (rows - 1).clamp(1, 100);
    double normC = c / (columns - 1).clamp(1, 100);
    double dist = math.sqrt(math.pow(normR - 0.5, 2) + math.pow(normC - 0.5, 2)) * 2;
    double angle = math.atan2(r - (rows-1)/2, c - (columns-1)/2) + math.pi;
    double pAngle = angle / (2 * math.pi);
    double manhattan = (normR - 0.5).abs() + (normC - 0.5).abs();
    double p = progress;
    double p2 = p * math.pi * 2;

    switch (pattern) {
      // ── Square patterns ──
      case MatrixPattern.square1: return math.max(0.0, math.sin((normC - normR + 1) * math.pi - p2));
      case MatrixPattern.square2: return math.max(0.0, math.sin(normC * math.pi * 2 - p2));
      case MatrixPattern.square3: return (math.sin(dist * 4 - p2) + 1) / 2;
      case MatrixPattern.square4:
        double ring = math.max((r - (rows-1)/2).abs(), (c - (columns-1)/2).abs());
        if (ring < 1) return 0.0;
        return math.sin(pAngle * math.pi * 2 + (ring % 2 == 0 ? 1 : -1) * p2) > 0.7 ? 1.0 : 0.1;
      case MatrixPattern.square5: return math.max(0.0, math.sin(normR * math.pi * 3 + normC * math.pi - p2));
      case MatrixPattern.square6: return ((r + c) % 2 == 0) ? (math.sin(p2 - dist * 3) + 1) / 2 : 0.1;
      case MatrixPattern.square7: return math.max(0.0, math.sin(manhattan * math.pi * 4 - p2));
      case MatrixPattern.square8:
        double snake = (r % 2 == 0 ? normC : 1 - normC) + r * 0.2;
        return (math.sin(snake * math.pi * 2 - p2) + 1) / 2;
      case MatrixPattern.square9: return math.max(0.0, math.cos(normR * math.pi * 4 - p2) * math.sin(normC * math.pi * 4 - p2));
      case MatrixPattern.square10: return (math.sin((r * columns + c) * 0.5 - p * 20) + 1) / 2;
      case MatrixPattern.square11: return math.max(0.0, math.sin(pAngle * math.pi * 4 + dist * 3 - p2));
      case MatrixPattern.square12:
        double diag = (r - c).abs() / (rows - 1).clamp(1, 100).toDouble();
        return (math.sin(diag * math.pi * 3 - p2) + 1) / 2;
      case MatrixPattern.square13: return math.max(0.0, math.sin(normR * math.pi * 2 - p2)) * math.max(0.0, math.sin(normC * math.pi * 2 - p2));
      case MatrixPattern.square14:
        double spiral = pAngle + dist * 2;
        return (math.sin(spiral * math.pi * 2 - p2) + 1) / 2;
      case MatrixPattern.square15: return (math.sin(normR * math.pi * 6 - p2) + math.sin(normC * math.pi * 6 - p2 * 1.3) + 2) / 4;
      case MatrixPattern.square16: return math.max(0.0, math.sin((normR + normC) * math.pi * 2 - p2 * 1.5));
      case MatrixPattern.square17:
        double wave = math.sin(normC * math.pi * 3 - p2) * 0.3;
        return (normR - 0.5 + wave).abs() < 0.15 ? 1.0 : 0.08;
      case MatrixPattern.square18: return ((c + (p * columns * 2).toInt()) % columns == r % columns) ? 1.0 : 0.08;
      case MatrixPattern.square19: return (math.sin(dist * math.pi * 6 - p2 * 2) + 1) / 2;
      case MatrixPattern.square20: return math.max(0.0, math.sin(pAngle * math.pi * 6 - p2));

      // ── Circular patterns ──
      case MatrixPattern.circular1: return math.max(0.0, math.sin(pAngle * math.pi * 2 - p2));
      case MatrixPattern.circular2: return (math.sin(dist * math.pi * 3 - p2) + 1) / 2;
      case MatrixPattern.circular3: return math.max(0.0, math.sin(angle * 2 - p2 + dist * 3));
      case MatrixPattern.circular4: return math.max(0.0, math.sin(dist * math.pi * 2 - p * math.pi * 4));
      case MatrixPattern.circular5:
        double spiral2 = pAngle * 2 + dist * 3;
        return (math.sin(spiral2 * math.pi - p2) + 1) / 2;
      case MatrixPattern.circular6: return math.max(0.0, math.sin(angle * 3 - p2));
      case MatrixPattern.circular7: return (math.sin(pAngle * math.pi * 6 + dist * 2 - p2) + 1) / 2;
      case MatrixPattern.circular8: return math.max(0.0, math.cos(dist * math.pi * 4 - p2));
      case MatrixPattern.circular9: return (math.sin(angle + dist * 5 - p2 * 2) + 1) / 2;
      case MatrixPattern.circular10: return math.max(0.0, math.sin(pAngle * math.pi * 8 - p2));
      case MatrixPattern.circular11:
        double radialWave = math.sin(dist * math.pi * 3 - p2) * math.cos(angle * 2 - p2);
        return (radialWave + 1) / 2;
      case MatrixPattern.circular12: return math.max(0.0, math.sin(dist * 6 - p2 * 1.5 + angle));
      case MatrixPattern.circular13: return (math.sin(angle * 4 - p2) + math.sin(dist * 4 - p2 * 1.5) + 2) / 4;
      case MatrixPattern.circular14:
        double ripple = math.sin(dist * math.pi * 5 - p2 * 2);
        return ripple > 0.3 ? 1.0 : 0.08;
      case MatrixPattern.circular15: return (math.sin(pAngle * math.pi * 4 - p2 + dist * 2) + 1) / 2;
      case MatrixPattern.circular16: return math.max(0.0, math.sin(angle * 5 + dist * 2 - p2 * 1.5));
      case MatrixPattern.circular17: return math.max(0.0, math.cos(angle * 3 + p2) * math.sin(dist * 4 - p2));
      case MatrixPattern.circular18: return (math.sin(dist * 8 - p2 * 3) + 1) / 2;
      case MatrixPattern.circular19: return math.max(0.0, math.sin(pAngle * math.pi * 2 + dist * 4 - p2 * 2));
      case MatrixPattern.circular20: return (math.sin(angle * 6 - p2 * 2 + dist * 3) + 1) / 2;

      // ── Triangle patterns ──
      case MatrixPattern.triangle1: return math.max(0.0, math.sin(normR * math.pi * 2 + normC - p2));
      case MatrixPattern.triangle2: return (math.sin((normR + normC * 0.5) * math.pi * 3 - p2) + 1) / 2;
      case MatrixPattern.triangle3: return math.max(0.0, math.sin(dist * 5 + angle - p2 * 1.5));
      case MatrixPattern.triangle4: return (math.sin(normR * math.pi * 4 - p2) + 1) / 2;
      case MatrixPattern.triangle5: return math.max(0.0, math.sin(manhattan * math.pi * 3 + angle * 0.5 - p2));
      case MatrixPattern.triangle6:
        double zigzag = (c % 2 == 0 ? normR : 1 - normR);
        return (math.sin(zigzag * math.pi * 3 - p2) + 1) / 2;
      case MatrixPattern.triangle7: return math.max(0.0, math.sin(angle * 3 + normR * 3 - p2));
      case MatrixPattern.triangle8: return (math.sin(normC * math.pi * 5 - p2 + normR * 2) + 1) / 2;
      case MatrixPattern.triangle9: return math.max(0.0, math.cos(dist * 4 - p2) * math.sin(normR * 3 - p2));
      case MatrixPattern.triangle10: return (math.sin(pAngle * math.pi * 4 - p2 + normR) + 1) / 2;
      case MatrixPattern.triangle11: return math.max(0.0, math.sin((r + c * 0.7) * 1.2 - p * 10));
      case MatrixPattern.triangle12: return (math.sin(normR * math.pi * 3 + normC * math.pi * 2 - p2) + 1) / 2;
      case MatrixPattern.triangle13: return math.max(0.0, math.sin(manhattan * 5 - p2 * 1.5));
      case MatrixPattern.triangle14:
        double fan = pAngle + normR * 0.5;
        return (math.sin(fan * math.pi * 4 - p2) + 1) / 2;
      case MatrixPattern.triangle15: return math.max(0.0, math.sin(normR * math.pi * 6 + angle - p2));
      case MatrixPattern.triangle16: return (math.sin(dist * 3 + angle * 2 - p2 * 1.5) + 1) / 2;
      case MatrixPattern.triangle17: return math.max(0.0, math.sin(normC * math.pi * 4 + normR * 2 - p2 * 1.3));
      case MatrixPattern.triangle18: return (math.sin((normR * normC) * math.pi * 8 - p2) + 1) / 2;
      case MatrixPattern.triangle19: return math.max(0.0, math.sin(angle * 4 + dist * 2 - p2 * 2));
      case MatrixPattern.triangle20: return (math.sin(normR * math.pi * 2 - p2) + math.cos(normC * math.pi * 2 - p2 * 1.3) + 2) / 4;
      case MatrixPattern.custom: return (math.sin(dist * 3 - p2) + 1) / 2;
    }
  }

  @override
  bool shouldRepaint(covariant _MatrixPainter oldDelegate) => true;
}
