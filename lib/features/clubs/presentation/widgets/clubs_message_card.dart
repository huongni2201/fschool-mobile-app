part of '../pages/clubs_page.dart';

class _ClubsMessageCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const _ClubsMessageCard({
    required this.icon,
    required this.title,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ClubsColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: ClubsColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: ClubsColors.primary, size: 36),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: ClubsColors.textStrong,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: ClubsColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: onRetry,
              child: const Text(ClubsStrings.retry),
            ),
          ],
        ],
      ),
    );
  }
}
