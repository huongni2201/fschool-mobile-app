import 'package:flutter/material.dart';

import '../../../../core/widgets/main_bottom_navigation.dart';
import '../constants/attendance_colors.dart';
import '../constants/attendance_strings.dart';

part '../widgets/attendance_header.dart';
part '../widgets/attendance_hero_card.dart';
part '../widgets/attendance_message_card.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AttendanceColors.canvas,
      body: SafeArea(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          children: [
            _AttendanceHeader(onBack: () => Navigator.of(context).maybePop()),
            const SizedBox(height: 18),
            const _AttendanceHeroCard(),
            const SizedBox(height: 18),
            const _AttendanceMessageCard(),
          ],
        ),
      ),
      bottomNavigationBar: const MainBottomNavigation(),
    );
  }
}
