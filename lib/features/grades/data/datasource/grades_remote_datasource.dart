import '../models/semester_grade_models.dart';

abstract class GradesRemoteDataSource {
  Future<List<SemesterOption>> getPeriods();

  Future<SemesterGradeSummary> getSummary({required SemesterOption period});

  Future<SubjectGrade> getSubjectDetail({
    required String periodId,
    required SubjectGrade subject,
  });
}
