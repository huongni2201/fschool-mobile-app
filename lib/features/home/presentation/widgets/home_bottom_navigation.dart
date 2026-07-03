part of '../pages/home_page.dart';

class _HomeBottomNavigation extends StatelessWidget {
  final ValueChanged<String> onSelectUnavailable;

  const _HomeBottomNavigation({required this.onSelectUnavailable});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(18, 8, 18, 8 + bottomPadding),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.homeDivider)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: _BottomNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: AppStrings.homeNavHome,
              isActive: true,
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              icon: Icons.calendar_today_outlined,
              activeIcon: Icons.calendar_month_rounded,
              label: AppStrings.homeNavSchedule,
              onTap: () => onSelectUnavailable(AppStrings.homeNavSchedule),
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              icon: Icons.chat_bubble_outline_rounded,
              activeIcon: Icons.chat_bubble_rounded,
              label: AppStrings.homeNavMessages,
              onTap: () => onSelectUnavailable(AppStrings.homeNavMessages),
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
              label: AppStrings.homeNavProfile,
              onTap: () => onSelectUnavailable(AppStrings.homeNavProfile),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.homeOrange : AppColors.homeNavInactive;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: isActive ? 58 : 42,
              height: 34,
              decoration: BoxDecoration(
                color: isActive ? AppColors.homeOrangeSoft : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Icon(isActive ? activeIcon : icon, color: color, size: 26),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w900 : FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
