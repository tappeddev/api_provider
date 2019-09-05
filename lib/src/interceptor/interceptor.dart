import 'package:api_provider/internal/interceptor/noop_interceptor.dart';
import 'package:api_provider/internal/interceptor/serial_interceptor.dart';
import 'package:api_provider/src/request_handler.dart';

abstract class Interceptor {
  RequestHandler<T> intercept<T>(RequestHandler<T> handler);

  factory Interceptor.noop() => NoopInterceptor();

  factory Interceptor.fromList(List<Interceptor> interceptors) =>
      interceptors.reduce((left, right) => SerialInterceptor(left, right));
}
