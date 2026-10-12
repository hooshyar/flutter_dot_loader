# flutter_dot_loader examples

Copy-paste recipes for the most common uses. For a live tour of all 60
patterns plus the frame editor, open the
[web demo](https://hooshyar.github.io/flutter_dot_loader/) or run this example
app (`flutter run -d chrome` from this folder).

```dart
import 'package:flutter/material.dart';
import 'package:flutter_dot_loader/flutter_dot_loader.dart';
```

## AI chat "thinking" indicator

One line, `const`, sized to sit inline next to text:

```dart
const DotLoader(color: Colors.blue)
```

Pick the state instead of a pattern:

```dart
const DotLoader.typing(color: Colors.blue)      // classic 3-dot wave
const DotLoader.thinking(color: Colors.blue)    // calm 3-dot ribbon
const DotLoader.searching(color: Colors.blue)   // 5-dot scanner sweep
const DotLoader.generating(color: Colors.blue)  // quick 5-dot wave
```

Inside a chat bubble while the first token is on its way:

```dart
Container(
  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    borderRadius: BorderRadius.circular(16),
  ),
  child: isWaiting
      ? DotLoader.thinking(color: Theme.of(context).colorScheme.primary)
      : Text(reply),
)
```

## LED dot-matrix loader

```dart
const MatrixLoader(
  columns: 7,
  rows: 7,
  shape: MatrixShape.circular,
  pattern: MatrixPattern.vortexSpin,
  activeColor: Colors.cyanAccent,
  size: 96,
)
```

## Scrolling marquee text

The built-in 5x7 font needs a matrix exactly 7 rows tall:

```dart
MatrixLoader(
  columns: 24,
  rows: 7,
  pattern: MatrixPattern.custom,
  customIntensity: MatrixText.scrolling('LOADING: 42%', loopPadding: 24),
  duration: const Duration(seconds: 4),
)
```

## Your own pixel frames

```dart
final frames = <List<List<int>>>[
  [
    [0, 1, 0],
    [1, 1, 1],
    [0, 1, 0],
  ],
  [
    [1, 0, 1],
    [0, 1, 0],
    [1, 0, 1],
  ],
];

MatrixLoader(
  columns: 3,
  rows: 3,
  dotSize: 8,
  pattern: MatrixPattern.custom,
  duration: const Duration(milliseconds: 800),
  customIntensity: (row, col, progress) {
    final i = (progress * frames.length).floor().clamp(0, frames.length - 1);
    return frames[i][row][col].toDouble();
  },
)
```

## Play once, then move on (splash screens)

```dart
MatrixLoader(
  pattern: MatrixPattern.bullsEye,
  playback: MatrixPlayback.once,
  duration: const Duration(seconds: 2),
  onComplete: () => Navigator.of(context).pushReplacementNamed('/home'),
)
```

## Geometric triangle loader

```dart
const TriangleLoader(
  color: Colors.indigoAccent,
  size: 200,
  triangleSize: 25,
)
```

## Accessibility

Loaders are decorative by default. Give them a label to announce them to
screen readers. They also stop animating when the OS asks for reduced motion
(`respectReducedMotion`, on by default):

```dart
const DotLoader(color: Colors.blue, semanticsLabel: 'Assistant is typing')
```
