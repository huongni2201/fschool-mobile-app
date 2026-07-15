import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfschool/core/constants/app_strings.dart';

import '../../../../core/auth/user_role_resolver.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/error/error_message_mapper.dart';
import '../../../../core/router/router_names.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/usecases/login_usecase.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final LoginUseCase _loginUseCase;

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _loginUseCase = getIt<LoginUseCase>();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  String? _validatePhoneNumber(String? value) {
    final String phoneNumber = value?.trim() ?? '';

    if (phoneNumber.isEmpty) return AppStrings.phoneRequired;

    final RegExp phoneRegex = RegExp(r'^0\d{9}$');

    if (!phoneRegex.hasMatch(phoneNumber)) return AppStrings.phoneInvalid;

    return null;
  }

  String? _validatePassword(String? value) {
    final String password = value ?? '';

    if (password.isEmpty) return AppStrings.passwordRequired;

    if (password.length < 6) return AppStrings.passwordTooShort;

    return null;
  }

  Future<void> _submitLogin() async {
    FocusScope.of(context).unfocus();

    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _loginUseCase(
        username: _phoneController.text.trim(),
        password: _passwordController.text,
      );

      await TokenStorage.saveTokens(
        accessToken: user.accessToken,
        refreshToken: user.refreshToken,
        userRole: user.userRole,
      );

      if (!mounted) return;

      final nextRoute = switch (TokenStorage.userRole) {
        UserRole.teacher => RouterNames.teacherHome,
        UserRole.parent => RouterNames.parentHome,
        _ => RouterNames.home,
      };

      Navigator.of(
        context,
        rootNavigator: true,
      ).pushNamedAndRemoveUntil(nextRoute, (route) => false);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(ErrorMessageMapper.login(error))));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _openForgotPassword() {
    Navigator.of(context).pushNamed(RouterNames.forgotPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPadding,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 160),
                        Image.asset(
                          AppAssets.fschoolLogo,
                          width: 300,
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          AppStrings.loginSubtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 60),
                        AppTextField(
                          controller: _phoneController,
                          hintText: AppStrings.phoneNumber,
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: _validatePhoneNumber,
                        ),
                        const SizedBox(height: AppSizes.mediumSpacing),
                        AppTextField(
                          controller: _passwordController,
                          hintText: AppStrings.password,
                          prefixIcon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          validator: _validatePassword,
                          onFieldSubmitted: (_) => _submitLogin(),
                          suffixIcon: IconButton(
                            onPressed: _togglePasswordVisibility,
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _isLoading ? null : _openForgotPassword,
                            child: const Text(
                              AppStrings.forgotPassword,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        AppButton(
                          text: AppStrings.login,
                          onPressed: _submitLogin,
                          isLoading: _isLoading,
                        ),
                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.only(top: 48, bottom: 16),
                          child: Column(
                            children: [
                              Text(
                                AppStrings.copyright,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                AppStrings.version,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
