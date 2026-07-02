import 'package:myfschool/core/error/exceptions.dart';
import 'package:myfschool/core/network/api_client.dart';
import 'package:myfschool/features/home/data/datasource/home_remote_datasource.dart';
import 'package:myfschool/features/home/data/models/home_dashboard.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  static const String dashboardPath = String.fromEnvironment(
    'HOME_DASHBOARD_PATH',
    defaultValue: '/students/me/dashboard',
  );

  @override
  Future<HomeDashboard> getDashboard() async {
    final response = await ApiClient.dio.get(dashboardPath);
    final responseData = _jsonMap(response.data);

    if (responseData.isEmpty) {
      throw const ParsingException('Home dashboard response must be a JSON object');
    }

    if (responseData['success'] == false) {
      throw ServerException(
        _backendMessage(responseData) ?? 'Không thể tải dữ liệu trang chủ',
      );
    }

    return HomeDashboard.fromJson(responseData);
  }

  Map<String, dynamic> _jsonMap(Object? value) {
    if (value is Map<String, dynamic>) return value;

    if (value is Map) {
      return value.map((key, value) => MapEntry(key.toString(), value));
    }

    return const {};
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
