import 'dart:math' as math;
import 'package:flutter/material.dart';

/// The geometric shape used to mask (clip) the dot grid in a [MatrixLoader].
///
/// - [square]: All dots in the rectangular grid are rendered.
/// - [circular]: Only dots within a circle inscribed in the grid are rendered.
/// - [triangle]: Only dots within an upward-pointing triangle are rendered.
/// - [custom]: Use the [MatrixLoader.customMask] callback to control which dots are shown.
enum MatrixShape { square, circular, triangle, custom }

/// The mathematical animation pattern used to drive the [MatrixLoader].
///
/// There are 60 built-in patterns:
/// - `square1`–`square20`: Grid-based patterns using cartesian coordinates.
/// - `circular1`–`circular20`: Radially-computed patterns using polar coordinates.
/// - `triangle1`–`triangle20`: Patterns tuned for the triangle [MatrixShape].
/// - [custom]: Drive the animation entirely from your own [MatrixLoader.customIntensity] callback.
///
/// See the [MatrixLoader] documentation and the package's example app for a
/// live gallery of all 60 patterns.
enum MatrixPattern {
  // Predefined square patterns
  square1,
  square2,
  square3,
  square4,
  square5,
  square6,
  square7,
  square8,
  square9,
  square10,
  square11,
  square12,
  square13,
  square14,
  square15,
  square16,
  square17,
  square18,
  square19,
  square20,
  // Predefined circular patterns
  circular1,
  circular2,
  circular3,
  circular4,
  circular5,
  circular6,
  circular7,
  circular8,
  circular9,
  circular10,
  circular11,
  circular12,
  circular13,
  circular14,
  circular15,
  circular16,
  circular17,
  circular18,
  circular19,
  circular20,
  // Predefined triangle patterns
  triangle1,
  triangle2,
  triangle3,
  triangle4,
  triangle5,
  triangle6,
  triangle7,
  triangle8,
  triangle9,
  triangle10,
  triangle11,
  triangle12,
  triangle13,
  triangle14,
  triangle15,
  triangle16,
  triangle17,
  triangle18,
  triangle19,
  triangle20,

  /// Use this pattern together with [MatrixLoader.customIntensity] to drive
  /// the animation from your own data (e.g. frame-by-frame pixel art or sprites).
  custom,
}

/// The animation playback mode for [MatrixLoader].
enum MatrixPlayback {
  /// The animation plays from start to end, then restarts from the beginning.
  loop,

  /// The animation plays from start to end, then reverses back to the start.
  bounce,

  /// The animation plays once from start to end and stops.
  once,
}

/// A high-performance, zero-dependency dot-matrix loading animation widget.
///
/// [MatrixLoader] renders a rectangular grid of dots animated by one of 60
/// built-in mathematical patterns, or entirely by a user-supplied
/// [customIntensity] function.
///
/// ## Basic Usage
///
/// ```dart
/// const MatrixLoader(
///   columns: 5,
///   rows: 5,
///   activeColor: Colors.cyanAccent,
///   inactiveColor: Color(0xFF1A1A1E),
///   dotSize: 5.0,
///   pattern: MatrixPattern.square11, // Vortex Spin
/// )
/// ```
///
/// ## Custom Frame Animation
///
/// You can drive the dot grid from your own frame data using
/// [MatrixPattern.custom] and the [customIntensity] callback:
///
/// ```dart
/// final frames = [
///   [[1,0,1],[0,1,0],[1,0,1]], // Frame 1
///   [[0,1,0],[1,1,1],[0,1,0]], // Frame 2
/// ];
///
/// MatrixLoader(
///   columns: 3,
///   rows: 3,
///   pattern: MatrixPattern.custom,
///   duration: const Duration(milliseconds: 800),
///   customIntensity: (row, col, progress) {
///     final idx = (progress * frames.length).floor().clamp(0, frames.length - 1);
///     return frames[idx][row][col].toDouble();
///   },
/// )
/// ```
///
/// ## Performance
///
/// All rendering is done via a single [CustomPainter]. The widget uses
/// [AnimationController.repeat] internally and rebuilds only the [CustomPaint]
/// layer on each frame — it does not call `setState` on the widget tree.
///
/// See also:
/// - [MatrixPattern], which enumerates all 61 available patterns.
/// - [MatrixShape], which controls grid clipping.
/// - [TriangleLoader], a companion geometric loading animation.
class MatrixLoader extends StatefulWidget {
  /// The geometric arrangement of dots.
  ///
  /// Defaults to [MatrixShape.square] (all grid dots are rendered).
  final MatrixShape shape;

