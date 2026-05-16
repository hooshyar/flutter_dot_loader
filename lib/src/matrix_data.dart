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

    return grid
        .map((row) {
          return row.map((val) => val == 1 ? '1' : '0').join('');
        })
        .join('|');
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

  // ---------------------------------------------------------------------------
  // JSON helpers — for shipping frames via Firebase Remote Config, Firestore,
  // app config, or any other JSON channel. The package itself stays zero-dep:
  // callers pass the returned `Map<String, dynamic>` to `dart:convert`'s
  // `jsonEncode` / `jsonDecode` on their side.
  // ---------------------------------------------------------------------------

  /// Current JSON schema version. Bumped when the on-disk shape changes in a
  /// non-backwards-compatible way. Stored in [framesToJson]'s output so
  /// future readers can branch on it.
  static const int jsonSchemaVersion = 1;

  /// Serializes a single 2D grid to a JSON-compatible map.
  ///
  /// Shape:
  /// ```json
  /// {"rows": 3, "cols": 3, "data": "101|010|101"}
  /// ```
  ///
  /// `rows` and `cols` are inferred from [grid]. `data` is the pipe-delimited
  /// string produced by [encode], so the payload stays compact even for large
  /// grids.
  ///
  /// Example:
  /// ```dart
  /// import 'dart:convert';
  /// final json = jsonEncode(MatrixData.toJson([[1,0,1],[0,1,0],[1,0,1]]));
  /// // {"rows":3,"cols":3,"data":"101|010|101"}
  /// ```
  static Map<String, dynamic> toJson(List<List<int>> grid) {
    final rows = grid.length;
    final cols = rows == 0 ? 0 : grid[0].length;
    return {'rows': rows, 'cols': cols, 'data': encode(grid)};
  }

  /// Deserializes a 2D grid from the map shape produced by [toJson].
  ///
  /// Accepts any map with a `data` field holding the pipe-delimited string.
  /// `rows` / `cols` are advisory — the returned grid's dimensions come from
  /// `data` itself, so a payload missing those fields is still readable.
  ///
  /// Throws [ArgumentError] if `data` is missing or not a string.
  static List<List<int>> fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is! String) {
      throw ArgumentError.value(
        json,
        'json',
        'MatrixData.fromJson: missing or non-string "data" field',
      );
    }
    return decode(data);
  }

  /// Serializes a list of frames to a JSON-compatible map.
  ///
  /// Shape:
  /// ```json
  /// {
  ///   "version": 1,
  ///   "rows": 3,
  ///   "cols": 3,
  ///   "frames": ["101|010|101", "000|111|000"]
  /// }
  /// ```
  ///
  /// `version` lets future readers handle schema changes. `rows` / `cols`
  /// describe the first frame and are advisory — frames are independently
  /// decodable from their pipe-delimited strings.
  ///
  /// Example:
  /// ```dart
  /// import 'dart:convert';
  /// final json = jsonEncode(MatrixData.framesToJson([
  ///   [[1,0,1],[0,1,0],[1,0,1]],
  ///   [[0,0,0],[1,1,1],[0,0,0]],
  /// ]));
  /// ```
  static Map<String, dynamic> framesToJson(List<List<List<int>>> frames) {
    final rows = frames.isEmpty || frames.first.isEmpty
        ? 0
        : frames.first.length;
    final cols = frames.isEmpty || frames.first.isEmpty
        ? 0
        : frames.first.first.length;
    return {
      'version': jsonSchemaVersion,
      'rows': rows,
      'cols': cols,
      'frames': frames.map(encode).toList(),
    };
  }

  /// Deserializes a list of frames from the map shape produced by
  /// [framesToJson].
  ///
  /// Accepts payloads from any [jsonSchemaVersion] ≤ current (currently 1).
  /// The `frames` field may be either a JSON array of pipe-delimited strings
  /// **or** the legacy comma-joined string accepted by [decodeFrames].
  ///
  /// Throws [ArgumentError] if `frames` is missing or has an unexpected type.
  static List<List<List<int>>> framesFromJson(Map<String, dynamic> json) {
    final frames = json['frames'];
    if (frames is List) {
      return frames.map((f) {
        if (f is! String) {
          throw ArgumentError.value(
            f,
            'frames[]',
            'MatrixData.framesFromJson: frame entry must be a string',
          );
        }
        return decode(f);
      }).toList();
    }
    if (frames is String) {
      return decodeFrames(frames);
    }
    throw ArgumentError.value(
      json,
      'json',
      'MatrixData.framesFromJson: missing or non-array/string "frames" field',
    );
  }
}
