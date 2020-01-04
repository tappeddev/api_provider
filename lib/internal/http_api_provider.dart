import 'dart:convert';

import 'package:api_provider/src/api_provider.dart';
import 'package:api_provider/src/interceptor/interceptor.dart';
import 'package:api_provider/src/request.dart';
import 'package:api_provider/src/response.dart';
import 'package:codable/codable.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

@immutable
class HttpClientApiProvider with DecodeEncodeMixin implements ApiProvider {
  final http.Client httpClient;

  @override
  final SerializerContainer container;

  final Interceptor _interceptor;

  HttpClientApiProvider({
    @required this.httpClient,
    @required this.container,
    Interceptor interceptor,
  }) : _interceptor = interceptor ?? Interceptor.noop();

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

  Response<Out> _mapToResponse<Out>(http.Response response) {
    final isSuccessful =
        response.statusCode >= 200 && response.statusCode < 300;
    final hasContent = response.statusCode != 204;

    Out data;
    String error;

    if (isSuccessful) {
      if (hasContent) {
        data = decode<Out>(response.body);
      }
    } else {
      error = response.body;
    }

    return Response(response.statusCode, data, error, isSuccessful);
  }

  // -----
  // Helper
  // -----

  /// calls the http clients base on the defined [method] with a
  /// json encoded [body]
  Future<http.Response> _callHttpClient(String url, HttpMethod method,
      {Map<String, String> headers, String body}) {
    switch (method) {
      case HttpMethod.POST:
        return httpClient.post(url,
            headers: headers, body: body, encoding: utf8);
      case HttpMethod.GET:
        return httpClient.get(url, headers: headers);
      case HttpMethod.DELETE:
        return httpClient.delete(url, headers: headers);
      case HttpMethod.PATCH:
        return httpClient.patch(url,
            headers: headers, body: body, encoding: utf8);
      case HttpMethod.PUT:
        return httpClient.put(url,
            headers: headers, body: body, encoding: utf8);
    }
    throw Exception("Unknown HTTP Method");
  }
}
