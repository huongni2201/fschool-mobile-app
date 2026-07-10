import '../../data/repositories/auth_repository.dart';

class VerifyPasswordResetOtpUseCase {
  final AuthRepository repository;

  const VerifyPasswordResetOtpUseCase({required this.repository});

  Future<String?> call({required String phoneNumber, required String otp}) {
    return repository.verifyPasswordResetOtp(
      phoneNumber: phoneNumber,
      otp: otp,
    );
  }
}
