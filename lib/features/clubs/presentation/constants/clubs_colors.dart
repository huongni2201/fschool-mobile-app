import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

abstract final class ClubsColors {
  static const Color canvas = AppColors.homeCanvas;
  static const Color surface = Colors.white;
  static const Color surfaceMuted = Color(0xB3FFFFFF);
  static const Color textStrong = AppColors.homeTextStrong;
  static const Color textMuted = AppColors.homeTextMuted;
  static const Color border = AppColors.homeBorder;
  static const Color divider = AppColors.homeDivider;
  static const Color primary = AppColors.homeOrange;
  static const Color primaryDark = AppColors.homeDeepOrange;
  static const Color primarySoft = AppColors.homeOrangeSoft;
  static const Color blue = Color(0xFF2F80ED);
  static const Color green = Color(0xFF27AE60);
  static const Color brown = Color(0xFF9B6A3D);

  static const List<Color> heroGradientColors = [primary, primaryDark];
}
