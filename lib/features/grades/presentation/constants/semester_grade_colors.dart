import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

abstract final class SemesterGradeColors {
  static const Color canvas = AppColors.homeCanvas;
  static const Color surface = Colors.white;
  static const Color transparent = Colors.transparent;
  static const Color primary = AppColors.homeOrange;
  static const Color primaryDeep = AppColors.homeDeepOrange;
  static const Color primarySoft = AppColors.homeOrangeSoft;
  static const Color textStrong = AppColors.homeTextStrong;
  static const Color textMuted = AppColors.homeTextMuted;
  static const Color border = AppColors.homeBorder;
  static const Color divider = AppColors.homeDivider;
  static const Color cardShadow = AppColors.homeCardShadow;
  static const Color success = Color(0xFF2FAE56);
  static const Color successSoft = Color(0xFFEAF8EE);

  static const Color subjectMath = AppColors.homeOrange;
  static const Color subjectLiterature = Color(0xFFB07D56);
  static const Color subjectEnglish = Color(0xFF5ED0A1);
  static const Color subjectPhysics = Color(0xFF4E8FEA);
  static const Color subjectChemistry = Color(0xFF9A8F86);
  static const Color subjectInformatics = Color(0xFF7A68C2);
  static const Color subjectBiology = Color(0xFF40A97B);
}
