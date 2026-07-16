import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/utils/validator.dart';
import 'package:drever_warr/core/widgets/auth/app_primary_button.dart';
import 'package:drever_warr/core/widgets/auth/app_text_field.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginFormCard extends StatefulWidget {
  const LoginFormCard({
    super.key,
    required this.formKey,
    required this.phoneController,
    required this.passwordController,
    required this.isLoading,
    required this.onLogin,
    required this.onForgotPassword,
    required this.onCreateAccount,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;
  final VoidCallback onCreateAccount;

  @override
  State<LoginFormCard> createState() => _LoginFormCardState();
}

class _LoginFormCardState extends State<LoginFormCard> {
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      color: Colors.white,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AuthUiConstants.cardTopRadius.r),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg.w,
          AppSpacing.xlg.h,
          AppSpacing.lg.w,
          AppSpacing.xlg.h,
        ),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: widget.isLoading ? 0.72 : 1,
          child: IgnorePointer(
            ignoring: widget.isLoading,
            child: Form(
              key: widget.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppPhoneField(
                    controller: widget.phoneController,
                    focusNode: _phoneFocus,
                    nextFocus: _passwordFocus,
                    validator: (val) =>
                        Validators.validatePhone(val, context),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  AppTextField(
                    controller: widget.passwordController,
                    focusNode: _passwordFocus,
                    hintKey: 'password',
                    icon: Icons.lock_outline_rounded,
                    obscureText: _obscurePassword,
                    textDirection: TextDirection.ltr,
                    suffix: IconButton(
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AuthUiConstants.iconMuted,
                        size: 20.sp,
                      ),
                    ),
                    validator: (val) =>
                        Validators.isEmptyValue(val, context),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton(
                      onPressed: widget.onForgotPassword,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.main1,
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 8.h,
                        ),
                      ),
                      child: Text(
                        AppTranslations.getText(
                          context,
                          'forgot_password_question',
                        ),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  AppPrimaryButton(
                    isLoading: widget.isLoading,
                    onPressed: widget.onLogin,
                    labelKey: 'login',
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  _CreateAccountFooter(onTap: widget.onCreateAccount),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CreateAccountFooter extends StatelessWidget {
  const _CreateAccountFooter({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          Text(
            AppTranslations.getText(context, 'no_account'),
            style: TextStyle(
              fontSize: 13.sp,
              color: AuthUiConstants.mutedText,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              AppTranslations.getText(context, 'register_title'),
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.main1,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
