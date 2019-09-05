import 'package:api_provider/api_provider.dart';
import 'package:api_provider/internal/mock/missing_matcher_error.dart';
import 'package:api_provider/internal/mock/mock_builder.dart';
import 'package:api_provider/internal/mock/request_matcher.dart';
import 'package:api_provider/src/api_provider.dart';

class MockApiProvider implements ApiProvider {
  final List<RequestMatcher> matcher;
  final Interceptor interceptor;

  MockApiProvider._(this.matcher, this.interceptor);

  factory MockApiProvider(void Function(MockBuilder builder) init) {
    final mockBuilder = MockBuilder();
    init(mockBuilder);

    return MockApiProvider._(mockBuilder.matchers, mockBuilder.interceptor);
  }

  @override
  Future<Response<Out>> request<Out>({Request request}) async {
    final future = matcher
        .map((matcher) => matcher.match(request))
        .firstWhere((response) => response != null, orElse: () => null);

    if (future == null) {
      throw MissingMatcherError(
          "Not matcher found for type ${Out.toString()}");
    }

    final response = await future;
    return response as Response<Out>;
  }
}
