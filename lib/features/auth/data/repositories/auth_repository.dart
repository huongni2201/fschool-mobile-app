import 'package:myfschool/features/auth/domain/entities/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser> login({required String username, required String password});

  Future<void> requestPasswordResetOtp({required String phoneNumber});

  Future<String> verifyPasswordResetOtp({
    required String phoneNumber,
    required String otp,
  });

  Future<void> resetPassword({
    required String phoneNumber,
    required String newPassword,
    required String resetToken,
  });
}
