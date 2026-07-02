class LoginResponse {
  final String accessToken;
  final String? refreshToken;

  const LoginResponse({required this.accessToken, this.refreshToken});

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
      refreshToken: refreshToken is String && refreshToken.isNotEmpty
          ? refreshToken
          : null,
    );
  }
}
