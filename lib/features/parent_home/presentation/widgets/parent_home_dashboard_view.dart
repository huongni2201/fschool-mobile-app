part of '../pages/parent_home_page.dart';

class _ParentHomeDashboardView extends StatelessWidget {
  final ParentDashboard dashboard;
  final int selectedStudentIndex;
  final bool hasRefreshError;
  final String? refreshErrorMessage;
  final VoidCallback onRetryRefresh;
  final ValueChanged<int> onSelectedStudent;
  final VoidCallback onLogout;
  final VoidCallback onNotificationTap;
  final VoidCallback onOpenGrades;
  final VoidCallback onOpenTuition;
  final VoidCallback onOpenRequests;
  final VoidCallback onOpenTimetable;
  final ValueChanged<String> onShowComingSoon;

  const _ParentHomeDashboardView({
    super.key,
    required this.dashboard,
    required this.selectedStudentIndex,
    required this.hasRefreshError,
    required this.refreshErrorMessage,
    required this.onRetryRefresh,
    required this.onSelectedStudent,
    required this.onLogout,
    required this.onNotificationTap,
    required this.onOpenGrades,
    required this.onOpenTuition,
    required this.onOpenRequests,
    required this.onOpenTimetable,
    required this.onShowComingSoon,
  });

  @override
  Widget build(BuildContext context) {
    final student = _selectedStudent(dashboard, selectedStudentIndex);

    return Column(
      key: const ValueKey('parent-dashboard-content'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ParentHomeHeader(
          parentName: dashboard.parentName,
          onNotificationTap: onNotificationTap,
          onLogout: onLogout,
        ),
        if (hasRefreshError) ...[
          const SizedBox(height: 14),
          _InlineParentHomeWarning(
            message: refreshErrorMessage ?? ParentHomeStrings.refreshFailed,
            onRetry: onRetryRefresh,
          ),
        ],
        const SizedBox(height: 18),
        _StudentSwitcher(
          students: dashboard.students,
          selectedIndex: _safeSelectedIndex(
            selectedStudentIndex,
            dashboard.students.length,
          ),
          onSelected: onSelectedStudent,
        ),
        const SizedBox(height: 18),
        _ParentFocusCard(student: student),
        const SizedBox(height: 20),
        _SectionHeader(
          title: ParentHomeStrings.quickSectionTitle,
          actionLabel: ParentHomeStrings.allActions,
          onAction: () => onShowComingSoon(ParentHomeStrings.allActions),
        ),
        const SizedBox(height: 12),
        _QuickActionGrid(
          onOpenGrades: onOpenGrades,
          onOpenTuition: onOpenTuition,
          onOpenRequests: onOpenRequests,
          onOpenTimetable: onOpenTimetable,
        ),
        const SizedBox(height: 22),
        _ParentAttentionCard(dashboard: dashboard, student: student),
        const SizedBox(height: 18),
        _TeacherContactCard(
          student: student,
          onMessage: () => onShowComingSoon('Nhắn tin giáo viên chủ nhiệm'),
          onCall: () => onShowComingSoon('Gọi giáo viên chủ nhiệm'),
        ),
      ],
    );
  }
}
