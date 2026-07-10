part of '../pages/attendance_page.dart';

class _AttendanceMessageCard extends StatelessWidget {
  const _AttendanceMessageCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AttendanceColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AttendanceColors.border),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.cloud_off_rounded,
            color: AttendanceColors.primary,
            size: 34,
          ),
          SizedBox(height: 10),
          Text(
            AttendanceStrings.unavailableTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AttendanceColors.textStrong,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 6),
          Text(
            AttendanceStrings.unavailableMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AttendanceColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
