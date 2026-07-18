part of '../pages/timetable_page.dart';

class _LessonTimelineCard extends StatelessWidget {
  final TimetableLesson lesson;
  final bool isTeacher;

  const _LessonTimelineCard({required this.lesson, required this.isTeacher});

  @override
  Widget build(BuildContext context) {
    final accent = _statusColor(lesson.status);
    final statusLabel = _statusLabel(lesson);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.homeBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.homeCardShadow.withValues(alpha: 0.45),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: lesson.subject,
                    style: const TextStyle(
                      color: AppColors.homeTextStrong,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                    ),
                    children: [
                      TextSpan(
                        text: ' (${lesson.timeLabel})',
                        style: TextStyle(
                          color: accent,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (statusLabel.isNotEmpty) ...[
                const SizedBox(width: 10),
                _StatusBadge(label: statusLabel, color: accent),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (lesson.periodLabel.isNotEmpty)
                _LessonInfoPill(
                  icon: Icons.view_timeline_outlined,
                  label: lesson.periodLabel,
                ),
              if (lesson.room.isNotEmpty)
                _LessonInfoPill(
                  icon: Icons.meeting_room_outlined,
                  label: lesson.room,
                ),
              if (lesson.teacherName.isNotEmpty)
                _LessonInfoPill(
                  icon: Icons.person_outline_rounded,
                  label: 'GV ${lesson.teacherName}',
                ),
              if (lesson.className.isNotEmpty)
                _LessonInfoPill(
                  icon: Icons.groups_2_outlined,
                  label: lesson.className,
                ),
            ],
          ),
          if (lesson.note.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              lesson.note,
              style: const TextStyle(
                color: AppColors.homeTextMuted,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _statusLabel(TimetableLesson lesson) {
    if (!isTeacher) return lesson.statusLabel;

    return switch (lesson.status) {
      TimetableLessonStatus.done => 'Đã dạy',
      TimetableLessonStatus.live => 'Đang dạy',
      TimetableLessonStatus.next => 'Sắp dạy',
      TimetableLessonStatus.normal => lesson.statusLabel,
    };
  }
}

class _LessonInfoPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _LessonInfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.homeCanvas,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.homeDivider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.homeTextMuted, size: 15),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.homeTextMuted,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
