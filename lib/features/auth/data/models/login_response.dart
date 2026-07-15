import '../../../../core/auth/user_role_resolver.dart';

class LoginResponse {
  final String accessToken;
  final String? refreshToken;
  final UserRole userRole;

  const LoginResponse({
    required this.accessToken,
    required this.userRole,
    this.refreshToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final source = data is Map<String, dynamic> ? data : json;
    final accessToken =
        source['accessToken'] ?? source['access_token'] ?? source['token'];

    if (accessToken is! String || accessToken.isEmpty) {
      throw const FormatException('Login response does not contain token');
    }

    final refreshToken = source['refreshToken'] ?? source['refresh_token'];

    return LoginResponse(
      accessToken: accessToken,
      userRole: _roleFromLoginResponse(source, accessToken),
      refreshToken: refreshToken is String && refreshToken.isNotEmpty
          ? refreshToken
          : null,
    );
  }

  static UserRole _roleFromLoginResponse(
    Map<String, dynamic> source,
    String accessToken,
  ) {
    final responseRole = UserRoleResolver.fromClaims(source);

    if (responseRole != UserRole.unknown) return responseRole;

    return UserRoleResolver.fromToken(accessToken);
  }
}
