part of '../pages/semester_grades_page.dart';

class _GradePageHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _GradePageHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: SemesterGradeColors.surface,
          borderRadius: BorderRadius.circular(
            SemesterGradeSizes.headerBackButtonRadius,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(
              SemesterGradeSizes.headerBackButtonRadius,
            ),
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              width: SemesterGradeSizes.headerBackButtonSize,
              height: SemesterGradeSizes.headerBackButtonSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  SemesterGradeSizes.headerBackButtonRadius,
                ),
                border: Border.all(color: SemesterGradeColors.border),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: SemesterGradeColors.textStrong,
              ),
            ),
          ),
        ),
        const SizedBox(width: SemesterGradeSizes.spacingXl),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: SemesterGradeColors.textStrong,
                  fontSize: SemesterGradeSizes.headerTitleSize,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: SemesterGradeSizes.spacingXs),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: SemesterGradeColors.textMuted,
                  fontSize: SemesterGradeSizes.headerSubtitleSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
