import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/router/router_names.dart';
import '../../../../core/widgets/main_bottom_navigation.dart';
import '../../data/models/teacher_dashboard.dart';
import '../../data/models/teacher_grade_models.dart';
import '../../domain/usecases/get_teacher_class_students_usecase.dart';
import '../constants/teacher_home_colors.dart';
import '../constants/teacher_home_strings.dart';
import '../utils/teacher_grade_flow_helpers.dart';
import '../widgets/teacher_class_summary_card.dart';
import '../widgets/teacher_flow_widgets.dart';
import '../widgets/teacher_student_card.dart';

class TeacherClassStudentsPageArgs {
  final TeacherClassSummary classSummary;

  const TeacherClassStudentsPageArgs({required this.classSummary});
}

class TeacherClassStudentsPage extends StatefulWidget {
  final TeacherClassSummary classSummary;

  const TeacherClassStudentsPage({super.key, required this.classSummary});

  @override
  State<TeacherClassStudentsPage> createState() =>
      _TeacherClassStudentsPageState();
}

class _TeacherClassStudentsPageState extends State<TeacherClassStudentsPage> {
  late final GetTeacherClassStudentsUseCase _getClassStudentsUseCase;

  TeacherClassStudentsResult? _result;
  Object? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _getClassStudentsUseCase = getIt<GetTeacherClassStudentsUseCase>();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    if (widget.classSummary.id.trim().isEmpty) {
      setState(() {
        _error = const ParsingException(TeacherHomeStrings.noClassIdMessage);
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await _getClassStudentsUseCase(widget.classSummary);

      if (!mounted) return;

      setState(() {
        _result = result;
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

  void _openStudentGrades(TeacherGradeStudent student) {
    if (student.id.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Chưa có mã học sinh')));
      return;
    }

    Navigator.of(
      context,
    ).pushNamed(RouterNames.semesterGrades, arguments: student.id);
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;
    final classSummary = result?.classSummary ?? widget.classSummary;
    final students = result?.students ?? const <TeacherGradeStudent>[];

    return Scaffold(
      backgroundColor: TeacherHomeColors.canvas,
      body: SafeArea(
        child: RefreshIndicator(
          color: TeacherHomeColors.primary,
          onRefresh: _loadStudents,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            children: [
              TeacherFlowTopBar(
                title: TeacherHomeStrings.classStudentsTitle,
                subtitle: TeacherHomeStrings.classStudentsSubtitle,
                onBack: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(height: 18),
              TeacherClassSummaryCard(classSummary: classSummary),
              const SizedBox(height: 18),
              if (_isLoading)
                const TeacherFlowLoadingCard()
              else if (result == null)
                TeacherFlowMessageCard(
                  icon: Icons.cloud_off_rounded,
                  title: widget.classSummary.id.trim().isEmpty
                      ? TeacherHomeStrings.noClassIdTitle
                      : TeacherHomeStrings.loadFailedTitle,
                  message: teacherFlowErrorMessage(_error),
                  onRetry: widget.classSummary.id.trim().isEmpty
                      ? null
                      : _loadStudents,
                )
              else ...[
                const TeacherFlowSectionHeader(
                  title: TeacherHomeStrings.classStudentsSection,
                ),
                const SizedBox(height: 10),
                if (students.isEmpty)
                  const TeacherFlowMessageCard(
                    icon: Icons.person_search_rounded,
                    title: TeacherHomeStrings.noStudentsTitle,
                    message: TeacherHomeStrings.noStudentsMessage,
                  )
                else
                  for (final student in students) ...[
                    TeacherStudentCard(
                      student: student,
                      onTap: () => _openStudentGrades(student),
                    ),
                    const SizedBox(height: 10),
                  ],
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MainBottomNavigation(),
    );
  }
}
