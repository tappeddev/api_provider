class MalformedPathError extends Error {
  final String message;

  MalformedPathError(this.message);

  @override
  String toString() => 'MalformedPathError{message: $message}';
}
