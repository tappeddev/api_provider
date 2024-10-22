import 'dart:async';
import 'package:api_provider/api_provider.dart';
import 'package:api_provider/internal/http_api_provider.dart';
import 'package:api_provider/src/interceptor/interceptor.dart';
import 'package:api_provider/src/request.dart';
import 'package:api_provider/src/response.dart';
import 'package:codable/codable.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

abstract class ApiProvider {
  Future<Response<Out>> request<Out>({@required Request request});

  // -----
  // Factories
  // -----

  factory ApiProvider({
    @required http.Client client,
    @required SerializerContainer serializerContainer,
    Interceptor interceptor,
  }) =>
      HttpClientApiProvider(
        httpClient: client,
        container: serializerContainer,
        interceptor: interceptor,
      );
}
