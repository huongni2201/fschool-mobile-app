import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

abstract final class AttendanceColors {
  static const Color canvas = AppColors.homeCanvas;
  static const Color surface = Colors.white;
  static const Color surfaceMuted = Color(0xB3FFFFFF);
  static const Color textStrong = AppColors.homeTextStrong;
  static const Color textMuted = AppColors.homeTextMuted;
  static const Color border = AppColors.homeBorder;
  static const Color primary = Color(0xFF2F80ED);
  static const Color primaryDark = Color(0xFF1D5DB8);
  static const Color primarySoft = Color(0xFFEAF3FF);

  static const List<Color> heroGradientColors = [primary, primaryDark];
}
