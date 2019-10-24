import 'package:api_provider/src/api_provider.dart';
import 'package:api_provider/src/interceptor/interceptor.dart';
import 'package:api_provider/src/request.dart';
import 'package:api_provider/src/response.dart';
import 'package:codable/codable.dart';
import 'package:dio/dio.dart' as http;
import 'package:meta/meta.dart';

@immutable
class HttpClientApiProvider with DecodeEncodeMixin implements ApiProvider {
  @override
  final SerializerContainer container;

  final http.Dio _httpClient;
  final Interceptor _interceptor;

  HttpClientApiProvider({@required this.container, Interceptor interceptor})
      : _httpClient = http.Dio(),
        _interceptor = interceptor ?? Interceptor.noop();

  @override
  Future<Response<Out>> request<Out>({@required Request request}) async {
    final sendTime = DateTime.now();

    final call = _interceptor.intercept<Out>(
        (Request request) => _sendRequest<Out>(sendTime, request));

    return call(request);
  }

  Future<Response<Out>> _sendRequest<Out>(
      DateTime sendTime, Request request) async {
    final clientResponse = await _callHttpClient(
      request.url.string,
      request.httpMethod,
      headers: request.headers,
      body: request.body == null ? null : encode(request.body),
    );

    return _mapToResponse(clientResponse);
  }

  Response<Out> _mapToResponse<Out>(http.Response<String> response) {
    var isSuccessful = response.statusCode >= 200 && response.statusCode < 300;

    Out data;
    String error;

    if (isSuccessful) {
      data = decode<Out>(response.data);
    } else {
      error = response.data;
    }

    return Response(response.statusCode, data, error, isSuccessful);
  }

  // -----
  // Helper
  // -----

  /// calls the http clients base on the defined [method] with a
  /// json encoded [body]
  Future<http.Response<String>> _callHttpClient(String url, HttpMethod method,
      {Map<String, String> headers, String body}) async {
    //TODO Add utf8 as encoding

    switch (method) {
      case HttpMethod.POST:
        return await http.Dio().post(url,
            options: http.Options(headers: headers), data: body);
      case HttpMethod.GET:
        return await http.Dio().get(url, options: http.Options(headers: headers));
      case HttpMethod.DELETE:
        return await http.Dio().delete(url, options: http.Options(headers: headers));
      case HttpMethod.PATCH:
        return await http.Dio().patch(url,
            data: body, options: http.Options(headers: headers));
      case HttpMethod.PUT:
        return await http.Dio().put(url,
            options: http.Options(headers: headers), data: body);
    }
    throw Exception("Unknown HTTP Method");
  }
}