  /// The animation pattern to display.
  ///
  /// Set to [MatrixPattern.custom] and provide [customIntensity] to drive
  /// the animation from your own data.
  ///
  /// Defaults to [MatrixPattern.square1].
  final MatrixPattern pattern;

  /// Number of horizontal dots in the grid.
  ///
  /// Defaults to `5`.
  final int columns;

  /// Number of vertical dots in the grid.
  ///
  /// Defaults to `5`.
  final int rows;

  /// The color of active (fully lit) dots.
  ///
  /// Defaults to [Colors.white].
  final Color activeColor;

  /// The color of inactive (fully dimmed) dots.
  ///
  /// Defaults to `Color(0xFF27272A)`.
  final Color inactiveColor;

  /// The width and height of the widget's bounding box in logical pixels.
  ///
  /// Defaults to `64.0`.
  final double size;

  /// The diameter of each individual dot in logical pixels.
  ///
  /// Defaults to `4.0`.
  final double dotSize;

  /// The gap between adjacent dots in logical pixels.
  ///
  /// If `null` (the default), the spacing is automatically calculated so the
  /// full grid fits exactly within [size].
  final double? spacing;

  /// Duration of one complete animation cycle.
  ///
  /// The animation loops indefinitely. Defaults to `1500ms`.
  final Duration duration;

  /// The behavior of the animation loop.
  ///
  /// Defaults to [MatrixPlayback.loop].
  final MatrixPlayback playback;

  /// An optional easing curve to apply to the animation progress.
  ///
  /// Defaults to [Curves.linear].
  final Curve curve;

  /// Whether to show a ripple effect when the user hovers over the widget.
  ///
  /// Only has a visible effect on platforms that support a pointer device
  /// (web, macOS, Windows, Linux). Defaults to `true`.
  final bool hoverAnimated;

  /// The minimum opacity applied to fully dimmed dots.
  ///
  /// This is the base of the three-tier LED opacity curve.
  /// Defaults to `0.08`.
  final double opacityBase;

  /// The mid-point opacity value in the three-tier LED glow curve.
  ///
  /// Defaults to `0.34`.
  final double opacityMid;

  /// The maximum opacity applied to fully lit dots.
  ///
  /// Defaults to `0.94`.
  final double opacityPeak;

  /// An optional function to determine whether the dot at (`row`, `col`)
  /// should be rendered at all.
  ///
  /// Use this with [MatrixShape.custom] to create arbitrary shapes.
  /// Return `true` to render the dot, `false` to skip it.
  ///
  /// ```dart
  /// customMask: (row, col) => (row + col) % 2 == 0, // checkerboard
  /// ```
  final bool Function(int row, int col)? customMask;

  /// A callback to drive the light intensity of each dot from your own data.
  ///
  /// Only used when [pattern] is [MatrixPattern.custom].
  ///
  /// - `row` and `col` are the zero-based grid coordinates.
  /// - `progress` is a value from `0.0` to `1.0` representing how far through
  ///   one [duration] cycle the animation is.
  /// - Return a value from `0.0` (fully dim) to `1.0` (fully lit).
  ///
  /// ```dart
  /// customIntensity: (row, col, progress) {
  ///   final frameIndex = (progress * myFrames.length).floor();
  ///   return myFrames[frameIndex][row][col].toDouble();
  /// },
  /// ```
  final double Function(int row, int col, double progress)? customIntensity;

  /// Called when a specific dot is tapped.
  ///
  /// Provides the `row` and `col` of the tapped dot.
  final void Function(int row, int col)? onDotTapped;

