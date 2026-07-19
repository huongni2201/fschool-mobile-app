import '../../data/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  const ResetPasswordUseCase({required this.repository});

  Future<void> call({
    required String phoneNumber,
    required String newPassword,
    required String resetToken,
  }) {
    return repository.resetPassword(
      phoneNumber: phoneNumber,
      newPassword: newPassword,
      resetToken: resetToken,
    );
  }
}
