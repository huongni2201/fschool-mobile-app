class TimetableWeek {
  final DateTime weekStart;
  final DateTime weekEnd;
  final List<TimetableDay> days;

  const TimetableWeek({
    required this.weekStart,
    required this.weekEnd,
    required this.days,
  });

  factory TimetableWeek.fromJson(
    Map<String, dynamic> json, {
    required DateTime fallbackWeekStart,
    required DateTime fallbackWeekEnd,
  }) {
    final rawPayload = json['data'] ?? json['result'];
    final payload = _mapFromObject(rawPayload);
    final source = payload.isEmpty ? json : payload;
    final weekStart = _dateOnly(
      _dateFromKeys(source, const [
            'weekStart',
            'startDate',
            'fromDate',
            'from',
            'start',
          ]) ??
          fallbackWeekStart,
    );
    final weekEnd = _dateOnly(
      _dateFromKeys(source, const [
            'weekEnd',
            'endDate',
            'toDate',
            'to',
            'end',
          ]) ??
          fallbackWeekEnd,
    );

    final explicitDays = _firstList(source, const [
      'days',
      'weekDays',
      'daySchedules',
      'dailySchedules',
    ]);
    final parsedDays = <TimetableDay>[];

    if (explicitDays.isNotEmpty) {
      for (var index = 0; index < explicitDays.length; index++) {
        parsedDays.add(
          TimetableDay.fromJson(
            explicitDays[index],
            fallbackDate: weekStart.add(Duration(days: index)),
          ),
        );
      }
    } else {
      final directList = _listFromObject(rawPayload);
      final candidateLessons = directList.isNotEmpty
          ? directList
          : _firstList(source, const [
              'lessons',
              'classes',
              'items',
              'schedules',
              'schedule',
              'timetable',
            ]);

      if (candidateLessons.any(_hasNestedLessonList)) {
        for (var index = 0; index < candidateLessons.length; index++) {
          parsedDays.add(
            TimetableDay.fromJson(
              candidateLessons[index],
              fallbackDate: weekStart.add(Duration(days: index)),
            ),
          );
        }
      } else {
        parsedDays.addAll(_daysFromFlatLessons(candidateLessons, weekStart));
      }
    }

    return TimetableWeek(
      weekStart: weekStart,
      weekEnd: weekEnd,
      days: _completeWeekDays(
        weekStart: weekStart,
        weekEnd: weekEnd,
        parsedDays: parsedDays,
      ),
    );
  }

  int get totalLessons {
    return days.fold(0, (total, day) => total + day.lessons.length);
  }

  TimetableDay dayFor(DateTime date) {
    final key = _dateKey(date);

    return days.firstWhere(
      (day) => _dateKey(day.date) == key,
      orElse: () => TimetableDay.empty(date),
    );
  }
}

class TimetableDay {
  final DateTime date;
  final String label;
  final List<TimetableLesson> lessons;

  const TimetableDay({
    required this.date,
    required this.label,
    required this.lessons,
  });

  factory TimetableDay.empty(DateTime date) {
    final normalizedDate = _dateOnly(date);

    return TimetableDay(
      date: normalizedDate,
      label: _weekdayName(normalizedDate.weekday),
      lessons: const [],
    );
  }

  factory TimetableDay.fromJson(
    Map<String, dynamic> json, {
    DateTime? fallbackDate,
  }) {
    final date = _dateOnly(
      _dateFromKeys(json, const ['date', 'day', 'dayDate', 'studyDate']) ??
          fallbackDate ??
          DateTime.now(),
    );
    final lessonItems = _firstList(json, const [
      'lessons',
      'classes',
      'items',
      'schedules',
      'periods',
    ]);
    final lessons = lessonItems.isEmpty && _looksLikeLesson(json)
        ? [TimetableLesson.fromJson(json, fallbackDate: date)]
        : lessonItems
              .map((item) => TimetableLesson.fromJson(item, fallbackDate: date))
              .toList(growable: false);

    return TimetableDay(
      date: date,
      label:
          _stringFromKeys(json, const [
            'label',
            'dayName',
            'weekdayName',
            'weekday',
            'dayOfWeekName',
          ]) ??
          _weekdayName(date.weekday),
      lessons: _sortedLessons(lessons),
    );
  }

