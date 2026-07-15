class ParentDashboard {
  final String? parentName;
  final int unreadNotificationCount;
  final DateTime? lastUpdatedAt;
  final List<ParentStudent> students;
  final List<ParentAlert> alerts;

  const ParentDashboard({
    required this.parentName,
    required this.unreadNotificationCount,
    required this.lastUpdatedAt,
    required this.students,
    required this.alerts,
  });

  factory ParentDashboard.fromJson(Map<String, dynamic> json) {
    final rawPayload = json['data'] ?? json['result'];
    final payload = _mapFromObject(rawPayload);
    final source = payload.isEmpty ? json : payload;
    final directStudents = _listFromObject(rawPayload);
    final parent = _firstMap(source, const [
      'parent',
      'guardian',
      'profile',
      'user',
      'account',
    ]);
    final studentSources = directStudents.isNotEmpty
        ? directStudents
        : _studentSources(source);

    return ParentDashboard(
      parentName:
          _stringFromKeys(parent, const ['fullName', 'name', 'displayName']) ??
          _stringFromKeys(source, const [
            'parentName',
            'guardianName',
            'fullName',
            'name',
            'displayName',
          ]),
      unreadNotificationCount:
          _intFromKeys(source, const [
            'unreadNotificationCount',
            'unreadNotifications',
            'newNotificationCount',
            'notificationCount',
          ]) ??
          0,
      lastUpdatedAt: _dateFromKeys(source, const [
        'lastUpdatedAt',
        'updatedAt',
        'generatedAt',
      ]),
      students: studentSources
          .map(ParentStudent.fromJson)
          .where((student) => student.name.trim().isNotEmpty)
          .toList(growable: false),
      alerts: _firstList(source, const [
        'alerts',
        'warnings',
        'attentionItems',
        'notifications',
      ]).map(ParentAlert.fromJson).toList(growable: false),
    );
  }
}

class ParentStudent {
  final String id;
  final String name;
  final String? code;
  final String className;
  final String avatarText;
  final String gradeAverageLabel;
  final String tuitionStatus;
  final String nextLessonLabel;
  final String statusLabel;
  final ParentTeacherContact teacherContact;
  final List<ParentAlert> alerts;

  const ParentStudent({
    required this.id,
    required this.name,
    required this.code,
    required this.className,
    required this.avatarText,
    required this.gradeAverageLabel,
    required this.tuitionStatus,
    required this.nextLessonLabel,
    required this.statusLabel,
    required this.teacherContact,
    required this.alerts,
  });

  factory ParentStudent.fromJson(Map<String, dynamic> json) {
    final student = _firstMap(json, const [
      'student',
      'studentInfo',
      'profile',
      'child',
      'user',
    ]);
    final source = student.isEmpty ? json : {...json, ...student};
    final classSource = _firstMap(source, const [
      'class',
      'classInfo',
      'homeroom',
    ]);
    final tuitionSource = _firstMap(source, const [
      'tuition',
      'fee',
      'payment',
      'finance',
    ]);
    final nextLessonSource = _firstMap(source, const [
      'nextLesson',
      'currentLesson',
      'currentClass',
      'nextClass',
      'lesson',
    ]);
    final teacherSource = _firstMap(source, const [
      'teacher',
      'homeroomTeacher',
      'advisor',
      'contactTeacher',
    ]);
    final name =
        _stringFromKeys(source, const [
          'fullName',
          'name',
          'studentName',
          'displayName',
        ]) ??
        'Học sinh';
    final code = _stringFromKeys(source, const [
      'studentCode',
      'code',
      'studentId',
    ]);
    final id =
        _stringFromKeys(source, const ['id', 'studentId', 'studentCode']) ??
        code ??
        name;

    return ParentStudent(
      id: id,
      name: name,
      code: code,
      className:
          _stringFromKeys(source, const [
            'className',
            'class',
            'homeroomClass',
          ]) ??
          _stringFromKeys(classSource, const ['name', 'title', 'className']) ??
          'Đang cập nhật',
      avatarText:
          _stringFromKeys(source, const ['avatarText', 'initials']) ??
          _avatarText(name),
      gradeAverageLabel: _scoreLabel(
        _valueFromKeys(source, const [
          'gradeAverage',
          'averageScore',
          'overallAverage',
          'gpa',
        ]),
      ),
      tuitionStatus: _tuitionStatus(source, tuitionSource),
      nextLessonLabel: _lessonLabel(source, nextLessonSource),
      statusLabel:
          _stringFromKeys(source, const [
            'statusLabel',
            'statusText',
            'learningStatus',
            'status',
          ]) ??
          'Đang cập nhật',
      teacherContact: ParentTeacherContact.fromJson(teacherSource),
      alerts: _firstList(source, const [
        'alerts',
        'warnings',
        'attentionItems',
      ]).map(ParentAlert.fromJson).toList(growable: false),
    );
  }
}

class ParentTeacherContact {
  final String name;
  final String role;
  final String? phone;
  final String? email;

  const ParentTeacherContact({
    required this.name,
    required this.role,
    this.phone,
    this.email,
  });

