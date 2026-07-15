part of '../pages/parent_home_page.dart';

class _ParentHomeHeader extends StatelessWidget {
  final String? parentName;
  final VoidCallback onNotificationTap;
  final VoidCallback onLogout;

  const _ParentHomeHeader({
    required this.parentName,
    required this.onNotificationTap,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ParentHomeStrings.greeting(parentName),
                style: const TextStyle(
                  color: ParentHomeColors.muted,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                ParentHomeStrings.subtitle,
                style: TextStyle(
                  color: ParentHomeColors.ink,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
        _RoundIconButton(
          icon: Icons.notifications_none_rounded,
          onTap: onNotificationTap,
        ),
        const SizedBox(width: 10),
        _RoundIconButton(icon: Icons.logout_rounded, onTap: onLogout),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: ParentHomeColors.border),
          ),
          child: Icon(icon, color: ParentHomeColors.ink),
        ),
      ),
    );
  }
}
