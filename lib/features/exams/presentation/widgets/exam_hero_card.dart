part of '../pages/exam_schedule_page.dart';

class _ExamHeroCard extends StatelessWidget {
  final ExamSchedule schedule;

  const _ExamHeroCard({required this.schedule});

  @override
  Widget build(BuildContext context) {
    final nextExam = schedule.nextExam;

    return Container(
      decoration: BoxDecoration(
        color: ExamScheduleColors.heroSurface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: ExamScheduleColors.heroBorder),
        boxShadow: const [
          BoxShadow(
            color: ExamScheduleColors.shadow,
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: ExamScheduleColors.heroAccentSurface,
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(color: ExamScheduleColors.primaryDark),
                  ),
                  child: const Icon(
                    Icons.alarm_rounded,
                    color: ExamScheduleColors.primary,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule.termName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: ExamScheduleColors.heroText,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        nextExam == null
                            ? ExamScheduleStrings.noUpcomingExam
                            : ExamScheduleStrings.nextExam(nextExam.subject),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: ExamScheduleColors.heroTextMuted,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (nextExam != null) ...[
              const SizedBox(height: 18),
              _NextExamStrip(exam: nextExam),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                _HeroStat(
                  value: schedule.totalExams,
                  label: ExamScheduleStrings.totalExamsLabel,
                ),
                const SizedBox(width: 10),
                _HeroStat(
                  value: schedule.upcomingExamCount,
                  label: ExamScheduleStrings.upcomingExamsLabel,
                ),
                const SizedBox(width: 10),
                _HeroStat(
                  value: schedule.finishedExamCount,
                  label: ExamScheduleStrings.finishedExamsLabel,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NextExamStrip extends StatelessWidget {
  final ExamItem exam;

  const _NextExamStrip({required this.exam});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ExamScheduleColors.heroInnerSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ExamScheduleColors.primaryDark),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _HeroInfoPill(
            icon: Icons.calendar_today_outlined,
            label: _fullDateLabel(exam.date),
          ),
          _HeroInfoPill(icon: Icons.schedule_rounded, label: exam.timeLabel),
          if (exam.room.isNotEmpty)
            _HeroInfoPill(icon: Icons.meeting_room_outlined, label: exam.room),
        ],
      ),
    );
  }
}

class _HeroInfoPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroInfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: ExamScheduleColors.primarySoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: ExamScheduleColors.primaryDark),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: ExamScheduleColors.primary, size: 15),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: ExamScheduleColors.textStrong,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final int value;
  final String label;

  const _HeroStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: ExamScheduleColors.heroInnerSurface,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: ExamScheduleColors.primaryDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value.toString(),
              style: const TextStyle(
                color: ExamScheduleColors.primary,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: ExamScheduleColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
