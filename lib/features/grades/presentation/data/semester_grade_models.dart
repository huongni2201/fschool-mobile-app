part of '../pages/semester_grades_page.dart';

class _SemesterOption {
  final String key;
  final String label;
  final String title;
  final String schoolYear;

  const _SemesterOption({
    required this.key,
    required this.label,
    required this.title,
    required this.schoolYear,
  });
}

class _SubjectGrade {
  final String subject;
  final String teacher;
  final String group;
  final double? average;
  final Color accent;
  final List<_ComponentScore> scores;

  const _SubjectGrade({
    required this.subject,
    required this.teacher,
    required this.group,
    required this.average,
    required this.accent,
    required this.scores,
  });
}

class _ComponentScore {
  final String label;
  final String value;

  const _ComponentScore({required this.label, required this.value});
}
