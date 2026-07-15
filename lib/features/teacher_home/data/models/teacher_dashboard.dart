class TeacherDashboard {
  final TeacherProfile teacher;
  final List<TeacherClassSession> todayClasses;
  final List<TeacherClassSummary> managedClasses;
  final TeacherClassSummary? homeroomClass;
  final int pendingApplications;
  final List<TeacherExam> upcomingExams;
  final List<TeacherNotification> recentNotifications;
  final List<TeacherTask> tasks;

  const TeacherDashboard({
    required this.teacher,
    required this.todayClasses,
    required this.managedClasses,
    required this.homeroomClass,
    required this.pendingApplications,
    required this.upcomingExams,
    required this.recentNotifications,
    required this.tasks,
  });

  factory TeacherDashboard.fromJson(Map<String, dynamic> json) {
    final rawPayload = json['data'] ?? json['result'];
    final payload = _mapFromObject(rawPayload);
    final source = payload.isEmpty ? json : payload;
    final teacherSource = _firstMap(source, const [
      'teacher',
      'teacherProfile',
      'profile',
      'user',
      'account',
    ]);
    final homeroom = _firstMap(source, const [
      'homeroomClass',
      'homeroom',
      'mainClass',
      'classTeacherAssignment',
    ]);

    return TeacherDashboard(
      teacher: TeacherProfile.fromJson(
        teacherSource.isEmpty ? source : teacherSource,
      ),
      todayClasses: _firstList(source, const [
        'todayClasses',
        'todayLessons',
        'teachingToday',
        'scheduleToday',
        'sessions',
      ]).map(TeacherClassSession.fromJson).toList(growable: false),
      managedClasses: _classSummaries(source),
      homeroomClass: homeroom.isEmpty
          ? null
          : TeacherClassSummary.fromJson(homeroom),
      pendingApplications:
          _intFromKeys(source, const [
            'pendingApplications',
            'pendingApplicationCount',
            'pendingRequests',
            'pendingRequestCount',
          ]) ??
          0,
      upcomingExams: _firstList(source, const [
        'upcomingExams',
        'exams',
        'examSchedule',
      ]).map(TeacherExam.fromJson).toList(growable: false),
      recentNotifications: _firstList(source, const [
        'recentNotifications',
        'notifications',
        'announcements',
      ]).map(TeacherNotification.fromJson).toList(growable: false),
      tasks: _firstList(source, const [
        'tasks',
        'todoItems',
        'actionItems',
        'workItems',
      ]).map(TeacherTask.fromJson).toList(growable: false),
    );
  }

  int get classCount {
    final ids = <String>{};

    for (final item in managedClasses) {
      ids.add(item.id);
    }

    final homeroom = homeroomClass;
    if (homeroom != null) ids.add(homeroom.id);

    return ids.length;
  }
}

class TeacherProfile {
  final String id;
  final String fullName;
  final String? employeeCode;
  final String? departmentName;
  final String avatarText;

  const TeacherProfile({
    required this.id,
    required this.fullName,
    required this.employeeCode,
    required this.departmentName,
    required this.avatarText,
  });

  factory TeacherProfile.fromJson(Map<String, dynamic> json) {
    final fullName =
        _stringFromKeys(json, const [
          'fullName',
          'name',
          'teacherName',
          'displayName',
        ]) ??
        'Giáo viên';

    return TeacherProfile(
      id:
          _stringFromKeys(json, const ['id', 'teacherId', 'userId']) ??
          fullName,
      fullName: fullName,
      employeeCode: _stringFromKeys(json, const [
        'employeeCode',
        'code',
        'teacherCode',
      ]),
      departmentName: _stringFromKeys(json, const [
        'departmentName',
        'department',
        'faculty',
      ]),
      avatarText:
          _stringFromKeys(json, const ['avatarText', 'initials']) ??
          _avatarText(fullName),
    );
  }
}

class TeacherClassSession {
  final String classId;
  final String className;
  final String subjectId;
  final String subjectName;
  final String room;
  final String timeLabel;
  final String statusLabel;

  const TeacherClassSession({
    required this.classId,
    required this.className,
    required this.subjectId,
    required this.subjectName,
    required this.room,
    required this.timeLabel,
    required this.statusLabel,
  });

  factory TeacherClassSession.fromJson(Map<String, dynamic> json) {
    final classSource = _firstMap(json, const ['class', 'classInfo']);
    final subjectSource = _firstMap(json, const ['subject', 'subjectInfo']);
    final source = {
      ...json,
      if (classSource.isNotEmpty) ...classSource,
      if (subjectSource.isNotEmpty) ...subjectSource,
    };

    return TeacherClassSession(
      classId:
          _stringFromKeys(source, const ['classId', 'id']) ??
          _stringFromKeys(classSource, const ['id']) ??
          '',
      className:
          _stringFromKeys(source, const [
            'className',
            'class',
            'homeroomClass',
          ]) ??
          _stringFromKeys(classSource, const ['name', 'title']) ??
          'Lớp học',
      subjectId:
          _stringFromKeys(source, const ['subjectId']) ??
          _stringFromKeys(subjectSource, const ['id']) ??
          '',
      subjectName:
          _stringFromKeys(source, const [
            'subjectName',
            'subject',
            'courseName',
          ]) ??
          _stringFromKeys(subjectSource, const ['name', 'title']) ??
          'Môn học',
      room:
          _stringFromKeys(source, const ['room', 'roomName', 'location']) ??
          'Đang cập nhật',
      timeLabel:
          _stringFromKeys(source, const [
            'timeLabel',
            'time',
            'periodLabel',
            'slot',
          ]) ??
          _timeRangeLabel(source),
      statusLabel:
          _stringFromKeys(source, const ['statusLabel', 'statusText']) ??
          'Hôm nay',
    );
  }
}

