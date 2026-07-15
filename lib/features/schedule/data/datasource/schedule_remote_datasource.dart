import '../models/timetable_models.dart';

abstract class ScheduleRemoteDataSource {
  Future<TimetableWeek> getWeeklyTimetable({
    required DateTime weekStart,
    String? studentId,
  });
}
