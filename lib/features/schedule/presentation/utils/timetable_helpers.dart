part of '../pages/timetable_page.dart';

Color _statusColor(TimetableLessonStatus status) {
  return switch (status) {
    TimetableLessonStatus.done => AppColors.homeDone,
    TimetableLessonStatus.live => AppColors.homeOrange,
    TimetableLessonStatus.next => AppColors.homeNext,
    TimetableLessonStatus.normal => AppColors.homeTextMuted,
  };
}

String _timetableErrorMessage(Object? error) {
  if (error == null) {
    return 'Không thể tải thời khoá biểu. Vui lòng thử lại.';
  }

  if (error is DioException) {
    final backendMessage = _extractBackendMessage(error.response?.data);

    if (backendMessage != null) return backendMessage;

    final statusCode = error.response?.statusCode;

    if (statusCode == 401 || statusCode == 403) {
      return 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
    }

    if (statusCode != null && statusCode >= 500) {
      return 'Máy chủ đang lỗi, vui lòng thử lại sau.';
    }

    return 'Không thể kết nối đến máy chủ. Kiểm tra mạng hoặc địa chỉ API.';
  }

  if (error is AppException) return error.message;

  return 'Không thể tải thời khoá biểu. Vui lòng thử lại.';
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

DateTime _startOfWeek(DateTime date) {
  final normalizedDate = _dateOnly(date);

  return normalizedDate.subtract(Duration(days: normalizedDate.weekday - 1));
}

DateTime _dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

bool _weekContains(TimetableWeek week, DateTime date) {
  final normalizedDate = _dateOnly(date);

  return !normalizedDate.isBefore(week.weekStart) &&
      !normalizedDate.isAfter(week.weekEnd);
}

bool _isDateInWeek(DateTime date, DateTime weekStart) {
  final normalizedDate = _dateOnly(date);
  final normalizedWeekStart = _dateOnly(weekStart);
  final weekEnd = normalizedWeekStart.add(const Duration(days: 6));

  return !normalizedDate.isBefore(normalizedWeekStart) &&
      !normalizedDate.isAfter(weekEnd);
}

bool _isSameDate(DateTime left, DateTime right) {
  return left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;
}

String _weekRangeLabel(DateTime start, DateTime end) {
  return '${_dayMonthLabel(start)} - ${_dayMonthLabel(end)}';
}

String _dayMonthLabel(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
}

String _dateLabel(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

String _shortWeekdayLabel(int weekday) {
  return switch (weekday) {
    DateTime.monday => 'T2',
    DateTime.tuesday => 'T3',
    DateTime.wednesday => 'T4',
    DateTime.thursday => 'T5',
    DateTime.friday => 'T6',
    DateTime.saturday => 'T7',
    _ => 'CN',
  };
}
