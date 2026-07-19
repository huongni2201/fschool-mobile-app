import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/error/error_message_mapper.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/usecases/request_password_reset_otp_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/verify_password_reset_otp_usecase.dart';
import '../widgets/auth_step_indicator.dart';

enum _ForgotPasswordStep { phone, otp, newPassword }

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late final RequestPasswordResetOtpUseCase _requestOtpUseCase;
  late final VerifyPasswordResetOtpUseCase _verifyOtpUseCase;
  late final ResetPasswordUseCase _resetPasswordUseCase;

  _ForgotPasswordStep _step = _ForgotPasswordStep.phone;
  String? _resetToken;
  bool _isLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();

    _requestOtpUseCase = getIt<RequestPasswordResetOtpUseCase>();
    _verifyOtpUseCase = getIt<VerifyPasswordResetOtpUseCase>();
    _resetPasswordUseCase = getIt<ResetPasswordUseCase>();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  int get _currentStepNumber {
    return switch (_step) {
      _ForgotPasswordStep.phone => 1,
      _ForgotPasswordStep.otp => 2,
      _ForgotPasswordStep.newPassword => 3,
    };
  }

  String get _phoneNumber => _phoneController.text.trim();

  String get _otp => _otpController.text.trim();

  void _back() {
    if (_isLoading) return;

    if (_step == _ForgotPasswordStep.newPassword) {
      setState(() {
        _step = _ForgotPasswordStep.otp;
      });
      return;
    }

    if (_step == _ForgotPasswordStep.otp) {
      _changePhoneNumber();
      return;
    }

    Navigator.of(context).pop();
  }

  void _changePhoneNumber() {
    setState(() {
      _step = _ForgotPasswordStep.phone;
      _resetToken = null;
      _otpController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    });
  }

  String? _validatePhoneNumber(String? value) {
    final phoneNumber = value?.trim() ?? '';

    if (phoneNumber.isEmpty) return AppStrings.phoneRequired;

    final phoneRegex = RegExp(r'^0\d{9}$');

    if (!phoneRegex.hasMatch(phoneNumber)) return AppStrings.phoneInvalid;

    return null;
  }

  String? _validateOtp(String? value) {
    final otp = value?.trim() ?? '';

    if (otp.isEmpty) return AppStrings.otpRequired;

    final otpRegex = RegExp(r'^\d{4,8}$');

    if (!otpRegex.hasMatch(otp)) return AppStrings.otpInvalid;

    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) return AppStrings.passwordRequired;
    if (password.length < 6) return AppStrings.passwordTooShort;

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final confirmPassword = value ?? '';

    if (confirmPassword.isEmpty) return AppStrings.confirmPasswordRequired;
    if (confirmPassword != _newPasswordController.text) {
      return AppStrings.passwordMismatch;
    }

    return null;
  }

  Future<void> _submitCurrentStep() {
    return switch (_step) {
      _ForgotPasswordStep.phone => _submitPhoneNumber(),
      _ForgotPasswordStep.otp => _submitOtp(),
      _ForgotPasswordStep.newPassword => _submitNewPassword(),
    };
  }

  Future<void> _submitPhoneNumber() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid || _isLoading) return;

    final phoneNumber = _phoneNumber;

    setState(() {
      _isLoading = true;
    });

    try {
      await _requestOtpUseCase(phoneNumber: phoneNumber);

      if (!mounted) return;

      setState(() {
        _step = _ForgotPasswordStep.otp;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.otpWillBeSent(phoneNumber))),
      );
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resendOtp() async {
    if (_isLoading) return;

    final phoneNumber = _phoneNumber;

    setState(() {
      _isLoading = true;
    });

    try {
      await _requestOtpUseCase(phoneNumber: phoneNumber);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppStrings.otpSentSuccess)));
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _submitOtp() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid || _isLoading) return;

    final phoneNumber = _phoneNumber;
    final otp = _otp;

    setState(() {
      _isLoading = true;
    });

    try {
      final resetToken = await _verifyOtpUseCase(
        phoneNumber: phoneNumber,
        otp: otp,
      );

      if (resetToken.isEmpty) {
        throw const FormatException();
      }

      if (!mounted) return;

      setState(() {
        _resetToken = resetToken;
        _step = _ForgotPasswordStep.newPassword;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.otpVerifiedSuccess)),
      );
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _submitNewPassword() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid || _isLoading) return;

    final phoneNumber = _phoneNumber;
    final resetToken = _resetToken;
    final newPassword = _newPasswordController.text;

    if (resetToken == null || resetToken.isEmpty) {
      _showError(const FormatException());
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _resetPasswordUseCase(
        phoneNumber: phoneNumber,
        newPassword: newPassword,
        resetToken: resetToken,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.passwordResetSuccess)),
      );

      Navigator.of(context).pop();
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(Object error) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ErrorMessageMapper.passwordReset(error))),
    );
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _obscureNewPassword = !_obscureNewPassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _backToLogin() {
    if (_isLoading) return;

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _back,
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(AppStrings.resetPasswordTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPadding,
            vertical: AppSizes.largeSpacing,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthStepIndicator(currentStep: _currentStepNumber),
                const SizedBox(height: 28),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: _buildCurrentStep(),
                ),
                const SizedBox(height: AppSizes.largeSpacing),
                AppButton(
                  text: _buttonText(),
                  onPressed: _submitCurrentStep,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 18),
                Center(
                  child: TextButton(
                    onPressed: _isLoading ? null : _backToLogin,
                    child: const Text(
                      AppStrings.backToLogin,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    return switch (_step) {
      _ForgotPasswordStep.phone => _PhoneStep(
        key: const ValueKey('forgot-password-phone'),
        controller: _phoneController,
        validator: _validatePhoneNumber,
        onSubmitted: (_) => _submitPhoneNumber(),
      ),
      _ForgotPasswordStep.otp => _OtpStep(
        key: const ValueKey('forgot-password-otp'),
        controller: _otpController,
        validator: _validateOtp,
        onSubmitted: (_) => _submitOtp(),
        onResendOtp: _resendOtp,
        onChangePhoneNumber: _changePhoneNumber,
        isLoading: _isLoading,
      ),
      _ForgotPasswordStep.newPassword => _NewPasswordStep(
        key: const ValueKey('forgot-password-new-password'),
        newPasswordController: _newPasswordController,
        confirmPasswordController: _confirmPasswordController,
        obscureNewPassword: _obscureNewPassword,
        obscureConfirmPassword: _obscureConfirmPassword,
        validatePassword: _validatePassword,
        validateConfirmPassword: _validateConfirmPassword,
        onToggleNewPassword: _toggleNewPasswordVisibility,
        onToggleConfirmPassword: _toggleConfirmPasswordVisibility,
        onSubmitted: (_) => _submitNewPassword(),
      ),
    };
  }

  String _buttonText() {
    return switch (_step) {
      _ForgotPasswordStep.phone => AppStrings.sendOtp,
      _ForgotPasswordStep.otp => AppStrings.verifyOtp,
      _ForgotPasswordStep.newPassword => AppStrings.resetPassword,
    };
  }
}

class _PhoneStep extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?) validator;
  final ValueChanged<String> onSubmitted;

  const _PhoneStep({
    super.key,
    required this.controller,
    required this.validator,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.enterPhoneForOtp,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.35,
          ),
        ),
        const SizedBox(height: AppSizes.largeSpacing),
        AppTextField(
          controller: controller,
          hintText: AppStrings.phoneNumber,
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: validator,
          onFieldSubmitted: onSubmitted,
        ),
      ],
    );
  }
}

