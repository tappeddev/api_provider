import 'package:api_provider/src/path/path.dart';
import 'package:meta/meta.dart';

enum HttpMethod { POST, GET, PATCH, DELETE, PUT }

@immutable
class Request {
  final Path url;
  final HttpMethod httpMethod;
  final Map<String, String> headers;
  final Object body;

  Request({
    @required this.url,
    @required this.httpMethod,
    this.headers,
    this.body,
  });

  Request copyWith({
    Path url,
    HttpMethod httpMethod,
    Map<String, String> headers,
    Object body,
  }) =>
      Request(
        url: url ?? this.url,
        httpMethod: httpMethod ?? this.httpMethod,
        body: body ?? this.body,
        headers: headers ?? this.headers,
      );

  @override
  String toString() =>
      'Request{url: $url, httpMethod: $httpMethod, headers: $headers, body: $body}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Request &&
          runtimeType == other.runtimeType &&
          url == other.url &&
          httpMethod == other.httpMethod &&
          headers == other.headers &&
          body == other.body;

  @override
  int get hashCode =>
      url.hashCode ^ httpMethod.hashCode ^ headers.hashCode ^ body.hashCode;
}
