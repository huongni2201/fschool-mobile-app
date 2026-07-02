import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myfschool/app.dart';
import 'package:myfschool/core/constants/app_strings.dart';
import 'package:myfschool/core/di/service_locator.dart';

void main() {
  setUpAll(setupServiceLocator);

  testWidgets('Login page renders', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    expect(find.text(AppStrings.login), findsOneWidget);
    expect(find.byIcon(Icons.phone_outlined), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
  });
}
