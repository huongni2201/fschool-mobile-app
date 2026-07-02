class HomeDashboard {
  final String studentName;
  final String? studentCode;
  final String avatarText;
  final String todayTitle;
  final HomeLesson? currentLesson;
  final List<HomeScheduleItem> schedules;
  final List<HomeGradeItem> recentGrades;

  const HomeDashboard({
    required this.studentName,
    required this.avatarText,
    required this.todayTitle,
    required this.currentLesson,
    required this.schedules,
    required this.recentGrades,
    this.studentCode,
  });

  factory HomeDashboard.fromJson(Map<String, dynamic> json) {
    final payload = _mapFromObject(json['data'] ?? json['result']);
    final source = payload.isEmpty ? json : payload;
    final student = _firstMap(source, const [
      'student',
      'studentInfo',
      'profile',
      'user',
      'account',
    ]);

    final studentName =
        _stringFromKeys(student, const [
          'fullName',
          'name',
          'studentName',
          'displayName',
        ]) ??
        _stringFromKeys(source, const [
          'fullName',
          'name',
          'studentName',
          'displayName',
        ]) ??
        'Học sinh';

    final studentCode =
        _stringFromKeys(student, const ['studentCode', 'code', 'studentId']) ??
        _stringFromKeys(source, const ['studentCode', 'code', 'studentId']);

    final scheduleItems = _firstList(source, const [
      'todaySchedule',
      'schedules',
      'schedule',
      'timetable',
      'classesToday',
      'lessons',
    ]).map(HomeScheduleItem.fromJson).toList(growable: false);

    final totalLessons =
        _intFromKeys(source, const [
          'totalLessonsToday',
          'todayLessons',
          'lessonCount',
          'totalLessons',
        ]) ??
        scheduleItems.length;

    final currentSource = _firstMap(source, const [
      'currentLesson',
      'currentClass',
      'currentSchedule',
      'currentPeriod',
      'now',
    ]);

    HomeLesson? currentLesson = currentSource.isEmpty
        ? null
        : HomeLesson.fromJson(currentSource, fallbackTotalLessons: totalLessons);

    currentLesson ??= scheduleItems
        .where((item) => item.status == HomeScheduleStatus.live)
        .map((item) => HomeLesson.fromSchedule(item, totalLessons))
        .firstOrNull;

    final gradeItems = _firstList(source, const [
      'recentGrades',
      'recentScores',
      'grades',
      'scores',
      'marks',
    ]).map(HomeGradeItem.fromJson).toList(growable: false);

    return HomeDashboard(
      studentName: studentName,
      studentCode: studentCode,
      avatarText: _avatarText(studentName),
      todayTitle:
          _stringFromKeys(source, const ['todayTitle', 'todayLabel', 'dateLabel']) ??
          _defaultTodayTitle(DateTime.now()),
      currentLesson: currentLesson,
      schedules: scheduleItems,
      recentGrades: gradeItems,
    );
  }
}

class HomeLesson {
  final String subject;
  final String periodLabel;
  final String room;
  final String teacherName;
  final String statusLabel;
  final int totalLessonsToday;

  const HomeLesson({
    required this.subject,
    required this.periodLabel,
    required this.room,
    required this.teacherName,
    required this.statusLabel,
    required this.totalLessonsToday,
  });

  factory HomeLesson.fromJson(
    Map<String, dynamic> json, {
    required int fallbackTotalLessons,
  }) {
    return HomeLesson(
      subject:
          _stringFromKeys(json, const [
            'subjectName',
            'subject',
            'courseName',
            'className',
            'name',
          ]) ??
          'Tiết học hiện tại',
      periodLabel: _periodLabel(json),
      room:
          _stringFromKeys(json, const ['roomName', 'room', 'classroom']) ?? '',
      teacherName:
          _stringFromKeys(json, const [
            'teacherName',
            'teacher',
            'lecturer',
            'instructor',
          ]) ??
          '',
      statusLabel:
          _stringFromKeys(json, const ['statusLabel', 'statusText', 'label']) ??
          'Đang diễn ra',
      totalLessonsToday:
          _intFromKeys(json, const [
            'totalLessonsToday',
            'todayLessons',
            'lessonCount',
            'totalLessons',
          ]) ??
          fallbackTotalLessons,
    );
  }

