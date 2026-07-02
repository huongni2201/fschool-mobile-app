class AuthUser {
  final String accessToken;
  final String? refreshToken;

  const AuthUser({required this.accessToken, this.refreshToken});
}
