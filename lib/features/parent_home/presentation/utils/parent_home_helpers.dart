part of '../pages/parent_home_page.dart';

int _safeSelectedIndex(int currentIndex, int length) {
  if (length <= 0) return 0;
  if (currentIndex < 0) return 0;
  if (currentIndex >= length) return length - 1;

  return currentIndex;
}

ParentStudent _selectedStudent(ParentDashboard dashboard, int selectedIndex) {
  return dashboard.students[_safeSelectedIndex(
    selectedIndex,
    dashboard.students.length,
  )];
}

Color _alertColor(String type) {
  final value = type.toLowerCase().trim();

  if (value.contains('danger') ||
      value.contains('error') ||
      value.contains('urgent') ||
      value.contains('overdue') ||
      value.contains('late')) {
    return ParentHomeColors.red;
  }

  if (value.contains('warning') ||
      value.contains('fee') ||
      value.contains('tuition') ||
      value.contains('payment')) {
    return ParentHomeColors.amber;
  }

  if (value.contains('success') ||
      value.contains('grade') ||
      value.contains('progress')) {
    return ParentHomeColors.green;
  }

  return ParentHomeColors.blue;
}

IconData _alertIcon(String type) {
  final value = type.toLowerCase().trim();

  if (value.contains('fee') ||
      value.contains('tuition') ||
      value.contains('payment')) {
    return Icons.payments_outlined;
  }

  if (value.contains('grade') || value.contains('progress')) {
    return Icons.trending_up_rounded;
  }

  if (value.contains('danger') ||
      value.contains('error') ||
      value.contains('urgent')) {
    return Icons.priority_high_rounded;
  }

  return Icons.campaign_outlined;
}

bool _isAttendanceAlert(ParentAlert alert) {
  final type = alert.type.toLowerCase();
  final title = alert.title.toLowerCase();
  final message = alert.message.toLowerCase();

  return type.contains('attendance') ||
      type.contains('absence') ||
      title.contains('attendance') ||
      title.contains('absence') ||
      message.contains('attendance') ||
      message.contains('absence');
}

String _parentHomeErrorMessage(Object? error) {
  if (error == null) return ParentHomeStrings.loadFailedMessage;

  if (error is DioException) {
    final backendMessage = _extractBackendMessage(error.response?.data);
    if (backendMessage != null) return backendMessage;

    final statusCode = error.response?.statusCode;
    if (statusCode == 401 || statusCode == 403) {
      return ParentHomeStrings.sessionExpired;
    }

    if (statusCode != null && statusCode >= 500) {
      return AppStrings.serverError;
    }

    return ParentHomeStrings.connectionError;
  }

  if (error is AppException) return error.message;

  return ParentHomeStrings.loadFailedMessage;
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
