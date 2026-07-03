import 'package:flutter/material.dart';

import '../constants/semester_grade_colors.dart';
import '../constants/semester_grade_sizes.dart';
import '../constants/semester_grade_strings.dart';

part '../data/semester_grade_models.dart';
part '../data/semester_grades_mock_data.dart';
part '../utils/semester_grade_helpers.dart';
part '../widgets/semester_grade_header.dart';
part '../widgets/semester_grade_note_card.dart';
part '../widgets/semester_grade_overview.dart';
part '../widgets/semester_switcher.dart';
part '../widgets/subject_grade_detail_page.dart';
part '../widgets/subject_grade_card.dart';

class SemesterGradesPage extends StatefulWidget {
  const SemesterGradesPage({super.key});

  @override
  State<SemesterGradesPage> createState() => _SemesterGradesPageState();
}

class _SemesterGradesPageState extends State<SemesterGradesPage> {
  int _selectedSemesterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final semester = _semesters[_selectedSemesterIndex];
    final subjects = _gradesBySemester[semester.key] ?? const [];
    final average = _averageOf(subjects);
    final strongestSubject = _strongestSubjectOf(subjects);

    return Scaffold(
      backgroundColor: SemesterGradeColors.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            SemesterGradeSizes.pagePaddingHorizontal,
            SemesterGradeSizes.pagePaddingTop,
            SemesterGradeSizes.pagePaddingHorizontal,
            SemesterGradeSizes.pagePaddingBottom,
          ),
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
                options: _semesters,
                selectedIndex: _selectedSemesterIndex,
                onSelected: (index) {
                  setState(() {
                    _selectedSemesterIndex = index;
                  });
                },
              ),
              const SizedBox(height: SemesterGradeSizes.spacing3xl),
              const _SubjectListHeader(),
              const SizedBox(height: SemesterGradeSizes.spacingLg),
              for (final subject in subjects) ...[
                _SubjectGradeCard(subject: subject),
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
