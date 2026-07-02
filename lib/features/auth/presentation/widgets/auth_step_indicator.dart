import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class AuthStepIndicator extends StatelessWidget {
  final int currentStep;

  const AuthStepIndicator({super.key, required this.currentStep});

  static const List<String> _stepLabels = [
    AppStrings.verifyStep,
    AppStrings.otpStep,
    AppStrings.newPasswordStep,
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_stepLabels.length, (index) {
        final int stepNumber = index + 1;
        final bool isActive = stepNumber <= currentStep;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: index == 0
                          ? Colors.transparent
                          : stepNumber <= currentStep
                          ? AppColors.primary
                          : AppColors.divider,
                    ),
                  ),
                  _StepCircle(stepNumber: stepNumber, isActive: isActive),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: index == _stepLabels.length - 1
                          ? Colors.transparent
                          : stepNumber < currentStep
                          ? AppColors.primary
                          : AppColors.divider,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                _stepLabels[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int stepNumber;
  final bool isActive;

  const _StepCircle({required this.stepNumber, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.stepInactive,
        shape: BoxShape.circle,
      ),
      child: Text(
        stepNumber.toString(),
        style: TextStyle(
          color: isActive ? Colors.white : AppColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
