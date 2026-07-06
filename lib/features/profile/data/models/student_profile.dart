class StudentProfile {
  final String fullName;
  final String? studentCode;
  final String avatarText;
  final String className;
  final String campus;
  final String schoolYear;
  final String? email;
  final String? phone;

  const StudentProfile({
    required this.fullName,
    required this.avatarText,
    required this.className,
    required this.campus,
    required this.schoolYear,
    this.studentCode,
    this.email,
    this.phone,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    final payload = _payload(json);
    final student = _firstMap(payload, const [
      'student',
      'studentInfo',
      'profile',
      'user',
      'account',
    ]);
    final source = student.isEmpty ? payload : {...payload, ...student};
    final classSource = _firstMap(source, const [
      'class',
      'classInfo',
      'homeroom',
    ]);
    final campusSource = _firstMap(source, const [
      'campus',
      'school',
      'branch',
    ]);
    final schoolYearSource = _firstMap(source, const [
      'schoolYear',
      'academicYear',
      'year',
    ]);
    final fullName =
        _stringFromKeys(source, const [
          'fullName',
          'name',
          'studentName',
          'displayName',
        ]) ??
        'Học sinh';

    return StudentProfile(
      fullName: fullName,
      avatarText:
          _stringFromKeys(source, const ['avatarText', 'initials']) ??
          _avatarText(fullName),
      studentCode: _stringFromKeys(source, const [
        'studentCode',
        'code',
        'studentId',
      ]),
      className:
          _stringFromKeys(source, const [
            'className',
            'class',
            'homeroomClass',
          ]) ??
          _stringFromKeys(classSource, const ['name', 'title', 'className']) ??
          'Đang cập nhật',
      campus:
          _stringFromKeys(source, const [
            'campus',
            'campusName',
            'school',
            'schoolName',
          ]) ??
          _stringFromKeys(campusSource, const [
            'name',
            'title',
            'campusName',
          ]) ??
          'Đang cập nhật',
      schoolYear:
          _stringFromKeys(source, const [
            'schoolYear',
            'academicYear',
            'year',
          ]) ??
          _stringFromKeys(schoolYearSource, const ['name', 'title', 'label']) ??
          'Đang cập nhật',
      email: _stringFromKeys(source, const ['email', 'emailAddress']),
      phone: _stringFromKeys(source, const ['phone', 'phoneNumber', 'mobile']),
    );
  }
}

Map<String, dynamic> _payload(Map<String, dynamic> source) {
  final data = _mapFromObject(source['data'] ?? source['result']);

  return data.isEmpty ? source : data;
}

Map<String, dynamic> _firstMap(Map<String, dynamic> source, List<String> keys) {
  for (final key in keys) {
    final map = _mapFromObject(source[key]);

    if (map.isNotEmpty) return map;
  }

  return const {};
}

Map<String, dynamic> _mapFromObject(Object? value) {
  if (value is Map<String, dynamic>) return value;

  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }

  return const {};
}

String? _stringFromKeys(Map<String, dynamic> source, List<String> keys) {
  for (final key in keys) {
    final value = _stringValue(source[key]);

    if (value != null) return value;
  }

  return null;
}

String? _stringValue(Object? value) {
  if (value == null) return null;

  if (value is String) {
    final trimmed = value.trim();

    return trimmed.isEmpty ? null : trimmed;
  }

  if (value is num || value is bool) return value.toString();

  return null;
}

String _avatarText(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList(growable: false);

  if (parts.isEmpty) return 'HS';
  if (parts.length == 1) {
    final end = parts.first.length < 2 ? parts.first.length : 2;

    return parts.first.substring(0, end).toUpperCase();
  }

  return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
      .toUpperCase();
}
