import 'package:api_provider/api_provider.dart';
import 'package:api_provider/src/request_handler.dart';

class MyInterceptor implements Interceptor {
  @override
  RequestHandler<T> intercept<T>(RequestHandler<T> handler) => (request) async {
        // adjust the request here,
        // Maybe add auth headers?
        // add additional content to the body?

        // do the call that returns the response
        final response = await handler(request);

        // do additional response handling
        // maybe resend if the response failed because of an expired token?
        // maybe log out the user if he has no permission to this endpoint.
        return response;
      };
}

class TokenInterceptor implements Interceptor {
  @override
  RequestHandler<T> intercept<T>(RequestHandler<T> handler) => (request) async {
        final updatedRequest = request.copyWith(
          headers: {"Authorization": await getToken()},
        );

        final response = await handler(updatedRequest);

        if (!response.isSuccessful && response.errorBody == "Token expired") {
          //refresh the token and resend the request
          final refreshedRequest = request.copyWith(
            headers: {"Authorization": await refreshToken()},
          );
          return handler(refreshedRequest);
        }

        return response;
      };

  Future<String> getToken() async => "sometoken";

  Future<String> refreshToken() async => "refreshedtoken";
}
