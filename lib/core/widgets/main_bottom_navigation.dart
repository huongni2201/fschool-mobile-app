import 'package:flutter/material.dart';

import '../auth/user_role_resolver.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../router/router_names.dart';
import '../storage/token_storage.dart';

enum MainBottomNavTab { home, schedule, notifications, profile, none }

class MainBottomNavigation extends StatelessWidget {
  final MainBottomNavTab activeTab;

  const MainBottomNavigation({
    super.key,
    this.activeTab = MainBottomNavTab.none,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final homeRouteName = switch (TokenStorage.userRole) {
      UserRole.teacher => RouterNames.teacherHome,
      UserRole.parent => RouterNames.parentHome,
      _ => RouterNames.home,
    };

    return Container(
      padding: EdgeInsets.fromLTRB(18, 8, 18, 8 + bottomPadding),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.homeDivider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _BottomNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: AppStrings.homeNavHome,
              isActive: activeTab == MainBottomNavTab.home,
              onTap: () => _openRoute(context, homeRouteName),
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              icon: Icons.calendar_today_outlined,
              activeIcon: Icons.calendar_month_rounded,
              label: AppStrings.homeNavSchedule,
              isActive: activeTab == MainBottomNavTab.schedule,
              onTap: () => _openRoute(context, RouterNames.timetable),
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              icon: Icons.notifications_none_rounded,
              activeIcon: Icons.notifications_rounded,
              label: AppStrings.homeNavNotifications,
              isActive: activeTab == MainBottomNavTab.notifications,
              onTap: () => _openRoute(context, RouterNames.notifications),
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
              label: AppStrings.homeNavProfile,
              isActive: activeTab == MainBottomNavTab.profile,
              onTap: () => _openRoute(context, RouterNames.profile),
            ),
          ),
        ],
      ),
    );
  }

  void _openRoute(BuildContext context, String routeName) {
    if (ModalRoute.of(context)?.settings.name == routeName) return;

    Navigator.of(context).pushNamedAndRemoveUntil(routeName, (route) => false);
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.onTap,
    this.isActive = false,
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
