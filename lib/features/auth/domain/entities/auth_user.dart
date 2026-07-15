import '../../../../core/auth/user_role_resolver.dart';

class AuthUser {
  final String accessToken;
  final String? refreshToken;
  final UserRole userRole;

  const AuthUser({
    required this.accessToken,
    required this.userRole,
    this.refreshToken,
  });
}
