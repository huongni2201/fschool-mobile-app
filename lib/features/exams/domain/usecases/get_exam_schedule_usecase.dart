import '../../data/datasource/exams_remote_datasource.dart';
import '../../data/models/exam_schedule_models.dart';

class GetExamScheduleUseCase {
  final ExamsRemoteDataSource remoteDataSource;

  const GetExamScheduleUseCase({required this.remoteDataSource});

  Future<ExamSchedule> call() {
    return remoteDataSource.getExamSchedule();
  }
}
