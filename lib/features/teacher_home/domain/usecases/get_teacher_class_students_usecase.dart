import '../../data/datasource/teacher_grades_remote_datasource.dart';
import '../../data/models/teacher_dashboard.dart';
import '../../data/models/teacher_grade_models.dart';

class GetTeacherClassStudentsUseCase {
  final TeacherGradesRemoteDataSource remoteDataSource;

  const GetTeacherClassStudentsUseCase({required this.remoteDataSource});

  Future<TeacherClassStudentsResult> call(TeacherClassSummary classSummary) {
    return remoteDataSource.getClassStudents(classSummary);
  }
}
