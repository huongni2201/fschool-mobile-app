import '../constants/app_strings.dart';
import 'failures.dart';

abstract final class ErrorMessageMapper {
  static String login(Object error) {
    return switch (error) {
      AuthFailure(:final message) => _messageOr(
        message,
        AppStrings.loginInvalidCredentials,
      ),
      NetworkFailure(:final message) => _messageOr(
        message,
        AppStrings.connectionError,
      ),
      ServerFailure(:final message) => _messageOr(
        message,
        AppStrings.serverError,
      ),
      ParsingFailure() => AppStrings.invalidLoginResponse,
      Failure(:final message) => _messageOr(message, AppStrings.loginFailed),
      FormatException() => AppStrings.invalidLoginResponse,
      _ => AppStrings.loginFailed,
    };
  }

  static String passwordReset(Object error) {
    return switch (error) {
      AuthFailure(:final message) => _messageOr(
        message,
        AppStrings.resetPasswordFailed,
      ),
      NetworkFailure(:final message) => _messageOr(
        message,
        AppStrings.connectionError,
      ),
      ServerFailure(:final message) => _messageOr(
        message,
        AppStrings.serverError,
      ),
      ParsingFailure(:final message) => _messageOr(
        message,
        AppStrings.resetPasswordFailed,
      ),
      Failure(:final message) => _messageOr(
        message,
        AppStrings.resetPasswordFailed,
      ),
      FormatException() => AppStrings.resetPasswordFailed,
      _ => AppStrings.resetPasswordFailed,
    };
  }

  static String _messageOr(String? message, String fallback) {
    final trimmedMessage = message?.trim();

    if (trimmedMessage == null || trimmedMessage.isEmpty) {
      return fallback;
    }

    return trimmedMessage;
  }
}
