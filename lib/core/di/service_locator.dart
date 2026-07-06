import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasource/auth_remote_datasource.dart';
import '../../features/auth/data/datasource/impl/auth_remote_datasource_impl.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/impl/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/clubs/data/datasource/clubs_remote_datasource.dart';
import '../../features/clubs/data/datasource/impl/clubs_remote_datasource_impl.dart';
import '../../features/clubs/domain/usecases/get_clubs_usecase.dart';
import '../../features/grades/data/datasource/grades_remote_datasource.dart';
import '../../features/grades/data/datasource/impl/grades_remote_datasource_impl.dart';
import '../../features/grades/domain/usecases/get_grade_periods_usecase.dart';
import '../../features/grades/domain/usecases/get_semester_grade_summary_usecase.dart';
import '../../features/grades/domain/usecases/get_subject_grade_detail_usecase.dart';
import '../../features/home/data/datasource/home_remote_datasource.dart';
import '../../features/home/data/datasource/impl/home_remote_datasource_impl.dart';
import '../../features/home/domain/usecases/get_home_dashboard_usecase.dart';
import '../../features/profile/data/datasource/profile_remote_datasource.dart';
import '../../features/profile/data/datasource/impl/profile_remote_datasource_impl.dart';
import '../../features/profile/domain/usecases/get_student_profile_usecase.dart';
import '../../features/requests/data/datasource/requests_remote_datasource.dart';
import '../../features/requests/data/datasource/impl/requests_remote_datasource_impl.dart';
import '../../features/requests/domain/usecases/get_request_types_usecase.dart';
import '../../features/requests/domain/usecases/get_student_requests_usecase.dart';
import '../../features/schedule/data/datasource/schedule_remote_datasource.dart';
import '../../features/schedule/data/datasource/impl/schedule_remote_datasource_impl.dart';
import '../../features/schedule/domain/usecases/get_weekly_timetable_usecase.dart';

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
  if (!getIt.isRegistered<ProfileRemoteDataSource>()) {
    getIt.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(),
    );
  }
  if (!getIt.isRegistered<GetStudentProfileUseCase>()) {
    getIt.registerLazySingleton<GetStudentProfileUseCase>(
      () => GetStudentProfileUseCase(
        remoteDataSource: getIt<ProfileRemoteDataSource>(),
      ),
    );
  }
  if (!getIt.isRegistered<RequestsRemoteDataSource>()) {
    getIt.registerLazySingleton<RequestsRemoteDataSource>(
      () => RequestsRemoteDataSourceImpl(),
    );
  }
  if (!getIt.isRegistered<GetRequestTypesUseCase>()) {
    getIt.registerLazySingleton<GetRequestTypesUseCase>(
      () => GetRequestTypesUseCase(
        remoteDataSource: getIt<RequestsRemoteDataSource>(),
      ),
    );
  }
  if (!getIt.isRegistered<GetStudentRequestsUseCase>()) {
    getIt.registerLazySingleton<GetStudentRequestsUseCase>(
      () => GetStudentRequestsUseCase(
        remoteDataSource: getIt<RequestsRemoteDataSource>(),
      ),
    );
  }
  if (!getIt.isRegistered<ClubsRemoteDataSource>()) {
    getIt.registerLazySingleton<ClubsRemoteDataSource>(
      () => ClubsRemoteDataSourceImpl(),
    );
  }
  if (!getIt.isRegistered<GetClubsUseCase>()) {
    getIt.registerLazySingleton<GetClubsUseCase>(
      () => GetClubsUseCase(remoteDataSource: getIt<ClubsRemoteDataSource>()),
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
  if (!getIt.isRegistered<ScheduleRemoteDataSource>()) {
    getIt.registerLazySingleton<ScheduleRemoteDataSource>(
      () => ScheduleRemoteDataSourceImpl(),
    );
  }
  if (!getIt.isRegistered<GetWeeklyTimetableUseCase>()) {
    getIt.registerLazySingleton<GetWeeklyTimetableUseCase>(
      () => GetWeeklyTimetableUseCase(
        remoteDataSource: getIt<ScheduleRemoteDataSource>(),
      ),
    );
  }
}
