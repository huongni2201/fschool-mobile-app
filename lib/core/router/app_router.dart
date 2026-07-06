import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/clubs/presentation/pages/clubs_page.dart';
import '../../features/grades/presentation/pages/semester_grades_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/requests/presentation/pages/requests_page.dart';
import '../../features/schedule/presentation/pages/timetable_page.dart';
import 'router_names.dart';

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return switch (settings.name) {
      RouterNames.login => _buildRoute(settings, const LoginPage()),
      RouterNames.forgotPassword => _buildRoute(
        settings,
        const ForgotPasswordPage(),
      ),
      RouterNames.home => _buildRoute(settings, const HomePage()),
      RouterNames.semesterGrades => _buildRoute(
        settings,
        const SemesterGradesPage(),
      ),
      RouterNames.timetable => _buildRoute(settings, const TimetablePage()),
      RouterNames.requests => _buildRoute(settings, const RequestsPage()),
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
}
