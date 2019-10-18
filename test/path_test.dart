import 'package:api_provider/api_provider.dart';
import 'package:test/test.dart';

void main() {
  test("api url - append path", () {
    final path = Path("https://tikkr.app/login");
    final startPath = path.string;

    final pathWithAppendix = path.append("/test").string;
    expect("$startPath/test", pathWithAppendix);
  });

  test("api url - append param", () {
    final path = Path("https://tikkr.app/logout");
    final startPath = path.string;

    final pathWithParam = path
        .appendParam("dontCheckPassword", "true")
        .appendParam("dontCheckEmail", "true")
        .string;

    expect(
        "$startPath?dontCheckPassword=true&dontCheckEmail=true", pathWithParam);
  });
}
