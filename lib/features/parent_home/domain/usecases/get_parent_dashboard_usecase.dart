import '../../data/datasource/parent_home_remote_datasource.dart';
import '../../data/models/parent_dashboard.dart';

class GetParentDashboardUseCase {
  final ParentHomeRemoteDataSource remoteDataSource;

  const GetParentDashboardUseCase({required this.remoteDataSource});

  Future<ParentDashboard> call() {
    return remoteDataSource.getDashboard();
  }
}
