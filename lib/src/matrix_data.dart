
/// Utility class to parse and generate compressed string representations
/// of matrix frames, useful for saving, loading, or exporting animations
/// from the Dot Matrix Studio.
class MatrixData {
  /// Parses a compact string representation of a grid into a 2D List.
  ///
  /// The [data] string should consist of '0' and '1' characters, where rows
  /// are separated by the pipe character '|'.
  ///
  /// Example:
  /// ```dart
  /// MatrixData.decode("101|010|101")
  /// ```
  static List<List<int>> decode(String data) {
    if (data.isEmpty) return [];
    
    return data.split('|').map((rowStr) {
      return rowStr.split('').map((char) => char == '1' ? 1 : 0).toList();
    }).toList();
  }

  /// Compresses a 2D List grid into a compact string representation.
  ///
  /// Rows are joined with the pipe character '|'.
  ///
  /// Example:
  /// ```dart
  /// MatrixData.encode([[1,0,1], [0,1,0], [1,0,1]]) // Returns "101|010|101"
  /// ```
  static String encode(List<List<int>> grid) {
    if (grid.isEmpty) return "";
    
    return grid.map((row) {
      return row.map((val) => val == 1 ? '1' : '0').join('');
    }).join('|');
  }

  /// Parses a string of multiple frames separated by commas.
  ///
  /// Example:
  /// ```dart
  /// MatrixData.decodeFrames("101|010|101,000|111|000")
  /// ```
  static List<List<List<int>>> decodeFrames(String data) {
    if (data.isEmpty) return [];
    return data.split(',').map((frame) => decode(frame)).toList();
  }

  /// Compresses a list of frames into a single string, separated by commas.
  ///
  /// Example:
  /// ```dart
  /// MatrixData.encodeFrames(myFrames) // Returns "101|010|101,000|111|000"
  /// ```
  static String encodeFrames(List<List<List<int>>> frames) {
    if (frames.isEmpty) return "";
    return frames.map((frame) => encode(frame)).join(',');
  }
}
