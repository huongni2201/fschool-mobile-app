import 'package:myfschool/core/error/exceptions.dart';
import 'package:myfschool/core/network/api_client.dart';
import 'package:myfschool/features/teacher_home/data/datasource/teacher_home_remote_datasource.dart';
import 'package:myfschool/features/teacher_home/data/models/teacher_dashboard.dart';

class TeacherHomeRemoteDataSourceImpl implements TeacherHomeRemoteDataSource {
  static const String dashboardPath = String.fromEnvironment(
    'TEACHER_DASHBOARD_PATH',
    defaultValue: '/teacher/dashboard',
  );

  @override
  Future<TeacherDashboard> getDashboard() async {
    final response = await ApiClient.dio.get(dashboardPath);
    final responseData = _jsonMap(response.data);

    if (responseData.isEmpty) {
      throw const ParsingException('Invalid teacher dashboard response');
    }

    _throwIfFailed(responseData, 'Cannot load teacher dashboard');

    return TeacherDashboard.fromJson(responseData);
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
