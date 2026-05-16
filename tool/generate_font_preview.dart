/// CLI entry-point: regenerates `doc/font_preview.md`.
///
/// Run from the repo root:
///
/// ```sh
/// dart run tool/generate_font_preview.dart
/// ```
///
/// The actual rendering logic lives in `tool/font_preview.dart` so the same
/// code can be re-used by the drift test under `flutter test`.
library;

import 'dart:io';

import 'font_preview.dart';

void main() {
  final out = File('doc/font_preview.md');
  out.parent.createSync(recursive: true);
  out.writeAsStringSync(renderFontPreviewMarkdown());
  stdout.writeln(
    'Wrote ${out.path} '
    '(${renderFontPreviewMarkdown().split('\n').length} lines).',
  );
}
