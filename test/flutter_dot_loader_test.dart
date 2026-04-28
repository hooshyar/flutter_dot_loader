import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dot_loader/flutter_dot_loader.dart';

void main() {
  testWidgets('MatrixLoader and TriangleLoader can be instantiated', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              MatrixLoader(),
              TriangleLoader(),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(MatrixLoader), findsOneWidget);
    expect(find.byType(TriangleLoader), findsOneWidget);
  });
}
