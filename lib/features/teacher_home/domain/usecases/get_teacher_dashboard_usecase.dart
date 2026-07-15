import '../../data/datasource/teacher_home_remote_datasource.dart';
import '../../data/models/teacher_dashboard.dart';

class GetTeacherDashboardUseCase {
  final TeacherHomeRemoteDataSource remoteDataSource;

  const GetTeacherDashboardUseCase({required this.remoteDataSource});

  Future<TeacherDashboard> call() {
    return remoteDataSource.getDashboard();
  }
}
