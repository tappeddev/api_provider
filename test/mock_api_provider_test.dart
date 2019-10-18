import 'package:api_provider/api_provider.dart';
import 'package:api_provider/internal/mock/mock_api_provider.dart';
import 'package:test/test.dart';

void main() {
  test('returns given response if path and method matches', () async {
    final url = Path("/usernames");
    final response = Response.success(body: ["Stefan, Tobi, Julian"]);

    final apiProvider = MockApiProvider((builder) {
      builder
          .onGet<List<String>>(url: url, handler: (request) async => response)
          .onDelete(url: url, handler: (request) async => response)
          .onPatch(url: url, handler: (request) async => response)
          .onPost(url: url, handler: (request) async => response)
          .onPut(url: url, handler: (request) async => response);
    });

    final getResult = await apiProvider.request<List<String>>(
        request: Request(url: url, httpMethod: HttpMethod.GET));

    final deleteResult = await apiProvider.request<List<String>>(
        request: Request(url: url, httpMethod: HttpMethod.DELETE));

    final patchResult = await apiProvider.request<List<String>>(
        request: Request(url: url, httpMethod: HttpMethod.PATCH));

    final postResult = await apiProvider.request<List<String>>(
        request: Request(url: url, httpMethod: HttpMethod.POST));

    final putResult = await apiProvider.request<List<String>>(
        request: Request(url: url, httpMethod: HttpMethod.PUT));

    expect(response, getResult);
    expect(response, deleteResult);
    expect(response, patchResult);
    expect(response, postResult);
    expect(response, putResult);
  });
}
