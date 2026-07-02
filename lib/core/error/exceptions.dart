abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

final class ServerException extends AppException {
  const ServerException(super.message);
}

final class ParsingException extends AppException {
  const ParsingException(super.message);
}
