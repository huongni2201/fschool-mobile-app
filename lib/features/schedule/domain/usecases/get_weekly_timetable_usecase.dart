import '../../data/datasource/schedule_remote_datasource.dart';
import '../../data/models/timetable_models.dart';

class GetWeeklyTimetableUseCase {
  final ScheduleRemoteDataSource remoteDataSource;

  const GetWeeklyTimetableUseCase({required this.remoteDataSource});

  Future<TimetableWeek> call({required DateTime weekStart}) {
    return remoteDataSource.getWeeklyTimetable(weekStart: weekStart);
  }
}
