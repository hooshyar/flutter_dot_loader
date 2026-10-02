import 'package:flutter/material.dart';

import 'matrix_loader.dart';

/// A simplified, AI-friendly version of [MatrixLoader].
///
/// [DotLoader] provides sensible defaults for common "thinking" or "loading"
/// indicators used in AI chat applications: a 3x1 horizontal row of dots
/// running the [MatrixPattern.diagonalWave] pattern.
///
/// Unlike [MatrixLoader], the bounding box does not default to a square:
/// when `height` is not given, the box height is derived from `rows` and
/// `dotSize`, so the default 3x1 indicator takes a text-height-friendly box
/// instead of a tall square. Pass `height` to override.
///
/// ## Usage
///
/// ```dart
/// // Modern 3-dot wave loader (single color is all you need)
/// const DotLoader(color: Colors.blue)
///
/// // Or fall back to MatrixLoader for full control
/// const MatrixLoader(
///   columns: 5,
///   rows: 5,
///   pattern: MatrixPattern.vortexSpin,
///   activeColor: Colors.cyanAccent,
/// )
/// ```
///
/// ## AI-state presets
///
/// Named constructors give the common chat states a recognisable look without
/// choosing a pattern by hand:
///
/// - [DotLoader.typing]: the classic 3-dot wave, a touch quicker than the
///   default.
/// - [DotLoader.thinking]: a slower, calmer ribbon across 3 dots.
/// - [DotLoader.searching]: a 5-dot scanner sweeping across the row.
/// - [DotLoader.generating]: a quick 5-dot wave for "writing the answer".
///
/// ```dart
/// const DotLoader.thinking(color: Colors.blue)
/// ```
///
/// See also:
/// - [MatrixLoader], the underlying widget with all 60+ patterns and full
///   shape/playback control.
class DotLoader extends MatrixLoader {
  /// Creates a simplified dot-matrix loader.
  ///
  /// [color] (optional) sets both the active dot color and a derived 10%-alpha
  /// inactive color. Leave it `null` to inherit [MatrixLoader]'s defaults
  /// (white on dark gray).
  ///
  /// `width` defaults to `size` (64). When `height` is omitted it is derived
  /// from `rows`, `dotSize`, and the auto horizontal spacing, so a single-row
  /// loader stays inline instead of reserving a square box.
  const DotLoader({
    Key? key,
    Color? color,
    double dotSize = 4.0,
    int columns = 3,
    int rows = 1,
    double size = 64.0,
    double? width,
    double? height,
    MatrixPattern pattern = MatrixPattern.diagonalWave,
    Duration duration = const Duration(milliseconds: 1500),
    Curve curve = Curves.linear,
    bool paused = false,
    String? semanticsLabel,
    bool respectReducedMotion = true,
    double Function(int row, int col)? customDotSize,
  }) : this._(
         key: key,
         color: color,
         dotSize: dotSize,
         columns: columns,
         rows: rows,
         size: size,
         width: width,
         height: height,
         pattern: pattern,
         duration: duration,
         curve: curve,
         paused: paused,
         semanticsLabel: semanticsLabel,
         respectReducedMotion: respectReducedMotion,
         customDotSize: customDotSize,
       );

  /// The classic 3-dot typing wave, a touch quicker than the default
  /// [DotLoader] and announced as "Typing" to screen readers.
  const DotLoader.typing({
    Key? key,
    Color? color,
    double dotSize = 4.0,
    double size = 64.0,
    double? width,
    double? height,
    bool paused = false,
    String? semanticsLabel = 'Typing',
    bool respectReducedMotion = true,
  }) : this._(
         key: key,
         color: color,
         dotSize: dotSize,
         columns: 3,
         rows: 1,
         size: size,
         width: width,
         height: height,
         pattern: MatrixPattern.diagonalWave,
         duration: const Duration(milliseconds: 1200),
         curve: Curves.linear,
         paused: paused,
         semanticsLabel: semanticsLabel,
         respectReducedMotion: respectReducedMotion,
       );

  /// A slower, calmer ribbon across 3 dots, for "the model is thinking".
  const DotLoader.thinking({
    Key? key,
    Color? color,
    double dotSize = 4.0,
    double size = 64.0,
    double? width,
    double? height,
    bool paused = false,
    String? semanticsLabel = 'Thinking',
    bool respectReducedMotion = true,
  }) : this._(
         key: key,
         color: color,
         dotSize: dotSize,
         columns: 3,
         rows: 1,
         size: size,
         width: width,
         height: height,
         pattern: MatrixPattern.sineRibbon,
         duration: const Duration(milliseconds: 2000),
         curve: Curves.linear,
         paused: paused,
         semanticsLabel: semanticsLabel,
         respectReducedMotion: respectReducedMotion,
       );

  /// A 5-dot scanner sweeping across the row, for "searching or retrieving".
  const DotLoader.searching({
    Key? key,
    Color? color,
    double dotSize = 4.0,
    double size = 64.0,
    double? width,
    double? height,
    bool paused = false,
    String? semanticsLabel = 'Searching',
    bool respectReducedMotion = true,
  }) : this._(
         key: key,
         color: color,
         dotSize: dotSize,
         columns: 5,
         rows: 1,
         size: size,
         width: width,
         height: height,
         pattern: MatrixPattern.columnWave,
         duration: const Duration(milliseconds: 1400),
         curve: Curves.linear,
         paused: paused,
         semanticsLabel: semanticsLabel,
         respectReducedMotion: respectReducedMotion,
       );

  /// A quick 5-dot wave, for "generating the answer".
  const DotLoader.generating({
    Key? key,
    Color? color,
    double dotSize = 4.0,
    double size = 64.0,
    double? width,
    double? height,
    bool paused = false,
    String? semanticsLabel = 'Generating',
    bool respectReducedMotion = true,
  }) : this._(
         key: key,
         color: color,
         dotSize: dotSize,
         columns: 5,
         rows: 1,
         size: size,
         width: width,
         height: height,
         pattern: MatrixPattern.diagonalWave,
         duration: const Duration(milliseconds: 900),
         curve: Curves.linear,
         paused: paused,
         semanticsLabel: semanticsLabel,
         respectReducedMotion: respectReducedMotion,
       );

  const DotLoader._({
    super.key,
    super.color,
    required super.dotSize,
    required super.columns,
    required super.rows,
    required super.size,
    super.width,
    double? height,
    required super.pattern,
    required super.duration,
    required super.curve,
    required super.paused,
    super.semanticsLabel,
    required super.respectReducedMotion,
    super.customDotSize,
  }) : super(
         // Derive the box height from the grid so no vertical space is
         // wasted: rows of dots separated by the same gap the horizontal
         // axis would auto-compute. Must stay a const expression.
         height:
             height ??
             ((rows * dotSize) +
                 ((rows - 1) *
                     (columns > 1
                         ? ((width ?? size) - (dotSize * columns)) /
                               (columns - 1)
                         : 0.0))),
       );
}
