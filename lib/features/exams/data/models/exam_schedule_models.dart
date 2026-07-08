class ExamSchedule {
  final String termName;
  final DateTime? lastUpdatedAt;
  final List<ExamItem> exams;

  const ExamSchedule({
    required this.termName,
    required this.lastUpdatedAt,
    required this.exams,
  });

  factory ExamSchedule.fromJson(Map<String, dynamic> json) {
    final rawPayload = json['data'] ?? json['result'];
    final payload = _mapFromObject(rawPayload);
    final source = payload.isEmpty ? json : payload;
    final directList = _listFromObject(rawPayload);
    final examItems = directList.isNotEmpty
        ? directList
        : _firstList(source, const [
            'items',
            'exams',
            'examSchedules',
            'schedules',
            'studentExams',
            'data',
          ]);

    return ExamSchedule(
      termName:
          _stringFromKeys(source, const [
            'termName',
            'semesterName',
            'periodName',
            'academicTerm',
            'title',
          ]) ??
          'Học kỳ hiện tại',
      lastUpdatedAt: _dateFromKeys(source, const [
        'lastUpdatedAt',
        'updatedAt',
        'generatedAt',
      ]),
      exams: _sortExams(
        examItems.map(ExamItem.fromJson).toList(growable: false),
      ),
    );
  }

  int get totalExams => exams.length;

  int get upcomingExamCount {
    return exams
        .where(
          (exam) =>
              exam.status == ExamStatus.upcoming ||
              exam.status == ExamStatus.today ||
              exam.status == ExamStatus.unknown,
        )
        .length;
  }

  int get finishedExamCount {
    return exams.where((exam) => exam.status == ExamStatus.finished).length;
  }

  ExamItem? get nextExam {
    for (final exam in exams) {
      if (exam.status == ExamStatus.upcoming ||
          exam.status == ExamStatus.today ||
          exam.status == ExamStatus.unknown) {
        return exam;
      }
    }

    return null;
  }
}

enum ExamStatus { upcoming, today, finished, cancelled, unknown }

class ExamItem {
  final String id;
  final String subject;
  final String examType;
  final DateTime? date;
  final String startTime;
  final String endTime;
  final int? durationMinutes;
  final String room;
  final String seatNumber;
  final String form;
  final String note;
  final String statusLabel;
  final ExamStatus status;

  const ExamItem({
    required this.id,
    required this.subject,
    required this.examType,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.room,
    required this.seatNumber,
    required this.form,
    required this.note,
    required this.statusLabel,
    required this.status,
  });

  factory ExamItem.fromJson(Map<String, dynamic> json) {
    final subjectMap = _mapFromObject(json['subject'] ?? json['course']);
    final source = subjectMap.isEmpty ? json : {...json, ...subjectMap};
    final date =
        _dateFromKeys(source, const [
          'examDate',
          'date',
          'day',
          'scheduledDate',
          'startDate',
          'startedAt',
        ]) ??
        _dateFromObject(source['startTime']);
    final startTime = _clockFromObject(
      _valueFromKeys(source, const [
        'startTime',
        'start',
        'from',
        'beginTime',
        'startedAt',
      ]),
    );
    final endTime = _clockFromObject(
      _valueFromKeys(source, const [
        'endTime',
        'end',
        'to',
        'finishTime',
        'endedAt',
      ]),
    );
    final parsedStatus = _parseStatus(
      _stringFromKeys(source, const ['status', 'state', 'statusCode', 'type']),
    );
    final status = parsedStatus ?? _statusFromDate(date);

    return ExamItem(
      id:
          _stringFromKeys(source, const ['id', 'examId', 'scheduleId']) ??
          '${_dateKey(date)}-${startTime ?? ''}-${_stringFromKeys(source, const ['subjectName', 'subject', 'courseName', 'name', 'title']) ?? 'exam'}',
      subject:
          _stringFromKeys(source, const [
            'subjectName',
            'subject',
            'courseName',
            'name',
            'title',
          ]) ??
          'Môn thi',
      examType:
          _stringFromKeys(source, const [
            'examType',
            'typeName',
            'category',
            'kind',
          ]) ??
          'Kiểm tra',
      date: date == null ? null : _dateOnly(date),
      startTime: startTime ?? '',
      endTime: endTime ?? '',
      durationMinutes: _intFromKeys(source, const [
        'durationMinutes',
        'duration',
        'timeLimit',
      ]),
      room:
          _stringFromKeys(source, const [
            'roomName',
            'room',
            'classroom',
            'location',
          ]) ??
          '',
      seatNumber:
          _stringFromKeys(source, const [
            'seatNumber',
            'seatNo',
            'seat',
            'candidateNumber',
          ]) ??
          '',
      form:
          _stringFromKeys(source, const [
            'form',
            'format',
            'method',
            'examForm',
          ]) ??
          '',
      note:
          _stringFromKeys(source, const [
            'note',
            'description',
            'remark',
            'content',
          ]) ??
          '',
      statusLabel:
          _stringFromKeys(source, const [
            'statusLabel',
            'statusText',
            'stateLabel',
          ]) ??
          _defaultStatusLabel(status),
      status: status,
    );
  }

