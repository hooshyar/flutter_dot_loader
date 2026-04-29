import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dot_loader/flutter_dot_loader.dart';

void main() {
  group('MatrixLoader', () {
    testWidgets('renders with default parameters', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: MatrixLoader())),
        ),
      );
      expect(find.byType(MatrixLoader), findsOneWidget);
    });

    testWidgets('renders with circular shape', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: MatrixLoader(
                shape: MatrixShape.circular,
                pattern: MatrixPattern.circular2,
                columns: 8,
                rows: 8,
                activeColor: Colors.red,
              ),
            ),
          ),
        ),
      );
      expect(find.byType(MatrixLoader), findsOneWidget);
    });

    testWidgets('renders with triangle shape', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: MatrixLoader(
                shape: MatrixShape.triangle,
                pattern: MatrixPattern.triangle4,
              ),
            ),
          ),
        ),
      );
      expect(find.byType(MatrixLoader), findsOneWidget);
    });

    testWidgets('renders with custom intensity callback', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MatrixLoader(
                columns: 3,
                rows: 3,
                pattern: MatrixPattern.custom,
                customIntensity: (row, col, progress) {
                  return (row + col) % 2 == 0 ? 1.0 : 0.0;
                },
              ),
            ),
          ),
        ),
      );
      expect(find.byType(MatrixLoader), findsOneWidget);
    });

    testWidgets('renders with custom mask callback', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MatrixLoader(
                columns: 5,
                rows: 5,
                shape: MatrixShape.custom,
                customMask: (row, col) => (row + col) % 2 == 0,
              ),
            ),
          ),
        ),
      );
      expect(find.byType(MatrixLoader), findsOneWidget);
    });
  });

  group('TriangleLoader', () {
    testWidgets('renders with default parameters', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: TriangleLoader())),
        ),
      );
      expect(find.byType(TriangleLoader), findsOneWidget);
    });

    testWidgets('renders in wireframe mode', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: TriangleLoader(
                wireframe: true,
                color: Colors.teal,
                size: 100,
                triangleSize: 20,
              ),
            ),
          ),
        ),
      );
      expect(find.byType(TriangleLoader), findsOneWidget);
    });
  });

  group('MatrixPattern', () {
    test(
      'has 61 values (20 square + 20 circular + 20 triangle + 1 custom)',
      () {
        expect(MatrixPattern.values.length, 61);
      },
    );
  });

  group('MatrixShape', () {
    test('has 4 values', () {
      expect(MatrixShape.values.length, 4);
    });
  });
}
