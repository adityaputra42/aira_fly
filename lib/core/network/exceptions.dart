class BadResponse implements Exception {
  final String message;

  BadResponse(this.message);

  @override
  String toString() => message;
}