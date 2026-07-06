part of '../pages/timetable_page.dart';

class _WeekNavigator extends StatelessWidget {
  final TimetableWeek week;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _WeekNavigator({
    required this.week,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.homeBorder),
      ),
      child: Row(
        children: [
          _WeekArrow(icon: Icons.chevron_left_rounded, onTap: onPrevious),
          Expanded(
            child: Column(
              children: [
                const Text(
                  'Tuần đang xem',
                  style: TextStyle(
                    color: AppColors.homeTextMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _weekRangeLabel(week.weekStart, week.weekEnd),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.homeTextStrong,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          _WeekArrow(icon: Icons.chevron_right_rounded, onTap: onNext),
        ],
      ),
    );
  }
}

class _WeekArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _WeekArrow({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: Icon(icon, color: AppColors.homeOrange, size: 28),
      ),
    );
  }
}
