import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String? _validatePhoneNumber(String? value) {
    final String phoneNumber = value?.trim() ?? '';

    if (phoneNumber.isEmpty) {
      return AppStrings.phoneRequired;
    }

    final RegExp phoneRegex = RegExp(r'^0\d{9}$');

    if (!phoneRegex.hasMatch(phoneNumber)) {
      return AppStrings.phoneInvalid;
    }

    return null;
  }

  void _submitPhoneNumber() {
    FocusScope.of(context).unfocus();

    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    final String phoneNumber = _phoneController.text.trim();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.otpWillBeSent(phoneNumber))),
    );

    // TODO: Gọi API gửi OTP rồi chuyển tới màn nhập OTP.
  }

  void _backToLogin() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _backToLogin,
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(AppStrings.resetPasswordTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPadding,
            vertical: AppSizes.largeSpacing,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.enterPhoneForOtp,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: AppSizes.largeSpacing),
                AppTextField(
                  controller: _phoneController,
                  hintText: AppStrings.phoneNumber,
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: _validatePhoneNumber,
                  onFieldSubmitted: (_) => _submitPhoneNumber(),
                ),
                const SizedBox(height: AppSizes.largeSpacing),
                AppButton(
                  text: AppStrings.sendOtp,
                  onPressed: _submitPhoneNumber,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