  bool get hasLessons => lessons.isNotEmpty;
}

enum TimetableLessonStatus { done, live, next, normal }

class TimetableLesson {
  final String id;
  final DateTime? date;
  final String subject;
  final String className;
  final String room;
  final String teacherName;
  final String periodLabel;
  final int? period;
  final String startTime;
  final String endTime;
  final int? startMinute;
  final int? endMinute;
  final String statusLabel;
  final TimetableLessonStatus status;
  final String note;

  const TimetableLesson({
    required this.id,
    required this.date,
    required this.subject,
    required this.className,
    required this.room,
    required this.teacherName,
    required this.periodLabel,
    required this.period,
    required this.startTime,
    required this.endTime,
    required this.startMinute,
    required this.endMinute,
    required this.statusLabel,
    required this.status,
    required this.note,
  });

  factory TimetableLesson.fromJson(
    Map<String, dynamic> json, {
    DateTime? fallbackDate,
  }) {
    final subjectMap = _mapFromObject(json['subject'] ?? json['course']);
    final source = subjectMap.isEmpty ? json : {...json, ...subjectMap};
    final date =
        _dateFromKeys(source, const [
          'date',
          'day',
          'studyDate',
          'lessonDate',
          'startDate',
        ]) ??
        fallbackDate;
    final startTime = _clockFromString(
      _stringFromKeys(source, const [
        'startTime',
        'start',
        'from',
        'beginTime',
        'startedAt',
      ]),
    );
    final endTime = _clockFromString(
      _stringFromKeys(source, const [
        'endTime',
        'end',
        'to',
        'finishTime',
        'endedAt',
      ]),
    );
    final startMinute = _minuteOfDay(startTime);
    final endMinute = _minuteOfDay(endTime);
    final parsedStatus = _parseLessonStatus(
      _stringFromKeys(source, const ['status', 'state', 'statusCode', 'type']),
    );
    final status =
        parsedStatus ?? _statusFromClock(date, startMinute, endMinute);
    final period = _intFromKeys(source, const [
      'period',
      'periodNumber',
      'lesson',
      'slot',
      'slotIndex',
    ]);

    return TimetableLesson(
      id:
          _stringFromKeys(source, const ['id', 'scheduleId', 'lessonId']) ??
          '${_dateKey(date ?? DateTime.now())}-${period ?? startTime ?? ''}-${_stringFromKeys(source, const ['subjectName', 'subject', 'name']) ?? 'lesson'}',
      date: date == null ? null : _dateOnly(date),
      subject:
          _stringFromKeys(source, const [
            'subjectName',
            'subject',
            'courseName',
            'name',
            'title',
          ]) ??
          'Môn học',
      className:
          _stringFromKeys(source, const [
            'className',
            'class',
            'group',
            'section',
          ]) ??
          '',
      room:
          _stringFromKeys(source, const [
            'roomName',
            'room',
            'classroom',
            'location',
          ]) ??
          '',
      teacherName:
          _stringFromKeys(source, const [
            'teacherName',
            'teacher',
            'lecturer',
            'instructor',
          ]) ??
          '',
      periodLabel: _periodLabel(source, period),
      period: period,
      startTime: startTime ?? '',
      endTime: endTime ?? '',
      startMinute: startMinute,
      endMinute: endMinute,
      statusLabel:
          _stringFromKeys(source, const [
            'statusLabel',
            'statusText',
            'label',
          ]) ??
          _defaultStatusLabel(status),
      status: status,
      note:
          _stringFromKeys(source, const [
            'note',
            'description',
            'remark',
            'content',
          ]) ??
          '',
    );
  }

  TimetableLesson copyWith({DateTime? date}) {
    return TimetableLesson(
      id: id,
      date: date ?? this.date,
      subject: subject,
      className: className,
      room: room,
      teacherName: teacherName,
      periodLabel: periodLabel,
      period: period,
      startTime: startTime,
      endTime: endTime,
      startMinute: startMinute,
      endMinute: endMinute,
      statusLabel: statusLabel,
      status: status,
      note: note,
    );
  }

  String get timeLabel {
    if (startTime.isNotEmpty && endTime.isNotEmpty) {
      return '$startTime - $endTime';
    }
    if (startTime.isNotEmpty) return startTime;

    return '--:--';
  }

