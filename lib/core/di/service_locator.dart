import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasource/auth_remote_datasource.dart';
import '../../features/auth/data/datasource/impl/auth_remote_datasource_impl.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/impl/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/grades/data/datasource/grades_remote_datasource.dart';
import '../../features/grades/data/datasource/impl/grades_remote_datasource_impl.dart';
import '../../features/grades/domain/usecases/get_grade_periods_usecase.dart';
import '../../features/grades/domain/usecases/get_semester_grade_summary_usecase.dart';
import '../../features/grades/domain/usecases/get_subject_grade_detail_usecase.dart';
import '../../features/home/data/datasource/home_remote_datasource.dart';
import '../../features/home/data/datasource/impl/home_remote_datasource_impl.dart';
import '../../features/home/domain/usecases/get_home_dashboard_usecase.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  if (!getIt.isRegistered<AuthRemoteDataSource>()) {
    getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDatasourceImpl(),
    );
  }
  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: getIt<AuthRemoteDataSource>()),
    );
  }
  if (!getIt.isRegistered<LoginUseCase>()) {
    getIt.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(repository: getIt<AuthRepository>()),
    );
  }
  if (!getIt.isRegistered<HomeRemoteDataSource>()) {
    getIt.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(),
    );
  }
  if (!getIt.isRegistered<GetHomeDashboardUseCase>()) {
    getIt.registerLazySingleton<GetHomeDashboardUseCase>(
      () => GetHomeDashboardUseCase(
        remoteDataSource: getIt<HomeRemoteDataSource>(),
      ),
    );
  }
  if (!getIt.isRegistered<GradesRemoteDataSource>()) {
    getIt.registerLazySingleton<GradesRemoteDataSource>(
      () => GradesRemoteDataSourceImpl(),
    );
  }
  if (!getIt.isRegistered<GetGradePeriodsUseCase>()) {
    getIt.registerLazySingleton<GetGradePeriodsUseCase>(
      () => GetGradePeriodsUseCase(
        remoteDataSource: getIt<GradesRemoteDataSource>(),
      ),
    );
  }
  if (!getIt.isRegistered<GetSemesterGradeSummaryUseCase>()) {
    getIt.registerLazySingleton<GetSemesterGradeSummaryUseCase>(
      () => GetSemesterGradeSummaryUseCase(
        remoteDataSource: getIt<GradesRemoteDataSource>(),
      ),
    );
  }
  if (!getIt.isRegistered<GetSubjectGradeDetailUseCase>()) {
    getIt.registerLazySingleton<GetSubjectGradeDetailUseCase>(
      () => GetSubjectGradeDetailUseCase(
        remoteDataSource: getIt<GradesRemoteDataSource>(),
      ),
    );
  }
}
