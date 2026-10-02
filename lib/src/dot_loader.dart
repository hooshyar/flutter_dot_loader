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
    super.key,
    super.color,
    super.dotSize,
    super.columns = 3,
    super.rows = 1,
    super.size = 64.0,
    super.width,
    double? height,
    super.pattern = MatrixPattern.diagonalWave,
    super.duration = const Duration(milliseconds: 1500),
    super.curve = Curves.linear,
    super.paused,
    super.semanticsLabel,
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