  factory ParentTeacherContact.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return const ParentTeacherContact(name: '', role: '');

    return ParentTeacherContact(
      name:
          _stringFromKeys(json, const [
            'fullName',
            'name',
            'teacherName',
            'displayName',
          ]) ??
          '',
      role:
          _stringFromKeys(json, const [
            'role',
            'title',
            'position',
            'teacherRole',
          ]) ??
          'Giáo viên chủ nhiệm',
      phone: _stringFromKeys(json, const ['phone', 'phoneNumber', 'mobile']),
      email: _stringFromKeys(json, const ['email', 'emailAddress']),
    );
  }

  bool get hasAny => name.isNotEmpty || phone != null || email != null;
}

class ParentAlert {
  final String title;
  final String message;
  final String type;

  const ParentAlert({
    required this.title,
    required this.message,
    required this.type,
  });

  factory ParentAlert.fromJson(Map<String, dynamic> json) {
    return ParentAlert(
      title:
          _stringFromKeys(json, const ['title', 'name', 'subject', 'label']) ??
          'Thông báo',
      message:
          _stringFromKeys(json, const [
            'message',
            'content',
            'description',
            'body',
          ]) ??
          '',
      type:
          _stringFromKeys(json, const [
            'type',
            'category',
            'level',
            'status',
          ]) ??
          'info',
    );
  }
}

List<Map<String, dynamic>> _studentSources(Map<String, dynamic> source) {
  final list = _firstList(source, const [
    'students',
    'children',
    'linkedStudents',
    'studentProfiles',
    'items',
  ]);

  if (list.isNotEmpty) return list;

  final student = _firstMap(source, const ['student', 'studentInfo', 'child']);
  if (student.isNotEmpty) return [student];

  if (_looksLikeStudent(source)) return [source];

  return const [];
}

bool _looksLikeStudent(Map<String, dynamic> source) {
  return _stringFromKeys(source, const [
        'studentName',
        'studentCode',
        'studentId',
        'className',
      ]) !=
      null;
}

String _tuitionStatus(
  Map<String, dynamic> source,
  Map<String, dynamic> tuitionSource,
) {
  return _stringFromKeys(source, const [
        'tuitionStatus',
        'feeStatus',
        'paymentStatus',
      ]) ??
      _stringFromKeys(tuitionSource, const [
        'statusLabel',
        'statusText',
        'status',
        'label',
      ]) ??
      _amountDueLabel(tuitionSource) ??
      'Đang cập nhật';
}

String? _amountDueLabel(Map<String, dynamic> source) {
  final amount = _doubleFromKeys(source, const [
    'remainingAmount',
    'amountDue',
    'unpaidAmount',
    'balance',
  ]);

  if (amount == null) return null;
  if (amount <= 0) return 'Đã hoàn tất';

  return 'Còn ${_compactAmount(amount)}';
}

String _compactAmount(double amount) {
  if (amount >= 1000000) {
    final value = amount / 1000000;
    return '${_trimTrailingZero(value)} triệu';
  }

  if (amount >= 1000) {
    final value = amount / 1000;
    return '${_trimTrailingZero(value)} nghìn';
  }

  return _trimTrailingZero(amount);
}

String _trimTrailingZero(double value) {
  final fixed = value.toStringAsFixed(
    value.truncateToDouble() == value ? 0 : 1,
  );
  return fixed.replaceAll('.', ',');
}

String _lessonLabel(
  Map<String, dynamic> source,
  Map<String, dynamic> lessonSource,
) {
  final explicit = _stringFromKeys(source, const [
    'nextLessonLabel',
    'currentLessonLabel',
    'lessonLabel',
  ]);
  if (explicit != null) return explicit;

  if (lessonSource.isEmpty) return 'Chưa có lịch gần nhất';

  final subject =
      _stringFromKeys(lessonSource, const [
        'subjectName',
        'subject',
        'courseName',
        'className',
        'name',
      ]) ??
      'Môn học';
  final period = _stringFromKeys(lessonSource, const [
    'periodLabel',
    'lessonLabel',
    'period',
    'slot',
  ]);
  final time = _stringFromKeys(lessonSource, const ['timeLabel', 'time']);

  return [
    subject,
    period,
    time,
  ].whereType<String>().where((value) => value.trim().isNotEmpty).join(' - ');
}

String _scoreLabel(Object? value) {
  if (value == null) return '--';

  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '--';

    final parsed = double.tryParse(trimmed.replaceAll(',', '.'));
    if (parsed != null) return _scoreLabel(parsed);

    return trimmed;
  }

  if (value is num) return value.toStringAsFixed(1);

  return '--';
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

  return DateTime.tryParse(raw);
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

Map<String, dynamic> _firstMap(Map<String, dynamic> source, List<String> keys) {
  for (final key in keys) {
    final map = _mapFromObject(source[key]);
    if (map.isNotEmpty) return map;
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

String _avatarText(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList(growable: false);

  if (parts.isEmpty) return 'PH';
  if (parts.length == 1) {
    final end = parts.first.length < 2 ? parts.first.length : 2;
    return parts.first.substring(0, end).toUpperCase();
  }

  return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
      .toUpperCase();
}
