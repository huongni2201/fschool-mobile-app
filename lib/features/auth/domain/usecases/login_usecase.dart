import '../../data/repositories/auth_repository.dart';
import '../entities/auth_user.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<AuthUser> call({required String username, required String password}) {
    return repository.login(username: username, password: password);
  }
}
