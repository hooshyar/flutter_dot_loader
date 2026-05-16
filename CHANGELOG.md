## Unreleased

- docs: new `doc/font_preview.md` — auto-generated ASCII-art preview of every
  glyph in the 5×7 `MatrixText` font. Pure Dart generator under
  `tool/generate_font_preview.dart`; a drift test fails if the artifact stops
  matching `matrix_text.dart`, so every glyph change forces a visible diff in
  review.
- chore: `lib/src/matrix_text.dart` no longer pulls in
  `package:flutter_dot_loader/flutter_dot_loader.dart` (it never used any
  Flutter or library types). The file is now pure Dart, which is what lets
  the new `tool/` scripts import it without dragging in `dart:ui`.
- feat: three new semantic aliases on `MatrixPattern` —
  `sonarPing` (alias for `circular4`, a pure outward radial pulse),
  `pinwheel` (alias for `circular15`, a 4-arm rotating sweep), and
  `columnWave` (alias for `triangle8`, a horizontal column scan). Total
  semantic aliases now 16; total enum values 77. README cheat sheet and
  AGENTS.md alias table reflect the additions.
- feat: `MatrixLoader.onComplete` callback — fires once when
  `MatrixPlayback.once` finishes a play-through. Closes the loop on finite
  splash / loading animations so apps can navigate, transition, or hand off
  state when the animation ends. Has no effect for `loop` / `bounce` modes.
  Stale-run-guarded: if the widget is disposed or the playback mode changes
  before completion, the callback does not fire.
- feat: `MatrixData` now has JSON helpers for shipping frames over Firebase
  Remote Config, Firestore, app config, or any other JSON channel. Four new
  methods: `MatrixData.toJson(grid)` / `fromJson(map)` for a single frame and
  `MatrixData.framesToJson(frames)` / `framesFromJson(map)` for an animation.
  Output is a `Map<String, dynamic>` (callers pass it through `dart:convert`'s
  `jsonEncode` — the package itself stays zero-dep). The frames payload is
  versioned (`MatrixData.jsonSchemaVersion`), and `framesFromJson` also accepts
  the legacy comma-joined string for backwards compatibility.
- feat: `MatrixText` font now covers all common UI punctuation and symbols —
  `, ; : ' " - _ + = / \ * # @ $ % & | ^ ~ \` ( ) [ ] { } < >` in addition to
  the previously supported `. ! ?`. Real-world strings like `"Loading: 42%"`,
  `"12/24"`, `"Don't quit"`, `"a@b.com"` now render fully.
- feat: `MatrixText.supportedCharacters` getter exposes the font's coverage
  set so apps can validate user input before encoding.
- docs: README + AGENTS reference the expanded charset.
- test: add MatrixText group asserting full charset coverage, glyph shape
  invariants (7 rows × 5 cols of `0`/`1`), fallback-to-space behavior, and
  lowercase normalization. Total test count: 18.

## 0.0.5

- fix: replace portrait animated-GIF pubspec screenshots with static landscape PNGs (`assets/screenshot_gallery.png`, `assets/screenshot_studio.png`) so pub.dev's screenshot pipeline renders thumbnails correctly. The animated GIFs remain in the README and are unchanged.

## 0.0.4

- fix: restore `const` constructors on `MatrixLoader` and `DotLoader` so the documented `const` usage in the README and tests actually compiles
- fix: replace deprecated `withOpacity` with `withValues(alpha:)` (Flutter 3.27+)
- chore: tighten `analysis_options.yaml` (strict-casts/inference, deprecation warnings, sorted directives & dependencies)
- chore: add pub.dev `topics:` for discoverability (`animation`, `loader`, `loading`, `widget`, `ui`)
- docs: add `AGENTS.md` with copy-paste recipes and a decision tree for AI coding agents
- docs: README quick-start now leads with `DotLoader(color: …)` for the AI-chat use case
- test: cover `DotLoader` defaults and the `color` shorthand; bump pattern-count assertion to 74

## 0.0.3

- feat: added DotLoader simplified wrapper
- feat: added semantic aliases to MatrixPattern
- feat: added 'color' parameter to MatrixLoader for automatic color derivation

## 0.0.2

* **Studio Parity Update**: Expanded `MatrixLoader` with dotanime studio parity features.
* **Marquee Text**: Added `MatrixText` to automatically convert and scroll text strings into dot-matrix arrays (includes a built-in 5x7 font map).
* **Interactivity**: Added `onDotTapped(row, col)` to allow using the dot matrix as an interactive keypad/synthesizer.
* **Playback Modes**: Added `MatrixPlayback` enum (`loop`, `bounce`, `once`) for non-loading, finite animations.
* **Easing Curves**: Added `curve` property to `MatrixLoader` to allow non-linear animation (e.g., easeInOut).
* **Compression Utilities**: Added `MatrixData` for compressing/decompressing 2D arrays to lightweight strings (e.g. `101|010|101`).
* **Example Upgrade**: Added `Text` and `Interactive` tabs to the example app to showcase the new capabilities.

## 0.0.1

* Initial release of `flutter_dot_loader`.
* Includes `MatrixLoader` with customizable shapes (Square, Circular, Triangle).
* Features **60 unique math-driven animation patterns** spanning spirals, vortexes, pulses, and geometric shifts.
* Supports **Custom Frames** (`MatrixPattern.custom` + `customIntensity`) for building frame-by-frame dot matrix animations (e.g. Tetris, scrolling text).
* High-performance rendering engine built cleanly on `CustomPainter`.
* Includes a fully-featured Example App: an interactive **Playground** (with real-time parameter tweaking and code generation) and a **Dot Matrix Studio Editor** for designing custom frames.
