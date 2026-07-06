part of '../pages/timetable_page.dart';

class _TimetableTopBar extends StatelessWidget {
  final VoidCallback onBack;

  const _TimetableTopBar({required this.onBack});

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
                'Th\u1EDDi kho\u00E1 bi\u1EC3u',
                style: TextStyle(
                  color: AppColors.homeTextStrong,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'L\u1ECBch h\u1ECDc theo tu\u1EA7n',
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
