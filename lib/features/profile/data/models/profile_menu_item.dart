part of '../../presentation/pages/profile_page.dart';

enum _ProfileMenuTarget { account, parents, notifications, security, support }

class _ProfileMenuItem {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final _ProfileMenuTarget target;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.target,
  });
}
