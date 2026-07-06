import '../../data/datasource/profile_remote_datasource.dart';
import '../../data/models/student_profile.dart';

class GetStudentProfileUseCase {
  final ProfileRemoteDataSource remoteDataSource;

  const GetStudentProfileUseCase({required this.remoteDataSource});

  Future<StudentProfile> call() {
    return remoteDataSource.getProfile();
  }
}
