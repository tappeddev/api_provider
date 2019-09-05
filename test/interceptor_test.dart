import 'package:api_provider/api_provider.dart';
import 'package:api_provider/internal/interceptor/serial_interceptor.dart';
import 'package:api_provider/src/interceptor/interceptor.dart';
import 'package:api_provider/src/request_handler.dart';
import 'package:test/test.dart';

void main() {
  test('serial interceptor executes in correct order', () async {
    var message = "";
    final interceptor = SerialInterceptor(
      _CallbackInterceptor(before: () => message += "first "),
      _CallbackInterceptor(before: () => message += "second"),
    );

    final initialFunction = (Request _) async => Response.success(body: "");
    final interceptedFunction = interceptor.intercept(initialFunction);

    await interceptedFunction(null);
    expect(message, "first second");
  });

  test('interceptor from list exectures in order and source handler only once',
      () async {
    var count = 0;
    var message1 = "";
    var message2 = "";

    final combinedInterceptor = Interceptor.fromList([
      _CallbackInterceptor(
        before: () => message1 += "This ",
        after: () => message2 += "well!",
      ),
      _CallbackInterceptor(
        before: () => message1 += "Interceptor.fromList ",
        after: () => message2 += "as ",
      ),
      _CallbackInterceptor(
        before: () => message1 += "function ",
        after: () => message2 += "reverse ",
      ),
      _CallbackInterceptor(
        before: () => message1 += "works ",
        after: () => message2 += "in ",
      ),
      _CallbackInterceptor(
        before: () => message1 += "great!",
        after: () => message2 += "Especially ",
      ),
    ]);

    final initialFunction = (Request _) async {
      count++;
      return Response.success(body: "");
    };
    final interceptedFunction = combinedInterceptor.intercept(initialFunction);

    await interceptedFunction(null);
    expect(message1, "This Interceptor.fromList function works great!");
    expect(message2, "Especially in reverse as well!");
    expect(count, 1);
  });
}

class _CallbackInterceptor implements Interceptor {
  final Function() before;
  final Function() after;

  _CallbackInterceptor({this.before, this.after});

  @override
  RequestHandler<T> intercept<T>(RequestHandler<T> handler) => (request) async {
        if (before != null) {
          before();
        }

        final result = await handler(request);

        if (after != null) {
          after();
        }
        return result;
      };
}
