import 'package:flutter/material.dart';
import 'matrix_loader.dart';
import 'matrix_data.dart';

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
  /// - [dotSize]: The diameter of each dot. Defaults to 4.0.
  /// - [columns]: Number of dots horizontally. Defaults to 3.
  /// - [rows]: Number of dots vertically. Defaults to 1.
  /// - [pattern]: The animation pattern. Defaults to [MatrixPattern.square1] (Diagonal Wave).
  DotLoader({
    super.key,
    Color? color,
    double dotSize = 4.0,
    int columns = 3,
    int rows = 1,
    MatrixPattern pattern = MatrixPattern.square1,
    super.size = 64.0,
    super.duration = const Duration(milliseconds: 1500),
    super.curve = Curves.linear,
  }) : super(
          activeColor: color ?? Colors.white,
          inactiveColor: (color ?? Colors.white).withValues(alpha: 0.1),
          dotSize: dotSize,
          columns: columns,
          rows: rows,
          pattern: pattern,
        );
}
