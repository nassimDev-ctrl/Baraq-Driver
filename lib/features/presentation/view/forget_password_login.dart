import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/utils/normalize_number.dart';
import 'package:drever_warr/core/utils/validator.dart';
import 'package:drever_warr/core/widgets/app_snack_bar.dart';
import 'package:drever_warr/core/widgets/auth/app_primary_button.dart';
import 'package:drever_warr/core/widgets/auth/app_text_field.dart';
import 'package:drever_warr/core/widgets/auth/auth_page_scaffold.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_verificationRepo/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_verificationRepo/cubite_state.dart';
import 'package:drever_warr/features/presentation/view/verification_cod_forget_password.dart';
import 'package:drever_warr/features/presentation/widgets/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetPasswordLogin extends StatefulWidget {
  const ForgetPasswordLogin({super.key});

  @override
  State<ForgetPasswordLogin> createState() => _ForgetPasswordLoginState();
}

class _ForgetPasswordLoginState extends State<ForgetPasswordLogin> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submit(bool isLoading) {
    if (isLoading) return;
    FocusScope.of(context).unfocus();
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    context.read<VerificationCubit>().sendVerificationCode(
          mobilePhone: '963${normalizePhone(_phoneController.text)}',
          typeOfUse: 'reset-password',
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerificationCubit, VerificationState>(
      listener: (context, state) {
        if (state is CreateVerificationCodeSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationCodeforgetpassword(
                mobilePhone: '963${normalizePhone(_phoneController.text)}',
              ),
            ),
          );
        } else if (state is VerificationFailure) {
          AppSnackBar.error(context, state.errMessage);
        }
      },
      builder: (context, state) {
        final isLoading = state is VerificationLoading;

        return AuthPageScaffold(
          icon: Icons.lock_reset_rounded,
          titleKey: 'forgot_password_question',
          subtitleKey: 'enter_phone_reset_password',
          isLoading: isLoading,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: AppColors.main1.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: AppColors.main1.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42.r,
                        height: 42.r,
                        decoration: BoxDecoration(
                          color: AppColors.main1.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.sms_outlined,
                          color: AppColors.main1,
                          size: 22.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          AppTranslations.getText(
                            context,
                            'enter_phone_reset_password',
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
                  AppTranslations.getText(context, 'phone_number'),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AuthUiConstants.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.sm.h),
                AppPhoneField(
                  controller: _phoneController,
                  textInputAction: TextInputAction.done,
                  validator: (val) => Validators.validatePhone(val, context),
                ),
                SizedBox(height: AppSpacing.xlg.h),
                AppPrimaryButton(
                  isLoading: isLoading,
                  labelKey: 'Send',
                  onPressed: () => _submit(isLoading),
                ),
                SizedBox(height: AppSpacing.lg.h),
                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        AppTranslations.getText(context, 'have_account'),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AuthUiConstants.mutedText,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginView(),
                            ),
                          );
                        },
                        child: Text(
                          AppTranslations.getText(context, 'login'),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.main1,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
