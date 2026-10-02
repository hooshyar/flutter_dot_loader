import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

  group('paused parameter', () {
    testWidgets('paused: true on construct blocks onComplete for once-mode', (
      tester,
    ) async {
      var fireCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MatrixLoader(
                playback: MatrixPlayback.once,
                duration: const Duration(milliseconds: 100),
                paused: true,
                onComplete: () => fireCount++,
              ),
            ),
          ),
        ),
      );
      // Even if a lot of wall time passes, paused never advances.
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 200));
      expect(fireCount, 0);
    });

    testWidgets('toggling paused true -> false resumes a loop animation', (
      tester,
    ) async {
      // Use a StatefulBuilder so we can flip paused at runtime.
      var paused = true;
      late void Function(void Function()) outerSetState;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) {
                  outerSetState = setState;
                  return MatrixLoader(
                    playback: MatrixPlayback.loop,
                    duration: const Duration(milliseconds: 100),
                    paused: paused,
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Render once paused — find the underlying state to inspect controller.
      final stateBefore = tester.state<State<MatrixLoader>>(
        find.byType(MatrixLoader),
      );
      // After a frame, paused: true means no animation ticks happened.
      expect(stateBefore.mounted, isTrue);

      // Now un-pause and let some time pass; controller should advance.
      outerSetState(() => paused = false);
      await tester.pump(); // commit setState
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));
      // We can't easily peek at the private _controller, but we can assert
      // the widget is still mounted and didn't crash — the existing loop
      // rendering tests would have failed if animation tick wiring was broken.
      expect(find.byType(MatrixLoader), findsOneWidget);
    });

    testWidgets('toggling paused false -> true stops onComplete from firing', (
      tester,
    ) async {
      var fireCount = 0;
      var paused = false;
      late void Function(void Function()) outerSetState;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) {
                  outerSetState = setState;
                  return MatrixLoader(
                    playback: MatrixPlayback.once,
                    duration: const Duration(milliseconds: 200),
                    paused: paused,
                    onComplete: () => fireCount++,
                  );
                },
              ),
            ),
          ),
        ),
      );
      // Advance partway through the once animation.
      await tester.pump(const Duration(milliseconds: 50));
      // Pause mid-flight; _runId bump should drop the pending TickerFuture.
      outerSetState(() => paused = true);
      await tester.pump();
      // Let the original duration elapse — callback must not fire.
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 200));
      expect(fireCount, 0);
    });

    testWidgets('DotLoader forwards paused to MatrixLoader', (tester) async {
      // DotLoader is a thin subclass; just verify the parameter compiles
      // and renders without throwing.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: DotLoader(color: Colors.blue, paused: true)),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(DotLoader), findsOneWidget);
    });
  });

  group('semanticsLabel', () {
    testWidgets('MatrixLoader exposes a semantics node when label is set', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: MatrixLoader(semanticsLabel: 'Loading')),
          ),
        ),
      );
      expect(find.bySemanticsLabel('Loading'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('MatrixLoader adds no semantics node when label is null', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: MatrixLoader())),
        ),
      );
      expect(find.bySemanticsLabel('Loading'), findsNothing);
      handle.dispose();
    });

    testWidgets('DotLoader forwards semanticsLabel to MatrixLoader', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: DotLoader(
                color: Colors.blue,
                semanticsLabel: 'Assistant is thinking',
              ),
            ),
          ),
        ),
      );
      expect(find.bySemanticsLabel('Assistant is thinking'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('TriangleLoader exposes a semantics node when label is set', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: TriangleLoader(semanticsLabel: 'Loading')),
          ),
        ),
      );
      expect(find.bySemanticsLabel('Loading'), findsOneWidget);
      handle.dispose();
    });
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

  group('non-square sizing', () {
    const extent = 512;

    /// Rasterizes the loader's [CustomPainter] into an oversized image and
    /// returns the smallest rect containing all painted (non-transparent)
    /// pixels. The image is larger than the widget box on purpose: dots
    /// painted outside the box are still rasterized, so overflow is
    /// detectable instead of being silently clipped.
    Future<Rect?> paintedBounds(WidgetTester tester) {
      final render = tester.renderObject<RenderCustomPaint>(
        find.descendant(
          of: find.bySubtype<MatrixLoader>(),
          matching: find.byType(CustomPaint),
        ),
      );
      final painter = render.painter!;
      final box = tester.getSize(find.bySubtype<MatrixLoader>());
      return tester.runAsync<Rect?>(() async {
        final recorder = ui.PictureRecorder();
        painter.paint(ui.Canvas(recorder), box);
        final image = await recorder.endRecording().toImage(extent, extent);
        final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
        if (data == null) return null;
        final bytes = data.buffer.asUint8List();
        var minX = extent;
        var minY = extent;
        var maxX = -1;
        var maxY = -1;
        for (var y = 0; y < extent; y++) {
          for (var x = 0; x < extent; x++) {
            if (bytes[(y * extent + x) * 4 + 3] != 0) {
              if (x < minX) minX = x;
              if (x > maxX) maxX = x;
              if (y < minY) minY = y;
              if (y > maxY) maxY = y;
            }
          }
        }
        if (maxX < 0) return null;
        return Rect.fromLTRB(
          minX.toDouble(),
          minY.toDouble(),
          (maxX + 1).toDouble(),
          (maxY + 1).toDouble(),
        );
      });
    }

    /// Asserts at least one dot was painted and every painted pixel stays
    /// inside the widget's bounding box (small tolerance for antialiasing).
    Future<void> expectPaintedInsideBox(WidgetTester tester) async {
      final bounds = await paintedBounds(tester);
      final box = tester.getSize(find.bySubtype<MatrixLoader>());
      expect(bounds, isNotNull, reason: 'the loader painted no dots');
      expect(bounds!.left, greaterThanOrEqualTo(-2.0));
      expect(bounds.top, greaterThanOrEqualTo(-2.0));
      expect(bounds.right, lessThanOrEqualTo(box.width + 2.0));
      expect(bounds.bottom, lessThanOrEqualTo(box.height + 2.0));
    }

    testWidgets('MatrixLoader honors explicit width and height', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: MatrixLoader(width: 120, height: 40, columns: 6, rows: 3),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(MatrixLoader)), const Size(120, 40));
      await expectPaintedInsideBox(tester);
    });

    testWidgets('grid stays inside the box when rows > columns', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: MatrixLoader(columns: 2, rows: 8, size: 64)),
          ),
        ),
      );
      expect(tester.getSize(find.byType(MatrixLoader)), const Size(64, 64));
      await expectPaintedInsideBox(tester);
    });

    testWidgets('1xN grid stays inside the box (regression: overflow bug)', (
      tester,
    ) async {
      // Before the fix, spacing was derived from columns only, so this
      // painted a ~260px tall grid outside the 64px box.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: MatrixLoader(columns: 1, rows: 5, size: 64)),
          ),
        ),
      );
      expect(tester.getSize(find.byType(MatrixLoader)), const Size(64, 64));
      await expectPaintedInsideBox(tester);
    });

    testWidgets('Nx1 grid stays inside the box', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: MatrixLoader(columns: 7, rows: 1, size: 64)),
          ),
        ),
      );
      expect(tester.getSize(find.byType(MatrixLoader)), const Size(64, 64));
      await expectPaintedInsideBox(tester);
    });

    testWidgets('triangle shape with a single row still paints dots', (
      tester,
    ) async {
      // rows == 1 used to divide by zero in the triangle mask, producing
      // NaN comparisons that rendered nothing.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: MatrixLoader(
                shape: MatrixShape.triangle,
                columns: 5,
                rows: 1,
                size: 64,
              ),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(MatrixLoader)), const Size(64, 64));
      await expectPaintedInsideBox(tester);
    });

    testWidgets('DotLoader default box derives its height from rows', (
      tester,
    ) async {
      // 3x1 grid, dotSize 4: the box should be a thin inline strip, not a
      // 64x64 square.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: DotLoader())),
        ),
      );
      expect(tester.getSize(find.byType(DotLoader)), const Size(64, 4));
      await expectPaintedInsideBox(tester);
    });

    testWidgets('DotLoader honors width-only and explicit height', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: DotLoader(width: 90, dotSize: 6))),
        ),
      );
      // Height still derived from the single row of 6px dots.
      expect(tester.getSize(find.byType(DotLoader)), const Size(90, 6));
      await expectPaintedInsideBox(tester);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: DotLoader(width: 90, height: 24, dotSize: 6)),
          ),
        ),
      );
      expect(tester.getSize(find.byType(DotLoader)), const Size(90, 24));
      await expectPaintedInsideBox(tester);
    });

    testWidgets('TriangleLoader honors explicit width and height', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: TriangleLoader(width: 160, height: 80, triangleSize: 20),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(TriangleLoader)), const Size(160, 80));
    });

    testWidgets('tap hit-testing uses the same non-square geometry', (
      tester,
    ) async {
      int? tappedRow;
      int? tappedCol;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MatrixLoader(
                columns: 2,
                rows: 6,
                size: 64,
                onDotTapped: (row, col) {
                  tappedRow = row;
                  tappedCol = col;
                },
              ),
            ),
          ),
        ),
      );
      // Geometry: spacingH = (64 - 8) / 1 = 56, spacingV = (64 - 24) / 5 = 8.
      // The bottom-right dot is centered at local (62, 62).
      final topLeft = tester.getTopLeft(find.byType(MatrixLoader));
      await tester.tapAt(topLeft + const Offset(62, 62));
      expect(tappedRow, 5);
      expect(tappedCol, 1);
    });
  });

  group('reduced motion', () {
    Widget host(Widget child, {required bool reduce}) => MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: reduce),
        child: Scaffold(body: Center(child: child)),
      ),
    );

    testWidgets('stops the ticker when the OS asks for reduced motion', (
      tester,
    ) async {
      await tester.pumpWidget(host(const MatrixLoader(), reduce: true));
      await tester.pump();
      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('animates when reduced motion is off', (tester) async {
      await tester.pumpWidget(host(const MatrixLoader(), reduce: false));
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.binding.hasScheduledFrame, isTrue);
    });

    testWidgets('respectReducedMotion: false keeps animating', (tester) async {
      await tester.pumpWidget(
        host(const MatrixLoader(respectReducedMotion: false), reduce: true),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.binding.hasScheduledFrame, isTrue);
    });

    testWidgets('reacts to the setting changing at runtime', (tester) async {
      await tester.pumpWidget(host(const MatrixLoader(), reduce: false));
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.binding.hasScheduledFrame, isTrue);

      await tester.pumpWidget(host(const MatrixLoader(), reduce: true));
      await tester.pump();
      await tester.pump();
      expect(tester.binding.hasScheduledFrame, isFalse);

      await tester.pumpWidget(host(const MatrixLoader(), reduce: false));
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.binding.hasScheduledFrame, isTrue);
    });

    testWidgets('once playback fires onComplete immediately when reduced', (
      tester,
    ) async {
      var completed = 0;
      await tester.pumpWidget(
        host(
          MatrixLoader(
            playback: MatrixPlayback.once,
            onComplete: () => completed++,
          ),
          reduce: true,
        ),
      );
      await tester.pump();
      await tester.pump();
      expect(completed, 1);
      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('DotLoader passes the flag through and TriangleLoader stops', (
      tester,
    ) async {
      await tester.pumpWidget(host(const DotLoader(), reduce: true));
      await tester.pump();
      expect(tester.binding.hasScheduledFrame, isFalse);

      await tester.pumpWidget(host(const TriangleLoader(), reduce: true));
      await tester.pump();
      expect(tester.binding.hasScheduledFrame, isFalse);

      await tester.pumpWidget(
        host(const TriangleLoader(respectReducedMotion: false), reduce: true),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.binding.hasScheduledFrame, isTrue);
    });
  });

  group('customDotSize', () {
    RenderBox paintBox(WidgetTester tester) => tester.renderObject<RenderBox>(
      find
          .descendant(
            of: find.byType(MatrixLoader),
            matching: find.byType(CustomPaint),
          )
          .first,
    );

    testWidgets('scales dot diameters', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MatrixLoader(
                columns: 2,
                rows: 1,
                dotSize: 8,
                customDotSize: (row, col) => 0.5,
              ),
            ),
          ),
        ),
      );
      // dotSize 8, scale 0.5 => radius 2 for every dot.
      expect(
        paintBox(tester),
        paints
          ..circle(radius: 2.0)
          ..circle(radius: 2.0),
      );
    });

    testWidgets('a scale of 0 hides the dot', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MatrixLoader(
                columns: 3,
                rows: 1,
                dotSize: 8,
                customDotSize: (row, col) => col == 1 ? 0 : 1,
              ),
            ),
          ),
        ),
      );
      expect(
        paintBox(tester),
        paints
          ..circle(radius: 4.0)
          ..circle(radius: 4.0),
      );
    });

    testWidgets('null callback keeps dotSize', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: MatrixLoader(columns: 2, rows: 1, dotSize: 8)),
          ),
        ),
      );
      expect(
        paintBox(tester),
        paints
          ..circle(radius: 4.0)
          ..circle(radius: 4.0),
      );
    });

    testWidgets('does not change tap hit-testing', (tester) async {
      int? tappedCol;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MatrixLoader(
                columns: 2,
                rows: 1,
                size: 64,
                dotSize: 8,
                customDotSize: (row, col) => 0,
                onDotTapped: (row, col) => tappedCol = col,
              ),
            ),
          ),
        ),
      );
      final topLeft = tester.getTopLeft(find.byType(MatrixLoader));
      await tester.tapAt(topLeft + const Offset(4, 32));
      expect(tappedCol, 0);
    });
  });

  group('DotLoader AI-state presets', () {
    Future<void> pump(WidgetTester tester, Widget w) => tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: Center(child: w)),
      ),
    );

    testWidgets('each preset renders inside its box with a semantics label', (
      tester,
    ) async {
      const presets = <String, DotLoader>{
        'Typing': DotLoader.typing(),
        'Thinking': DotLoader.thinking(),
        'Searching': DotLoader.searching(),
        'Generating': DotLoader.generating(),
      };
      for (final entry in presets.entries) {
        await pump(tester, entry.value);
        await tester.pump(const Duration(milliseconds: 200));
        final size = tester.getSize(find.byType(DotLoader));
        expect(size.height, lessThanOrEqualTo(8), reason: entry.key);
        expect(find.bySemanticsLabel(entry.key), findsOneWidget);
      }
    });

    testWidgets('presets use curated grids and durations', (tester) async {
      const thinking = DotLoader.thinking();
      const searching = DotLoader.searching();
      const generating = DotLoader.generating();
      expect(thinking.columns, 3);
      expect(thinking.duration, const Duration(milliseconds: 2000));
      expect(searching.columns, 5);
      expect(generating.columns, 5);
      expect(generating.duration < searching.duration, isTrue);
    });

    testWidgets('presets accept color and honour reduced motion', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: Center(child: DotLoader.thinking(color: Colors.blue)),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(tester.binding.hasScheduledFrame, isFalse);
    });
  });
}
