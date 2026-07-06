import '../../data/datasource/requests_remote_datasource.dart';
import '../../data/models/request_display_models.dart';

class GetRequestTypesUseCase {
  final RequestsRemoteDataSource remoteDataSource;

  const GetRequestTypesUseCase({required this.remoteDataSource});

  Future<List<RequestTypeItem>> call() {
    return remoteDataSource.getRequestTypes();
  }
}
