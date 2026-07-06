import '../../data/datasource/clubs_remote_datasource.dart';
import '../../data/models/club_models.dart';

class GetClubsUseCase {
  final ClubsRemoteDataSource remoteDataSource;

  const GetClubsUseCase({required this.remoteDataSource});

  Future<List<ClubItem>> call() {
    return remoteDataSource.getClubs();
  }
}