  /// Creates a [MatrixLoader].
  ///
  /// All parameters are optional and have sensible defaults. At minimum,
  /// provide [activeColor] and [inactiveColor] to match your app's theme.
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
    this.playback = MatrixPlayback.loop,
    this.curve = Curves.linear,
    this.hoverAnimated = true,
    this.opacityBase = 0.08,
    this.opacityMid = 0.34,
    this.opacityPeak = 0.94,
    this.customMask,
    this.customIntensity,
    this.onDotTapped,
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
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _applyPlayback();
  }

  @override
  void didUpdateWidget(covariant MatrixLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
    if (oldWidget.playback != widget.playback) {
      _applyPlayback();
    }
  }

  void _applyPlayback() {
    _controller.stop();
    switch (widget.playback) {
      case MatrixPlayback.loop:
        _controller.repeat();
        break;
      case MatrixPlayback.bounce:
        _controller.repeat(reverse: true);
        break;
      case MatrixPlayback.once:
        _controller.forward(from: 0.0);
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(TapUpDetails details) {
    if (widget.onDotTapped == null) return;
    final spacing = widget.spacing ??
        (widget.size - widget.dotSize * widget.columns) /
            (widget.columns - 1).clamp(1, 100);

    final totalWidth =
        (widget.columns * widget.dotSize) + ((widget.columns - 1) * spacing);
    final totalHeight =
        (widget.rows * widget.dotSize) + ((widget.rows - 1) * spacing);
    final offsetX = (widget.size - totalWidth) / 2;
    final offsetY = (widget.size - totalHeight) / 2;

    final x = details.localPosition.dx - offsetX;
    final y = details.localPosition.dy - offsetY;

    if (x < 0 || y < 0 || x > totalWidth || y > totalHeight) return;

    final col = (x / (widget.dotSize + spacing)).floor();
    final row = (y / (widget.dotSize + spacing)).floor();

    if (col >= 0 && col < widget.columns && row >= 0 && row < widget.rows) {
      widget.onDotTapped!(row, col);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapUp: widget.onDotTapped != null ? _handleTap : null,
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final curvedProgress = widget.curve.transform(_controller.value);
              return CustomPaint(
                painter: _MatrixPainter(
                  progress: curvedProgress,
                  shape: widget.shape,
                  pattern: widget.pattern,
                  columns: widget.columns,
                  rows: widget.rows,
                  activeColor: widget.activeColor,
                  inactiveColor: widget.inactiveColor,
                  dotSize: widget.dotSize,
                  spacing: widget.spacing ??
                      (widget.size - widget.dotSize * widget.columns) /
                          (widget.columns - 1).clamp(1, 100),
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
    final offset = Offset(
      (size.width - totalWidth) / 2,
      (size.height - totalHeight) / 2,
    );

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < columns; c++) {
        if (!_isInMask(r, c)) continue;

        final x = offset.dx + c * (dotSize + spacing) + dotSize / 2;
        final y = offset.dy + r * (dotSize + spacing) + dotSize / 2;

        double intensity =
            (pattern == MatrixPattern.custom && customIntensity != null)
            ? customIntensity!(r, c, progress)
            : _calculateIntensity(r, c);

        if (isHovered) {
          final dist = math.sqrt(
            math.pow(r - rows / 2, 2) + math.pow(c - columns / 2, 2),
          );
          intensity = math.max(
            intensity,
            math.sin((dist * 0.8) - progress * math.pi * 2).clamp(0.0, 1.0),
          );
        }

        double remapped = _remapOpacity(intensity.clamp(0.0, 1.0));
        paint.color = Color.lerp(
          inactiveColor.withValues(alpha: opacityBase),
          activeColor,
          remapped,
        )!;

        canvas.drawCircle(Offset(x, y), dotSize / 2, paint);
      }
    }
  }

  double _remapOpacity(double val) {
    if (val <= 0.08) return (val / 0.08) * opacityBase;
    if (val <= 0.34) {
      return opacityBase +
          ((val - 0.08) / (0.34 - 0.08)) * (opacityMid - opacityBase);
    }
    return opacityMid +
        ((val - 0.34) / (1.0 - 0.34)) * (opacityPeak - opacityMid);
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
    double dist =
        math.sqrt(math.pow(normR - 0.5, 2) + math.pow(normC - 0.5, 2)) * 2;
    double angle =
        math.atan2(r - (rows - 1) / 2, c - (columns - 1) / 2) + math.pi;
    double pAngle = angle / (2 * math.pi);
    double manhattan = (normR - 0.5).abs() + (normC - 0.5).abs();
    double p = progress;
    double p2 = p * math.pi * 2;

    switch (pattern) {
      // ── Square patterns ──
      case MatrixPattern.square1:
        return math.max(0.0, math.sin((normC - normR + 1) * math.pi - p2));
      case MatrixPattern.square2:
        return math.max(0.0, math.sin(normC * math.pi * 2 - p2));
      case MatrixPattern.square3:
        return (math.sin(dist * 4 - p2) + 1) / 2;
      case MatrixPattern.square4:
        double ring = math.max(
          (r - (rows - 1) / 2).abs(),
          (c - (columns - 1) / 2).abs(),
        );
        if (ring < 1) return 0.0;
        return math.sin(pAngle * math.pi * 2 + (ring % 2 == 0 ? 1 : -1) * p2) >
                0.7
            ? 1.0
            : 0.1;
      case MatrixPattern.square5:
        return math.max(
          0.0,
          math.sin(normR * math.pi * 3 + normC * math.pi - p2),
        );
      case MatrixPattern.square6:
        return ((r + c) % 2 == 0) ? (math.sin(p2 - dist * 3) + 1) / 2 : 0.1;
      case MatrixPattern.square7:
        return math.max(0.0, math.sin(manhattan * math.pi * 4 - p2));
      case MatrixPattern.square8:
        double snake = (r % 2 == 0 ? normC : 1 - normC) + r * 0.2;
        return (math.sin(snake * math.pi * 2 - p2) + 1) / 2;
      case MatrixPattern.square9:
        return math.max(
          0.0,
          math.cos(normR * math.pi * 4 - p2) *
              math.sin(normC * math.pi * 4 - p2),
        );
      case MatrixPattern.square10:
        return (math.sin((r * columns + c) * 0.5 - p * 20) + 1) / 2;
      case MatrixPattern.square11:
        return math.max(0.0, math.sin(pAngle * math.pi * 4 + dist * 3 - p2));
      case MatrixPattern.square12:
        double diag = (r - c).abs() / (rows - 1).clamp(1, 100).toDouble();
        return (math.sin(diag * math.pi * 3 - p2) + 1) / 2;
      case MatrixPattern.square13:
        return math.max(0.0, math.sin(normR * math.pi * 2 - p2)) *
            math.max(0.0, math.sin(normC * math.pi * 2 - p2));
      case MatrixPattern.square14:
        double spiral = pAngle + dist * 2;
        return (math.sin(spiral * math.pi * 2 - p2) + 1) / 2;
      case MatrixPattern.square15:
        return (math.sin(normR * math.pi * 6 - p2) +
                math.sin(normC * math.pi * 6 - p2 * 1.3) +
                2) /
            4;
      case MatrixPattern.square16:
        return math.max(
          0.0,
          math.sin((normR + normC) * math.pi * 2 - p2 * 1.5),
        );
      case MatrixPattern.square17:
        double wave = math.sin(normC * math.pi * 3 - p2) * 0.3;
        return (normR - 0.5 + wave).abs() < 0.15 ? 1.0 : 0.08;
      case MatrixPattern.square18:
        return ((c + (p * columns * 2).toInt()) % columns == r % columns)
            ? 1.0
            : 0.08;
      case MatrixPattern.square19:
        return (math.sin(dist * math.pi * 6 - p2 * 2) + 1) / 2;
      case MatrixPattern.square20:
        return math.max(0.0, math.sin(pAngle * math.pi * 6 - p2));

      // ── Circular patterns ──
      case MatrixPattern.circular1:
        return math.max(0.0, math.sin(pAngle * math.pi * 2 - p2));
      case MatrixPattern.circular2:
        return (math.sin(dist * math.pi * 3 - p2) + 1) / 2;
      case MatrixPattern.circular3:
        return math.max(0.0, math.sin(angle * 2 - p2 + dist * 3));
      case MatrixPattern.circular4:
        return math.max(0.0, math.sin(dist * math.pi * 2 - p * math.pi * 4));
      case MatrixPattern.circular5:
        double spiral2 = pAngle * 2 + dist * 3;
        return (math.sin(spiral2 * math.pi - p2) + 1) / 2;
      case MatrixPattern.circular6:
        return math.max(0.0, math.sin(angle * 3 - p2));
      case MatrixPattern.circular7:
        return (math.sin(pAngle * math.pi * 6 + dist * 2 - p2) + 1) / 2;
      case MatrixPattern.circular8:
        return math.max(0.0, math.cos(dist * math.pi * 4 - p2));
      case MatrixPattern.circular9:
        return (math.sin(angle + dist * 5 - p2 * 2) + 1) / 2;
      case MatrixPattern.circular10:
        return math.max(0.0, math.sin(pAngle * math.pi * 8 - p2));
      case MatrixPattern.circular11:
        double radialWave =
            math.sin(dist * math.pi * 3 - p2) * math.cos(angle * 2 - p2);
        return (radialWave + 1) / 2;
      case MatrixPattern.circular12:
        return math.max(0.0, math.sin(dist * 6 - p2 * 1.5 + angle));
      case MatrixPattern.circular13:
        return (math.sin(angle * 4 - p2) + math.sin(dist * 4 - p2 * 1.5) + 2) /
            4;
      case MatrixPattern.circular14:
        double ripple = math.sin(dist * math.pi * 5 - p2 * 2);
        return ripple > 0.3 ? 1.0 : 0.08;
      case MatrixPattern.circular15:
        return (math.sin(pAngle * math.pi * 4 - p2 + dist * 2) + 1) / 2;
      case MatrixPattern.circular16:
        return math.max(0.0, math.sin(angle * 5 + dist * 2 - p2 * 1.5));
      case MatrixPattern.circular17:
        return math.max(
          0.0,
          math.cos(angle * 3 + p2) * math.sin(dist * 4 - p2),
        );
      case MatrixPattern.circular18:
        return (math.sin(dist * 8 - p2 * 3) + 1) / 2;
      case MatrixPattern.circular19:
        return math.max(
          0.0,
          math.sin(pAngle * math.pi * 2 + dist * 4 - p2 * 2),
        );
      case MatrixPattern.circular20:
        return (math.sin(angle * 6 - p2 * 2 + dist * 3) + 1) / 2;

      // ── Triangle patterns ──
      case MatrixPattern.triangle1:
        return math.max(0.0, math.sin(normR * math.pi * 2 + normC - p2));
      case MatrixPattern.triangle2:
        return (math.sin((normR + normC * 0.5) * math.pi * 3 - p2) + 1) / 2;
      case MatrixPattern.triangle3:
        return math.max(0.0, math.sin(dist * 5 + angle - p2 * 1.5));
      case MatrixPattern.triangle4:
        return (math.sin(normR * math.pi * 4 - p2) + 1) / 2;
      case MatrixPattern.triangle5:
        return math.max(
          0.0,
          math.sin(manhattan * math.pi * 3 + angle * 0.5 - p2),
        );
      case MatrixPattern.triangle6:
        double zigzag = (c % 2 == 0 ? normR : 1 - normR);
        return (math.sin(zigzag * math.pi * 3 - p2) + 1) / 2;
      case MatrixPattern.triangle7:
        return math.max(0.0, math.sin(angle * 3 + normR * 3 - p2));
      case MatrixPattern.triangle8:
        return (math.sin(normC * math.pi * 5 - p2 + normR * 2) + 1) / 2;
      case MatrixPattern.triangle9:
        return math.max(
          0.0,
          math.cos(dist * 4 - p2) * math.sin(normR * 3 - p2),
        );
      case MatrixPattern.triangle10:
        return (math.sin(pAngle * math.pi * 4 - p2 + normR) + 1) / 2;
      case MatrixPattern.triangle11:
        return math.max(0.0, math.sin((r + c * 0.7) * 1.2 - p * 10));
      case MatrixPattern.triangle12:
        return (math.sin(normR * math.pi * 3 + normC * math.pi * 2 - p2) + 1) /
            2;
      case MatrixPattern.triangle13:
        return math.max(0.0, math.sin(manhattan * 5 - p2 * 1.5));
      case MatrixPattern.triangle14:
        double fan = pAngle + normR * 0.5;
        return (math.sin(fan * math.pi * 4 - p2) + 1) / 2;
      case MatrixPattern.triangle15:
        return math.max(0.0, math.sin(normR * math.pi * 6 + angle - p2));
      case MatrixPattern.triangle16:
        return (math.sin(dist * 3 + angle * 2 - p2 * 1.5) + 1) / 2;
      case MatrixPattern.triangle17:
        return math.max(
          0.0,
          math.sin(normC * math.pi * 4 + normR * 2 - p2 * 1.3),
        );
      case MatrixPattern.triangle18:
        return (math.sin((normR * normC) * math.pi * 8 - p2) + 1) / 2;
      case MatrixPattern.triangle19:
        return math.max(0.0, math.sin(angle * 4 + dist * 2 - p2 * 2));
      case MatrixPattern.triangle20:
        return (math.sin(normR * math.pi * 2 - p2) +
                math.cos(normC * math.pi * 2 - p2 * 1.3) +
                2) /
            4;
      case MatrixPattern.custom:
        return (math.sin(dist * 3 - p2) + 1) / 2;
    }
  }

  @override
  bool shouldRepaint(covariant _MatrixPainter oldDelegate) => true;
}
