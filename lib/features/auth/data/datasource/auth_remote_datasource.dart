import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/password_reset_models.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);

  Future<void> requestPasswordResetOtp(PasswordResetOtpRequest request);

  Future<PasswordResetVerification> verifyPasswordResetOtp(
    PasswordResetOtpVerificationRequest request,
  );

  Future<void> resetPassword(PasswordResetRequest request);
}
