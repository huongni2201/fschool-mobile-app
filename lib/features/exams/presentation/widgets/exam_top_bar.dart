part of '../pages/exam_schedule_page.dart';

class _ExamTopBar extends StatelessWidget {
  final VoidCallback onBack;

  const _ExamTopBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CircleIconButton(icon: Icons.arrow_back_rounded, onTap: onBack),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ExamScheduleStrings.pageTitle,
                style: TextStyle(
                  color: ExamScheduleColors.textStrong,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              SizedBox(height: 5),
              Text(
                ExamScheduleStrings.pageSubtitle,
                style: TextStyle(
                  color: ExamScheduleColors.textMuted,
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

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ExamScheduleColors.surface,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: ExamScheduleColors.border),
          ),
          child: Icon(icon, color: ExamScheduleColors.textStrong, size: 22),
        ),
      ),
    );
  }
}
