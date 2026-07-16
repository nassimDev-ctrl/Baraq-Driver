import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/utils/validator.dart';
import 'package:drever_warr/core/widgets/app_snack_bar.dart';
import 'package:drever_warr/core/widgets/auth/app_primary_button.dart';
import 'package:drever_warr/core/widgets/auth/app_text_field.dart';
import 'package:drever_warr/core/widgets/auth/auth_page_scaffold.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_forget_passwrde/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_forget_passwrde/cubit_state.dart';
import 'package:drever_warr/features/presentation/widgets/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfermPassword extends StatefulWidget {
  const ConfermPassword({super.key, required this.mobilePhone1});
  final String mobilePhone1;

  @override
  State<ConfermPassword> createState() => _ConfermPasswordState();
}

class _ConfermPasswordState extends State<ConfermPassword> {
  final TextEditingController _password1Controller = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _password1Focus = FocusNode();
  final _password2Focus = FocusNode();
  bool _obscurePassword1 = true;
  bool _obscurePassword2 = true;

  @override
  void dispose() {
    _password1Controller.dispose();
    _password2Controller.dispose();
    _password1Focus.dispose();
    _password2Focus.dispose();
    super.dispose();
  }

  void _submit(bool isLoading) {
    if (isLoading) return;
    FocusScope.of(context).unfocus();
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    context.read<ConfirmPasswordCubit>().confirmNewPassword(
          password: _password1Controller.text,
          mobilphone: widget.mobilePhone1,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConfirmPasswordCubit, ConfirmPasswordState>(
      listener: (context, state) {
        if (state is ConfirmPasswordSuccess) {
          _password1Controller.clear();
          _password2Controller.clear();
          AppSnackBar.success(context, 'تم تغيير كلمة المرور بنجاح');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginView()),
            (route) => false,
          );
        } else if (state is ConfirmPasswordFailure) {
          AppSnackBar.error(context, state.errMessage);
        }
      },
      builder: (context, state) {
        final isLoading = state is ConfirmPasswordLoading;

        return AuthPageScaffold(
          icon: Icons.lock_outline_rounded,
          titleKey: 'new_password_title',
          subtitleKey: 'enter_new_password_hint',
          isLoading: isLoading,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: AppColors.button.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: AppColors.button.withValues(alpha: 0.16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42.r,
                        height: 42.r,
                        decoration: BoxDecoration(
                          color: AppColors.button.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.shield_outlined,
                          color: AppColors.button,
                          size: 22.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          AppTranslations.getText(
                            context,
                            'enter_new_password_hint',
                          ),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AuthUiConstants.mutedText,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.xlg.h),
                Text(
                  AppTranslations.getText(context, 'password'),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AuthUiConstants.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.sm.h),
                AppTextField(
                  controller: _password1Controller,
                  focusNode: _password1Focus,
                  nextFocus: _password2Focus,
                  hintKey: 'password',
                  icon: Icons.lock_outline_rounded,
                  obscureText: _obscurePassword1,
                  textDirection: TextDirection.ltr,
                  suffix: IconButton(
                    onPressed: () {
                      setState(() => _obscurePassword1 = !_obscurePassword1);
                    },
                    icon: Icon(
                      _obscurePassword1
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AuthUiConstants.iconMuted,
                      size: 20.sp,
                    ),
                  ),
                  validator: (val) =>
                      Validators.validatePassword(val, context),
                ),
                SizedBox(height: AppSpacing.md.h),
                Text(
                  AppTranslations.getText(context, 'confirm_password_label'),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AuthUiConstants.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.sm.h),
                AppTextField(
                  controller: _password2Controller,
                  focusNode: _password2Focus,
                  hintKey: 'confirm_password_label',
                  icon: Icons.lock_person_outlined,
                  obscureText: _obscurePassword2,
                  textDirection: TextDirection.ltr,
                  suffix: IconButton(
                    onPressed: () {
                      setState(() => _obscurePassword2 = !_obscurePassword2);
                    },
                    icon: Icon(
                      _obscurePassword2
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AuthUiConstants.iconMuted,
                      size: 20.sp,
                    ),
                  ),
                  validator: (val) {
                    if (val != _password1Controller.text) {
                      return 'كلمتا المرور غير متطابقتين';
                    }
                    return Validators.validatePassword(val, context);
                  },
                ),
                SizedBox(height: AppSpacing.xlg.h),
                AppPrimaryButton(
                  isLoading: isLoading,
                  labelKey: 'Send',
                  onPressed: () => _submit(isLoading),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
