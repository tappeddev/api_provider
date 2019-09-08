# ApiProvider

### Clean and boilerplate free network requests with only a few lines of code.

```dart
  final request = Request(url: Path("https://someapi/user"), httpMethod: HttpMethod.GET);

  final response = await apiProvider.request<User>(request: request);
  print("fetched user :${response.body.name}");
```

### Features:

- Typesafe interface on `Request` and `Response` objects.
- Powerful `Interceptors`
- Testing / Mocking out of the Box!



### Installing

Add the following snippet into your `pubspec.yaml`. (Release on pub will happen when the api is stable)

```yaml
api_provider:
    git:
      url: git://github.com/tikkrapp/api_provider.git
```





### Serializing Requests and Deserializing Responses

Instead of providing a serializer when calling  `request`, all the serialisers are stored in a `SerializeContainer` .The `ApiProvider` will get the stored  `Serializable`'s and `Deserializable` 's that are needed when you call `request`.

⚠️  Important:  `T`  of `request` is used to get the needed serializer, thats why it should never be  `dynamic`.  ⚠️ 

We highly recomment to disable `implicit-dynamic`  and `implicit-casts`.

```yml
analyzer:
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false
```



Specify your `SerializeContainer` in the constructor.

```dart
final apiProvider = HttpClientApiProvider(
    // use IOClient for flutter apps
    // use BrowserClient for dartJs
    httpClient: client,
    container: SerializerContainer()
      ..insertEncoder(UserEncoder())
      ..insertDecoder(UserDecoder()),
);

// responsible for decoding a user
// similar to a "toMap" method.
class UserEncoder implements Deserializable<Map, User> {
  @override
  Map to(User input) => <String, dynamic>{
        'email': input.email,
        'name': input.name,
      };
}

// responsible for encoding a user
// similar to a "fromMap" method.
class UserDecoder implements Serializable<Map, User> {
  @override
  User from(Map input) => User(
    email: input['email'] as String,
    name: input['name'] as String,
  );
}
```



### Interceptors

Interceptors give you the ability to transform, change or listen to request or response calls.

This could be something simply like adding an Authorization Header or something more complex like catching and handling a specific error from your api.

1. #### Start by implementing `Interceptor`. 

```dart
class MyInterceptor implements Interceptor {
  @override
  RequestHandler<T> intercept<T>(RequestHandler<T> handler) => (request) async {
        // adjust the request here using request.copyWith
        // Maybe add auth headers?
        // add additional content to the body?
    
        // do the call that returns the response
        final response = await handler(request);
      
        // do additional response handling
        // maybe resend if the response failed because of an expired token?
        // maybe log out the user if he has no permission to this endpoint?
        return response;
      };
}
```

An example could look like this:

```dart
class AuthInterceptor implements Interceptor {
  @override
  RequestHandler<T> intercept<T>(RequestHandler<T> handler) => (request) async {
        final updatedRequest = request.copyWith(
          headers: {"Authorization": await getToken()},
        );

				return handler(updatedRequest);
	};
  
  ...
}
```

or

```dart
class RefreshTokenInterceptor implements Interceptor {
  @override
  RequestHandler<T> intercept<T>(RequestHandler<T> handler) => (request) async {
        final response = await handler(updatedRequest);

        if (!response.isSuccessful && response.errorBody == "Shit! Token expired!") {
          // refresh the token asynchronously
          final refreshedRequest = request.copyWith(
            headers: {"Authorization": await refreshToken()},
          );
          
          // resend the request with the refreshed token!
          return handler(refreshedRequest);
        }

        return response;
      };
	...
}
```



2. #### Chain your interceptors

   You can chain multiple `Interceptor`'s using `Interceptor.fromList`. 

   ```dart
   final apiProvider = HttpClientApiProvider(
       httpClient: yourClient,
       container: yourContainer,
       interceptor: Interceptor.fromList([
         TokenInterceptor(),
         MyInterceptor(),
         LoggingInterceptor(),
       ]),
   ```

   The given `Interceptors`'s wrap around the source call like an onion.  🤤

   TODO insert graphic

   

   Testing a chain of `Interceptor`'s can be done by mocking.

   

   

   

   ### Testing / Mocking an `ApiProvider`

   The slim interface of `ApiProvider` makes mocking really easy. You can simply implement the `ApiProvider` interface, implement the `request` method and returns whatever you need in your use case. 

   

   Besides that we provide a powerful mocking implementation out of the Box!

   Use `MockApiProvider` and configure it using the builder!

   ```dart
   	final apiProvider = MockApiProvider((builder) {
       builder.onGet<User>(
         url: Path("https://someapi/user"),
         handler: (request) async => Response.success(body: mockedUser()),
       );
     });
   ```

   If you want to test your `ApiProvider` with all of your custom `Interceptor`'s' we gotcha covered, because `MockApiProvider` supports  `Interceptor`'s   as well! 💪🏼 

   Just use `addInterceptor` on the `builder`.

   ```dart
   	builder
         ..onGet<User>(...)
         ..addInterceptor(Interceptor.fromList([
           // your interceptors
         ]));
   ```

   
