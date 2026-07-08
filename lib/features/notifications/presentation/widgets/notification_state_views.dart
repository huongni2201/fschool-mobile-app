part of '../pages/notifications_page.dart';

class _EmptyNotificationCard extends StatelessWidget {
  final _NotificationFilter filter;

  const _EmptyNotificationCard({required this.filter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 26),
      decoration: BoxDecoration(
        color: NotificationColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: NotificationColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: NotificationColors.primarySoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: NotificationColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _emptyNotificationTitle(filter),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: NotificationColors.textStrong,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _emptyNotificationMessage(filter),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: NotificationColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineNotificationWarning extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _InlineNotificationWarning({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: NotificationColors.warningBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: NotificationColors.warningBorder),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: NotificationColors.primaryDark,
            size: 20,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: NotificationColors.textStrong,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text(NotificationStrings.retry),
          ),
        ],
      ),
    );
  }
}

class _NotificationLoadingView extends StatelessWidget {
  const _NotificationLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      decoration: BoxDecoration(
        color: NotificationColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: NotificationColors.border),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: NotificationColors.primary),
      ),
    );
  }
}

class _NotificationErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _NotificationErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 32, 22, 28),
      decoration: BoxDecoration(
        color: NotificationColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: NotificationColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: NotificationColors.primarySoft,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.cloud_off_rounded,
              color: NotificationColors.primary,
              size: 34,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            NotificationStrings.loadFailedTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: NotificationColors.textStrong,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: NotificationColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text(NotificationStrings.reload),
            style: FilledButton.styleFrom(
              backgroundColor: NotificationColors.primary,
              foregroundColor: NotificationColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
