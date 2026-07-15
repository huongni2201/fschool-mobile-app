import '../../data/datasource/requests_remote_datasource.dart';
import '../../data/models/request_display_models.dart';

class SubmitStudentRequestUseCase {
  final RequestsRemoteDataSource remoteDataSource;

  const SubmitStudentRequestUseCase({required this.remoteDataSource});

  Future<StudentRequestItem> call(
    CreateStudentRequestPayload payload, {
    String? studentId,
  }) {
    return remoteDataSource.submitStudentRequest(payload, studentId: studentId);
  }
}
