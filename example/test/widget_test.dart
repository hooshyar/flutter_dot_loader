import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dot_loader_example/main.dart';

void main() {
  testWidgets('Gallery app loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const DotMatrixGalleryApp());
    expect(find.textContaining('DOT MATRIX'), findsWidgets);
  });
}