class TeacherClassSummary {
  final String id;
  final String name;
  final String roleLabel;
  final String? subjectName;
  final int studentCount;

  const TeacherClassSummary({
    required this.id,
    required this.name,
    required this.roleLabel,
    required this.subjectName,
    required this.studentCount,
  });

  factory TeacherClassSummary.fromJson(Map<String, dynamic> json) {
    final classSource = _firstMap(json, const ['class', 'classInfo']);
    final source = classSource.isEmpty ? json : {...json, ...classSource};

    return TeacherClassSummary(
      id: _stringFromKeys(source, const ['id', 'classId']) ?? '',
      name:
          _stringFromKeys(source, const ['name', 'className', 'title']) ??
          'Lớp học',
      roleLabel:
          _stringFromKeys(source, const [
            'roleLabel',
            'role',
            'assignmentRole',
          ]) ??
          'Giảng dạy',
      subjectName: _stringFromKeys(source, const [
        'subjectName',
        'subject',
        'courseName',
      ]),
      studentCount:
          _intFromKeys(source, const [
            'studentCount',
            'totalStudents',
            'studentsCount',
          ]) ??
          _firstList(source, const ['students']).length,
    );
  }
}

class TeacherExam {
  final String title;
  final String className;
  final String subjectName;
  final String dateLabel;

  const TeacherExam({
    required this.title,
    required this.className,
    required this.subjectName,
    required this.dateLabel,
  });

  factory TeacherExam.fromJson(Map<String, dynamic> json) {
    return TeacherExam(
      title:
          _stringFromKeys(json, const ['title', 'name', 'examName']) ??
          'Lịch kiểm tra',
      className:
          _stringFromKeys(json, const ['className', 'class']) ?? 'Lớp học',
      subjectName:
          _stringFromKeys(json, const ['subjectName', 'subject']) ?? 'Môn học',
      dateLabel:
          _stringFromKeys(json, const ['dateLabel', 'date', 'examDate']) ??
          'Đang cập nhật',
    );
  }
}

class TeacherNotification {
  final String title;
  final String message;
  final String type;

  const TeacherNotification({
    required this.title,
    required this.message,
    required this.type,
  });

  factory TeacherNotification.fromJson(Map<String, dynamic> json) {
    return TeacherNotification(
      title:
          _stringFromKeys(json, const ['title', 'subject', 'heading']) ??
          'Thông báo',
      message:
          _stringFromKeys(json, const ['message', 'content', 'body']) ?? '',
      type:
          _stringFromKeys(json, const ['type', 'category', 'level']) ?? 'info',
    );
  }
}

class TeacherTask {
  final String title;
  final String message;
  final int count;
  final String type;

  const TeacherTask({
    required this.title,
    required this.message,
    required this.count,
    required this.type,
  });

  factory TeacherTask.fromJson(Map<String, dynamic> json) {
    return TeacherTask(
      title:
          _stringFromKeys(json, const ['title', 'name', 'label']) ?? 'Đầu việc',
      message:
          _stringFromKeys(json, const ['message', 'description', 'content']) ??
          '',
      count: _intFromKeys(json, const ['count', 'total', 'quantity']) ?? 0,
      type:
          _stringFromKeys(json, const ['type', 'category', 'status']) ?? 'info',
    );
  }
}

List<TeacherClassSummary> _classSummaries(Map<String, dynamic> source) {
  final classes = _firstList(source, const [
    'managedClasses',
    'classes',
    'teachingClasses',
    'teachingAssignments',
  ]).map(TeacherClassSummary.fromJson).toList(growable: true);

  final seen = <String>{};

  return classes
      .where((item) {
        final key = item.id.isEmpty ? item.name : item.id;
        if (seen.contains(key)) return false;
        seen.add(key);
        return true;
      })
      .toList(growable: false);
}

String _timeRangeLabel(Map<String, dynamic> source) {
  final start = _stringFromKeys(source, const ['startTime', 'from']);
  final end = _stringFromKeys(source, const ['endTime', 'to']);

  if (start != null && end != null) return '$start - $end';
  if (start != null) return start;

  return 'Đang cập nhật';
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

String _avatarText(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList(growable: false);

  if (parts.isEmpty) return 'GV';
  if (parts.length == 1) {
    final end = parts.first.length < 2 ? parts.first.length : 2;
    return parts.first.substring(0, end).toUpperCase();
  }

  return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
      .toUpperCase();
}
