import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static String? _accessToken;
  static String? _refreshToken;
  static bool _isLoaded = false;

  static String? get accessToken => _accessToken;

  static String? get refreshToken => _refreshToken;

  static bool get hasAccessToken =>
      _accessToken != null && _accessToken!.isNotEmpty;

  static Future<void> loadTokens() async {
    if (_isLoaded) return;

    try {
      _accessToken = await _storage.read(key: _accessTokenKey);
      _refreshToken = await _storage.read(key: _refreshTokenKey);
    } catch (_) {
      _accessToken = null;
      _refreshToken = null;
    } finally {
      _isLoaded = true;
    }
  }

  static Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _isLoaded = true;

    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  static Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
    _isLoaded = true;

    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
