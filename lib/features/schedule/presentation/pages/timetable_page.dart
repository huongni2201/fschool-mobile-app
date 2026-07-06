import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/widgets/main_bottom_navigation.dart';
import '../../data/models/timetable_models.dart';
import '../../domain/usecases/get_weekly_timetable_usecase.dart';

part '../utils/timetable_helpers.dart';
part '../widgets/day_selector.dart';
part '../widgets/lesson_timeline_card.dart';
part '../widgets/timetable_state_views.dart';
part '../widgets/timetable_top_bar.dart';
part '../widgets/week_hero_card.dart';
part '../widgets/week_navigator.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  late final GetWeeklyTimetableUseCase _getWeeklyTimetableUseCase;
  late DateTime _selectedWeekStart;
  late DateTime _selectedDate;

  TimetableWeek? _week;
  Object? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    final today = _dateOnly(DateTime.now());

    _selectedDate = today;
    _selectedWeekStart = _startOfWeek(today);
    _getWeeklyTimetableUseCase = getIt<GetWeeklyTimetableUseCase>();
    _loadWeek();
  }

  Future<void> _loadWeek({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final week = await _getWeeklyTimetableUseCase(
        weekStart: _selectedWeekStart,
      );

      if (!mounted) return;

      setState(() {
        _week = week;
        _selectedDate = _weekContains(week, _selectedDate)
            ? _selectedDate
            : week.weekStart;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error;
      });

      if (silent && _week != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_timetableErrorMessage(error))));
      }
    } finally {
      if (mounted && !silent) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshWeek() {
    return _loadWeek(silent: true);
  }

  void _changeWeek(int direction) {
    final nextWeekStart = _selectedWeekStart.add(Duration(days: direction * 7));
    final today = _dateOnly(DateTime.now());

    setState(() {
      _selectedWeekStart = nextWeekStart;
      _selectedDate = _isDateInWeek(today, nextWeekStart)
          ? today
          : nextWeekStart;
    });

    _loadWeek();
  }

  void _selectDay(DateTime date) {
    setState(() {
      _selectedDate = _dateOnly(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    final week = _week;

    return Scaffold(
      backgroundColor: AppColors.homeCanvas,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.homeOrange,
          onRefresh: _refreshWeek,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
            children: [
              _TimetableTopBar(onBack: () => Navigator.of(context).maybePop()),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: _buildContent(week),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MainBottomNavigation(
        activeTab: MainBottomNavTab.schedule,
      ),
    );
  }

  Widget _buildContent(TimetableWeek? week) {
    if (_isLoading && week == null) {
      return const _TimetableLoadingView(key: ValueKey('schedule-loading'));
    }

    if (week == null) {
      return _TimetableErrorView(
        key: const ValueKey('schedule-error'),
        message: _timetableErrorMessage(_error),
        onRetry: _loadWeek,
      );
    }

    final selectedDay = week.dayFor(_selectedDate);

    return Column(
      key: const ValueKey('schedule-content'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _WeekHeroCard(week: week),
        if (_error != null) ...[
          const SizedBox(height: 12),
          _InlineScheduleWarning(
            message: _timetableErrorMessage(_error),
            onRetry: () => _loadWeek(silent: true),
          ),
        ],
        const SizedBox(height: 16),
        _WeekNavigator(
          week: week,
          onPrevious: () => _changeWeek(-1),
          onNext: () => _changeWeek(1),
        ),
        const SizedBox(height: 14),
        _DaySelector(
          week: week,
          selectedDate: _selectedDate,
          onSelected: _selectDay,
        ),
        const SizedBox(height: 20),
        _SelectedDayHeader(day: selectedDay),
        const SizedBox(height: 12),
        if (selectedDay.lessons.isEmpty)
          _EmptyLessonsCard(day: selectedDay)
        else
          for (var index = 0; index < selectedDay.lessons.length; index++) ...[
            _LessonTimelineCard(lesson: selectedDay.lessons[index]),
            if (index != selectedDay.lessons.length - 1)
              const SizedBox(height: 12),
          ],
      ],
    );
  }
}
