/// A high-performance, zero-dependency dot-matrix loading animation library
/// for Flutter.
///
/// ## Overview
///
/// The library provides two widgets:
///
/// - [MatrixLoader] — a dot-matrix grid animatable with 60 built-in
///   mathematical patterns or your own frame-by-frame data.
/// - [TriangleLoader] — a geometric grid of equilateral triangles animated
///   by a radial wave.
///
/// ## Getting Started
///
/// ```dart
/// import 'package:flutter_dot_loader/flutter_dot_loader.dart';
///
/// // Drop-in loader with a built-in pattern
/// const MatrixLoader(
///   columns: 5,
///   rows: 5,
///   activeColor: Colors.cyanAccent,
///   pattern: MatrixPattern.square11,
/// )
///
/// // Or use a custom frame animation
/// MatrixLoader(
///   columns: 3,
///   rows: 3,
///   pattern: MatrixPattern.custom,
///   customIntensity: (row, col, progress) {
///     // Return 0.0 (dim) or 1.0 (lit) based on your data
///     return myFrames[(progress * myFrames.length).floor()][row][col].toDouble();
///   },
/// )
/// ```
///
/// See [MatrixPattern] for all available built-in patterns, [MatrixShape] for
/// grid clipping options, and [TriangleLoader] for the geometric alternative.
library;


export 'src/matrix_loader.dart';
export 'src/triangle_loader.dart';
