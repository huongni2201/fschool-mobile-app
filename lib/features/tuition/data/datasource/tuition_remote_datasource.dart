import '../models/tuition_models.dart';

abstract class TuitionRemoteDataSource {
  Future<TuitionOverview> getTuitionOverview();
}
