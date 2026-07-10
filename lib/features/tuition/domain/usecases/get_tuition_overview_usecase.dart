import '../../data/datasource/tuition_remote_datasource.dart';
import '../../data/models/tuition_models.dart';

class GetTuitionOverviewUseCase {
  final TuitionRemoteDataSource remoteDataSource;

  const GetTuitionOverviewUseCase({required this.remoteDataSource});

  Future<TuitionOverview> call() {
    return remoteDataSource.getTuitionOverview();
  }
}
