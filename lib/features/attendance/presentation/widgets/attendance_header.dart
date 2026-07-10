part of '../pages/attendance_page.dart';

class _AttendanceHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _AttendanceHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: AttendanceColors.surface,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onBack,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AttendanceColors.border),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: AttendanceColors.textStrong,
                size: 22,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AttendanceStrings.pageTitle,
                style: TextStyle(
                  color: AttendanceColors.textStrong,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              SizedBox(height: 5),
              Text(
                AttendanceStrings.pageSubtitle,
                style: TextStyle(
                  color: AttendanceColors.textMuted,
                  fontSize: 13,
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
