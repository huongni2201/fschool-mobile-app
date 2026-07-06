import 'package:myfschool/core/error/exceptions.dart';
import 'package:myfschool/core/network/api_client.dart';
import 'package:myfschool/features/clubs/data/datasource/clubs_remote_datasource.dart';
import 'package:myfschool/features/clubs/data/models/club_models.dart';

class ClubsRemoteDataSourceImpl implements ClubsRemoteDataSource {
  static const String clubsPath = String.fromEnvironment(
    'CLUBS_PATH',
    defaultValue: '/students/me/clubs',
  );

  @override
  Future<List<ClubItem>> getClubs() async {
    final response = await ApiClient.dio.get(clubsPath);
    final responseData = _jsonMap(response.data);

    if (responseData.isEmpty && response.data is List) {
      return _jsonList(
        response.data as List,
      ).map(ClubItem.fromJson).toList(growable: false);
    }

    _throwIfFailed(responseData, 'Cannot load clubs');

    return _listFromResponse(
      responseData,
    ).map(ClubItem.fromJson).toList(growable: false);
  }

  List<Map<String, dynamic>> _listFromResponse(Map<String, dynamic> source) {
    final directData = source['data'] ?? source['result'];

    if (directData is List) return _jsonList(directData);

    final payload = _payload(source);

    for (final key in const ['items', 'clubs', 'studentClubs', 'data']) {
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
