import 'package:flutter_dot_loader/flutter_dot_loader.dart';

/// A utility to generate frame data and scrolling animations from text strings
/// for use with [MatrixLoader] and [MatrixPattern.custom].
class MatrixText {
  /// Basic 5x7 pixel font for A-Z, 0-9, and common punctuation.
  /// Each character is a 7-row by 5-column grid.


  // Wait, encoding fonts as hex is standard but requires a decoder. 
  // Let's use simple string arrays for the 5x7 font to be very readable and easy to maintain.
  static final Map<String, List<String>> _fontMap = {
    'A': [
      '01110',
      '10001',
      '10001',
      '11111',
      '10001',
      '10001',
      '10001',
    ],
    'B': [
      '11110',
      '10001',
      '10001',
      '11110',
      '10001',
      '10001',
      '11110',
    ],
    'C': [
      '01110',
      '10001',
      '10000',
      '10000',
      '10000',
      '10001',
      '01110',
    ],
    'D': [
      '11110',
      '10001',
      '10001',
      '10001',
      '10001',
      '10001',
      '11110',
    ],
    'E': [
      '11111',
      '10000',
      '10000',
      '11110',
      '10000',
      '10000',
      '11111',
    ],
    'F': [
      '11111',
      '10000',
      '10000',
      '11110',
      '10000',
      '10000',
      '10000',
    ],
    'G': [
      '01110',
      '10001',
      '10000',
      '10111',
      '10001',
      '10001',
      '01110',
    ],
    'H': [
      '10001',
      '10001',
      '10001',
      '11111',
      '10001',
      '10001',
      '10001',
    ],
    'I': [
      '01110',
      '00100',
      '00100',
      '00100',
      '00100',
      '00100',
      '01110',
    ],
    'J': [
      '00111',
      '00010',
      '00010',
      '00010',
      '10010',
      '10010',
      '01100',
    ],
    'K': [
      '10001',
      '10010',
      '10100',
      '11000',
      '10100',
      '10010',
      '10001',
    ],
    'L': [
      '10000',
      '10000',
      '10000',
      '10000',
      '10000',
      '10000',
      '11111',
    ],
    'M': [
      '10001',
      '11011',
      '10101',
      '10001',
      '10001',
      '10001',
      '10001',
    ],
    'N': [
      '10001',
      '11001',
      '10101',
      '10011',
      '10001',
      '10001',
      '10001',
    ],
    'O': [
      '01110',
      '10001',
      '10001',
      '10001',
      '10001',
      '10001',
      '01110',
    ],
    'P': [
      '11110',
      '10001',
      '10001',
      '11110',
      '10000',
      '10000',
      '10000',
    ],
    'Q': [
      '01110',
      '10001',
      '10001',
      '10001',
      '10101',
      '10010',
      '01101',
    ],
    'R': [
      '11110',
      '10001',
      '10001',
      '11110',
      '10100',
      '10010',
      '10001',
    ],
    'S': [
      '01111',
      '10000',
      '10000',
      '01110',
      '00001',
      '00001',
      '11110',
    ],
    'T': [
      '11111',
      '00100',
      '00100',
      '00100',
      '00100',
      '00100',
      '00100',
    ],
    'U': [
      '10001',
      '10001',
      '10001',
      '10001',
      '10001',
      '10001',
      '01110',
    ],
    'V': [
      '10001',
      '10001',
      '10001',
      '10001',
      '10001',
      '01010',
      '00100',
    ],
    'W': [
      '10001',
      '10001',
      '10001',
      '10101',
      '10101',
      '11011',
      '10001',
    ],
    'X': [
      '10001',
      '10001',
      '01010',
      '00100',
      '01010',
      '10001',
      '10001',
    ],
    'Y': [
      '10001',
      '10001',
      '10001',
      '01010',
      '00100',
      '00100',
      '00100',
    ],
    'Z': [
      '11111',
      '00001',
      '00010',
      '00100',
      '01000',
      '10000',
      '11111',
    ],
    '0': [
      '01110',
      '10011',
      '10101',
      '10101',
      '11001',
      '10001',
      '01110',
    ],
    '1': [
      '00100',
      '01100',
      '00100',
      '00100',
      '00100',
      '00100',
      '01110',
    ],
    '2': [
      '01110',
      '10001',
      '00001',
      '00110',
      '01000',
      '10000',
      '11111',
    ],
    '3': [
      '01110',
      '10001',
      '00001',
      '00110',
      '00001',
      '10001',
      '01110',
    ],
    '4': [
      '00010',
      '00110',
      '01010',
      '10010',
      '11111',
      '00010',
      '00010',
    ],
    '5': [
      '11111',
      '10000',
      '11110',
      '00001',
      '00001',
      '10001',
      '01110',
    ],
    '6': [
      '01110',
      '10000',
      '10000',
      '11110',
      '10001',
      '10001',
      '01110',
    ],
    '7': [
      '11111',
      '00001',
      '00010',
      '00100',
      '01000',
      '01000',
      '01000',
    ],
    '8': [
      '01110',
      '10001',
      '10001',
      '01110',
      '10001',
      '10001',
      '01110',
    ],
    '9': [
      '01110',
      '10001',
      '10001',
      '01111',
      '00001',
      '00001',
      '01110',
    ],
    ' ': [
      '00000',
      '00000',
      '00000',
      '00000',
      '00000',
      '00000',
      '00000',
    ],
    '.': [
      '00000',
      '00000',
      '00000',
      '00000',
      '00000',
      '00000',
      '00100',
    ],
    '!': [
      '00100',
      '00100',
      '00100',
      '00100',
      '00000',
      '00000',
      '00100',
    ],
    '?': [
      '01110',
      '10001',
      '00001',
      '00010',
      '00100',
      '00000',
      '00100',
    ],
  };

