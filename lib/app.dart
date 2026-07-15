import 'package:flutter/material.dart';

import 'core/auth/user_role_resolver.dart';
import 'core/router/app_router.dart';
import 'core/router/router_names.dart';
import 'core/storage/token_storage.dart';
import 'core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FPT Schools',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: _initialRoute,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }

  String get _initialRoute {
    if (!TokenStorage.hasAccessToken) return RouterNames.login;

    return switch (TokenStorage.userRole) {
      UserRole.teacher => RouterNames.teacherHome,
      UserRole.parent => RouterNames.parentHome,
      _ => RouterNames.home,
    };
  }
}
