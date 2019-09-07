import 'package:api_provider/api_provider.dart';
import 'package:api_provider/internal/http_api_provider.dart';
import 'package:codable/codable.dart';

import 'user.dart';

void main() async {
  final apiProvider = HttpClientApiProvider(
    httpClient: null,
    container: SerializerContainer()..insertDecoder(UserDecoder()),
  );

  final request = Request(
    url: Path("https://someapi/user"),
    httpMethod: HttpMethod.GET,
  );

  final response = await apiProvider.request<User>(request: request);
  print("fetched user :${response.body}");
}
