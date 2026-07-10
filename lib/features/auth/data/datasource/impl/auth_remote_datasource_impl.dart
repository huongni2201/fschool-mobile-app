import 'package:myfschool/core/error/exceptions.dart';
import 'package:myfschool/core/network/api_client.dart';
import 'package:myfschool/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:myfschool/features/auth/data/models/login_request.dart';
import 'package:myfschool/features/auth/data/models/login_response.dart';
import 'package:myfschool/features/auth/data/models/password_reset_models.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDataSource {
  static const String sendOtpPath = String.fromEnvironment(
    'FORGOT_PASSWORD_SEND_OTP_PATH',
    defaultValue: '/auth/forgot-password/send-otp',
  );
  static const String verifyOtpPath = String.fromEnvironment(
    'FORGOT_PASSWORD_VERIFY_OTP_PATH',
    defaultValue: '/auth/forgot-password/verify-otp',
  );
  static const String resetPasswordPath = String.fromEnvironment(
    'FORGOT_PASSWORD_RESET_PATH',
    defaultValue: '/auth/forgot-password/reset',
  );

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await ApiClient.dio.post(
      '/auth/login',
      data: request.toJson(),
    );

    final responseData = response.data;

    if (responseData is! Map<String, dynamic>) {
      throw const ParsingException('Login response must be a JSON object');
    }

    return LoginResponse.fromJson(responseData);
  }

  @override
  Future<void> requestPasswordResetOtp(PasswordResetOtpRequest request) async {
    final response = await ApiClient.dio.post(
      sendOtpPath,
      data: request.toJson(),
    );

    _throwIfFailed(response.data, 'Cannot send password reset OTP');
  }

  @override
  Future<PasswordResetVerification> verifyPasswordResetOtp(
    PasswordResetOtpVerificationRequest request,
  ) async {
    final response = await ApiClient.dio.post(
      verifyOtpPath,
      data: request.toJson(),
    );

    final responseData = _jsonMap(response.data);

    _throwIfFailed(responseData, 'Cannot verify password reset OTP');

    return PasswordResetVerification.fromJson(responseData);
  }

  @override
  Future<void> resetPassword(PasswordResetRequest request) async {
    final response = await ApiClient.dio.post(
      resetPasswordPath,
      data: request.toJson(),
    );

    _throwIfFailed(response.data, 'Cannot reset password');
  }

  Map<String, dynamic> _jsonMap(Object? value) {
    if (value is Map<String, dynamic>) return value;

    if (value is Map) {
      return value.map((key, value) => MapEntry(key.toString(), value));
    }

    return const {};
  }

  void _throwIfFailed(Object? data, String fallbackMessage) {
    final source = _jsonMap(data);

    if (source.isEmpty || source['success'] != false) return;

    throw ServerException(_backendMessage(source) ?? fallbackMessage);
  }

  String? _backendMessage(Map<String, dynamic> source) {
    final message = source['message'] ?? source['error'];

    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }

    final data = _jsonMap(source['data']);

    if (data.isEmpty) return null;

    return _backendMessage(data);
  }
}
