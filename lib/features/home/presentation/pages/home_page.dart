import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myfschool/core/error/exceptions.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/router/router_names.dart';
import '../../../../core/storage/token_storage.dart';
import '../../data/models/home_dashboard.dart';
import '../../domain/usecases/get_home_dashboard_usecase.dart';

part '../utils/home_ui_helpers.dart';
part '../widgets/current_lesson_card.dart';
part '../widgets/grade_grid.dart';
part '../widgets/home_bottom_navigation.dart';
part '../widgets/home_dashboard_view.dart';
part '../widgets/home_header.dart';
part '../widgets/home_section_widgets.dart';
part '../widgets/home_state_views.dart';
part '../widgets/schedule_list.dart';
part '../widgets/shortcut_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final GetHomeDashboardUseCase _getDashboardUseCase;

  HomeDashboard? _dashboard;
  Object? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _getDashboardUseCase = getIt<GetHomeDashboardUseCase>();
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_homeErrorMessage(error))));
      }
    } finally {
      if (mounted && !silent) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshDashboard() async {
    await _loadDashboard(silent: true);
  }

  Future<void> _logout() async {
    await TokenStorage.clear();

    if (!mounted) return;

    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamedAndRemoveUntil(RouterNames.login, (route) => false);
  }

  void _showUnavailableFeature(String featureName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.homeFeatureUnavailable(featureName))),
    );
  }

  void _openSemesterGrades() {
    Navigator.of(context).pushNamed(RouterNames.semesterGrades);
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = _dashboard;

    return Scaffold(
      backgroundColor: AppColors.homeCanvas,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.homeOrange,
          onRefresh: _refreshDashboard,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: _buildBody(dashboard),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _HomeBottomNavigation(
        onSelectUnavailable: _showUnavailableFeature,
      ),
    );
  }

  Widget _buildBody(HomeDashboard? dashboard) {
    if (_isLoading && dashboard == null) {
      return const _HomeLoadingView(key: ValueKey('home-loading'));
    }

    if (dashboard == null) {
      return _HomeErrorView(
        key: const ValueKey('home-error'),
        message: _homeErrorMessage(_error),
        onRetry: _loadDashboard,
        onLogout: _logout,
      );
    }

    return _HomeDashboardView(
      key: const ValueKey('home-dashboard'),
      dashboard: dashboard,
      hasRefreshError: _error != null,
      refreshErrorMessage: _error == null ? null : _homeErrorMessage(_error),
      onRetryRefresh: () => _loadDashboard(silent: true),
      onLogout: _logout,
      onUnavailableFeature: _showUnavailableFeature,
      onOpenGrades: _openSemesterGrades,
    );
  }
}
