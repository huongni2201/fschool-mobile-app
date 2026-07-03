part of '../pages/semester_grades_page.dart';

double _averageOf(List<SubjectGrade> subjects) {
  final scoredSubjects = subjects
      .where((subject) => subject.average != null)
      .toList(growable: false);

  if (scoredSubjects.isEmpty) return 0;

  final total = scoredSubjects.fold<double>(
    0,
    (sum, subject) => sum + subject.average!,
  );

  return total / scoredSubjects.length;
}

SubjectGrade? _strongestSubjectOf(List<SubjectGrade> subjects) {
  SubjectGrade? strongestSubject;

  for (final subject in subjects) {
    final average = subject.average;

    if (average == null) continue;
    if (strongestSubject == null || average > (strongestSubject.average ?? 0)) {
      strongestSubject = subject;
    }
  }

  return strongestSubject;
}

String _rankLabel(double average) {
  if (average >= 9) return SemesterGradeStrings.rankExcellent;
  if (average >= 8) return SemesterGradeStrings.rankGood;
  if (average >= 7) return SemesterGradeStrings.rankFair;
  if (average >= 6.5) return SemesterGradeStrings.rankMediumFair;
  if (average >= 5) return SemesterGradeStrings.rankMedium;

  return SemesterGradeStrings.rankNeedsImprovement;
}

Color _subjectAccent(SubjectGrade _) {
  return SemesterGradeColors.primary;
}

String _gradeErrorMessage(Object? error) {
  final message = error?.toString().trim();

  if (message != null && message.isNotEmpty) return message;

  return 'Cannot load grades';
}

IconData _subjectIcon(String group) {
  final normalizedGroup = group.toLowerCase();

  if (normalizedGroup.contains(SemesterGradeStrings.groupLanguageKeyword)) {
    return Icons.translate_rounded;
  }
  if (normalizedGroup.contains(SemesterGradeStrings.groupSocialKeyword)) {
    return Icons.auto_stories_rounded;
  }
  if (normalizedGroup.contains(SemesterGradeStrings.groupTechnologyKeyword)) {
    return Icons.memory_rounded;
  }

  return Icons.science_rounded;
}
