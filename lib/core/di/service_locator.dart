import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasource/auth_remote_datasource.dart';
import '../../features/auth/data/datasource/impl/auth_remote_datasource_impl.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/impl/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/request_password_reset_otp_usecase.dart';
import '../../features/auth/domain/usecases/reset_password_usecase.dart';
import '../../features/auth/domain/usecases/verify_password_reset_otp_usecase.dart';
import '../../features/clubs/data/datasource/clubs_remote_datasource.dart';
import '../../features/clubs/data/datasource/impl/clubs_remote_datasource_impl.dart';
import '../../features/clubs/domain/usecases/get_clubs_usecase.dart';
import '../../features/exams/data/datasource/exams_remote_datasource.dart';
import '../../features/exams/data/datasource/impl/exams_remote_datasource_impl.dart';
import '../../features/exams/domain/usecases/get_exam_schedule_usecase.dart';
import '../../features/grades/data/datasource/grades_remote_datasource.dart';
import '../../features/grades/data/datasource/impl/grades_remote_datasource_impl.dart';
import '../../features/grades/domain/usecases/get_grade_periods_usecase.dart';
import '../../features/grades/domain/usecases/get_semester_grade_summary_usecase.dart';
import '../../features/grades/domain/usecases/get_subject_grade_detail_usecase.dart';
import '../../features/home/data/datasource/home_remote_datasource.dart';
import '../../features/home/data/datasource/impl/home_remote_datasource_impl.dart';
import '../../features/home/domain/usecases/get_home_dashboard_usecase.dart';
import '../../features/notifications/data/datasource/impl/notifications_remote_datasource_impl.dart';
import '../../features/notifications/data/datasource/notifications_remote_datasource.dart';
import '../../features/notifications/domain/usecases/get_notifications_usecase.dart';
import '../../features/parent_home/data/datasource/impl/parent_home_remote_datasource_impl.dart';
import '../../features/parent_home/data/datasource/parent_home_remote_datasource.dart';
import '../../features/parent_home/domain/usecases/get_parent_dashboard_usecase.dart';
import '../../features/profile/data/datasource/profile_remote_datasource.dart';
import '../../features/profile/data/datasource/impl/profile_remote_datasource_impl.dart';
import '../../features/profile/domain/usecases/get_student_profile_usecase.dart';
import '../../features/requests/data/datasource/requests_remote_datasource.dart';
import '../../features/requests/data/datasource/impl/requests_remote_datasource_impl.dart';
import '../../features/requests/domain/usecases/get_request_types_usecase.dart';
import '../../features/requests/domain/usecases/get_student_requests_usecase.dart';
import '../../features/requests/domain/usecases/submit_student_request_usecase.dart';
import '../../features/schedule/data/datasource/schedule_remote_datasource.dart';
import '../../features/schedule/data/datasource/impl/schedule_remote_datasource_impl.dart';
import '../../features/schedule/domain/usecases/get_weekly_timetable_usecase.dart';
import '../../features/teacher_home/data/datasource/impl/teacher_home_remote_datasource_impl.dart';
import '../../features/teacher_home/data/datasource/teacher_home_remote_datasource.dart';
import '../../features/teacher_home/domain/usecases/get_teacher_dashboard_usecase.dart';
import '../../features/tuition/data/datasource/impl/tuition_remote_datasource_impl.dart';
import '../../features/tuition/data/datasource/tuition_remote_datasource.dart';
import '../../features/tuition/domain/usecases/get_tuition_overview_usecase.dart';

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
  if (!getIt.isRegistered<RequestPasswordResetOtpUseCase>()) {
    getIt.registerLazySingleton<RequestPasswordResetOtpUseCase>(
      () => RequestPasswordResetOtpUseCase(repository: getIt<AuthRepository>()),
    );
  }
  if (!getIt.isRegistered<VerifyPasswordResetOtpUseCase>()) {
    getIt.registerLazySingleton<VerifyPasswordResetOtpUseCase>(
      () => VerifyPasswordResetOtpUseCase(repository: getIt<AuthRepository>()),
    );
  }
  if (!getIt.isRegistered<ResetPasswordUseCase>()) {
    getIt.registerLazySingleton<ResetPasswordUseCase>(
      () => ResetPasswordUseCase(repository: getIt<AuthRepository>()),
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
  if (!getIt.isRegistered<NotificationsRemoteDataSource>()) {
    getIt.registerLazySingleton<NotificationsRemoteDataSource>(
      () => NotificationsRemoteDataSourceImpl(),
    );
  }
  if (!getIt.isRegistered<GetNotificationsUseCase>()) {
    getIt.registerLazySingleton<GetNotificationsUseCase>(
      () => GetNotificationsUseCase(
        remoteDataSource: getIt<NotificationsRemoteDataSource>(),
      ),
    );
  }
  if (!getIt.isRegistered<ParentHomeRemoteDataSource>()) {
    getIt.registerLazySingleton<ParentHomeRemoteDataSource>(
      () => ParentHomeRemoteDataSourceImpl(),
    );
  }
  if (!getIt.isRegistered<GetParentDashboardUseCase>()) {
    getIt.registerLazySingleton<GetParentDashboardUseCase>(
      () => GetParentDashboardUseCase(
        remoteDataSource: getIt<ParentHomeRemoteDataSource>(),
      ),
    );
  }
  if (!getIt.isRegistered<TeacherHomeRemoteDataSource>()) {
    getIt.registerLazySingleton<TeacherHomeRemoteDataSource>(
      () => TeacherHomeRemoteDataSourceImpl(),
    );
  }
  if (!getIt.isRegistered<GetTeacherDashboardUseCase>()) {
    getIt.registerLazySingleton<GetTeacherDashboardUseCase>(
      () => GetTeacherDashboardUseCase(
        remoteDataSource: getIt<TeacherHomeRemoteDataSource>(),
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
  if (!getIt.isRegistered<SubmitStudentRequestUseCase>()) {
    getIt.registerLazySingleton<SubmitStudentRequestUseCase>(
      () => SubmitStudentRequestUseCase(
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
  if (!getIt.isRegistered<ExamsRemoteDataSource>()) {
    getIt.registerLazySingleton<ExamsRemoteDataSource>(
      () => ExamsRemoteDataSourceImpl(),
    );
  }
  if (!getIt.isRegistered<GetExamScheduleUseCase>()) {
    getIt.registerLazySingleton<GetExamScheduleUseCase>(
      () => GetExamScheduleUseCase(
        remoteDataSource: getIt<ExamsRemoteDataSource>(),
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
  if (!getIt.isRegistered<TuitionRemoteDataSource>()) {
    getIt.registerLazySingleton<TuitionRemoteDataSource>(
      () => TuitionRemoteDataSourceImpl(),
    );
  }
  if (!getIt.isRegistered<GetTuitionOverviewUseCase>()) {
    getIt.registerLazySingleton<GetTuitionOverviewUseCase>(
      () => GetTuitionOverviewUseCase(
        remoteDataSource: getIt<TuitionRemoteDataSource>(),
      ),
    );
  }
}
