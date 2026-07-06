part of '../pages/timetable_page.dart';

class _EmptyLessonsCard extends StatelessWidget {
  final TimetableDay day;

  const _EmptyLessonsCard({required this.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.homeBorder),
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.homeOrangeSoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.event_available_outlined,
              color: AppColors.homeOrange,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Không có lịch học',
            style: TextStyle(
              color: AppColors.homeTextStrong,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${day.label} chưa có tiết học. Kéo xuống để làm mới khi nhà trường cập nhật lịch.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.homeTextMuted,
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

class _InlineScheduleWarning extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _InlineScheduleWarning({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.homeRefreshErrorBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.homeRefreshErrorBorder),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.homeDeepOrange,
            size: 20,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.homeTextStrong,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Thử lại')),
        ],
      ),
    );
  }
}

class _TimetableLoadingView extends StatelessWidget {
  const _TimetableLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.homeBorder),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.homeOrange),
      ),
    );
  }
}

class _TimetableErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _TimetableErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 32, 22, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.homeBorder),
      ),
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: AppColors.homeOrangeSoft,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.cloud_off_rounded,
              color: AppColors.homeOrange,
              size: 34,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Chưa tải được thời khoá biểu',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.homeTextStrong,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.homeTextMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Tải lại'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.homeOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
