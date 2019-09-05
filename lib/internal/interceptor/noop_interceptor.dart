import 'package:api_provider/api_provider.dart';
import 'package:api_provider/src/interceptor/interceptor.dart';
import 'package:api_provider/src/request_handler.dart';

class NoopInterceptor implements Interceptor {
  @override
  RequestHandler<T> intercept<T>(RequestHandler<T> handler) =>
      (request) => handler(request);
}
