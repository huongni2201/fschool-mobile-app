part of '../pages/profile_page.dart';

const _profileMenuItems = [
  _ProfileMenuItem(
    icon: Icons.badge_outlined,
    title: ProfileStrings.accountInfoTitle,
    description: ProfileStrings.accountInfoDescription,
    color: ProfileColors.primary,
    target: _ProfileMenuTarget.account,
  ),
  _ProfileMenuItem(
    icon: Icons.family_restroom_outlined,
    title: ProfileStrings.parentInfoTitle,
    description: ProfileStrings.parentInfoDescription,
    color: ProfileColors.blue,
    target: _ProfileMenuTarget.parents,
  ),
  _ProfileMenuItem(
    icon: Icons.notifications_none_rounded,
    title: ProfileStrings.notificationTitle,
    description: ProfileStrings.notificationDescription,
    color: ProfileColors.success,
    target: _ProfileMenuTarget.notifications,
  ),
  _ProfileMenuItem(
    icon: Icons.lock_outline_rounded,
    title: ProfileStrings.securityTitle,
    description: ProfileStrings.securityDescription,
    color: ProfileColors.brown,
    target: _ProfileMenuTarget.security,
  ),
  _ProfileMenuItem(
    icon: Icons.support_agent_rounded,
    title: ProfileStrings.supportTitle,
    description: ProfileStrings.supportDescription,
    color: ProfileColors.primaryDark,
    target: _ProfileMenuTarget.support,
  ),
];
