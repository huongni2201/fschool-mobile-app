import '../../data/repositories/auth_repository.dart';

class RequestPasswordResetOtpUseCase {
  final AuthRepository repository;

  const RequestPasswordResetOtpUseCase({required this.repository});

  Future<void> call({required String phoneNumber}) {
    return repository.requestPasswordResetOtp(phoneNumber: phoneNumber);
  }
}
