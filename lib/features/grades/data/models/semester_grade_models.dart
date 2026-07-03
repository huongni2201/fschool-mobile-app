class SemesterOption {
  final String key;
  final String label;
  final String title;
  final String schoolYear;

  const SemesterOption({
    required this.key,
    required this.label,
    required this.title,
    required this.schoolYear,
  });

  factory SemesterOption.fromJson(Map<String, dynamic> json) {
    final key =
        _stringFromKeys(json, const ['id', 'key', 'periodId', 'code']) ??
        'period';
    final label =
        _stringFromKeys(json, const ['label', 'name', 'shortName']) ?? key;
    final title =
        _stringFromKeys(json, const ['title', 'displayName', 'name']) ?? label;
    final schoolYear =
        _stringFromKeys(json, const ['schoolYear', 'year', 'academicYear']) ??
        '';

    return SemesterOption(
      key: key,
      label: label,
      title: title,
      schoolYear: schoolYear,
    );
  }
}

class SemesterGradeSummary {
  final SemesterOption period;
  final List<SubjectGrade> subjects;
  final double? overallAverage;

  const SemesterGradeSummary({
    required this.period,
    required this.subjects,
    required this.overallAverage,
  });

  factory SemesterGradeSummary.fromJson(
    Map<String, dynamic> json, {
    required SemesterOption fallbackPeriod,
  }) {
    final payload = _payload(json);
    final periodMap = _mapFromObject(payload['period']);
    final period = periodMap.isEmpty
        ? fallbackPeriod
        : SemesterOption.fromJson(periodMap);

    final subjects = _firstList(payload, const [
      'subjects',
      'grades',
      'scores',
      'items',
    ]).map(SubjectGrade.fromJson).toList(growable: false);

    return SemesterGradeSummary(
      period: period,
      subjects: subjects,
      overallAverage: _doubleFromKeys(payload, const [
        'overallAverage',
        'average',
        'gpa',
        'semesterAverage',
      ]),
    );
  }
}

class SubjectGrade {
  final String subjectId;
  final String subject;
  final String teacher;
  final String group;
  final double? average;
  final List<ComponentScore> scores;

  const SubjectGrade({
    required this.subjectId,
    required this.subject,
    required this.teacher,
    required this.group,
    required this.average,
    required this.scores,
  });

  factory SubjectGrade.fromJson(Map<String, dynamic> json) {
    final subjectMap = _mapFromObject(json['subject']);
    final source = subjectMap.isEmpty ? json : {...json, ...subjectMap};
    final subject =
        _stringFromKeys(source, const [
          'subjectName',
          'subject',
          'name',
          'courseName',
        ]) ??
        'Subject';
    final subjectId =
        _stringFromKeys(source, const [
          'subjectId',
          'id',
          'code',
          'subjectCode',
        ]) ??
        subject;

    return SubjectGrade(
      subjectId: subjectId,
      subject: subject,
      teacher:
          _stringFromKeys(source, const [
            'teacherName',
            'teacher',
            'lecturer',
            'instructor',
          ]) ??
          '',
      group:
          _stringFromKeys(source, const [
            'group',
            'subjectGroup',
            'category',
            'department',
          ]) ??
          '',
      average: _doubleFromKeys(source, const [
        'average',
        'averageScore',
        'finalAverage',
        'finalScore',
        'score',
      ]),
      scores: _firstList(source, const [
        'componentScores',
        'components',
        'details',
        'scores',
        'items',
      ]).map(ComponentScore.fromJson).toList(growable: false),
    );
  }

  SubjectGrade copyWith({List<ComponentScore>? scores, double? average}) {
    return SubjectGrade(
      subjectId: subjectId,
      subject: subject,
      teacher: teacher,
      group: group,
      average: average ?? this.average,
      scores: scores ?? this.scores,
    );
  }
}

class ComponentScore {
  final String label;
  final String value;

  const ComponentScore({required this.label, required this.value});

  factory ComponentScore.fromJson(Map<String, dynamic> json) {
    final label =
        _stringFromKeys(json, const [
          'label',
          'name',
          'type',
          'scoreType',
          'title',
        ]) ??
        'Score';
    final value = _doubleFromKeys(json, const [
      'value',
      'score',
      'mark',
      'grade',
      'point',
    ]);

    return ComponentScore(
      label: label,
      value: value == null ? '--' : value.toStringAsFixed(1),
    );
  }
}

Map<String, dynamic> _payload(Map<String, dynamic> json) {
  final data = _mapFromObject(json['data'] ?? json['result']);

  return data.isEmpty ? json : data;
}

Map<String, dynamic> _mapFromObject(Object? value) {
  if (value is Map<String, dynamic>) return value;

  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
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
      return value
          .map(_mapFromObject)
          .where((item) => item.isNotEmpty)
          .toList(growable: false);
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
