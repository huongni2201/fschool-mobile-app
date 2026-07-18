import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/router/router_names.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/widgets/main_bottom_navigation.dart';
import '../../data/models/teacher_dashboard.dart';
import '../../domain/usecases/get_teacher_dashboard_usecase.dart';
import '../constants/teacher_home_colors.dart';
import '../constants/teacher_home_strings.dart';

part '../utils/teacher_home_helpers.dart';
part '../widgets/teacher_class_scope_card.dart';
part '../widgets/teacher_dashboard_view.dart';
part '../widgets/teacher_header.dart';
part '../widgets/teacher_hero_card.dart';
part '../widgets/teacher_home_state_views.dart';
part '../widgets/teacher_info_card.dart';
part '../widgets/teacher_quick_action_grid.dart';
part '../widgets/teacher_today_classes_card.dart';
part '../widgets/teacher_work_cards.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({super.key});

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  late final GetTeacherDashboardUseCase _getDashboardUseCase;

  TeacherDashboard? _dashboard;
  Object? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _getDashboardUseCase = getIt<GetTeacherDashboardUseCase>();
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
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error;
      });

      if (silent && _dashboard != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_teacherHomeErrorMessage(error))),
        );
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

  void _showComingSoon(String featureName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(TeacherHomeStrings.comingSoon(featureName))),
    );
  }

  void _openTimetable() {
    Navigator.of(context).pushNamed(RouterNames.timetable);
  }

  void _openGrades() {
    Navigator.of(context).pushNamed(RouterNames.teacherGrades);
  }

  void _openNotifications() {
    Navigator.of(context).pushNamed(RouterNames.notifications);
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = _dashboard;

    return Scaffold(
      backgroundColor: TeacherHomeColors.canvas,
      body: SafeArea(
        child: RefreshIndicator(
          color: TeacherHomeColors.primary,
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

  Widget _buildBody(TeacherDashboard? dashboard) {
    if (_isLoading && dashboard == null) {
      return const _TeacherHomeLoadingView(key: ValueKey('teacher-loading'));
    }

    if (dashboard == null) {
      return _TeacherHomeErrorView(
        key: const ValueKey('teacher-error'),
        message: _teacherHomeErrorMessage(_error),
        onRetry: _loadDashboard,
        onLogout: _logout,
      );
    }

    return _TeacherDashboardView(
      key: const ValueKey('teacher-dashboard'),
      dashboard: dashboard,
      hasRefreshError: _error != null,
      refreshErrorMessage: _error == null
          ? null
          : _teacherHomeErrorMessage(_error),
      onRetryRefresh: () => _loadDashboard(silent: true),
      onLogout: _logout,
      onOpenTimetable: _openTimetable,
      onOpenGrades: _openGrades,
      onOpenNotifications: _openNotifications,
      onShowComingSoon: _showComingSoon,
    );
  }
}
