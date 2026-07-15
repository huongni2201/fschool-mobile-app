import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../auth/user_role_resolver.dart';

class TokenStorage {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userRoleKey = 'user_role';

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static String? _accessToken;
  static String? _refreshToken;
  static UserRole _userRole = UserRole.unknown;
  static bool _isLoaded = false;

  static String? get accessToken => _accessToken;

  static String? get refreshToken => _refreshToken;

  static UserRole get userRole => _userRole;

  static bool get isParent => _userRole == UserRole.parent;

  static bool get isTeacher => _userRole == UserRole.teacher;

  static bool get hasAccessToken =>
      _accessToken != null && _accessToken!.isNotEmpty;

  static Future<void> loadTokens() async {
    if (_isLoaded) return;

    try {
      _accessToken = await _storage.read(key: _accessTokenKey);
      _refreshToken = await _storage.read(key: _refreshTokenKey);
      _userRole = UserRoleResolver.fromStorage(
        await _storage.read(key: _userRoleKey),
      );

      if (_userRole == UserRole.unknown) {
        _userRole = UserRoleResolver.fromToken(_accessToken);
      }
    } catch (_) {
      _accessToken = null;
      _refreshToken = null;
      _userRole = UserRole.unknown;
    } finally {
      _isLoaded = true;
    }
  }

  static Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    UserRole? userRole,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _userRole = userRole ?? UserRoleResolver.fromToken(accessToken);
    _isLoaded = true;

    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);

    final roleValue = UserRoleResolver.toStorage(_userRole);
    if (roleValue == null) {
      await _storage.delete(key: _userRoleKey);
    } else {
      await _storage.write(key: _userRoleKey, value: roleValue);
    }
  }

  static Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
    _userRole = UserRole.unknown;
    _isLoaded = true;

    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userRoleKey);
  }
}
