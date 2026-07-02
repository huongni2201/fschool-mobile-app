import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasource/auth_remote_datasource.dart';
import '../../features/auth/data/datasource/impl/auth_remote_datasource_impl.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/impl/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/home/data/datasource/home_remote_datasource.dart';
import '../../features/home/data/datasource/impl/home_remote_datasource_impl.dart';
import '../../features/home/domain/usecases/get_home_dashboard_usecase.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  if (getIt.isRegistered<LoginUseCase>()) return;

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDatasourceImpl(),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt<AuthRemoteDataSource>()),
  );
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(),
  );
  getIt.registerLazySingleton<GetHomeDashboardUseCase>(
    () => GetHomeDashboardUseCase(
      remoteDataSource: getIt<HomeRemoteDataSource>(),
    ),
  );
}
