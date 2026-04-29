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
