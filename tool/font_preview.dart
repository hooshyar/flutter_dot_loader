/// Pure Dart helper that renders [MatrixText]'s 5×7 font as a Markdown
/// document. Used both by [tool/generate_font_preview.dart] (manual
/// regeneration) and by the drift test (`flutter test`) to catch
/// glyph-vs-artifact skew.
///
/// Lives outside `lib/` so it never ends up in the published package.
library;

import 'package:flutter_dot_loader/src/matrix_text.dart';

/// Returns the canonical Markdown rendering of every supported glyph in the
/// font, grouped by category, with `●`/`·` ASCII art.
String renderFontPreviewMarkdown() {
  final all = MatrixText.supportedCharacters.toList()..sort();

  // Hand-tuned category split — keeps the artifact human-scannable instead
  // of dumping everything in code-point order.
  final letters = all.where((c) => RegExp(r'^[A-Z]$').hasMatch(c)).toList();
  final digits = all.where((c) => RegExp(r'^[0-9]$').hasMatch(c)).toList();
  final whitespace = all.where((c) => c == ' ').toList();
  final brackets = all.where(_inBrackets).toList();
  final punctuation = all
      .where(
        (c) =>
            !letters.contains(c) &&
            !digits.contains(c) &&
            !whitespace.contains(c) &&
            !brackets.contains(c),
      )
      .toList();

  final buf = StringBuffer();
  buf.writeln('# `MatrixText` font preview');
  buf.writeln();
  buf.writeln('> Auto-generated. **Do not edit by hand.** Re-generate with');
  buf.writeln(
    '> `dart run tool/generate_font_preview.dart` (from the repo root)',
  );
  buf.writeln('> whenever you add or change a glyph in');
  buf.writeln(
    '> `lib/src/matrix_text.dart`. The `MatrixText font preview is in',
  );
  buf.writeln("> sync with the source` test will fail until you do.");
  buf.writeln();
  buf.writeln('Each glyph is the 5×7 dot grid as ASCII art —');
  buf.writeln('`●` is a lit pixel, `·` is dim. Total glyphs: ${all.length}.');
  buf.writeln();

  _writeSection(buf, 'Letters (A–Z)', letters);
  _writeSection(buf, 'Digits (0–9)', digits);
  _writeSection(buf, 'Whitespace', whitespace);
  _writeSection(buf, 'Punctuation & symbols', punctuation);
  _writeSection(buf, 'Brackets', brackets);

  return buf.toString();
}

bool _inBrackets(String c) =>
    const {'(', ')', '[', ']', '{', '}', '<', '>'}.contains(c);

void _writeSection(StringBuffer buf, String title, List<String> chars) {
  if (chars.isEmpty) return;
  buf.writeln('## $title');
  buf.writeln();
  for (final c in chars) {
    final label = c == ' ' ? 'SPACE' : '`$c`';
    buf.writeln('### $label');
    buf.writeln();
    buf.writeln('```');
    for (final row in MatrixText.getChar(c)) {
      buf.writeln(row.replaceAll('1', '●').replaceAll('0', '·'));
    }
    buf.writeln('```');
    buf.writeln();
  }
}
