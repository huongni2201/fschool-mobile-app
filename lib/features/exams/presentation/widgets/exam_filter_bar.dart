part of '../pages/exam_schedule_page.dart';

class _ExamFilterBar extends StatelessWidget {
  final _ExamScheduleFilter selectedFilter;
  final ExamSchedule schedule;
  final ValueChanged<_ExamScheduleFilter> onSelected;

  const _ExamFilterBar({
    required this.selectedFilter,
    required this.schedule,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _ExamFilterChip(
            label: ExamScheduleStrings.upcomingFilter,
            count: schedule.upcomingExamCount,
            isSelected: selectedFilter == _ExamScheduleFilter.upcoming,
            onTap: () => onSelected(_ExamScheduleFilter.upcoming),
          ),
          const SizedBox(width: 8),
          _ExamFilterChip(
            label: ExamScheduleStrings.finishedFilter,
            count: schedule.exams
                .where(
                  (exam) =>
                      exam.status == ExamStatus.finished ||
                      exam.status == ExamStatus.cancelled,
                )
                .length,
            isSelected: selectedFilter == _ExamScheduleFilter.finished,
            onTap: () => onSelected(_ExamScheduleFilter.finished),
          ),
          const SizedBox(width: 8),
          _ExamFilterChip(
            label: ExamScheduleStrings.allFilter,
            count: schedule.totalExams,
            isSelected: selectedFilter == _ExamScheduleFilter.all,
            onTap: () => onSelected(_ExamScheduleFilter.all),
          ),
        ],
      ),
    );
  }
}

class _ExamFilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _ExamFilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = isSelected
        ? ExamScheduleColors.surface
        : ExamScheduleColors.textStrong;
    final background = isSelected
        ? ExamScheduleColors.primary
        : ExamScheduleColors.surface;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isSelected
                  ? ExamScheduleColors.primary
                  : ExamScheduleColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: foreground,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 7),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: isSelected
                      ? ExamScheduleColors.surface.withValues(alpha: 0.2)
                      : ExamScheduleColors.primarySoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: isSelected
                        ? ExamScheduleColors.surface
                        : ExamScheduleColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExamSectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const _ExamSectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: ExamScheduleColors.textStrong,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          ExamScheduleStrings.examCount(count),
          style: const TextStyle(
            color: ExamScheduleColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
