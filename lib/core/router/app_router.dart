import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/clubs/presentation/pages/clubs_page.dart';
import '../../features/exams/presentation/pages/exam_schedule_page.dart';
import '../../features/grades/presentation/pages/semester_grades_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/parent_home/presentation/pages/parent_home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/requests/data/models/request_display_models.dart';
import '../../features/requests/presentation/pages/create_request_page.dart';
import '../../features/requests/presentation/pages/requests_page.dart';
import '../../features/schedule/presentation/pages/timetable_page.dart';
import '../../features/teacher_home/presentation/pages/teacher_home_page.dart';
import '../../features/tuition/presentation/pages/tuition_page.dart';
import '../auth/user_role_resolver.dart';
import '../storage/token_storage.dart';
import 'router_names.dart';

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return switch (settings.name) {
      RouterNames.login => _buildRoute(settings, const LoginPage()),
      RouterNames.forgotPassword => _buildRoute(
        settings,
        const ForgotPasswordPage(),
      ),
      RouterNames.home => _buildRoute(settings, _homePageForRole()),
      RouterNames.parentHome => _buildRoute(settings, const ParentHomePage()),
      RouterNames.teacherHome => _buildRoute(settings, const TeacherHomePage()),
      RouterNames.semesterGrades => _buildRoute(
        settings,
        SemesterGradesPage(studentId: _studentIdFromArguments(settings)),
      ),
      RouterNames.timetable => _buildRoute(
        settings,
        TimetablePage(studentId: _studentIdFromArguments(settings)),
      ),
      RouterNames.examSchedule => _buildRoute(
        settings,
        const ExamSchedulePage(),
      ),
      RouterNames.notifications => _buildRoute(
        settings,
        NotificationsPage(studentId: _studentIdFromArguments(settings)),
      ),
      RouterNames.requests => _buildRoute(
        settings,
        RequestsPage(studentId: _studentIdFromArguments(settings)),
      ),
      RouterNames.createRequest => _buildRoute(
        settings,
        _createRequestPage(settings),
      ),
      RouterNames.tuition => _buildRoute(
        settings,
        TuitionPage(studentId: _studentIdFromArguments(settings)),
      ),
      RouterNames.profile => _buildRoute(settings, const ProfilePage()),
      RouterNames.clubs => _buildRoute(settings, const ClubsPage()),
      _ => _buildRoute(settings, const LoginPage()),
    };
  }

  static MaterialPageRoute<dynamic> _buildRoute(
    RouteSettings settings,
    Widget page,
  ) {
    return MaterialPageRoute<dynamic>(settings: settings, builder: (_) => page);
  }

  static Widget _createRequestPage(RouteSettings settings) {
    final arguments = settings.arguments;

    if (arguments is CreateRequestPageArgs) {
      return CreateRequestPage(
        requestType: arguments.requestType,
        studentId: arguments.studentId,
      );
    }

    if (arguments is RequestTypeItem) {
      return CreateRequestPage(requestType: arguments);
    }

    return const RequestsPage();
  }

  static Widget _homePageForRole() {
    return switch (TokenStorage.userRole) {
      UserRole.teacher => const TeacherHomePage(),
      UserRole.parent => const ParentHomePage(),
      _ => const HomePage(),
    };
  }

  static String? _studentIdFromArguments(RouteSettings settings) {
    final arguments = settings.arguments;

    if (arguments is String && arguments.trim().isNotEmpty) {
      return arguments.trim();
    }

    return null;
  }
}