  String get timeLabel {
    if (startTime.isNotEmpty && endTime.isNotEmpty) {
      return '$startTime - $endTime';
    }
    if (startTime.isNotEmpty) return startTime;
    if (endTime.isNotEmpty) return endTime;

    return 'Chưa cập nhật';
  }

  String get durationLabel {
    final duration = durationMinutes;

    if (duration == null || duration <= 0) return '';

    return '$duration phút';
  }
}

List<ExamItem> _sortExams(List<ExamItem> exams) {
  final sorted = [...exams];

  sorted.sort((left, right) {
    final leftDate = left.date ?? DateTime(9999);
    final rightDate = right.date ?? DateTime(9999);
    final dateComparison = leftDate.compareTo(rightDate);

    if (dateComparison != 0) return dateComparison;

    return _minuteOfDay(
      left.startTime,
    ).compareTo(_minuteOfDay(right.startTime));
  });

  return sorted;
}

ExamStatus? _parseStatus(String? rawStatus) {
  final value = rawStatus?.toLowerCase().trim() ?? '';

  if (value.isEmpty) return null;

  if (value.contains('cancel') ||
      value.contains('hủy') ||
      value.contains('huy')) {
    return ExamStatus.cancelled;
  }

  if (value.contains('done') ||
      value.contains('complete') ||
      value.contains('finish') ||
      value.contains('past') ||
      value.contains('đã') ||
      value.contains('da thi')) {
    return ExamStatus.finished;
  }

  if (value.contains('today') || value.contains('hôm nay')) {
    return ExamStatus.today;
  }

  if (value.contains('upcoming') ||
      value.contains('future') ||
      value.contains('next') ||
      value.contains('sắp') ||
      value.contains('sap')) {
    return ExamStatus.upcoming;
  }

  return null;
}

ExamStatus _statusFromDate(DateTime? date) {
  if (date == null) return ExamStatus.unknown;

  final today = _dateOnly(DateTime.now());
  final examDate = _dateOnly(date);

  if (examDate.isBefore(today)) return ExamStatus.finished;
  if (_isSameDate(examDate, today)) return ExamStatus.today;

  return ExamStatus.upcoming;
}

String _defaultStatusLabel(ExamStatus status) {
  return switch (status) {
    ExamStatus.upcoming => 'Sắp thi',
    ExamStatus.today => 'Hôm nay',
    ExamStatus.finished => 'Đã thi',
    ExamStatus.cancelled => 'Đã hủy',
    ExamStatus.unknown => 'Chưa rõ',
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

String? _clockFromObject(Object? value) {
  if (value == null) return null;
  if (value is DateTime) return _clockLabel(value.hour, value.minute);

  final raw = _stringValue(value);

  if (raw == null) return null;

  final parsedDate = DateTime.tryParse(raw);

  if (parsedDate != null && raw.contains(':')) {
    return _clockLabel(parsedDate.hour, parsedDate.minute);
  }

  final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(raw);

  if (match == null) return raw;

  final hour = int.tryParse(match.group(1) ?? '');
  final minute = int.tryParse(match.group(2) ?? '');

  if (hour == null || minute == null) return raw;

  return _clockLabel(hour, minute);
}

String _clockLabel(int hour, int minute) {
  return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

int _minuteOfDay(String? clock) {
  if (clock == null) return 9999;

  final match = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(clock);

  if (match == null) return 9999;

  final hour = int.tryParse(match.group(1) ?? '');
  final minute = int.tryParse(match.group(2) ?? '');

  if (hour == null || minute == null) return 9999;

  return hour * 60 + minute;
}

DateTime _dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

String _dateKey(DateTime? date) {
  if (date == null) return 'unknown-date';

  final normalized = _dateOnly(date);

  return '${normalized.year.toString().padLeft(4, '0')}-${normalized.month.toString().padLeft(2, '0')}-${normalized.day.toString().padLeft(2, '0')}';
}

bool _isSameDate(DateTime left, DateTime right) {
  return left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;
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
