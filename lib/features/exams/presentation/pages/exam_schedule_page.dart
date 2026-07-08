import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/widgets/main_bottom_navigation.dart';
import '../../data/models/exam_schedule_models.dart';
import '../../domain/usecases/get_exam_schedule_usecase.dart';
import '../constants/exam_schedule_colors.dart';
import '../constants/exam_schedule_strings.dart';
part '../utils/exam_schedule_helpers.dart';
part '../widgets/exam_card.dart';
part '../widgets/exam_filter_bar.dart';
part '../widgets/exam_hero_card.dart';
part '../widgets/exam_state_views.dart';
part '../widgets/exam_top_bar.dart';

enum _ExamScheduleFilter { upcoming, finished, all }

class ExamSchedulePage extends StatefulWidget {
  const ExamSchedulePage({super.key});

  @override
  State<ExamSchedulePage> createState() => _ExamSchedulePageState();
}

class _ExamSchedulePageState extends State<ExamSchedulePage> {
  late final GetExamScheduleUseCase _getExamScheduleUseCase;

  ExamSchedule? _schedule;
  Object? _error;
  bool _isLoading = true;
  _ExamScheduleFilter _filter = _ExamScheduleFilter.upcoming;

  @override
  void initState() {
    super.initState();

    _getExamScheduleUseCase = getIt<GetExamScheduleUseCase>();
    _loadSchedule();
  }

  Future<void> _loadSchedule({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final schedule = await _getExamScheduleUseCase();

      if (!mounted) return;

      setState(() {
        _schedule = schedule;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error;
      });

      if (silent && _schedule != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_examErrorMessage(error))));
      }
    } finally {
      if (mounted && !silent) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshSchedule() {
    return _loadSchedule(silent: true);
  }

  void _selectFilter(_ExamScheduleFilter filter) {
    setState(() {
      _filter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final schedule = _schedule;

    return Scaffold(
      backgroundColor: ExamScheduleColors.canvas,
      body: SafeArea(
        child: RefreshIndicator(
          color: ExamScheduleColors.primary,
          onRefresh: _refreshSchedule,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
            children: [
              _ExamTopBar(onBack: () => Navigator.of(context).maybePop()),
              const SizedBox(height: 18),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: _buildContent(schedule),
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

  Widget _buildContent(ExamSchedule? schedule) {
    if (_isLoading && schedule == null) {
      return const _ExamLoadingView(key: ValueKey('exam-loading'));
    }

    if (schedule == null) {
      return _ExamErrorView(
        key: const ValueKey('exam-error'),
        message: _examErrorMessage(_error),
        onRetry: _loadSchedule,
      );
    }

    final exams = _filteredExams(schedule.exams);

    return Column(
      key: ValueKey('exam-content-${_filter.name}-${schedule.totalExams}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ExamHeroCard(schedule: schedule),
        if (_error != null) ...[
          const SizedBox(height: 12),
          _InlineExamWarning(
            message: _examErrorMessage(_error),
            onRetry: () => _loadSchedule(silent: true),
          ),
        ],
        const SizedBox(height: 16),
        _ExamFilterBar(
          selectedFilter: _filter,
          schedule: schedule,
          onSelected: _selectFilter,
        ),
        const SizedBox(height: 18),
        _ExamSectionHeader(title: _filterTitle(_filter), count: exams.length),
        const SizedBox(height: 10),
        if (exams.isEmpty)
          _EmptyExamCard(filter: _filter)
        else
          for (var index = 0; index < exams.length; index++) ...[
            _ExamCard(exam: exams[index]),
            if (index != exams.length - 1) const SizedBox(height: 12),
          ],
      ],
    );
  }

  List<ExamItem> _filteredExams(List<ExamItem> exams) {
    return switch (_filter) {
      _ExamScheduleFilter.upcoming =>
        exams
            .where(
              (exam) =>
                  exam.status == ExamStatus.upcoming ||
                  exam.status == ExamStatus.today ||
                  exam.status == ExamStatus.unknown,
            )
            .toList(growable: false),
      _ExamScheduleFilter.finished =>
        exams
            .where(
              (exam) =>
                  exam.status == ExamStatus.finished ||
                  exam.status == ExamStatus.cancelled,
            )
            .toList(growable: false),
      _ExamScheduleFilter.all => exams,
    };
  }
}
