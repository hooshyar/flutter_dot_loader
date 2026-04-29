import 'package:flutter/material.dart';
import 'matrix_loader.dart';

/// A simplified, AI-friendly version of [MatrixLoader].
/// 
/// [DotLoader] provides sensible defaults for common "thinking" or "loading"
/// indicators used in AI chat applications.
/// 
/// ## Usage
/// 
/// ```dart
/// // Modern 3-dot wave loader
/// DotLoader(color: Colors.blue)
/// ```
class DotLoader extends MatrixLoader {
  /// Creates a simplified dot-matrix loader.
  /// 
  /// - [color]: The primary color for the dots. If provided, [activeColor]
  ///   is set to this color, and [inactiveColor] is derived with 10% opacity.
  DotLoader({
    super.key,
    Color? color,
    super.dotSize,
    super.columns = 3,
    super.rows = 1,
    super.pattern = MatrixPattern.diagonalWave,
    super.size = 64.0,
    super.duration = const Duration(milliseconds: 1500),
    super.curve = Curves.linear,
  }) : super(
          activeColor: color ?? Colors.white,
          inactiveColor: (color ?? Colors.white).withValues(alpha: 0.1),
        );
}
