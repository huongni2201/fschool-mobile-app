import 'package:myfschool/core/error/exceptions.dart';
import 'package:myfschool/core/network/api_client.dart';
import 'package:myfschool/features/teacher_home/data/datasource/teacher_grades_remote_datasource.dart';
import 'package:myfschool/features/teacher_home/data/models/teacher_dashboard.dart';
import 'package:myfschool/features/teacher_home/data/models/teacher_grade_models.dart';

class TeacherGradesRemoteDataSourceImpl
    implements TeacherGradesRemoteDataSource {
  static const String classStudentsPath = String.fromEnvironment(
    'TEACHER_CLASS_STUDENTS_PATH',
    defaultValue: '/teachers/me/classes/{classId}/students',
  );

  @override
  Future<TeacherClassStudentsResult> getClassStudents(
    TeacherClassSummary classSummary,
  ) async {
    final classId = classSummary.id.trim();

    if (classId.isEmpty) {
      throw const ParsingException('Class id is missing');
    }

    final response = await ApiClient.dio.get(_pathForClass(classId));
    final responseData = _jsonMap(response.data);

    if (responseData.isEmpty) {
      if (response.data is List) {
        return TeacherClassStudentsResult(
          classSummary: classSummary,
          students: _jsonList(response.data as List)
              .map(
                (item) => TeacherGradeStudent.fromJson(
                  item,
                  fallbackClassName: classSummary.name,
                ),
              )
              .toList(growable: false),
        );
      }

      throw const ParsingException('Invalid class students response');
    }

    _throwIfFailed(responseData, 'Cannot load class students');

    final payload = _payload(responseData);
    final students = _listFromResponse(responseData)
        .map(
          (item) => TeacherGradeStudent.fromJson(
            item,
            fallbackClassName: classSummary.name,
          ),
        )
        .toList(growable: false);
    final classInfo = _jsonMap(
      payload['classInfo'] ?? payload['class'] ?? payload['homeroom'],
    );

    return TeacherClassStudentsResult(
      classSummary: classInfo.isEmpty
          ? classSummary
          : TeacherClassSummary.fromJson({
              ...classSummaryToJson(classSummary),
              ...classInfo,
            }),
      students: students,
    );
  }

  String _pathForClass(String classId) {
    final encodedClassId = Uri.encodeComponent(classId);

    if (classStudentsPath.contains('{classId}')) {
      return classStudentsPath.replaceAll('{classId}', encodedClassId);
    }

    final separator = classStudentsPath.endsWith('/') ? '' : '/';

    return '$classStudentsPath$separator$encodedClassId/students';
  }

  Map<String, dynamic> classSummaryToJson(TeacherClassSummary classSummary) {
    return {
      'id': classSummary.id,
      'name': classSummary.name,
      'roleLabel': classSummary.roleLabel,
      'subjectName': classSummary.subjectName,
      'studentCount': classSummary.studentCount,
    };
  }

  List<Map<String, dynamic>> _listFromResponse(Map<String, dynamic> source) {
    final directList = source['data'] ?? source['result'];

    if (directList is List) return _jsonList(directList);

    final payload = _payload(source);

    for (final key in const [
      'students',
      'items',
      'members',
      'learners',
      'classStudents',
    ]) {
      final value = payload[key];

      if (value is List) return _jsonList(value);
    }

    return const [];
  }

  Map<String, dynamic> _payload(Map<String, dynamic> source) {
    final data = _jsonMap(source['data'] ?? source['result']);

    return data.isEmpty ? source : data;
  }

  List<Map<String, dynamic>> _jsonList(List<dynamic> source) {
    return source
        .map(_jsonMap)
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  Map<String, dynamic> _jsonMap(Object? value) {
    if (value is Map<String, dynamic>) return value;

    if (value is Map) {
      return value.map((key, value) => MapEntry(key.toString(), value));
    }

    return const {};
  }

  void _throwIfFailed(Map<String, dynamic> source, String fallbackMessage) {
    if (source['success'] != false) return;

    throw ServerException(_backendMessage(source) ?? fallbackMessage);
  }

  String? _backendMessage(Map<String, dynamic> source) {
    final message = source['message'] ?? source['error'];

    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }

    final data = _jsonMap(source['data']);

    if (data.isEmpty) return null;

    return _backendMessage(data);
  }
}
