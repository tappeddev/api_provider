import 'package:api_provider/api_provider.dart';
import 'package:api_provider/internal/interceptor/serial_interceptor.dart';
import 'package:api_provider/internal/mock/request_matcher.dart';
import 'package:api_provider/src/path/path.dart';
import 'package:meta/meta.dart';

class MockBuilder {
  final matchers = List<RequestMatcher>();

  Interceptor get interceptor => _interceptor;

  var _interceptor = Interceptor.noop();

  MockBuilder onGet<T>(
          {@required Path url, @required RequestHandler<T> handler}) =>
      _on(url, HttpMethod.GET, handler);

  MockBuilder onPost<T>(
          {@required Path url, @required RequestHandler<T> handler}) =>
      _on(url, HttpMethod.POST, handler);

  MockBuilder onPatch<T>(
          {@required Path url, @required RequestHandler<T> handler}) =>
      _on(url, HttpMethod.PATCH, handler);

  MockBuilder onDelete<T>(
          {@required Path url, @required RequestHandler<T> handler}) =>
      _on(url, HttpMethod.DELETE, handler);

  MockBuilder onPut<T>(
          {@required Path url, @required RequestHandler<T> handler}) =>
      _on(url, HttpMethod.PUT, handler);

  MockBuilder addInterceptor(Interceptor interceptor) {
    interceptor = SerialInterceptor(_interceptor, interceptor);
    return this;
  }

  // -----
  // Helper
  // -----

  MockBuilder _on<T>(Path url, HttpMethod method, RequestHandler<T> handler) {
    matchers.add(RequestMatcherImpl<T>(url, method, handler));
    return this;
  }
}
