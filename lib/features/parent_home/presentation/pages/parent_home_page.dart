import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/router/router_names.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/widgets/main_bottom_navigation.dart';
import '../../data/models/parent_dashboard.dart';
import '../../domain/usecases/get_parent_dashboard_usecase.dart';
import '../constants/parent_home_colors.dart';
import '../constants/parent_home_strings.dart';

part '../utils/parent_home_helpers.dart';
part '../widgets/parent_attention_card.dart';
part '../widgets/parent_focus_card.dart';
part '../widgets/parent_home_dashboard_view.dart';
part '../widgets/parent_home_header.dart';
part '../widgets/parent_home_state_views.dart';
part '../widgets/parent_info_card.dart';
part '../widgets/parent_quick_action_grid.dart';
part '../widgets/student_switcher.dart';
part '../widgets/teacher_contact_card.dart';

class ParentHomePage extends StatefulWidget {
  const ParentHomePage({super.key});

  @override
  State<ParentHomePage> createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> {
  late final GetParentDashboardUseCase _getDashboardUseCase;

  ParentDashboard? _dashboard;
  Object? _error;
  bool _isLoading = true;
  int _selectedStudentIndex = 0;

  @override
  void initState() {
    super.initState();

    _getDashboardUseCase = getIt<GetParentDashboardUseCase>();
    _loadDashboard();
  }

  Future<void> _loadDashboard({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final dashboard = await _getDashboardUseCase();

      if (!mounted) return;

      setState(() {
        _dashboard = dashboard;
        _selectedStudentIndex = _safeSelectedIndex(
          _selectedStudentIndex,
          dashboard.students.length,
        );
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error;
      });

      if (silent && _dashboard != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_parentHomeErrorMessage(error))));
      }
    } finally {
      if (mounted && !silent) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshDashboard() {
    return _loadDashboard(silent: true);
  }

  Future<void> _logout() async {
    await TokenStorage.clear();

    if (!mounted) return;

    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamedAndRemoveUntil(RouterNames.login, (route) => false);
  }

  void _selectStudent(int index) {
    setState(() {
      _selectedStudentIndex = index;
    });
  }

  void _openRoute(String routeName) {
    final dashboard = _dashboard;
    final student = dashboard == null
        ? null
        : _selectedStudent(dashboard, _selectedStudentIndex);

    Navigator.of(context).pushNamed(routeName, arguments: student?.id);
  }

  void _showComingSoon(String featureName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ParentHomeStrings.comingSoon(featureName))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = _dashboard;

    return Scaffold(
      backgroundColor: ParentHomeColors.canvas,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.homeOrange,
          onRefresh: _refreshDashboard,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: _buildBody(dashboard),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MainBottomNavigation(
        activeTab: MainBottomNavTab.home,
      ),
    );
  }

  Widget _buildBody(ParentDashboard? dashboard) {
    if (_isLoading && dashboard == null) {
      return const _ParentHomeLoadingView(key: ValueKey('parent-loading'));
    }

    if (dashboard == null) {
      return _ParentHomeErrorView(
        key: const ValueKey('parent-error'),
        message: _parentHomeErrorMessage(_error),
        onRetry: _loadDashboard,
        onLogout: _logout,
      );
    }

    if (dashboard.students.isEmpty) {
      return _ParentHomeEmptyStudentsView(
        key: const ValueKey('parent-empty-students'),
        parentName: dashboard.parentName,
        onNotificationTap: () => _openRoute(RouterNames.notifications),
        onLogout: _logout,
        onRetry: _loadDashboard,
      );
    }

    return _ParentHomeDashboardView(
      key: ValueKey('parent-dashboard-${dashboard.students.length}'),
      dashboard: dashboard,
      selectedStudentIndex: _selectedStudentIndex,
      hasRefreshError: _error != null,
      refreshErrorMessage: _error == null
          ? null
          : _parentHomeErrorMessage(_error),
      onRetryRefresh: () => _loadDashboard(silent: true),
      onSelectedStudent: _selectStudent,
      onLogout: _logout,
      onNotificationTap: () => _openRoute(RouterNames.notifications),
      onOpenGrades: () => _openRoute(RouterNames.semesterGrades),
      onOpenTuition: () => _openRoute(RouterNames.tuition),
      onOpenRequests: () => _openRoute(RouterNames.requests),
      onOpenTimetable: () => _openRoute(RouterNames.timetable),
      onShowComingSoon: _showComingSoon,
    );
  }
}
