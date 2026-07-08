part of '../pages/exam_schedule_page.dart';

class _EmptyExamCard extends StatelessWidget {
  final _ExamScheduleFilter filter;

  const _EmptyExamCard({required this.filter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 26),
      decoration: BoxDecoration(
        color: ExamScheduleColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: ExamScheduleColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: ExamScheduleColors.primarySoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.assignment_turned_in_outlined,
              color: ExamScheduleColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _emptyTitle(filter),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: ExamScheduleColors.textStrong,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _emptyMessage(filter),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: ExamScheduleColors.textMuted,
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

class _InlineExamWarning extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _InlineExamWarning({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ExamScheduleColors.warningBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ExamScheduleColors.warningBorder),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: ExamScheduleColors.primaryDark,
            size: 20,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: ExamScheduleColors.textStrong,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text(ExamScheduleStrings.retry),
          ),
        ],
      ),
    );
  }
}

class _ExamLoadingView extends StatelessWidget {
  const _ExamLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      decoration: BoxDecoration(
        color: ExamScheduleColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: ExamScheduleColors.border),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: ExamScheduleColors.primary),
      ),
    );
  }
}

class _ExamErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ExamErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 32, 22, 28),
      decoration: BoxDecoration(
        color: ExamScheduleColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: ExamScheduleColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: ExamScheduleColors.primarySoft,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.cloud_off_rounded,
              color: ExamScheduleColors.primary,
              size: 34,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            ExamScheduleStrings.loadFailedTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ExamScheduleColors.textStrong,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: ExamScheduleColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text(ExamScheduleStrings.reload),
            style: FilledButton.styleFrom(
              backgroundColor: ExamScheduleColors.primary,
              foregroundColor: ExamScheduleColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
