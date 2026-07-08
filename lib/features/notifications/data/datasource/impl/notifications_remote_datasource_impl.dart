import 'package:myfschool/core/error/exceptions.dart';
import 'package:myfschool/core/network/api_client.dart';
import 'package:myfschool/features/notifications/data/datasource/notifications_remote_datasource.dart';
import 'package:myfschool/features/notifications/data/models/notification_models.dart';

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  static const String notificationsPath = String.fromEnvironment(
    'NOTIFICATIONS_PATH',
    defaultValue: '/students/me/notifications',
  );

  @override
  Future<NotificationFeed> getNotifications() async {
    final response = await ApiClient.dio.get(notificationsPath);
    final responseData = _jsonMap(response.data);

    if (responseData.isEmpty) {
      if (response.data is List) {
        return NotificationFeed.fromJson({'data': response.data});
      }

      throw const ParsingException('Invalid notifications response');
    }

    _throwIfFailed(responseData, 'Cannot load notifications');

    return NotificationFeed.fromJson(responseData);
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
