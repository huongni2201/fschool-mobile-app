part of '../pages/profile_page.dart';

class _ProfileLogoutButton extends StatelessWidget {
  final VoidCallback onLogout;

  const _ProfileLogoutButton({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onLogout,
        icon: const Icon(Icons.logout_rounded),
        label: const Text(ProfileStrings.logout),
        style: OutlinedButton.styleFrom(
          foregroundColor: ProfileColors.danger,
          side: const BorderSide(color: ProfileColors.border),
          backgroundColor: ProfileColors.surface,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}
