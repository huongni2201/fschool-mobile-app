part of '../pages/profile_page.dart';

class _SecurityPage extends StatelessWidget {
  final VoidCallback onLogout;

  const _SecurityPage({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return _ProfileDetailShell(
      title: ProfileStrings.securityTitle,
      subtitle: ProfileStrings.securitySubtitle,
      icon: Icons.lock_outline_rounded,
      children: [
        _ActionCard(
          icon: Icons.password_rounded,
          title: ProfileStrings.passwordSecurityTitle,
          description: ProfileStrings.passwordSecurityDescription,
          actionLabel: ProfileStrings.changePassword,
          onAction: () =>
              Navigator.of(context).pushNamed(RouterNames.forgotPassword),
        ),
        const SizedBox(height: 12),
        _ActionCard(
          icon: Icons.devices_rounded,
          title: ProfileStrings.currentSessionTitle,
          description: ProfileStrings.currentSessionDescription,
          actionLabel: ProfileStrings.logout,
          actionColor: ProfileColors.danger,
          onAction: onLogout,
        ),
      ],
    );
  }
}
