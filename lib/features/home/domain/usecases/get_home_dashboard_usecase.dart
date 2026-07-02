import '../../data/datasource/home_remote_datasource.dart';
import '../../data/models/home_dashboard.dart';

class GetHomeDashboardUseCase {
  final HomeRemoteDataSource remoteDataSource;

  const GetHomeDashboardUseCase({required this.remoteDataSource});

  Future<HomeDashboard> call() {
    return remoteDataSource.getDashboard();
  }
}
