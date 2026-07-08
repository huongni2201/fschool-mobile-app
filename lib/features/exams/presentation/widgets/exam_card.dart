part of '../pages/exam_schedule_page.dart';

class _ExamCard extends StatelessWidget {
  final ExamItem exam;

  const _ExamCard({required this.exam});

  @override
  Widget build(BuildContext context) {
    final accent = _statusColor(exam.status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: ExamScheduleColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ExamScheduleColors.border),
        boxShadow: [
          BoxShadow(
            color: ExamScheduleColors.shadow.withValues(alpha: 0.38),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ExamDateBadge(date: exam.date, color: accent),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        exam.subject,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: ExamScheduleColors.textStrong,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusBadge(label: exam.statusLabel, color: accent),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  exam.examType,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ExamScheduleColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 11),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ExamInfoPill(
                      icon: Icons.schedule_rounded,
                      label: exam.timeLabel,
                    ),
                    if (exam.room.isNotEmpty)
                      _ExamInfoPill(
                        icon: Icons.meeting_room_outlined,
                        label: exam.room,
                      ),
                    if (exam.durationLabel.isNotEmpty)
                      _ExamInfoPill(
                        icon: Icons.timer_outlined,
                        label: exam.durationLabel,
                      ),
                    if (exam.seatNumber.isNotEmpty)
                      _ExamInfoPill(
                        icon: Icons.event_seat_outlined,
                        label: ExamScheduleStrings.seat(exam.seatNumber),
                      ),
                    if (exam.form.isNotEmpty)
                      _ExamInfoPill(
                        icon: Icons.fact_check_outlined,
                        label: exam.form,
                      ),
                  ],
                ),
                if (exam.note.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    exam.note,
                    style: const TextStyle(
                      color: ExamScheduleColors.textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExamDateBadge extends StatelessWidget {
  final DateTime? date;
  final Color color;

  const _ExamDateBadge({required this.date, required this.color});

  @override
  Widget build(BuildContext context) {
    final examDate = date;

    return Container(
      width: 62,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        children: [
          Text(
            examDate == null
                ? ExamScheduleStrings.unknownDateDay
                : _shortWeekdayLabel(examDate.weekday),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            examDate == null
                ? ExamScheduleStrings.unknownDateDay
                : examDate.day.toString().padLeft(2, '0'),
            style: TextStyle(
              color: color,
              fontSize: 23,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            examDate == null
                ? ExamScheduleStrings.unknownDateMonth
                : 'T${examDate.month.toString().padLeft(2, '0')}',
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExamInfoPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ExamInfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: ExamScheduleColors.canvas,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: ExamScheduleColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: ExamScheduleColors.textMuted, size: 15),
          const SizedBox(width: 5),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 190),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: ExamScheduleColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
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
