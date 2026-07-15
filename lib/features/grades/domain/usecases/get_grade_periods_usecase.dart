import '../../data/datasource/grades_remote_datasource.dart';
import '../../data/models/semester_grade_models.dart';

class GetGradePeriodsUseCase {
  final GradesRemoteDataSource remoteDataSource;

  const GetGradePeriodsUseCase({required this.remoteDataSource});

  Future<List<SemesterOption>> call({String? studentId}) {
    return remoteDataSource.getPeriods(studentId: studentId);
  }
}
