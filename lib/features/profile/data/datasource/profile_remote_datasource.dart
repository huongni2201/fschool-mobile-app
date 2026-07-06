import '../models/student_profile.dart';

abstract class ProfileRemoteDataSource {
  Future<StudentProfile> getProfile();
}
