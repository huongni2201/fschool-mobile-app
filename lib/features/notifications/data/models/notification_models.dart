class NotificationFeed {
  final int unreadCount;
  final List<NotificationItem> notifications;

  const NotificationFeed({
    required this.unreadCount,
    required this.notifications,
  });

  factory NotificationFeed.fromJson(Map<String, dynamic> json) {
    final rawPayload = json['data'] ?? json['result'];
    final payload = _mapFromObject(rawPayload);
    final source = payload.isEmpty ? json : payload;
    final directList = _listFromObject(rawPayload);
    final items = directList.isNotEmpty
        ? directList
        : _firstList(source, const [
            'items',
            'notifications',
            'announcements',
            'studentNotifications',
            'data',
          ]);
    final notifications = _sortNotifications(
      items.map(NotificationItem.fromJson).toList(growable: false),
    );

    return NotificationFeed(
      unreadCount:
          _intFromKeys(source, const [
            'unreadCount',
            'unread',
            'totalUnread',
          ]) ??
          notifications.where((item) => !item.isRead).length,
      notifications: notifications,
    );
  }

  int get totalCount => notifications.length;
}

enum NotificationCategory { academic, tuition, request, system, event, general }

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationCategory category;
  final DateTime? createdAt;
  final bool isRead;
  final String actionLabel;
  final String deepLink;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.category,
    required this.createdAt,
    required this.isRead,
    required this.actionLabel,
    required this.deepLink,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    final createdAt = _dateFromKeys(json, const [
      'createdAt',
      'sentAt',
      'publishedAt',
      'date',
    ]);
    final rawRead = _valueFromKeys(json, const [
      'isRead',
      'read',
      'seen',
      'isSeen',
    ]);

    return NotificationItem(
      id:
          _stringFromKeys(json, const [
            'id',
            'notificationId',
            'announcementId',
          ]) ??
          '${_dateKey(createdAt)}-${_stringFromKeys(json, const ['title', 'subject']) ?? 'notification'}',
      title:
          _stringFromKeys(json, const ['title', 'subject', 'heading']) ??
          'Thông báo',
      message:
          _stringFromKeys(json, const [
            'message',
            'content',
            'body',
            'description',
          ]) ??
          '',
      category: _parseCategory(
        _stringFromKeys(json, const ['category', 'type', 'group', 'kind']),
      ),
      createdAt: createdAt,
      isRead: _boolValue(rawRead) ?? false,
      actionLabel:
          _stringFromKeys(json, const [
            'actionLabel',
            'ctaLabel',
            'buttonText',
          ]) ??
          '',
      deepLink:
          _stringFromKeys(json, const [
            'deepLink',
            'link',
            'targetUrl',
            'url',
          ]) ??
          '',
    );
  }
}

List<NotificationItem> _sortNotifications(List<NotificationItem> items) {
  final sorted = [...items];

  sorted.sort((left, right) {
    final leftDate = left.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final rightDate = right.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);

    return rightDate.compareTo(leftDate);
  });

  return sorted;
}

NotificationCategory _parseCategory(String? rawCategory) {
  final value = rawCategory?.toLowerCase().trim() ?? '';

  if (value.contains('grade') ||
      value.contains('score') ||
      value.contains('exam') ||
      value.contains('academic') ||
      value.contains('study') ||
      value.contains('điểm') ||
      value.contains('diem') ||
      value.contains('thi')) {
    return NotificationCategory.academic;
  }

  if (value.contains('tuition') ||
      value.contains('fee') ||
      value.contains('payment') ||
      value.contains('học phí') ||
      value.contains('hoc phi')) {
    return NotificationCategory.tuition;
  }

  if (value.contains('request') ||
      value.contains('form') ||
      value.contains('đơn') ||
      value.contains('don')) {
    return NotificationCategory.request;
  }

  if (value.contains('event') ||
      value.contains('activity') ||
      value.contains('sự kiện') ||
      value.contains('su kien')) {
    return NotificationCategory.event;
  }

  if (value.contains('system') || value.contains('account')) {
    return NotificationCategory.system;
  }

  return NotificationCategory.general;
}

DateTime? _dateFromKeys(Map<String, dynamic> source, List<String> keys) {
  for (final key in keys) {
    final parsedDate = _dateFromObject(source[key]);

    if (parsedDate != null) return parsedDate;
  }

  return null;
}

DateTime? _dateFromObject(Object? value) {
  if (value == null) return null;
  if (value is DateTime) return value;

  final raw = _stringValue(value);

  if (raw == null) return null;

  final isoDate = DateTime.tryParse(raw);

  if (isoDate != null) return isoDate;

  final localDate = RegExp(
    r'^(\d{1,2})[/-](\d{1,2})[/-](\d{4})$',
  ).firstMatch(raw);

  if (localDate == null) return null;

  final day = int.tryParse(localDate.group(1) ?? '');
  final month = int.tryParse(localDate.group(2) ?? '');
  final year = int.tryParse(localDate.group(3) ?? '');

  if (day == null || month == null || year == null) return null;

  return DateTime(year, month, day);
}

String _dateKey(DateTime? date) {
  if (date == null) return 'unknown-date';

  return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

Object? _valueFromKeys(Map<String, dynamic> source, List<String> keys) {
  for (final key in keys) {
    final value = source[key];

    if (value != null) return value;
  }

  return null;
}

Map<String, dynamic> _mapFromObject(Object? value) {
  if (value is Map<String, dynamic>) return value;

  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }

  return const {};
}

List<Map<String, dynamic>> _listFromObject(Object? value) {
  if (value is! List) return const [];

  return value
      .map(_mapFromObject)
      .where((item) => item.isNotEmpty)
      .toList(growable: false);
}

List<Map<String, dynamic>> _firstList(
  Map<String, dynamic> source,
  List<String> keys,
) {
  for (final key in keys) {
    final list = _listFromObject(source[key]);

    if (list.isNotEmpty) return list;
  }

  return const [];
}

String? _stringFromKeys(Map<String, dynamic> source, List<String> keys) {
  for (final key in keys) {
    final value = _stringValue(source[key]);

    if (value != null) return value;
  }

  return null;
}

String? _stringValue(Object? value) {
  if (value == null) return null;

  if (value is String) {
    final trimmed = value.trim();

    return trimmed.isEmpty ? null : trimmed;
  }

  if (value is num || value is bool) return value.toString();

  return null;
}

int? _intFromKeys(Map<String, dynamic> source, List<String> keys) {
  for (final key in keys) {
    final value = source[key];

    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value.trim());

      if (parsed != null) return parsed;
    }
  }

  return null;
}

bool? _boolValue(Object? value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final normalized = value.toLowerCase().trim();

    if (normalized == 'true' || normalized == '1' || normalized == 'yes') {
      return true;
    }
    if (normalized == 'false' || normalized == '0' || normalized == 'no') {
      return false;
    }
  }

  return null;
}
