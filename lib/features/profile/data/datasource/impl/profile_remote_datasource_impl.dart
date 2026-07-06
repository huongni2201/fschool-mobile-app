import 'package:myfschool/core/error/exceptions.dart';
import 'package:myfschool/core/network/api_client.dart';
import 'package:myfschool/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:myfschool/features/profile/data/models/student_profile.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  static const String profilePath = String.fromEnvironment(
    'PROFILE_PATH',
    defaultValue: '/students/me/profile',
  );

  @override
  Future<StudentProfile> getProfile() async {
    final response = await ApiClient.dio.get(profilePath);
    final responseData = _jsonMap(response.data);

    if (responseData.isEmpty) {
      throw const ParsingException('Invalid profile response');
    }

    _throwIfFailed(responseData, 'Cannot load profile');

    return StudentProfile.fromJson(responseData);
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
