import '../models/teacher_dashboard.dart';

abstract class TeacherHomeRemoteDataSource {
  Future<TeacherDashboard> getDashboard();
}