  /// Returns the 5x7 binary string representation of a character.
  /// If the character is not supported, it returns a blank 5x7 space.
  static List<String> getChar(String c) {
    return _fontMap[c.toUpperCase()] ?? _fontMap[' ']!;
  }

  /// Converts a [text] string into a 2D grid array (List of rows, where each row is a List of integers).
  ///
  /// The resulting grid will have a height of 7. The width will be
  /// `text.length * 6 - 1` (5 pixels per char + 1 pixel letter spacing).
  static List<List<int>> encode(String text) {
    if (text.isEmpty) return List.generate(7, (_) => []);
    
    List<List<int>> grid = List.generate(7, (_) => []);
    
    for (int i = 0; i < text.length; i++) {
      final charGrid = getChar(text[i]);
      for (int r = 0; r < 7; r++) {
        for (int c = 0; c < 5; c++) {
          grid[r].add(charGrid[r][c] == '1' ? 1 : 0);
        }
        // Add 1 column spacing between characters, except for the last char
        if (i < text.length - 1) {
          grid[r].add(0);
        }
      }
    }
    return grid;
  }

  /// Returns a [customIntensity] callback that automatically scrolls [text]
  /// horizontally across the [MatrixLoader].
  ///
  /// - [text]: The string to scroll.
  /// - [loopPadding]: Empty columns to pad before/after the text to allow a smooth loop.
  static double Function(int row, int col, double progress) scrolling(
    String text, {
    int loopPadding = 10,
  }) {
    final textGrid = encode(text);
    if (textGrid[0].isEmpty) return (r, c, p) => 0.0;
    
    final textWidth = textGrid[0].length;
    final totalScrollWidth = textWidth + loopPadding * 2;

    return (int row, int col, double progress) {
      // Map progress (0.0 -> 1.0) to an offset in columns
      int offset = (progress * totalScrollWidth).floor();
      
      // Calculate which column of the textGrid corresponds to the current Matrix column
      int textCol = col + offset - loopPadding;

      if (row >= 0 && row < 7 && textCol >= 0 && textCol < textWidth) {
        return textGrid[row][textCol].toDouble();
      }
      return 0.0;
    };
  }
}
