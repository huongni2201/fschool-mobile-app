part of '../pages/teacher_home_page.dart';

String _teacherHomeErrorMessage(Object? error) {
  if (error == null) return TeacherHomeStrings.loadFailedMessage;

  if (error is DioException) {
    final backendMessage = _extractBackendMessage(error.response?.data);
    if (backendMessage != null) return backendMessage;

    final statusCode = error.response?.statusCode;
    if (statusCode == 401 || statusCode == 403) {
      return TeacherHomeStrings.sessionExpired;
    }

    if (statusCode != null && statusCode >= 500) {
      return AppStrings.serverError;
    }

    return TeacherHomeStrings.connectionError;
  }

  if (error is AppException) return error.message;

  return TeacherHomeStrings.loadFailedMessage;
}

String? _extractBackendMessage(Object? data) {
  if (data is! Map) return null;

  final message = data['message'] ?? data['error'];

  if (message is String && message.trim().isNotEmpty) {
    return message.trim();
  }

  final nestedData = data['data'];
  if (nestedData is Map) return _extractBackendMessage(nestedData);

  return null;
}

Color _teacherWorkColor(String type) {
  final value = type.toLowerCase().trim();

  if (value.contains('urgent') ||
      value.contains('danger') ||
      value.contains('reject')) {
    return TeacherHomeColors.red;
  }

  if (value.contains('application') ||
      value.contains('request') ||
      value.contains('pending')) {
    return TeacherHomeColors.amber;
  }

  if (value.contains('grade') || value.contains('class')) {
    return TeacherHomeColors.blue;
  }

  return TeacherHomeColors.primary;
}

IconData _teacherWorkIcon(String type) {
  final value = type.toLowerCase().trim();

  if (value.contains('application') ||
      value.contains('request') ||
      value.contains('pending')) {
    return Icons.fact_check_outlined;
  }

  if (value.contains('grade') || value.contains('score')) {
    return Icons.edit_square;
  }

  if (value.contains('exam')) return Icons.event_note_outlined;
  if (value.contains('notification')) return Icons.campaign_outlined;

  return Icons.task_alt_rounded;
}
