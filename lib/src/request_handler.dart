import 'package:api_provider/src/request.dart';
import 'package:api_provider/src/response.dart';

typedef Future<Response<T>> RequestHandler<T>(Request request);
