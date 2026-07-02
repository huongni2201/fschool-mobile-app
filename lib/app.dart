import 'package:flutter/material.dart';

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
      initialRoute: TokenStorage.hasAccessToken
          ? RouterNames.home
          : RouterNames.login,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
