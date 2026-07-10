part of '../pages/attendance_page.dart';

class _AttendanceHeroCard extends StatelessWidget {
  const _AttendanceHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AttendanceColors.heroGradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: AttendanceColors.primary.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AttendanceStrings.heroTitle,
                  style: TextStyle(
                    color: AttendanceColors.surface,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  AttendanceStrings.heroDescription,
                  style: TextStyle(
                    color: AttendanceColors.surfaceMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Icon(
            Icons.assignment_turned_in_outlined,
            color: AttendanceColors.surface,
            size: 54,
          ),
        ],
      ),
    );
  }
}
