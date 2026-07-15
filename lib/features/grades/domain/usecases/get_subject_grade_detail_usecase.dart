import '../../data/datasource/grades_remote_datasource.dart';
import '../../data/models/semester_grade_models.dart';

class GetSubjectGradeDetailUseCase {
  final GradesRemoteDataSource remoteDataSource;

  const GetSubjectGradeDetailUseCase({required this.remoteDataSource});

  Future<SubjectGrade> call({
    required String periodId,
    required SubjectGrade subject,
    String? studentId,
  }) {
    return remoteDataSource.getSubjectDetail(
      periodId: periodId,
      subject: subject,
      studentId: studentId,
    );
  }
}
