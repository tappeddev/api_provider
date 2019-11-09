import 'package:api_provider/api_provider.dart';
import 'package:api_provider/src/path/path.dart';
import 'package:api_provider/src/request.dart';
import 'package:api_provider/src/response.dart';

abstract class RequestMatcher<T> {
  Future<Response<T>> match(Request request);
}

class RequestMatcherImpl<T> implements RequestMatcher<T> {
  final Path path;
  final HttpMethod method;
  final RequestHandler<T> handler;

  RequestMatcherImpl(this.path, this.method, this.handler);

  @override
  Future<Response<T>> match(Request request) {
    if (_matches(request, path) && request.httpMethod == method) {
      return handler(request);
    }
    return null;
  }

  bool _matches(Request request, Path path) {
    return request.url == path;
  }
}
