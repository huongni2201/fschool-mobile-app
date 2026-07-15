part of '../pages/teacher_home_page.dart';

class _TeacherDashboardView extends StatelessWidget {
  final TeacherDashboard dashboard;
  final bool hasRefreshError;
  final String? refreshErrorMessage;
  final VoidCallback onRetryRefresh;
  final VoidCallback onLogout;
  final ValueChanged<String> onShowComingSoon;

  const _TeacherDashboardView({
    super.key,
    required this.dashboard,
    required this.hasRefreshError,
    required this.refreshErrorMessage,
    required this.onRetryRefresh,
    required this.onLogout,
    required this.onShowComingSoon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('teacher-dashboard-content'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TeacherHeader(
          teacher: dashboard.teacher,
          onLogout: onLogout,
          onNotificationTap: () =>
              onShowComingSoon(TeacherHomeStrings.notificationsTitle),
        ),
        if (hasRefreshError) ...[
          const SizedBox(height: 14),
          _InlineTeacherHomeWarning(
            message: refreshErrorMessage ?? TeacherHomeStrings.refreshFailed,
            onRetry: onRetryRefresh,
          ),
        ],
        const SizedBox(height: 18),
        _TeacherHeroCard(dashboard: dashboard),
        const SizedBox(height: 20),
        const _TeacherSectionHeader(
          title: TeacherHomeStrings.quickSectionTitle,
        ),
        const SizedBox(height: 10),
        _TeacherQuickActionGrid(onTap: onShowComingSoon),
        const SizedBox(height: 22),
        _TeacherTodayClassesCard(items: dashboard.todayClasses),
        const SizedBox(height: 18),
        _TeacherClassScopeCard(dashboard: dashboard),
        const SizedBox(height: 18),
        _TeacherTasksCard(
          pendingApplications: dashboard.pendingApplications,
          tasks: dashboard.tasks,
          onTap: onShowComingSoon,
        ),
        const SizedBox(height: 18),
        _TeacherExamsCard(items: dashboard.upcomingExams),
        const SizedBox(height: 18),
        _TeacherNotificationsCard(items: dashboard.recentNotifications),
      ],
    );
  }
}
