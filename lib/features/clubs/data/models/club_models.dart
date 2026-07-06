class ClubItem {
  final String id;
  final String name;
  final String description;
  final String teacherName;
  final String location;
  final String scheduleLabel;
  final String status;
  final String statusLabel;
  final int? memberCount;

  const ClubItem({
    required this.id,
    required this.name,
    required this.description,
    required this.teacherName,
    required this.location,
    required this.scheduleLabel,
    required this.status,
    required this.statusLabel,
    required this.memberCount,
  });

  factory ClubItem.fromJson(Map<String, dynamic> json) {
    final status =
        _stringFromKeys(json, const [
          'status',
          'state',
          'registrationStatus',
        ]) ??
        '';
    final scheduleLabel =
        _stringFromKeys(json, const [
          'scheduleLabel',
          'schedule',
          'timeLabel',
          'meetingTime',
        ]) ??
        _scheduleFromParts(json);
    final clubName =
        _stringFromKeys(json, const ['name', 'clubName', 'title']) ??
        'Câu lạc bộ';

    return ClubItem(
      id:
          _stringFromKeys(json, const ['id', 'clubId', 'code']) ??
          '$clubName-${DateTime.now().microsecondsSinceEpoch}',
      name: clubName,
      description:
          _stringFromKeys(json, const ['description', 'summary', 'note']) ?? '',
      teacherName:
          _stringFromKeys(json, const [
            'teacherName',
            'mentorName',
            'instructorName',
            'supervisorName',
          ]) ??
          _stringFromKeys(_mapFromObject(json['teacher']), const ['name']) ??
          '',
      location:
          _stringFromKeys(json, const ['location', 'room', 'roomName']) ?? '',
      scheduleLabel: scheduleLabel,
      status: status,
      statusLabel:
          _stringFromKeys(json, const ['statusLabel', 'statusText', 'label']) ??
          _defaultStatusLabel(status),
      memberCount: _intFromKeys(json, const [
        'memberCount',
        'members',
        'totalMembers',
        'studentCount',
      ]),
    );
  }
}

Map<String, dynamic> _mapFromObject(Object? value) {
  if (value is Map<String, dynamic>) return value;

  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }

  return const {};
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

String _scheduleFromParts(Map<String, dynamic> json) {
  final weekday = _stringFromKeys(json, const ['weekday', 'dayOfWeek', 'day']);
  final start = _stringFromKeys(json, const ['startTime', 'from']);
  final end = _stringFromKeys(json, const ['endTime', 'to']);

  if (weekday == null && start == null && end == null) return '';

  final timeLabel = start != null && end != null ? '$start - $end' : start;

  return [?weekday, ?timeLabel].join(' · ');
}

String _defaultStatusLabel(String status) {
  final normalized = status.toLowerCase().trim();

  if (normalized.contains('joined') || normalized.contains('active')) {
    return 'Đang tham gia';
  }
  if (normalized.contains('pending')) return 'Chờ duyệt';
  if (normalized.contains('open')) return 'Đang mở';
  if (normalized.contains('closed')) return 'Đã đóng';

  return status.isEmpty ? 'Đang cập nhật' : status;
}
