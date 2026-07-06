import '../models/club_models.dart';

abstract class ClubsRemoteDataSource {
  Future<List<ClubItem>> getClubs();
}
