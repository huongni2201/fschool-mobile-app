import '../models/request_display_models.dart';

abstract class RequestsRemoteDataSource {
  Future<List<RequestTypeItem>> getRequestTypes();

  Future<List<StudentRequestItem>> getStudentRequests({
    int page = 1,
    int limit = 20,
  });

  Future<StudentRequestItem> submitStudentRequest(
    CreateStudentRequestPayload payload,
  );
}
