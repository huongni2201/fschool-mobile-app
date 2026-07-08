import '../models/exam_schedule_models.dart';

abstract class ExamsRemoteDataSource {
  Future<ExamSchedule> getExamSchedule();
}
