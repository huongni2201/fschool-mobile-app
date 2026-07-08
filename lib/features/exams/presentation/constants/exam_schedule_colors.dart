import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

abstract final class ExamScheduleColors {
  static const Color canvas = AppColors.homeCanvas;
  static const Color surface = Colors.white;
  static const Color textStrong = AppColors.homeTextStrong;
  static const Color textMuted = AppColors.homeTextMuted;
  static const Color border = AppColors.homeBorder;
  static const Color divider = AppColors.homeDivider;
  static const Color primary = AppColors.homeOrange;
  static const Color primaryDark = AppColors.homeDeepOrange;
  static const Color primarySoft = AppColors.homeOrangeSoft;
  static const Color error = AppColors.error;
  static const Color shadow = AppColors.homeCardShadow;
  static const Color done = AppColors.homeDone;
  static const Color today = AppColors.homeNext;
  static const Color warningBackground = AppColors.homeRefreshErrorBackground;
  static const Color warningBorder = AppColors.homeRefreshErrorBorder;
  static const Color heroSurface = primary;
  static const Color heroAccentSurface = primarySoft;
  static const Color heroText = surface;
  static const Color heroTextMuted = Color(0xFFFFE0CC);
  static const Color heroBorder = primaryDark;
  static const Color heroInnerSurface = Color(0xFFFFF3EA);
}
