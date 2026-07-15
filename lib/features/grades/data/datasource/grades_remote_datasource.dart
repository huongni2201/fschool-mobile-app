import '../models/semester_grade_models.dart';

abstract class GradesRemoteDataSource {
  Future<List<SemesterOption>> getPeriods({String? studentId});

  Future<SemesterGradeSummary> getSummary({
    required SemesterOption period,
    String? studentId,
  });

  Future<SubjectGrade> getSubjectDetail({
    required String periodId,
    required SubjectGrade subject,
    String? studentId,
  });
}
