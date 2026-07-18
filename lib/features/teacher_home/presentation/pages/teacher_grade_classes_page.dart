import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/router/router_names.dart';
import '../../../../core/widgets/main_bottom_navigation.dart';
import '../../data/models/teacher_dashboard.dart';
import '../../domain/usecases/get_teacher_dashboard_usecase.dart';
import '../constants/teacher_home_colors.dart';
import '../constants/teacher_home_strings.dart';
import '../utils/teacher_grade_flow_helpers.dart';
import '../widgets/teacher_flow_widgets.dart';
import '../widgets/teacher_grade_class_card.dart';
import 'teacher_class_students_page.dart';

class TeacherGradeClassesPage extends StatefulWidget {
  const TeacherGradeClassesPage({super.key});

  @override
  State<TeacherGradeClassesPage> createState() =>
      _TeacherGradeClassesPageState();
}

class _TeacherGradeClassesPageState extends State<TeacherGradeClassesPage> {
  late final GetTeacherDashboardUseCase _getDashboardUseCase;

  TeacherDashboard? _dashboard;
  Object? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _getDashboardUseCase = getIt<GetTeacherDashboardUseCase>();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final dashboard = await _getDashboardUseCase();

      if (!mounted) return;

      setState(() {
        _dashboard = dashboard;
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

  void _openClass(TeacherClassSummary classSummary) {
    if (classSummary.id.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(TeacherHomeStrings.noClassIdMessage)),
      );
      return;
    }

    Navigator.of(context).pushNamed(
      RouterNames.teacherClassStudents,
      arguments: TeacherClassStudentsPageArgs(classSummary: classSummary),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = _dashboard;
    final classes = dashboard == null
        ? const <TeacherClassSummary>[]
        : classesForTeacherGrades(dashboard);

    return Scaffold(
      backgroundColor: TeacherHomeColors.canvas,
      body: SafeArea(
        child: RefreshIndicator(
          color: TeacherHomeColors.primary,
          onRefresh: _loadClasses,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            children: [
              TeacherFlowTopBar(
                title: TeacherHomeStrings.gradeClassesTitle,
                subtitle: TeacherHomeStrings.gradeClassesSubtitle,
                onBack: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(height: 18),
              if (_isLoading)
                const TeacherFlowLoadingCard()
              else if (dashboard == null)
                TeacherFlowMessageCard(
                  icon: Icons.cloud_off_rounded,
                  title: TeacherHomeStrings.loadFailedTitle,
                  message: teacherFlowErrorMessage(_error),
                  onRetry: _loadClasses,
                )
              else ...[
                const TeacherFlowSectionHeader(
                  title: TeacherHomeStrings.gradeClassesSection,
                ),
                const SizedBox(height: 10),
                if (classes.isEmpty)
                  const TeacherFlowMessageCard(
                    icon: Icons.groups_2_outlined,
                    title: TeacherHomeStrings.noManagedClassTitle,
                    message: TeacherHomeStrings.noManagedClassMessage,
                  )
                else
                  for (final classSummary in classes) ...[
                    TeacherGradeClassCard(
                      classSummary: classSummary,
                      onTap: () => _openClass(classSummary),
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
