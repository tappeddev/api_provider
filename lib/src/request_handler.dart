import 'package:api_provider/src/request.dart';
import 'package:api_provider/src/response.dart';

typedef RequestHandler<T> = Future<Response<T>> Function(Request request);
