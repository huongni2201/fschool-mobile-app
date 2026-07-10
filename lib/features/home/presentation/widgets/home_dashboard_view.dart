part of '../pages/home_page.dart';

class _HomeDashboardView extends StatelessWidget {
  final HomeDashboard dashboard;
  final bool hasRefreshError;
  final String? refreshErrorMessage;
  final VoidCallback onRetryRefresh;
  final VoidCallback onLogout;
  final ValueChanged<String> onUnavailableFeature;
  final VoidCallback onOpenGrades;
  final VoidCallback onOpenTimetable;
  final VoidCallback onOpenExams;
  final VoidCallback onOpenNotifications;
  final VoidCallback onOpenRequests;
  final VoidCallback onOpenTuition;
  final VoidCallback onOpenClubs;
  final VoidCallback onOpenAttendance;

  const _HomeDashboardView({
    super.key,
    required this.dashboard,
    required this.hasRefreshError,
    required this.refreshErrorMessage,
    required this.onRetryRefresh,
    required this.onLogout,
    required this.onUnavailableFeature,
    required this.onOpenGrades,
    required this.onOpenTimetable,
    required this.onOpenExams,
    required this.onOpenNotifications,
    required this.onOpenRequests,
    required this.onOpenTuition,
    required this.onOpenClubs,
    required this.onOpenAttendance,
  });

  @override
  Widget build(BuildContext context) {
    final schedules = dashboard.schedules.take(3).toList(growable: false);
    final grades = dashboard.recentGrades.take(4).toList(growable: false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HomeHeader(
            dashboard: dashboard,
            onLogout: onLogout,
            onNotificationTap: onOpenNotifications,
          ),
          if (hasRefreshError) ...[
            const SizedBox(height: 14),
            _InlineErrorBanner(
              message: refreshErrorMessage ?? AppStrings.homeRefreshDataFailed,
              onRetry: onRetryRefresh,
            ),
          ],
          const SizedBox(height: 16),
          _CurrentLessonCard(dashboard: dashboard),
          const SizedBox(height: 18),
          const _SectionTitle(title: AppStrings.homeMainFunctions),
          const SizedBox(height: 10),
          _ShortcutGrid(
            onTap: onUnavailableFeature,
            onOpenGrades: onOpenGrades,
            onOpenTimetable: onOpenTimetable,
            onOpenExams: onOpenExams,
            onOpenRequests: onOpenRequests,
            onOpenTuition: onOpenTuition,
            onOpenClubs: onOpenClubs,
            onOpenAttendance: onOpenAttendance,
          ),
          const SizedBox(height: 18),
          _SectionHeader(
            title: AppStrings.homeTodaySchedule,
            actionLabel: AppStrings.homeViewWeek,
            onAction: onOpenTimetable,
          ),
          const SizedBox(height: 8),
          schedules.isEmpty
              ? const _EmptyHomeCard(
                  icon: Icons.event_available_outlined,
                  title: AppStrings.homeNoScheduleTitle,
                  message: AppStrings.homeNoScheduleMessage,
                )
              : _ScheduleList(items: schedules),
          const SizedBox(height: 18),
          _SectionHeader(
            title: AppStrings.homeRecentGrades,
            actionLabel: AppStrings.homeDetail,
            onAction: onOpenGrades,
          ),
          const SizedBox(height: 8),
          grades.isEmpty
              ? const _EmptyHomeCard(
                  icon: Icons.workspace_premium_outlined,
                  title: AppStrings.homeNoRecentGradesTitle,
                  message: AppStrings.homeNoRecentGradesMessage,
                )
              : _GradeGrid(items: grades),
        ],
      ),
    );
  }
}
