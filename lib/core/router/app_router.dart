import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/grades/presentation/pages/semester_grades_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
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
