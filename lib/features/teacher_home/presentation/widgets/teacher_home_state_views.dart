part of '../pages/teacher_home_page.dart';

class _TeacherHomeLoadingView extends StatelessWidget {
  const _TeacherHomeLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: TeacherHomeColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: TeacherHomeColors.border),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: TeacherHomeColors.primary,
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Đang tải trang giáo viên...',
            style: TextStyle(
              color: TeacherHomeColors.muted,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _TeacherHomeErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onLogout;

  const _TeacherHomeErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 52),
      child: _TeacherInfoCard(
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: TeacherHomeColors.warningBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: TeacherHomeColors.warningBorder),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: TeacherHomeColors.red,
                size: 30,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              TeacherHomeStrings.loadFailedTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: TeacherHomeColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: TeacherHomeColors.muted,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onLogout,
                    child: const Text(
                      TeacherHomeStrings.logoutAndLoginAgain,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: onRetry,
                    style: FilledButton.styleFrom(
                      backgroundColor: TeacherHomeColors.primary,
                    ),
                    child: const Text(TeacherHomeStrings.reload),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineTeacherHomeWarning extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _InlineTeacherHomeWarning({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TeacherHomeColors.warningBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: TeacherHomeColors.warningBorder),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: TeacherHomeColors.red,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: TeacherHomeColors.ink,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text(TeacherHomeStrings.reload),
          ),
        ],
      ),
    );
  }
}
