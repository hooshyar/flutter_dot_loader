import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dot_loader/flutter_dot_loader.dart';
import 'package:flutter_test/flutter_test.dart';

import '../tool/font_preview.dart' show renderFontPreviewMarkdown;

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
      'has 77 values (20 square + 20 circular + 20 triangle + 16 aliases + 1 custom)',
      () {
        expect(MatrixPattern.values.length, 77);
      },
    );

    test('semantic aliases resolve to working patterns', () {
      // Sanity-check a handful of aliases that the README advertises.
      expect(MatrixPattern.values, contains(MatrixPattern.vortexSpin));
      expect(MatrixPattern.values, contains(MatrixPattern.bullsEye));
      expect(MatrixPattern.values, contains(MatrixPattern.diagonalWave));
      // Tick 7 additions.
      expect(MatrixPattern.values, contains(MatrixPattern.sonarPing));
      expect(MatrixPattern.values, contains(MatrixPattern.pinwheel));
      expect(MatrixPattern.values, contains(MatrixPattern.columnWave));
    });

    testWidgets('new aliases render without throwing', (tester) async {
      for (final p in const [
        MatrixPattern.sonarPing,
        MatrixPattern.pinwheel,
        MatrixPattern.columnWave,
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(child: MatrixLoader(pattern: p)),
            ),
          ),
        );
        expect(find.byType(MatrixLoader), findsOneWidget);
      }
    });
  });

  group('DotLoader', () {
    testWidgets('renders with default parameters', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: DotLoader())),
        ),
      );
      expect(find.byType(DotLoader), findsOneWidget);
      expect(find.bySubtype<MatrixLoader>(), findsOneWidget);
    });

    testWidgets('accepts a single color and stays const-constructable', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: DotLoader(color: Colors.blue)),
          ),
        ),
      );
      expect(find.byType(DotLoader), findsOneWidget);
    });
  });

  group('MatrixShape', () {
    test('has 4 values', () {
      expect(MatrixShape.values.length, 4);
    });
  });

  group('MatrixText', () {
    test(
      'supportedCharacters covers letters, digits, and common punctuation',
      () {
        final set = MatrixText.supportedCharacters;
        // Letters and digits
        for (final c in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'.split('')) {
          expect(set, contains(c), reason: 'missing glyph for $c');
        }
        // Common UI punctuation that real apps need
        for (final c in [
          ' ',
          '.',
          ',',
          '!',
          '?',
          ':',
          ';',
          '-',
          '_',
          '+',
          '=',
          '/',
          '\\',
          '*',
          '#',
          '@',
          r'$',
          '%',
          '&',
          '|',
          '^',
          '~',
          '`',
          "'",
          '"',
          '(',
          ')',
          '[',
          ']',
          '{',
          '}',
          '<',
          '>',
        ]) {
          expect(
            set,
            contains(c),
            reason: 'missing glyph for "$c" — needed for real UI text',
          );
        }
      },
    );

    test('each glyph is exactly 7 rows of 5 columns', () {
      for (final c in MatrixText.supportedCharacters) {
        final glyph = MatrixText.getChar(c);
        expect(glyph.length, 7, reason: 'glyph "$c" must have 7 rows');
        for (var r = 0; r < 7; r++) {
          expect(
            glyph[r].length,
            5,
            reason: 'row $r of glyph "$c" must be 5 columns wide',
          );
          expect(
            RegExp(r'^[01]+$').hasMatch(glyph[r]),
            isTrue,
            reason: 'glyph "$c" row $r must be 0s and 1s only',
          );
        }
      }
    });

    test('encode("Hi: 42%") produces a non-empty 7-row grid', () {
      final grid = MatrixText.encode('Hi: 42%');
      expect(grid.length, 7);
      expect(grid[0].length, greaterThan(0));
      // 7 chars × 5 cols + 6 inter-char gaps = 41 cols
      expect(grid[0].length, 41);
    });

    test('lowercase input is upper-cased before lookup', () {
      expect(MatrixText.getChar('a'), MatrixText.getChar('A'));
      expect(MatrixText.getChar('z'), MatrixText.getChar('Z'));
    });

    test('unsupported character falls back to space (blank 5×7)', () {
      // U+2603 SNOWMAN — definitely not in the font.
      final glyph = MatrixText.getChar('☃');
      expect(glyph, MatrixText.getChar(' '));
      expect(glyph.every((row) => row == '00000'), isTrue);
    });

    test('scrolling callback returns a function and handles empty text', () {
      final cb = MatrixText.scrolling('');
      expect(cb(0, 0, 0.0), 0.0);
    });

    test(
      'font preview artifact (doc/font_preview.md) is in sync with the source',
      () {
        final expected = renderFontPreviewMarkdown();
        final file = File('doc/font_preview.md');
        expect(
          file.existsSync(),
          isTrue,
          reason:
              'doc/font_preview.md is missing. Run: dart run tool/generate_font_preview.dart',
        );
        final actual = file.readAsStringSync();
        if (actual != expected) {
          fail(
            'doc/font_preview.md has drifted from MatrixText. Regenerate '
            'by running: dart run tool/generate_font_preview.dart',
          );
        }
      },
    );
  });

  group('onComplete callback', () {
    testWidgets('fires once when MatrixPlayback.once finishes', (tester) async {
      var fireCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MatrixLoader(
                playback: MatrixPlayback.once,
                duration: const Duration(milliseconds: 100),
                onComplete: () => fireCount++,
              ),
            ),
          ),
        ),
      );
      expect(fireCount, 0);
      // Pump well past the animation duration to let the completion future
      // settle on the event loop.
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 80));
      await tester.pumpAndSettle();
      expect(fireCount, 1);
    });

    testWidgets('does NOT fire for MatrixPlayback.loop', (tester) async {
      var fireCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MatrixLoader(
                playback: MatrixPlayback.loop,
                duration: const Duration(milliseconds: 50),
                onComplete: () => fireCount++,
              ),
            ),
          ),
        ),
      );
      // Drive several frames forward; loop must NOT trigger completion.
      await tester.pump(const Duration(milliseconds: 60));
      await tester.pump(const Duration(milliseconds: 60));
      await tester.pump(const Duration(milliseconds: 60));
      expect(fireCount, 0);
    });

    testWidgets('does NOT fire for MatrixPlayback.bounce', (tester) async {
      var fireCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MatrixLoader(
                playback: MatrixPlayback.bounce,
                duration: const Duration(milliseconds: 50),
                onComplete: () => fireCount++,
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 60));
      await tester.pump(const Duration(milliseconds: 60));
      await tester.pump(const Duration(milliseconds: 60));
      expect(fireCount, 0);
    });

    testWidgets('safe to dispose mid-flight without firing', (tester) async {
      var fireCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MatrixLoader(
                playback: MatrixPlayback.once,
                duration: const Duration(milliseconds: 200),
                onComplete: () => fireCount++,
              ),
            ),
          ),
        ),
      );
      // Replace the widget tree before the animation completes.
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
      // Let any pending TickerFuture drain.
      await tester.pump(const Duration(milliseconds: 300));
      expect(fireCount, 0);
    });
  });

  group('MatrixData JSON helpers', () {
    final sampleGrid = [
      [1, 0, 1],
      [0, 1, 0],
      [1, 0, 1],
    ];
    final sampleFrames = [
      sampleGrid,
      [
        [0, 0, 0],
        [1, 1, 1],
        [0, 0, 0],
      ],
    ];

    test('toJson produces rows/cols/data and round-trips through fromJson', () {
      final json = MatrixData.toJson(sampleGrid);
      expect(json['rows'], 3);
      expect(json['cols'], 3);
      expect(json['data'], '101|010|101');
      expect(MatrixData.fromJson(json), sampleGrid);
    });

    test('toJson handles an empty grid', () {
      final json = MatrixData.toJson(<List<int>>[]);
      expect(json['rows'], 0);
      expect(json['cols'], 0);
      expect(json['data'], '');
    });

    test(
      'fromJson throws ArgumentError when "data" is missing or wrong type',
      () {
        expect(
          () => MatrixData.fromJson(<String, dynamic>{}),
          throwsArgumentError,
        );
        expect(
          () => MatrixData.fromJson(<String, dynamic>{'data': 42}),
          throwsArgumentError,
        );
      },
    );

    test('framesToJson includes schema version and round-trips', () {
      final json = MatrixData.framesToJson(sampleFrames);
      expect(json['version'], MatrixData.jsonSchemaVersion);
      expect(json['rows'], 3);
      expect(json['cols'], 3);
      expect(json['frames'], isA<List<String>>());
      expect(json['frames'], ['101|010|101', '000|111|000']);
      expect(MatrixData.framesFromJson(json), sampleFrames);
    });

    test('framesFromJson accepts legacy comma-joined string in "frames"', () {
      final legacy = <String, dynamic>{
        'version': 1,
        'rows': 3,
        'cols': 3,
        'frames': '101|010|101,000|111|000',
      };
      expect(MatrixData.framesFromJson(legacy), sampleFrames);
    });

    test('framesFromJson throws ArgumentError on missing/bad "frames"', () {
      expect(
        () => MatrixData.framesFromJson(<String, dynamic>{}),
        throwsArgumentError,
      );
      expect(
        () => MatrixData.framesFromJson(<String, dynamic>{
          'frames': [123, 456],
        }),
        throwsArgumentError,
      );
    });

    test('json output is dart:convert-encodable end-to-end', () {
      final mapOut = MatrixData.framesToJson(sampleFrames);
      final encoded = jsonEncode(mapOut);
      final decoded = jsonDecode(encoded) as Map<String, dynamic>;
      expect(MatrixData.framesFromJson(decoded), sampleFrames);
    });
  });
}
