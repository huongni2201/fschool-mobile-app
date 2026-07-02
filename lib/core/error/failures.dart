abstract class Failure implements Exception {
  final String? message;

  const Failure([this.message]);

  @override
  String toString() {
    final detail = message;

    if (detail == null || detail.trim().isEmpty) {
      return runtimeType.toString();
    }

    return '$runtimeType: $detail';
  }
}

final class AuthFailure extends Failure {
  const AuthFailure([super.message]);
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message]);
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

final class ParsingFailure extends Failure {
  const ParsingFailure([super.message]);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message]);
}
