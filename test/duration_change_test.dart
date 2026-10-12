import 'package:flutter/material.dart';
import 'package:flutter_dot_loader/flutter_dot_loader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('duration change applies to a running loop', (tester) async {
    var progress = 0.0;
    double record(int row, int col, double p) => progress = p;

    Future<void> pumpLoader(Duration duration) {
      return tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: MatrixLoader(
              columns: 1,
              rows: 1,
              pattern: MatrixPattern.custom,
              duration: duration,
              hoverAnimated: false,
              customIntensity: record,
            ),
          ),
        ),
      );
    }

    await pumpLoader(const Duration(seconds: 10));
    await tester.pump(const Duration(seconds: 1));
    await pumpLoader(const Duration(seconds: 2));
    final before = progress;
    await tester.pump(const Duration(milliseconds: 500));

    // At the new 2s period, 500ms moves the loop on by ~0.25. Before the fix
    // the running loop kept its 10s period and moved only ~0.05.
    expect(progress - before, greaterThan(0.15));
  });
}
