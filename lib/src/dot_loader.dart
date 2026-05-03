import 'package:flutter/material.dart';
import 'matrix_loader.dart';

/// A simplified, AI-friendly version of [MatrixLoader].
///
/// [DotLoader] provides sensible defaults for common "thinking" or "loading"
/// indicators used in AI chat applications: a 3×1 horizontal row of dots
/// running the [MatrixPattern.diagonalWave] pattern.
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
  const DotLoader({
    super.key,
    super.color,
    super.dotSize,
    super.columns = 3,
    super.rows = 1,
    super.pattern = MatrixPattern.diagonalWave,
    super.size = 64.0,
    super.duration = const Duration(milliseconds: 1500),
    super.curve = Curves.linear,
  });
}
