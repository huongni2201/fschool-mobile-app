import 'package:myfschool/core/error/exceptions.dart';
import 'package:myfschool/core/network/api_client.dart';
import 'package:myfschool/features/grades/data/datasource/grades_remote_datasource.dart';
import 'package:myfschool/features/grades/data/models/semester_grade_models.dart';

class GradesRemoteDataSourceImpl implements GradesRemoteDataSource {
  static const String periodsPath = String.fromEnvironment(
    'GRADE_PERIODS_PATH',
    defaultValue: '/students/me/academic-periods',
  );
  static const String summaryPath = String.fromEnvironment(
    'GRADE_SUMMARY_PATH',
    defaultValue: '/students/me/grades/summary',
  );
  static const String subjectDetailPath = String.fromEnvironment(
    'GRADE_SUBJECT_DETAIL_PATH',
    defaultValue: '/students/me/grades/subjects',
  );

  @override
  Future<List<SemesterOption>> getPeriods() async {
    final response = await ApiClient.dio.get(periodsPath);
    final responseData = _jsonMap(response.data);

    _throwIfFailed(responseData, 'Cannot load grade periods');

    final list = _listFromResponse(responseData);

    return list.map(SemesterOption.fromJson).toList(growable: false);
  }

  @override
  Future<SemesterGradeSummary> getSummary({
    required SemesterOption period,
  }) async {
    final response = await ApiClient.dio.get(
      summaryPath,
      queryParameters: {'periodId': period.key},
    );
    final responseData = _jsonMap(response.data);

    if (responseData.isEmpty) {
      throw const ParsingException('Invalid grade summary response');
    }

    _throwIfFailed(responseData, 'Cannot load grade summary');

    return SemesterGradeSummary.fromJson(responseData, fallbackPeriod: period);
  }

  @override
  Future<SubjectGrade> getSubjectDetail({
    required String periodId,
    required SubjectGrade subject,
  }) async {
    final encodedSubjectId = Uri.encodeComponent(subject.subjectId);
    final response = await ApiClient.dio.get(
      '$subjectDetailPath/$encodedSubjectId',
      queryParameters: {'periodId': periodId},
    );
    final responseData = _jsonMap(response.data);

    if (responseData.isEmpty) {
      throw const ParsingException('Invalid subject grade response');
    }

    _throwIfFailed(responseData, 'Cannot load subject grade detail');

    final payload = _payload(responseData);
    final subjectSource = _jsonMap(payload['subject']);
    final source = subjectSource.isEmpty
        ? payload
        : {...payload, ...subjectSource};
    final parsedSubject = SubjectGrade.fromJson(source);

    return parsedSubject.copyWith(
      average: parsedSubject.average ?? subject.average,
      scores: parsedSubject.scores.isEmpty
          ? subject.scores
          : parsedSubject.scores,
    );
  }

  List<Map<String, dynamic>> _listFromResponse(Map<String, dynamic> source) {
    final payload = _payload(source);
    final directList = source['data'] ?? source['result'];

    if (directList is List) return _jsonList(directList);

    for (final key in const ['periods', 'academicPeriods', 'items']) {
      final value = payload[key];

      if (value is List) return _jsonList(value);
    }

    return const [];
  }

  Map<String, dynamic> _payload(Map<String, dynamic> source) {
    final data = _jsonMap(source['data'] ?? source['result']);

    return data.isEmpty ? source : data;
  }

  List<Map<String, dynamic>> _jsonList(List<Object?> source) {
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
