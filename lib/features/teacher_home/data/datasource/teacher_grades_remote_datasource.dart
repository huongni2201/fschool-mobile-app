import '../models/teacher_dashboard.dart';
import '../models/teacher_grade_models.dart';

abstract class TeacherGradesRemoteDataSource {
  Future<TeacherClassStudentsResult> getClassStudents(
    TeacherClassSummary classSummary,
  );
}
