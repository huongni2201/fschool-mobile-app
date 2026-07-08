part of '../pages/exam_schedule_page.dart';

Color _statusColor(ExamStatus status) {
  return switch (status) {
    ExamStatus.upcoming => ExamScheduleColors.primary,
    ExamStatus.today => ExamScheduleColors.today,
    ExamStatus.finished => ExamScheduleColors.done,
    ExamStatus.cancelled => ExamScheduleColors.error,
    ExamStatus.unknown => ExamScheduleColors.textMuted,
  };
}

String _filterTitle(_ExamScheduleFilter filter) {
  return switch (filter) {
    _ExamScheduleFilter.upcoming => ExamScheduleStrings.upcomingSectionTitle,
    _ExamScheduleFilter.finished => ExamScheduleStrings.finishedSectionTitle,
    _ExamScheduleFilter.all => ExamScheduleStrings.allSectionTitle,
  };
}

String _emptyTitle(_ExamScheduleFilter filter) {
  return switch (filter) {
    _ExamScheduleFilter.upcoming => ExamScheduleStrings.emptyUpcomingTitle,
    _ExamScheduleFilter.finished => ExamScheduleStrings.emptyFinishedTitle,
    _ExamScheduleFilter.all => ExamScheduleStrings.emptyAllTitle,
  };
}

String _emptyMessage(_ExamScheduleFilter filter) {
  return switch (filter) {
    _ExamScheduleFilter.upcoming => ExamScheduleStrings.emptyUpcomingMessage,
    _ExamScheduleFilter.finished => ExamScheduleStrings.emptyFinishedMessage,
    _ExamScheduleFilter.all => ExamScheduleStrings.emptyAllMessage,
  };
}

String _examErrorMessage(Object? error) {
  if (error == null) {
    return ExamScheduleStrings.defaultLoadFailed;
  }

  if (error is DioException) {
    final backendMessage = _extractBackendMessage(error.response?.data);

    if (backendMessage != null) return backendMessage;

    final statusCode = error.response?.statusCode;

    if (statusCode == 401 || statusCode == 403) {
      return ExamScheduleStrings.sessionExpired;
    }

    if (statusCode != null && statusCode >= 500) {
      return ExamScheduleStrings.serverError;
    }

    return ExamScheduleStrings.connectionError;
  }

  if (error is AppException) return error.message;

  return ExamScheduleStrings.defaultLoadFailed;
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

String _fullDateLabel(DateTime? date) {
  if (date == null) return ExamScheduleStrings.dateNotUpdated;

  return '${_weekdayLabel(date.weekday)}, ${_dateLabel(date)}';
}

String _dateLabel(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

String _weekdayLabel(int weekday) {
  return switch (weekday) {
    DateTime.monday => ExamScheduleStrings.monday,
    DateTime.tuesday => ExamScheduleStrings.tuesday,
    DateTime.wednesday => ExamScheduleStrings.wednesday,
    DateTime.thursday => ExamScheduleStrings.thursday,
    DateTime.friday => ExamScheduleStrings.friday,
    DateTime.saturday => ExamScheduleStrings.saturday,
    _ => ExamScheduleStrings.sunday,
  };
}

String _shortWeekdayLabel(int weekday) {
  return switch (weekday) {
    DateTime.monday => ExamScheduleStrings.mondayShort,
    DateTime.tuesday => ExamScheduleStrings.tuesdayShort,
    DateTime.wednesday => ExamScheduleStrings.wednesdayShort,
    DateTime.thursday => ExamScheduleStrings.thursdayShort,
    DateTime.friday => ExamScheduleStrings.fridayShort,
    DateTime.saturday => ExamScheduleStrings.saturdayShort,
    _ => ExamScheduleStrings.sundayShort,
  };
}
