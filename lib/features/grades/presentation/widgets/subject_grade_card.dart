part of '../pages/semester_grades_page.dart';

class _SubjectListHeader extends StatelessWidget {
  const _SubjectListHeader();

  @override
  Widget build(BuildContext context) {
    return const Text(
      SemesterGradeStrings.subjectListTitle,
      style: TextStyle(
        color: SemesterGradeColors.textStrong,
        fontSize: SemesterGradeSizes.sectionTitleSize,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _SubjectGradeCard extends StatelessWidget {
  final String periodId;
  final SubjectGrade subject;
  final String? studentId;

  const _SubjectGradeCard({
    required this.periodId,
    required this.subject,
    required this.studentId,
  });

  @override
  Widget build(BuildContext context) {
    final average = subject.average;
    final accent = _subjectAccent(subject);

    return Material(
      color: SemesterGradeColors.surface,
      borderRadius: BorderRadius.circular(SemesterGradeSizes.subjectCardRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(
          SemesterGradeSizes.subjectCardRadius,
        ),
        onTap: () => _openSubjectDetail(context, subject),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            SemesterGradeSizes.subjectCardPaddingLeft,
            SemesterGradeSizes.subjectCardPaddingTop,
            SemesterGradeSizes.subjectCardPaddingRight,
            SemesterGradeSizes.subjectCardPaddingBottom,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              SemesterGradeSizes.subjectCardRadius,
            ),
            border: Border.all(color: SemesterGradeColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: SemesterGradeSizes.subjectIconBoxSize,
                    height: SemesterGradeSizes.subjectIconBoxSize,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(
                        SemesterGradeSizes.subjectIconBoxRadius,
                      ),
                    ),
                    child: Icon(
                      _subjectIcon(subject.group),
                      color: accent,
                      size: SemesterGradeSizes.subjectIconSize,
                    ),
                  ),
                  const SizedBox(width: SemesterGradeSizes.spacingLg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject.subject,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: SemesterGradeColors.textStrong,
                            fontSize: SemesterGradeSizes.subjectTitleSize,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: SemesterGradeSizes.spacingXs),
                        Text(
                          SemesterGradeStrings.subjectTeacherLine(
                            subject.group,
                            subject.teacher,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: SemesterGradeColors.textMuted,
                            fontSize: SemesterGradeSizes.subjectSubtitleSize,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: SemesterGradeSizes.spacingMd),
                  _AverageBadge(
                    averageLabel:
                        average?.toStringAsFixed(1) ??
                        SemesterGradeStrings.unavailableScore,
                    accent: accent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openSubjectDetail(BuildContext context, SubjectGrade subject) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _SubjectGradeDetailPage(
          periodId: periodId,
          subject: subject,
          studentId: studentId,
        ),
      ),
    );
  }
}

class _AverageBadge extends StatelessWidget {
  final String averageLabel;
  final Color accent;

  const _AverageBadge({required this.averageLabel, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SemesterGradeSizes.subjectAverageBadgeSize,
      height: SemesterGradeSizes.subjectAverageBadgeSize,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          SemesterGradeSizes.subjectAverageBadgeRadius,
        ),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            averageLabel,
            style: TextStyle(
              color: accent,
              fontSize: SemesterGradeSizes.subjectAverageSize,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
