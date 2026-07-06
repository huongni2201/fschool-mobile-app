part of '../pages/profile_page.dart';

class _ProfileErrorBanner extends StatelessWidget {
  final VoidCallback onRetry;

  const _ProfileErrorBanner({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ProfileColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ProfileColors.border),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: ProfileColors.primary,
            size: 22,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              ProfileStrings.loadFailed,
              style: TextStyle(
                color: ProfileColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text(ProfileStrings.retry),
          ),
        ],
      ),
    );
  }
}
