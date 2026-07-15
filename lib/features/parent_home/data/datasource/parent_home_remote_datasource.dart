import '../models/parent_dashboard.dart';

abstract class ParentHomeRemoteDataSource {
  Future<ParentDashboard> getDashboard();
}
