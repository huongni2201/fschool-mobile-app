import 'teacher_dashboard.dart';

class TeacherGradeStudent {
  final String id;
  final String name;
  final String? code;
  final String className;
  final String avatarText;
  final String statusLabel;

  const TeacherGradeStudent({
    required this.id,
    required this.name,
    required this.code,
    required this.className,
    required this.avatarText,
    required this.statusLabel,
  });

  factory TeacherGradeStudent.fromJson(
    Map<String, dynamic> json, {
    String? fallbackClassName,
  }) {
    final student = _firstMap(json, const [
      'student',
      'studentInfo',
      'profile',
      'learner',
      'user',
    ]);
    final source = student.isEmpty ? json : {...json, ...student};
    final name =
        _stringFromKeys(source, const [
          'fullName',
          'name',
          'studentName',
          'displayName',
        ]) ??
        'Học sinh';
    final code = _stringFromKeys(source, const [
      'studentCode',
      'code',
      'studentNo',
    ]);
    final id =
        _stringFromKeys(source, const ['id', 'studentId', 'userId']) ??
        code ??
        name;

    return TeacherGradeStudent(
      id: id,
      name: name,
      code: code,
      className:
          _stringFromKeys(source, const ['className', 'class']) ??
          fallbackClassName ??
          'Lớp học',
      avatarText:
          _stringFromKeys(source, const ['avatarText', 'initials']) ??
          _avatarText(name),
      statusLabel:
          _stringFromKeys(source, const [
            'statusLabel',
            'statusText',
            'learningStatus',
            'status',
          ]) ??
          'Đang học',
    );
  }
}

class TeacherClassStudentsResult {
  final TeacherClassSummary classSummary;
  final List<TeacherGradeStudent> students;

  const TeacherClassStudentsResult({
    required this.classSummary,
    required this.students,
  });
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
