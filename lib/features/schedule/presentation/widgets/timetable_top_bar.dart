part of '../pages/timetable_page.dart';

class _TimetableTopBar extends StatelessWidget {
  final bool isTeacher;
  final VoidCallback onBack;

  const _TimetableTopBar({required this.isTeacher, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CircleIconButton(icon: Icons.arrow_back_rounded, onTap: onBack),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thời khoá biểu',
                style: TextStyle(
                  color: AppColors.homeTextStrong,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              SizedBox(height: 5),
              Text(
                isTeacher ? 'Lịch dạy theo tuần' : 'Lịch học theo tuần',
                style: TextStyle(
                  color: AppColors.homeTextMuted,
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
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.homeBorder),
          ),
          child: Icon(icon, color: AppColors.homeTextStrong, size: 22),
        ),
      ),
    );
  }
}
