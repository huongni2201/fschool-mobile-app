part of '../pages/semester_grades_page.dart';

class _GradeNoteCard extends StatelessWidget {
  const _GradeNoteCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SemesterGradeSizes.notePadding),
      decoration: BoxDecoration(
        color: SemesterGradeColors.surface.withValues(alpha: 0.76),
        borderRadius: BorderRadius.circular(SemesterGradeSizes.noteRadius),
        border: Border.all(color: SemesterGradeColors.border),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: SemesterGradeColors.primary),
          SizedBox(width: SemesterGradeSizes.spacingLg),
          Expanded(
            child: Text(
              SemesterGradeStrings.note,
              style: TextStyle(
                color: SemesterGradeColors.textMuted,
                fontSize: SemesterGradeSizes.noteFontSize,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

