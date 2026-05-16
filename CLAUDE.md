# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

`flutter_dot_loader` is a published Flutter package (pub.dev) — a zero-dependency dot-matrix / LED loading animation library. The repo contains both the package itself (`lib/`) and an embedded example app (`example/`) used as a live gallery + studio.

Dart SDK `^3.11.4`, Flutter `>=1.17.0`. No runtime dependencies beyond Flutter itself; only `flutter_lints` for dev.

## Common commands

Run from the repo root unless noted.

```sh
flutter pub get                     # install deps
flutter analyze                     # lint with flutter_lints
flutter test                        # run all widget tests
flutter test test/flutter_dot_loader_test.dart --plain-name 'renders with circular shape'   # single test
flutter pub publish --dry-run       # validate before bumping version on pub.dev
```

Example app (separate pubspec):

```sh
cd example
flutter pub get
flutter run -d chrome   # web preview
flutter run             # native device
```

Note: per global rules, do not auto-launch simulators/emulators — only run the app when explicitly asked.

## Architecture

The public API is exported from `lib/flutter_dot_loader.dart`. The package is intentionally small — five files in `lib/src/`, all rendered through a single `CustomPainter` per widget, with `AnimationController.repeat` driving the frame loop. No `setState` is called in the animation hot path; only the `CustomPaint` layer rebuilds.

### Widget hierarchy

- **`MatrixLoader`** (`lib/src/matrix_loader.dart`) — the core widget. Holds three orthogonal concerns:
  1. **Shape mask** (`MatrixShape`: `square` / `circular` / `triangle` / `custom`) — decides *which* dots render. `custom` is gated by the `customMask` callback.
  2. **Pattern** (`MatrixPattern`: 60 named patterns + `custom` + semantic aliases like `vortexSpin`, `bullsEye`) — decides *how bright* each dot is. The `custom` pattern hands intensity off to the `customIntensity` callback.
  3. **Playback** (`MatrixPlayback`: `loop` / `bounce` / `once`) and an optional `Curve` are applied to the controller in `_applyPlayback()` and `curve.transform(...)` respectively.
- **`DotLoader`** (`lib/src/dot_loader.dart`) — a thin subclass of `MatrixLoader` with AI-chat-friendly defaults (3×1, diagonal wave, single `color` derives both active and inactive). Keep in sync when adding new `MatrixLoader` parameters.
- **`TriangleLoader`** (`lib/src/triangle_loader.dart`) — fully independent geometric loader (tessellated equilateral triangles + radial wave). Does *not* share code with `MatrixLoader`.

### Helper modules

- **`MatrixText`** (`lib/src/matrix_text.dart`) — built-in 5×7 pixel font (A–Z, 0–9, a few punctuation glyphs). `MatrixText.scrolling(text)` returns a `customIntensity` callback that scrolls text horizontally; the matrix must be exactly **7 rows tall** for the default font to render correctly.
- **`MatrixData`** (`lib/src/matrix_data.dart`) — encode/decode 2D `0/1` grids to compact pipe-delimited strings (e.g. `"101|010|101"`). Used by the example app's Studio editor for save/load.

### The intensity → opacity pipeline

`_MatrixPainter.paint()` in `matrix_loader.dart` drives every frame:

1. For each `(row, col)`, compute a raw intensity `[0..1]` — either via the built-in `_calculateIntensity` switch (one big switch over all `MatrixPattern` values) or via `customIntensity(row, col, progress)`.
2. If hovered, OR-merge a radial sine ripple on top.
3. Run the value through the **three-tier LED remap** (`_remapOpacity`): piecewise linear `opacityBase → opacityMid → opacityPeak` (defaults `0.08 / 0.34 / 0.94`). This is what gives the "glowing LED" look — do not flatten it without understanding the visual impact.
4. `Color.lerp(inactiveColor.withValues(alpha: opacityBase), activeColor, remapped)` produces the final dot color. Note: this package uses `withValues(alpha:)` (Flutter 3.27+), never the deprecated `withOpacity`.

When **adding a new pattern**, add it to the `MatrixPattern` enum *and* its case in `_calculateIntensity`. Update the test that asserts `MatrixPattern.values.length == 74` (`test/flutter_dot_loader_test.dart`) — 60 numeric (20 square + 20 circular + 20 triangle) + 13 semantic aliases + 1 `custom`. Semantic aliases (e.g. `vortexSpin`) share a `case` block with their numeric counterpart (`square11`).

### Constructors are `const` — color derivation happens in `build()`

`MatrixLoader` and `DotLoader` constructors **are** `const`. The `color` shorthand still works because the active/inactive derivation runs at render time inside `_MatrixLoaderState.build()` (see `matrix_loader.dart:454-456`), not at construction. So `const DotLoader(color: Colors.blue)` is valid and is the documented quick-start. Do not remove `const` from these constructors — the v0.0.4 CHANGELOG entry and the `accepts a single color and stays const-constructable` test both depend on it.

## Releasing

1. Bump `version:` in `pubspec.yaml`.
2. Add a section to `CHANGELOG.md` (existing entries are terse bullet lists).
3. `flutter pub publish --dry-run` and address any warnings before publishing.
