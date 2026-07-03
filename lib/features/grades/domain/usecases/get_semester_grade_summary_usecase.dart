import '../../data/datasource/grades_remote_datasource.dart';
import '../../data/models/semester_grade_models.dart';

class GetSemesterGradeSummaryUseCase {
  final GradesRemoteDataSource remoteDataSource;

  const GetSemesterGradeSummaryUseCase({required this.remoteDataSource});

  Future<SemesterGradeSummary> call({required SemesterOption period}) {
    return remoteDataSource.getSummary(period: period);
  }
}