  String get detailLabel {
    return [
      if (periodLabel.isNotEmpty) periodLabel,
      if (room.isNotEmpty) room,
      if (teacherName.isNotEmpty) 'GV $teacherName',
    ].join(' · ');
  }
}

List<TimetableDay> _daysFromFlatLessons(
  List<Map<String, dynamic>> lessons,
  DateTime weekStart,
) {
  final groupedLessons = <String, List<TimetableLesson>>{};
  final dates = <String, DateTime>{};

  for (final lessonSource in lessons) {
    final fallbackDate = _dateFromWeekday(lessonSource, weekStart);
    final lesson = TimetableLesson.fromJson(
      lessonSource,
      fallbackDate: fallbackDate,
    );
    final lessonDate = _dateOnly(lesson.date ?? fallbackDate ?? weekStart);
    final key = _dateKey(lessonDate);

    dates[key] = lessonDate;
    groupedLessons
        .putIfAbsent(key, () => [])
        .add(lesson.copyWith(date: lessonDate));
  }

  return groupedLessons.entries
      .map(
        (entry) => TimetableDay(
          date: dates[entry.key] ?? weekStart,
          label: _weekdayName((dates[entry.key] ?? weekStart).weekday),
          lessons: _sortedLessons(entry.value),
        ),
      )
      .toList(growable: false);
}

List<TimetableDay> _completeWeekDays({
  required DateTime weekStart,
  required DateTime weekEnd,
  required List<TimetableDay> parsedDays,
}) {
  final parsedByDate = {for (final day in parsedDays) _dateKey(day.date): day};
  final length = weekEnd.difference(weekStart).inDays.clamp(0, 6).toInt() + 1;

  return List.generate(length, (index) {
    final date = _dateOnly(weekStart.add(Duration(days: index)));
    final parsed = parsedByDate[_dateKey(date)];

    if (parsed == null) return TimetableDay.empty(date);

    return TimetableDay(
      date: date,
      label: parsed.label,
      lessons: _sortedLessons(parsed.lessons),
    );
  }, growable: false);
}

List<TimetableLesson> _sortedLessons(List<TimetableLesson> lessons) {
  final sorted = [...lessons];

  sorted.sort((left, right) {
    final leftTime = left.startMinute ?? (left.period ?? 9999);
    final rightTime = right.startMinute ?? (right.period ?? 9999);

    return leftTime.compareTo(rightTime);
  });

  return sorted;
}

bool _hasNestedLessonList(Map<String, dynamic> source) {
  for (final key in const ['lessons', 'classes', 'items', 'schedules']) {
    if (source[key] is List) return true;
  }

  return false;
}

bool _looksLikeLesson(Map<String, dynamic> source) {
  return _stringFromKeys(source, const [
        'subjectName',
        'subject',
        'courseName',
        'name',
        'title',
      ]) !=
      null;
}

DateTime? _dateFromWeekday(Map<String, dynamic> source, DateTime weekStart) {
  final rawWeekday =
      _intFromKeys(source, const ['weekdayIndex', 'weekdayNumber']) ??
      _weekdayNumberFromString(
        _stringFromKeys(source, const [
          'weekday',
          'dayOfWeek',
          'dayName',
          'thu',
        ]),
      );

  if (rawWeekday == null) return null;

  final weekday = rawWeekday.clamp(DateTime.monday, DateTime.sunday).toInt();

  return _dateOnly(weekStart.add(Duration(days: weekday - DateTime.monday)));
}

int? _weekdayNumberFromString(String? value) {
  if (value == null) return null;

  final normalized = value.toLowerCase().trim();
  final parsedNumber = int.tryParse(normalized);

  if (parsedNumber != null) {
    if (parsedNumber == 8) return DateTime.sunday;

    return parsedNumber.clamp(DateTime.monday, DateTime.sunday).toInt();
  }

  if (normalized.contains('mon') || normalized.contains('hai')) {
    return DateTime.monday;
  }
  if (normalized.contains('tue') || normalized.contains('ba')) {
    return DateTime.tuesday;
  }
  if (normalized.contains('wed') || normalized.contains('tư')) {
    return DateTime.wednesday;
  }
  if (normalized.contains('thu') || normalized.contains('năm')) {
    return DateTime.thursday;
  }
  if (normalized.contains('fri') || normalized.contains('sáu')) {
    return DateTime.friday;
  }
  if (normalized.contains('sat') || normalized.contains('bảy')) {
    return DateTime.saturday;
  }
  if (normalized.contains('sun') || normalized.contains('chủ nhật')) {
    return DateTime.sunday;
  }

  return null;
}

