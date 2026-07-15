import '../models/request_display_models.dart';

abstract class RequestsRemoteDataSource {
  Future<List<RequestTypeItem>> getRequestTypes({String? studentId});

  Future<List<StudentRequestItem>> getStudentRequests({
    int page = 1,
    int limit = 20,
    String? studentId,
  });

  Future<StudentRequestItem> submitStudentRequest(
    CreateStudentRequestPayload payload, {
    String? studentId,
  });
}
