import '../../data/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  const ResetPasswordUseCase({required this.repository});

  Future<void> call({
    required String phoneNumber,
    required String otp,
    required String newPassword,
    String? resetToken,
  }) {
    return repository.resetPassword(
      phoneNumber: phoneNumber,
      otp: otp,
      newPassword: newPassword,
      resetToken: resetToken,
    );
  }
}
