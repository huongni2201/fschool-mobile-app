part of '../pages/notifications_page.dart';

String _notificationErrorMessage(Object? error) {
  if (error == null) {
    return NotificationStrings.defaultLoadFailed;
  }

  if (error is DioException) {
    final backendMessage = _extractBackendMessage(error.response?.data);

    if (backendMessage != null) return backendMessage;

    final statusCode = error.response?.statusCode;

    if (statusCode == 401 || statusCode == 403) {
      return NotificationStrings.sessionExpired;
    }

    if (statusCode != null && statusCode >= 500) {
      return NotificationStrings.serverError;
    }

    return NotificationStrings.connectionError;
  }

  if (error is AppException) return error.message;

  return NotificationStrings.defaultLoadFailed;
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

String _notificationTimeLabel(DateTime? date) {
  if (date == null) return NotificationStrings.unknownTime;

  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inMinutes < 1) return NotificationStrings.justNow;
  if (difference.inHours < 1) {
    return NotificationStrings.minuteAgo(difference.inMinutes);
  }
  if (difference.inDays < 1) {
    return NotificationStrings.hourAgo(difference.inHours);
  }
  if (difference.inDays < 7) {
    return NotificationStrings.dayAgo(difference.inDays);
  }

  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

Color _notificationCategoryColor(NotificationCategory category) {
  return switch (category) {
    NotificationCategory.academic => NotificationColors.academic,
    NotificationCategory.tuition => NotificationColors.tuition,
    NotificationCategory.request => NotificationColors.request,
    NotificationCategory.system => NotificationColors.system,
    NotificationCategory.event => NotificationColors.event,
    NotificationCategory.general => NotificationColors.general,
  };
}

IconData _notificationCategoryIcon(NotificationCategory category) {
  return switch (category) {
    NotificationCategory.academic => Icons.school_outlined,
    NotificationCategory.tuition => Icons.payments_outlined,
    NotificationCategory.request => Icons.edit_document,
    NotificationCategory.system => Icons.settings_outlined,
    NotificationCategory.event => Icons.campaign_outlined,
    NotificationCategory.general => Icons.notifications_none_rounded,
  };
}

String _notificationCategoryLabel(NotificationCategory category) {
  return switch (category) {
    NotificationCategory.academic => NotificationStrings.academicCategory,
    NotificationCategory.tuition => NotificationStrings.tuitionCategory,
    NotificationCategory.request => NotificationStrings.requestCategory,
    NotificationCategory.system => NotificationStrings.systemCategory,
    NotificationCategory.event => NotificationStrings.eventCategory,
    NotificationCategory.general => NotificationStrings.generalCategory,
  };
}

String _emptyNotificationTitle(_NotificationFilter filter) {
  return switch (filter) {
    _NotificationFilter.all => NotificationStrings.emptyAllTitle,
    _NotificationFilter.unread => NotificationStrings.emptyUnreadTitle,
  };
}

String _emptyNotificationMessage(_NotificationFilter filter) {
  return switch (filter) {
    _NotificationFilter.all => NotificationStrings.emptyAllMessage,
    _NotificationFilter.unread => NotificationStrings.emptyUnreadMessage,
  };
}
