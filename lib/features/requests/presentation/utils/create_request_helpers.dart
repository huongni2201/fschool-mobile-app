part of '../pages/create_request_page.dart';

String _fieldKey(RequestField field) {
  return field.key.trim().isNotEmpty ? field.key.trim() : field.label.trim();
}

String _fieldLabel(RequestField field) {
  final label = field.label.trim().isNotEmpty ? field.label.trim() : field.key;

  return field.required ? '$label *' : label;
}

String _fieldHint(RequestField field) {
  final label = field.label.trim().isNotEmpty ? field.label.trim() : field.key;

  return label.isEmpty ? RequestsStrings.requiredField : 'Nhập $label';
}

TextInputType? _keyboardType(RequestField field) {
  final normalized = field.type.toLowerCase();

  if (normalized.contains('number') || normalized.contains('amount')) {
    return TextInputType.number;
  }
  if (normalized.contains('email')) return TextInputType.emailAddress;
  if (normalized.contains('phone')) return TextInputType.phone;

  return null;
}

bool _isLongTextField(RequestField field) {
  final normalized = field.type.toLowerCase();

  return normalized.contains('textarea') ||
      normalized.contains('long') ||
      normalized.contains('note');
}

String _fileSizeLabel(int size) {
  if (size >= 1024 * 1024) {
    return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  if (size >= 1024) return '${(size / 1024).toStringAsFixed(1)}KB';

  return '${size}B';
}

String _requestErrorMessage(Object error) {
  if (error is AppException) return error.message;

  if (error is DioException) {
    final backendMessage = _backendMessage(error.response?.data);

    if (backendMessage != null) return backendMessage;

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout => 'Không thể kết nối đến máy chủ',
      _ => RequestsStrings.submitFailed,
    };
  }

  return RequestsStrings.submitFailed;
}

String? _backendMessage(Object? source) {
  if (source is Map) {
    final message = source['message'] ?? source['error'];

    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }

    return _backendMessage(source['data'] ?? source['result']);
  }

  return null;
}
