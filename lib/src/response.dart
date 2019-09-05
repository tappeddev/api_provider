import 'package:meta/meta.dart';

@immutable
class Response<T> {
  final int statusCode;
  final T body;
  final String errorBody;
  final bool isSuccessful;

  Response(
    this.statusCode,
    this.body,
    this.errorBody,
    this.isSuccessful,
  );

  factory Response.success({int statusCode = 200, T body}) =>
      Response(statusCode, body, null, true);

  Response<T> copyWith({
    int statusCode,
    T body,
    String errorBody,
    bool isSuccessful,
  }) =>
      Response<T>(
        statusCode ?? this.statusCode,
        body ?? this.body,
        errorBody ?? this.errorBody,
        isSuccessful ?? this.isSuccessful,
      );

  // -----
  // Default overrides
  // -----

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Response &&
          runtimeType == other.runtimeType &&
          statusCode == other.statusCode &&
          body == other.body &&
          errorBody == other.errorBody &&
          isSuccessful == other.isSuccessful;

  @override
  int get hashCode =>
      statusCode.hashCode ^
      body.hashCode ^
      errorBody.hashCode ^
      isSuccessful.hashCode;

  @override
  String toString() =>
      'Response{statusCode: $statusCode, body: $body, errorBody: $errorBody, isSuccessful: $isSuccessful}';
}
