import 'package:myfschool/core/error/exceptions.dart';
import 'package:myfschool/core/network/api_client.dart';
import 'package:myfschool/core/storage/token_storage.dart';
import 'package:myfschool/features/schedule/data/datasource/schedule_remote_datasource.dart';
import 'package:myfschool/features/schedule/data/models/timetable_models.dart';

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  static const String timetablePath = String.fromEnvironment(
    'TIMETABLE_PATH',
    defaultValue: '/students/me/timetable',
  );
  static const String startDateParam = String.fromEnvironment(
    'TIMETABLE_START_DATE_PARAM',
    defaultValue: 'startDate',
  );
  static const String endDateParam = String.fromEnvironment(
    'TIMETABLE_END_DATE_PARAM',
    defaultValue: 'endDate',
  );

  @override
  Future<TimetableWeek> getWeeklyTimetable({
    required DateTime weekStart,
    String? studentId,
  }) async {
    final normalizedWeekStart = _dateOnly(weekStart);
    final weekEnd = normalizedWeekStart.add(const Duration(days: 6));
    final response = await ApiClient.dio.get(
      _pathForStudent(timetablePath, studentId, 'timetable'),
      queryParameters: {
        startDateParam: _formatDate(normalizedWeekStart),
        endDateParam: _formatDate(weekEnd),
      },
    );
    final responseData = _jsonMap(response.data);

    if (responseData.isEmpty) {
      if (response.data is List) {
        return TimetableWeek.fromJson(
          {'data': response.data},
          fallbackWeekStart: normalizedWeekStart,
          fallbackWeekEnd: weekEnd,
        );
      }

      throw const ParsingException('Invalid timetable response');
    }

    _throwIfFailed(responseData, 'Cannot load timetable');

    return TimetableWeek.fromJson(
      responseData,
      fallbackWeekStart: normalizedWeekStart,
      fallbackWeekEnd: weekEnd,
    );
  }

  String _pathForStudent(String studentPath, String? studentId, String suffix) {
    if (!TokenStorage.isParent || studentId == null || studentId.isEmpty) {
      return studentPath;
    }

    final encodedStudentId = Uri.encodeComponent(studentId);

    return '/parents/me/students/$encodedStudentId/$suffix';
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

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
