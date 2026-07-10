import 'package:myfschool/core/error/exceptions.dart';
import 'package:myfschool/core/network/api_client.dart';
import 'package:myfschool/features/tuition/data/datasource/tuition_remote_datasource.dart';
import 'package:myfschool/features/tuition/data/models/tuition_models.dart';

class TuitionRemoteDataSourceImpl implements TuitionRemoteDataSource {
  static const String tuitionPath = String.fromEnvironment(
    'TUITION_PATH',
    defaultValue: '/students/me/tuition',
  );

  @override
  Future<TuitionOverview> getTuitionOverview() async {
    final response = await ApiClient.dio.get(tuitionPath);
    final responseData = _jsonMap(response.data);

    if (responseData.isEmpty) {
      throw const ParsingException('Invalid tuition response');
    }

    _throwIfFailed(responseData, 'Cannot load tuition overview');

    return TuitionOverview.fromJson(responseData);
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