  factory HomeLesson.fromSchedule(HomeScheduleItem item, int totalLessonsToday) {
    return HomeLesson(
      subject: item.subject,
      periodLabel: item.periodLabel,
      room: item.room,
      teacherName: item.teacherName,
      statusLabel: item.statusLabel,
      totalLessonsToday: totalLessonsToday,
    );
  }

  String get detailLabel {
    return [
      periodLabel,
      room,
      teacherName.isEmpty ? null : 'GV $teacherName',
    ].whereType<String>().where((item) => item.trim().isNotEmpty).join(' · ');
  }
}

enum HomeScheduleStatus { done, live, next, normal }

class HomeScheduleItem {
  final String timeLabel;
  final String subject;
  final String periodLabel;
  final String room;
  final String teacherName;
  final String statusLabel;
  final HomeScheduleStatus status;

  const HomeScheduleItem({
    required this.timeLabel,
    required this.subject,
    required this.periodLabel,
    required this.room,
    required this.teacherName,
    required this.statusLabel,
    required this.status,
  });

  factory HomeScheduleItem.fromJson(Map<String, dynamic> json) {
    final status = _parseScheduleStatus(
      _stringFromKeys(json, const ['status', 'state', 'statusCode', 'type']),
    );

    return HomeScheduleItem(
      timeLabel: _timeLabel(json),
      subject:
          _stringFromKeys(json, const [
            'subjectName',
            'subject',
            'courseName',
            'className',
            'name',
          ]) ??
          'Môn học',
      periodLabel: _periodLabel(json),
      room:
          _stringFromKeys(json, const ['roomName', 'room', 'classroom']) ?? '',
      teacherName:
          _stringFromKeys(json, const [
            'teacherName',
            'teacher',
            'lecturer',
            'instructor',
          ]) ??
          '',
      statusLabel:
          _stringFromKeys(json, const ['statusLabel', 'statusText', 'label']) ??
          _defaultScheduleStatusLabel(status),
      status: status,
    );
  }

  String get detailLabel {
    return [
      periodLabel,
      room,
      teacherName.isEmpty ? null : teacherName,
    ].whereType<String>().where((item) => item.trim().isNotEmpty).join(' · ');
  }
}

class HomeGradeItem {
  final String subject;
  final double? score;
  final double maxScore;
  final String label;

  const HomeGradeItem({
    required this.subject,
    required this.score,
    required this.maxScore,
    required this.label,
  });

  factory HomeGradeItem.fromJson(Map<String, dynamic> json) {
    final score = _doubleFromKeys(json, const [
      'score',
      'value',
      'mark',
      'grade',
      'point',
    ]);
    final maxScore =
        _doubleFromKeys(json, const ['maxScore', 'scale', 'total']) ?? 10;

    return HomeGradeItem(
      subject:
          _stringFromKeys(json, const [
            'subjectName',
            'subject',
            'courseName',
            'name',
          ]) ??
          'Môn học',
      score: score,
      maxScore: maxScore <= 0 ? 10 : maxScore,
      label:
          _stringFromKeys(json, const [
            'performance',
            'rating',
            'rank',
            'label',
          ]) ??
          _gradeLabel(score),
    );
  }

  double get progress {
    final currentScore = score;

    if (currentScore == null || maxScore <= 0) return 0;

    return (currentScore / maxScore).clamp(0, 1).toDouble();
  }

  String get scoreLabel {
    final currentScore = score;

    if (currentScore == null) return '--';

    return currentScore.toStringAsFixed(1);
  }
}

extension _FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;

    if (!iterator.moveNext()) return null;

    return iterator.current;
  }
}

Map<String, dynamic> _mapFromObject(Object? value) {
  if (value is Map<String, dynamic>) return value;

  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }

  return const {};
}

Map<String, dynamic> _firstMap(Map<String, dynamic> source, List<String> keys) {
  for (final key in keys) {
    final value = source[key];
    final map = _mapFromObject(value);

    if (map.isNotEmpty) return map;
  }

  return const {};
}

