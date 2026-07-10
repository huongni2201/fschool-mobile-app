import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

abstract final class TuitionColors {
  static const Color canvas = AppColors.homeCanvas;
  static const Color surface = Colors.white;
  static const Color textStrong = AppColors.homeTextStrong;
  static const Color textMuted = AppColors.homeTextMuted;
  static const Color border = AppColors.homeBorder;
  static const Color divider = AppColors.homeDivider;
  static const Color primary = AppColors.homeOrange;
  static const Color primaryDark = AppColors.homeDeepOrange;
  static const Color primarySoft = AppColors.homeOrangeSoft;
  static const Color primaryLight = AppColors.homeOrangeLight;
  static const Color green = Color(0xFF27AE60);
  static const Color greenSoft = Color(0xFFEAF8F1);
  static const Color blue = Color(0xFF2F80ED);
  static const Color blueSoft = Color(0xFFEAF3FF);
  static const Color warning = Color(0xFFF2994A);
  static const Color warningSoft = Color(0xFFFFF4E6);
  static const Color error = AppColors.error;
  static const Color errorSoft = Color(0xFFFFEFEF);
  static const Color shadow = AppColors.homeCardShadow;
  static const Color warningBackground = AppColors.homeRefreshErrorBackground;
  static const Color warningBorder = AppColors.homeRefreshErrorBorder;
}
