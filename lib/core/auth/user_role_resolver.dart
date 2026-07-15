import 'dart:convert';

enum UserRole { unknown, student, parent, teacher }

abstract final class UserRoleResolver {
  static UserRole fromToken(String? token) {
    if (token == null || token.trim().isEmpty) return UserRole.unknown;

    final parts = token.split('.');
    if (parts.length < 2) return UserRole.unknown;

    try {
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final decoded = jsonDecode(payload);

      if (decoded is! Map<String, dynamic>) return UserRole.unknown;

      return fromClaims(decoded);
    } catch (_) {
      return UserRole.unknown;
    }
  }

  static UserRole fromStorage(String? value) {
    return switch (value?.trim().toLowerCase()) {
      'parent' => UserRole.parent,
      'teacher' => UserRole.teacher,
      'student' => UserRole.student,
      _ => UserRole.unknown,
    };
  }

  static UserRole fromObject(Object? value) {
    return _fromClaimValue(value);
  }

  static String? toStorage(UserRole role) {
    return switch (role) {
      UserRole.parent => 'parent',
      UserRole.teacher => 'teacher',
      UserRole.student => 'student',
      UserRole.unknown => null,
    };
  }

  static UserRole fromClaims(Map<String, dynamic> claims) {
    const roleKeys = [
      'role',
      'roles',
      'userRole',
      'accountRole',
      'accountType',
      'type',
      'authorities',
      'authority',
      'scope',
      'scopes',
      'permissions',
    ];

    for (final key in roleKeys) {
      final role = _fromClaimValue(claims[key]);
      if (role != UserRole.unknown) return role;
    }

    const nestedKeys = [
      'data',
      'result',
      'payload',
      'user',
      'account',
      'profile',
      'member',
      'principal',
    ];

    for (final key in nestedKeys) {
      final role = _fromClaimValue(claims[key]);
      if (role != UserRole.unknown) return role;
    }

    return UserRole.unknown;
  }

  static UserRole _fromClaimValue(Object? value) {
    if (value == null) return UserRole.unknown;

    if (value is String) return _fromText(value);

    if (value is Iterable) {
      for (final item in value) {
        final role = _fromClaimValue(item);
        if (role != UserRole.unknown) return role;
      }
    }

    if (value is Map) {
      for (final item in value.values) {
        final role = _fromClaimValue(item);
        if (role != UserRole.unknown) return role;
      }
    }

    return UserRole.unknown;
  }

  static UserRole _fromText(String value) {
    final normalized = value.trim().toLowerCase().replaceAll(
      RegExp(r'[\s\-]+'),
      '_',
    );

    if (normalized.contains('parent') ||
        normalized.contains('guardian') ||
        normalized.contains('phu_huynh') ||
        normalized.contains('phụ_huynh') ||
        normalized.contains('phuhuynh')) {
      return UserRole.parent;
    }

    if (normalized.contains('teacher') ||
        normalized.contains('homeroom_teacher') ||
        normalized.contains('giao_vien') ||
        normalized.contains('giáo_viên') ||
        normalized.contains('giaovien') ||
        normalized.contains('gvcn')) {
      return UserRole.teacher;
    }

    if (normalized.contains('student') ||
        normalized.contains('hoc_sinh') ||
        normalized.contains('học_sinh') ||
        normalized.contains('hocsinh')) {
      return UserRole.student;
    }

    return UserRole.unknown;
  }
}