String _weekdayName(int weekday) {
  return switch (weekday) {
    DateTime.monday => 'Thứ 2',
    DateTime.tuesday => 'Thứ 3',
    DateTime.wednesday => 'Thứ 4',
    DateTime.thursday => 'Thứ 5',
    DateTime.friday => 'Thứ 6',
    DateTime.saturday => 'Thứ 7',
    _ => 'CN',
  };
}

String _periodLabel(Map<String, dynamic> source, int? period) {
  final explicitLabel = _stringFromKeys(source, const [
    'periodLabel',
    'lessonLabel',
    'periodText',
    'slotLabel',
  ]);

  if (explicitLabel != null) return explicitLabel;
  if (period == null) return '';

  return 'Tiết $period';
}

String? _clockFromString(String? value) {
  if (value == null) return null;

  final parsedDate = DateTime.tryParse(value);

  if (parsedDate != null) {
    return _clockLabel(parsedDate.hour, parsedDate.minute);
  }

  final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(value);

  if (match == null) return value;

  final hour = int.tryParse(match.group(1) ?? '');
  final minute = int.tryParse(match.group(2) ?? '');

  if (hour == null || minute == null) return value;

  return _clockLabel(hour, minute);
}

String _clockLabel(int hour, int minute) {
  return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

int? _minuteOfDay(String? clock) {
  if (clock == null) return null;

  final match = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(clock);

  if (match == null) return null;

  final hour = int.tryParse(match.group(1) ?? '');
  final minute = int.tryParse(match.group(2) ?? '');

  if (hour == null || minute == null) return null;

  return hour * 60 + minute;
}

TimetableLessonStatus? _parseLessonStatus(String? rawStatus) {
  final value = rawStatus?.toLowerCase().trim() ?? '';

  if (value.isEmpty) return null;

  if (value.contains('done') ||
      value.contains('complete') ||
      value.contains('finish') ||
      value.contains('past') ||
      value.contains('xong')) {
    return TimetableLessonStatus.done;
  }

  if (value.contains('live') ||
      value.contains('current') ||
      value.contains('ongoing') ||
      value.contains('progress') ||
      value.contains('đang') ||
      value.contains('dang')) {
    return TimetableLessonStatus.live;
  }

  if (value.contains('next') ||
      value.contains('upcoming') ||
      value.contains('future') ||
      value.contains('sắp') ||
      value.contains('sap')) {
    return TimetableLessonStatus.next;
  }

  return TimetableLessonStatus.normal;
}

TimetableLessonStatus _statusFromClock(
  DateTime? date,
  int? startMinute,
  int? endMinute,
) {
  if (date == null) return TimetableLessonStatus.normal;

  final now = DateTime.now();
  final lessonDate = _dateOnly(date);
  final today = _dateOnly(now);

  if (lessonDate.isBefore(today)) return TimetableLessonStatus.done;
  if (lessonDate.isAfter(today)) return TimetableLessonStatus.normal;
  if (startMinute == null || endMinute == null) {
    return TimetableLessonStatus.normal;
  }

  final currentMinute = now.hour * 60 + now.minute;

  if (currentMinute > endMinute) return TimetableLessonStatus.done;
  if (currentMinute >= startMinute && currentMinute <= endMinute) {
    return TimetableLessonStatus.live;
  }
  if (currentMinute < startMinute) return TimetableLessonStatus.next;

  return TimetableLessonStatus.normal;
}

String _defaultStatusLabel(TimetableLessonStatus status) {
  return switch (status) {
    TimetableLessonStatus.done => 'Đã học',
    TimetableLessonStatus.live => 'Đang học',
    TimetableLessonStatus.next => 'Sắp tới',
    TimetableLessonStatus.normal => '',
  };
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

DateTime _dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

String _dateKey(DateTime date) {
  final normalized = _dateOnly(date);

  return '${normalized.year.toString().padLeft(4, '0')}-${normalized.month.toString().padLeft(2, '0')}-${normalized.day.toString().padLeft(2, '0')}';
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
