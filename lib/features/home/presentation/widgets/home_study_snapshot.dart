part of '../pages/home_page.dart';

class _HomeStudySnapshot extends StatelessWidget {
  final HomeDashboard dashboard;
  final VoidCallback onOpenTimetable;
  final VoidCallback onOpenGrades;

  const _HomeStudySnapshot({
    required this.dashboard,
    required this.onOpenTimetable,
    required this.onOpenGrades,
  });

  @override
  Widget build(BuildContext context) {
    final focusLesson = _focusLesson;
    final focusGrade = _focusGrade;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF5),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.homeBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12F45B00),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _SnapshotTile(
              icon: Icons.auto_graph_rounded,
              label: 'Nhịp học hôm nay',
              value: '${dashboard.schedules.length} tiết',
              note: focusLesson == null
                  ? 'Chưa có lịch nổi bật'
                  : focusLesson.subject,
              color: AppColors.homeOrange,
              onTap: onOpenTimetable,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SnapshotTile(
              icon: Icons.stars_rounded,
              label: 'Điểm mới',
              value: '${dashboard.recentGrades.length}',
              note: focusGrade == null
                  ? 'Chưa có cập nhật'
                  : '${focusGrade.subject}: ${focusGrade.scoreLabel}',
              color: _gradeColor(focusGrade?.score),
              onTap: onOpenGrades,
            ),
          ),
        ],
      ),
    );
  }

  HomeScheduleItem? get _focusLesson {
    for (final item in dashboard.schedules) {
      if (item.status == HomeScheduleStatus.live ||
          item.status == HomeScheduleStatus.next) {
        return item;
      }
    }

    return dashboard.schedules.isEmpty ? null : dashboard.schedules.first;
  }

  HomeGradeItem? get _focusGrade {
    HomeGradeItem? best;

    for (final item in dashboard.recentGrades) {
      if (item.score == null) continue;

      if (best == null || item.score! > best.score!) {
        best = item;
      }
    }

    if (best != null) return best;

    return dashboard.recentGrades.isEmpty ? null : dashboard.recentGrades.first;
  }
}

class _SnapshotTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String note;
  final Color color;
  final VoidCallback onTap;

  const _SnapshotTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.note,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_outward_rounded,
                    color: AppColors.homeTextMuted,
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.homeTextStrong,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.homeTextMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                note,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.homeTextStrong,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
