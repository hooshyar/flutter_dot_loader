/// A high-performance, zero-dependency dot-matrix loading animation library
/// for Flutter.
///
/// ## Overview
///
/// The library provides three widgets:
///
/// - [DotLoader] — a simplified, AI-friendly version of the matrix loader.
/// - [MatrixLoader] — a dot-matrix grid animatable with 60+ patterns.
/// - [TriangleLoader] — a geometric grid of equilateral triangles.
///
/// ## Getting Started
///
/// ```dart
/// import 'package:flutter_dot_loader/flutter_dot_loader.dart';
///
/// // Easiest usage (AI-friendly)
/// DotLoader(color: Colors.blue)
///
/// // Or full control with MatrixLoader
/// const MatrixLoader(
///   columns: 5,
///   rows: 5,
///   activeColor: Colors.cyanAccent,
///   pattern: MatrixPattern.vortexSpin,
/// )
/// ```
library;

export 'src/dot_loader.dart';
export 'src/matrix_data.dart';
export 'src/matrix_loader.dart';
export 'src/matrix_text.dart';
export 'src/triangle_loader.dart';
