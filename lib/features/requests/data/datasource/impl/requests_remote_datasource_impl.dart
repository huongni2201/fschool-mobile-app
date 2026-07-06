import 'package:myfschool/core/error/exceptions.dart';
import 'package:myfschool/core/network/api_client.dart';
import 'package:myfschool/features/requests/data/datasource/requests_remote_datasource.dart';
import 'package:myfschool/features/requests/data/models/request_display_models.dart';

class RequestsRemoteDataSourceImpl implements RequestsRemoteDataSource {
  static const String requestTypesPath = String.fromEnvironment(
    'REQUEST_TYPES_PATH',
    defaultValue: '/students/me/request-types',
  );
  static const String requestsPath = String.fromEnvironment(
    'REQUESTS_PATH',
    defaultValue: '/students/me/requests',
  );

  @override
  Future<List<RequestTypeItem>> getRequestTypes() async {
    final response = await ApiClient.dio.get(requestTypesPath);
    final responseData = _jsonMap(response.data);

    if (responseData.isEmpty && response.data is List) {
      return _jsonList(
        response.data as List,
      ).map(RequestTypeItem.fromJson).toList(growable: false);
    }

    _throwIfFailed(responseData, 'Cannot load request types');

    return _listFromResponse(responseData, const [
      'types',
      'requestTypes',
      'items',
    ]).map(RequestTypeItem.fromJson).toList(growable: false);
  }

  @override
  Future<List<StudentRequestItem>> getStudentRequests({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await ApiClient.dio.get(
      requestsPath,
      queryParameters: {'page': page, 'limit': limit},
    );
    final responseData = _jsonMap(response.data);

    if (responseData.isEmpty && response.data is List) {
      return _jsonList(
        response.data as List,
      ).map(StudentRequestItem.fromJson).toList(growable: false);
    }

    _throwIfFailed(responseData, 'Cannot load requests');

    return _listFromResponse(responseData, const [
      'items',
      'requests',
      'studentRequests',
      'data',
    ]).map(StudentRequestItem.fromJson).toList(growable: false);
  }

  List<Map<String, dynamic>> _listFromResponse(
    Map<String, dynamic> source,
    List<String> keys,
  ) {
    final directData = source['data'] ?? source['result'];

    if (directData is List) return _jsonList(directData);

    final payload = _payload(source);

    for (final key in keys) {
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
    if (source.isEmpty) throw ParsingException(fallbackMessage);
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
