import 'dart:html';

import 'package:api_provider/api_provider.dart';
import 'package:api_provider/internal/http_api_provider.dart';
import 'package:api_provider/src/interceptor/interceptor.dart';
import 'package:codable/codable.dart';

import 'example_interceptors.dart';
import 'user.dart';

void main(Client client) async {
  final apiProvider = HttpClientApiProvider(
    // use IOClient for flutter apps
    // use BrowserClient for dartJs
    httpClient: null,
    container: SerializerContainer()
      ..insertEncoder(UserEncoder())
      ..insertDecoder(UserDecoder()),
    interceptor: Interceptor.fromList([TokenInterceptor(), MyInterceptor()]),
  );

  final request = Request(
    url: Path("https://someapi/user"),
    httpMethod: HttpMethod.GET,
  );

  final response = await apiProvider.request<User>(request: request);
  print("fetched user :${response.body}");
}

User mockedUser() => User(email: "mail", name: "name");
