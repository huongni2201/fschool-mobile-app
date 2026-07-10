part of '../pages/tuition_page.dart';

class _TuitionLoadingView extends StatelessWidget {
  const _TuitionLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      decoration: BoxDecoration(
        color: TuitionColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: TuitionColors.border),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: TuitionColors.primary),
      ),
    );
  }
}

class _TuitionErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _TuitionErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 32, 22, 28),
      decoration: BoxDecoration(
        color: TuitionColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: TuitionColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: TuitionColors.primarySoft,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.cloud_off_rounded,
              color: TuitionColors.primary,
              size: 34,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            TuitionStrings.loadFailedTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TuitionColors.textStrong,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: TuitionColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text(TuitionStrings.reload),
            style: FilledButton.styleFrom(
              backgroundColor: TuitionColors.primary,
              foregroundColor: TuitionColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineTuitionWarning extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _InlineTuitionWarning({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TuitionColors.warningBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: TuitionColors.warningBorder),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: TuitionColors.primaryDark,
            size: 20,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: TuitionColors.textStrong,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text(TuitionStrings.retry),
          ),
        ],
      ),
    );
  }
}

class _TuitionMessageCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _TuitionMessageCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 24),
      decoration: BoxDecoration(
        color: TuitionColors.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: TuitionColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: TuitionColors.primarySoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: TuitionColors.primary, size: 31),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: TuitionColors.textStrong,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: TuitionColors.textMuted,
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
