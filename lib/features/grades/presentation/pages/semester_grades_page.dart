import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/main_bottom_navigation.dart';
import '../../data/models/semester_grade_models.dart';
import '../../domain/usecases/get_grade_periods_usecase.dart';
import '../../domain/usecases/get_semester_grade_summary_usecase.dart';
import '../../domain/usecases/get_subject_grade_detail_usecase.dart';
import '../constants/semester_grade_colors.dart';
import '../constants/semester_grade_sizes.dart';
import '../constants/semester_grade_strings.dart';

part '../utils/semester_grade_helpers.dart';
part '../widgets/semester_grade_header.dart';
part '../widgets/semester_grade_note_card.dart';
part '../widgets/semester_grade_overview.dart';
part '../widgets/semester_switcher.dart';
part '../widgets/subject_grade_detail_page.dart';
part '../widgets/subject_grade_card.dart';

class SemesterGradesPage extends StatefulWidget {
  final String? studentId;

  const SemesterGradesPage({super.key, this.studentId});

  @override
  State<SemesterGradesPage> createState() => _SemesterGradesPageState();
}

class _SemesterGradesPageState extends State<SemesterGradesPage> {
  late final GetGradePeriodsUseCase _getGradePeriodsUseCase;
  late final GetSemesterGradeSummaryUseCase _getSummaryUseCase;

  List<SemesterOption> _semesters = const [];
  SemesterGradeSummary? _summary;
  Object? _error;
  int _selectedSemesterIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _getGradePeriodsUseCase = getIt<GetGradePeriodsUseCase>();
    _getSummaryUseCase = getIt<GetSemesterGradeSummaryUseCase>();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final periods = await _getGradePeriodsUseCase(
        studentId: widget.studentId,
      );

      if (!mounted) return;

      if (periods.isEmpty) {
        setState(() {
          _semesters = const [];
          _summary = null;
          _error = StateError('No grade periods');
          _isLoading = false;
        });
        return;
      }

      final selectedIndex = _selectedSemesterIndex.clamp(0, periods.length - 1);
      final summary = await _getSummaryUseCase(
        period: periods[selectedIndex],
        studentId: widget.studentId,
      );

      if (!mounted) return;

      setState(() {
        _semesters = periods;
        _selectedSemesterIndex = selectedIndex;
        _summary = summary;
        _error = null;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadSummary(int index) async {
    final period = _semesters[index];

    setState(() {
      _selectedSemesterIndex = index;
      _isLoading = true;
      _error = null;
    });

    try {
      final summary = await _getSummaryUseCase(
        period: period,
        studentId: widget.studentId,
      );

      if (!mounted) return;

      setState(() {
        _summary = summary;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error;
        _summary = null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = _summary;
    final semesters = _semesters;

    if (_isLoading && summary == null) {
      return const _SemesterGradesScaffold(child: _SemesterGradesLoadingView());
    }

    if (summary == null || semesters.isEmpty) {
      return _SemesterGradesScaffold(
        child: _SemesterGradesErrorView(
          message: _gradeErrorMessage(_error),
          onRetry: _loadInitialData,
        ),
      );
    }

    final semester = semesters[_selectedSemesterIndex];
    final subjects = summary.subjects;
    final average = summary.overallAverage ?? _averageOf(subjects);
    final strongestSubject = _strongestSubjectOf(subjects);

    return _SemesterGradesScaffold(
      child: RefreshIndicator(
        color: SemesterGradeColors.primary,
        onRefresh: _loadInitialData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GradePageHeader(
                title: SemesterGradeStrings.pageTitle,
                subtitle: SemesterGradeStrings.pageSubtitle(
                  semester.title,
                  semester.schoolYear,
                ),
              ),
              const SizedBox(height: SemesterGradeSizes.spacing2xl),
              _GradeOverviewCard(
                average: average,
                rankLabel: _rankLabel(average),
                subjectCount: subjects.length,
                excellentCount: subjects
                    .where((subject) => (subject.average ?? 0) >= 8)
                    .length,
                strongestSubject:
                    strongestSubject?.subject ?? SemesterGradeStrings.updating,
              ),
              const SizedBox(height: SemesterGradeSizes.spacing2xl),
              _SemesterSwitcher(
                options: semesters,
                selectedIndex: _selectedSemesterIndex,
                onSelected: _loadSummary,
              ),
              const SizedBox(height: SemesterGradeSizes.spacing3xl),
              const _SubjectListHeader(),
              const SizedBox(height: SemesterGradeSizes.spacingLg),
              for (final subject in subjects) ...[
                _SubjectGradeCard(
                  periodId: semester.key,
                  subject: subject,
                  studentId: widget.studentId,
                ),
                const SizedBox(height: SemesterGradeSizes.spacingLg),
              ],
              const SizedBox(height: SemesterGradeSizes.spacingXxs),
              const _GradeNoteCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SemesterGradesScaffold extends StatelessWidget {
  final Widget child;

  const _SemesterGradesScaffold({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SemesterGradeColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            SemesterGradeSizes.pagePaddingHorizontal,
            SemesterGradeSizes.pagePaddingTop,
            SemesterGradeSizes.pagePaddingHorizontal,
            SemesterGradeSizes.pagePaddingBottom,
          ),
          child: child,
        ),
      ),
      bottomNavigationBar: const MainBottomNavigation(),
    );
  }
}

class _SemesterGradesLoadingView extends StatelessWidget {
  const _SemesterGradesLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: SemesterGradeColors.primary),
    );
  }
}

class _SemesterGradesErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _SemesterGradesErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            color: SemesterGradeColors.primary,
            size: 46,
          ),
          const SizedBox(height: SemesterGradeSizes.spacingLg),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: SemesterGradeColors.textMuted,
              fontSize: SemesterGradeSizes.overviewSubtitleSize,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: SemesterGradeSizes.spacing2xl),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
            style: FilledButton.styleFrom(
              backgroundColor: SemesterGradeColors.primary,
              foregroundColor: SemesterGradeColors.surface,
            ),
          ),
        ],
      ),
    );
  }
}
