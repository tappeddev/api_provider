import 'package:api_provider/src/path/malformed_path_error.dart';
import 'package:meta/meta.dart';

@immutable
class Path {
  static const SEPARATOR = "/";

  final String string;

  Path(this.string);

  Path append(String part) => Path(_join(string, part));

  Path appendParam(String name, String value) {
    _assertParam(name, value);

    final containsParam = string.contains("?");
    final prefix = containsParam ? "&" : "?";

    return Path("$string$prefix$name=$value");
  }

  Path appendParams(Map<String, String> params) {
    Path path = this;
    params.forEach((name, value) {
      path = path.appendParam(name, value);
    });

    return path;
  }

  Path operator +(Path other) => Path(_join(string, other.string));

  // -----
  // Helper
  // -----

  String _join(String first, String second) {
    if (first.endsWith(SEPARATOR)) {
      first = first.substring(0, first.length - 1);
    }

    if (second.startsWith(SEPARATOR)) {
      second = second.substring(1, second.length);
    }

    return first + SEPARATOR + second;
  }

  void _assertParam(String name, String value) {
    if (name == null || name.isEmpty) {
      throw MalformedPathError("param name can not be null or empty!");
    }
    if (value == null) {
      throw MalformedPathError("param value can not be null!");
    }
  }

  // -----
  // Default overrides
  // -----

  @override
  String toString() => 'Path{string: $string}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Path &&
          runtimeType == other.runtimeType &&
          string == other.string;

  @override
  int get hashCode => string.hashCode;
}
