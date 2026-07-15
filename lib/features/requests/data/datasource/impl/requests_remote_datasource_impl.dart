import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:myfschool/core/error/exceptions.dart';
import 'package:myfschool/core/network/api_client.dart';
import 'package:myfschool/core/storage/token_storage.dart';
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
  Future<List<RequestTypeItem>> getRequestTypes({String? studentId}) async {
    final response = await ApiClient.dio.get(
      _pathForStudent(requestTypesPath, studentId, 'request-types'),
    );
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
    String? studentId,
  }) async {
    final response = await ApiClient.dio.get(
      _pathForStudent(requestsPath, studentId, 'requests'),
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

  @override
  Future<StudentRequestItem> submitStudentRequest(
    CreateStudentRequestPayload payload, {
    String? studentId,
  }) async {
    final response = await ApiClient.dio.post(
      _pathForStudent(requestsPath, studentId, 'requests'),
      data: payload.hasAttachments
          ? await _formDataFromPayload(payload)
          : payload.toJson(),
      options: payload.hasAttachments
          ? Options(contentType: Headers.multipartFormDataContentType)
          : null,
    );
    final responseData = _jsonMap(response.data);

    if (responseData.isEmpty) {
      return StudentRequestItem.fromCreatedPayload(payload);
    }

    _throwIfFailed(responseData, 'Cannot submit request');

    final requestData = _requestFromResponse(responseData);

    if (requestData.isEmpty) {
      return StudentRequestItem.fromCreatedPayload(payload);
    }

    return StudentRequestItem.fromJson(requestData);
  }

  String _pathForStudent(String studentPath, String? studentId, String suffix) {
    if (!TokenStorage.isParent || studentId == null || studentId.isEmpty) {
      return studentPath;
    }

    final encodedStudentId = Uri.encodeComponent(studentId);

    return '/parents/me/students/$encodedStudentId/$suffix';
  }

  Future<FormData> _formDataFromPayload(
    CreateStudentRequestPayload payload,
  ) async {
    final fields = <String, dynamic>{};

    for (final entry in payload.toJson().entries) {
      final value = entry.value;

      fields[entry.key] = value is Map || value is List
          ? jsonEncode(value)
          : value;
    }

    fields['attachments'] = await Future.wait(
      payload.attachments.map(_multipartFileFromAttachment),
    );

    return FormData.fromMap(fields);
  }

  Future<MultipartFile> _multipartFileFromAttachment(
    RequestAttachmentPayload attachment,
  ) {
    final path = attachment.path;
    final bytes = attachment.bytes;

    if (path != null && path.isNotEmpty) {
      return MultipartFile.fromFile(path, filename: attachment.name);
    }

    if (bytes != null) {
      return Future.value(
        MultipartFile.fromBytes(bytes, filename: attachment.name),
      );
    }

    throw const ParsingException('Attachment file data is missing');
  }

  Map<String, dynamic> _requestFromResponse(Map<String, dynamic> source) {
    final payload = _payload(source);

    for (final key in const [
      'request',
      'studentRequest',
      'item',
      'createdRequest',
    ]) {
      final value = _jsonMap(payload[key]);

      if (value.isNotEmpty) return value;
    }

    if (_looksLikeRequest(payload)) return payload;
    if (_looksLikeRequest(source)) return source;

    return const {};
  }

  bool _looksLikeRequest(Map<String, dynamic> source) {
    return source.containsKey('id') ||
        source.containsKey('requestId') ||
        source.containsKey('status') ||
        source.containsKey('typeCode') ||
        source.containsKey('requestTypeCode');
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