List<Map<String, dynamic>> _firstList(
  Map<String, dynamic> source,
  List<String> keys,
) {
  for (final key in keys) {
    final value = source[key];

    if (value is List) {
      return value.map(_mapFromObject).where((item) => item.isNotEmpty).toList();
    }
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

double? _doubleFromKeys(Map<String, dynamic> source, List<String> keys) {
  for (final key in keys) {
    final value = source[key];

    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value.trim().replaceAll(',', '.'));

      if (parsed != null) return parsed;
    }
  }

  return null;
}

String _periodLabel(Map<String, dynamic> source) {
  final period = _stringFromKeys(source, const [
    'periodLabel',
    'lessonLabel',
    'periodText',
  ]);

  if (period != null) return period;

  final rawPeriod = _stringFromKeys(source, const [
    'period',
    'lesson',
    'slot',
    'periodNumber',
  ]);

  if (rawPeriod == null) return '';

  return rawPeriod.toLowerCase().contains('tiết') ? rawPeriod : 'Tiết $rawPeriod';
}

String _timeLabel(Map<String, dynamic> source) {
  final explicitTime = _stringFromKeys(source, const ['timeLabel', 'time']);

  if (explicitTime != null) return explicitTime;

  final start = _clockFromString(
    _stringFromKeys(source, const ['startTime', 'start', 'from']),
  );
  final end = _clockFromString(
    _stringFromKeys(source, const ['endTime', 'end', 'to']),
  );

  if (start != null && end != null) return '$start - $end';
  if (start != null) return start;

  return '--:--';
}

String? _clockFromString(String? value) {
  if (value == null) return null;

  final parsedDate = DateTime.tryParse(value);

  if (parsedDate != null) {
    return '${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}';
  }

  final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(value);

  if (match == null) return value;

  final hour = match.group(1)?.padLeft(2, '0') ?? '00';
  final minute = match.group(2) ?? '00';

  return '$hour:$minute';
}

HomeScheduleStatus _parseScheduleStatus(String? rawStatus) {
  final value = rawStatus?.toLowerCase().trim() ?? '';

  if (value.isEmpty) return HomeScheduleStatus.normal;

  if (value.contains('done') ||
      value.contains('complete') ||
      value.contains('finish') ||
      value.contains('past') ||
      value.contains('xong')) {
    return HomeScheduleStatus.done;
  }

  if (value.contains('live') ||
      value.contains('current') ||
      value.contains('ongoing') ||
      value.contains('progress') ||
      value.contains('đang') ||
      value.contains('dang')) {
    return HomeScheduleStatus.live;
  }

  if (value.contains('next') ||
      value.contains('upcoming') ||
      value.contains('tiếp') ||
      value.contains('tiep')) {
    return HomeScheduleStatus.next;
  }

  return HomeScheduleStatus.normal;
}

String _defaultScheduleStatusLabel(HomeScheduleStatus status) {
  return switch (status) {
    HomeScheduleStatus.done => 'Xong',
    HomeScheduleStatus.live => 'Live',
    HomeScheduleStatus.next => 'Tiếp',
    HomeScheduleStatus.normal => '',
  };
}

String _gradeLabel(double? score) {
  if (score == null) return 'Chưa có điểm';
  if (score >= 9) return 'Xuất sắc';
  if (score >= 8) return 'Giỏi';
  if (score >= 7) return 'Khá';
  if (score >= 6.5) return 'TB Khá';
  if (score >= 5) return 'Trung bình';

  return 'Cần cải thiện';
}

String _avatarText(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList(growable: false);

  if (parts.isEmpty) return 'HS';
  if (parts.length == 1) {
    final end = parts.first.length < 2 ? parts.first.length : 2;

    return parts.first.substring(0, end).toUpperCase();
  }

  return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
      .toUpperCase();
}

String _defaultTodayTitle(DateTime date) {
  final dayName = switch (date.weekday) {
    DateTime.monday => 'THỨ HAI',
    DateTime.tuesday => 'THỨ BA',
    DateTime.wednesday => 'THỨ TƯ',
    DateTime.thursday => 'THỨ NĂM',
    DateTime.friday => 'THỨ SÁU',
    DateTime.saturday => 'THỨ BẢY',
    _ => 'CHỦ NHẬT',
  };

  return 'HÔM NAY · $dayName';
}