class _OtpStep extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?) validator;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onResendOtp;
  final VoidCallback onChangePhoneNumber;
  final bool isLoading;

  const _OtpStep({
    super.key,
    required this.controller,
    required this.validator,
    required this.onSubmitted,
    required this.onResendOtp,
    required this.onChangePhoneNumber,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.enterOtpForResetPassword,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.35,
          ),
        ),
        const SizedBox(height: AppSizes.largeSpacing),
        AppTextField(
          controller: controller,
          hintText: AppStrings.otp,
          prefixIcon: Icons.sms_outlined,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(8),
          ],
          validator: validator,
          onFieldSubmitted: onSubmitted,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            TextButton(
              onPressed: isLoading ? null : onResendOtp,
              child: const Text(AppStrings.resendOtp),
            ),
            const Spacer(),
            TextButton(
              onPressed: isLoading ? null : onChangePhoneNumber,
              child: const Text(AppStrings.changePhoneNumber),
            ),
          ],
        ),
      ],
    );
  }
}

class _NewPasswordStep extends StatelessWidget {
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool obscureNewPassword;
  final bool obscureConfirmPassword;
  final String? Function(String?) validatePassword;
  final String? Function(String?) validateConfirmPassword;
  final VoidCallback onToggleNewPassword;
  final VoidCallback onToggleConfirmPassword;
  final ValueChanged<String> onSubmitted;

  const _NewPasswordStep({
    super.key,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.obscureNewPassword,
    required this.obscureConfirmPassword,
    required this.validatePassword,
    required this.validateConfirmPassword,
    required this.onToggleNewPassword,
    required this.onToggleConfirmPassword,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.enterNewPasswordForReset,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.35,
          ),
        ),
        const SizedBox(height: AppSizes.largeSpacing),
        AppTextField(
          controller: newPasswordController,
          hintText: AppStrings.newPassword,
          prefixIcon: Icons.lock_outline,
          obscureText: obscureNewPassword,
          textInputAction: TextInputAction.next,
          validator: validatePassword,
          suffixIcon: IconButton(
            onPressed: onToggleNewPassword,
            icon: Icon(
              obscureNewPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          ),
        ),
        const SizedBox(height: AppSizes.mediumSpacing),
        AppTextField(
          controller: confirmPasswordController,
          hintText: AppStrings.confirmPassword,
          prefixIcon: Icons.lock_reset_outlined,
          obscureText: obscureConfirmPassword,
          textInputAction: TextInputAction.done,
          validator: validateConfirmPassword,
          onFieldSubmitted: onSubmitted,
          suffixIcon: IconButton(
            onPressed: onToggleConfirmPassword,
            icon: Icon(
              obscureConfirmPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          ),
        ),
      ],
    );
  }
}
