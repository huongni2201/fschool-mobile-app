import '../models/home_dashboard.dart';

abstract class HomeRemoteDataSource {
  Future<HomeDashboard> getDashboard();
}
