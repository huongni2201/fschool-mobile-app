import '../../data/datasource/requests_remote_datasource.dart';
import '../../data/models/request_display_models.dart';

class GetStudentRequestsUseCase {
  final RequestsRemoteDataSource remoteDataSource;

  const GetStudentRequestsUseCase({required this.remoteDataSource});

  Future<List<StudentRequestItem>> call({int page = 1, int limit = 20}) {
    return remoteDataSource.getStudentRequests(page: page, limit: limit);
  }
}
