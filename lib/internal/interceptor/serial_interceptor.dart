import 'package:api_provider/src/interceptor/interceptor.dart';
import 'package:api_provider/src/request_handler.dart';

class SerialInterceptor implements Interceptor {
  final Interceptor first;
  final Interceptor second;

  SerialInterceptor(this.first, this.second);

  @override
  RequestHandler<T> intercept<T>(RequestHandler<T> handler) =>
      first.intercept(second.intercept(handler));
}