import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/utils/validator.dart';
import 'package:drever_warr/core/widgets/auth/app_primary_button.dart';
import 'package:drever_warr/core/widgets/auth/app_text_field.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/presentation/widgets/row_select_gender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.emailController,
    required this.governorateController,
    required this.addressController,
    required this.passwordController,
    required this.emergencyController,
    required this.firstNameFocus,
    required this.lastNameFocus,
    required this.phoneFocus,
    required this.emailFocus,
    required this.addressFocus,
    required this.passwordFocus,
    required this.emergencyFocus,
    required this.obscurePassword,
    required this.selectedGender,
    required this.isLoading,
    required this.onTogglePassword,
    required this.onGenderSelected,
    required this.onGovernorateTap,
    required this.onSubmit,
    required this.onLoginTap,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController governorateController;
  final TextEditingController addressController;
  final TextEditingController passwordController;
  final TextEditingController emergencyController;
  final FocusNode firstNameFocus;
  final FocusNode lastNameFocus;
  final FocusNode phoneFocus;
  final FocusNode emailFocus;
  final FocusNode addressFocus;
  final FocusNode passwordFocus;
  final FocusNode emergencyFocus;
  final bool obscurePassword;
  final String selectedGender;
  final bool isLoading;
  final VoidCallback onTogglePassword;
  final ValueChanged<String> onGenderSelected;
  final VoidCallback onGovernorateTap;
  final VoidCallback onSubmit;
  final VoidCallback onLoginTap;

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
          opacity: isLoading ? 0.72 : 1,
          child: IgnorePointer(
            ignoring: isLoading,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: firstNameController,
                          focusNode: firstNameFocus,
                          nextFocus: lastNameFocus,
                          hintKey: 'first_name',
                          icon: Icons.person_outline_rounded,
                          validator: (val) =>
                              Validators.isEmptyValue(val, context),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm.w),
                      Expanded(
                        child: AppTextField(
                          controller: lastNameController,
                          focusNode: lastNameFocus,
                          nextFocus: phoneFocus,
                          hintKey: 'last_name',
                          icon: Icons.badge_outlined,
                          validator: (val) =>
                              Validators.isEmptyValue(val, context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  AppPhoneField(
                    controller: phoneController,
                    focusNode: phoneFocus,
                    nextFocus: emailFocus,
                    validator: (val) => Validators.validatePhone(val, context),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  AppTextField(
                    controller: emailController,
                    focusNode: emailFocus,
                    nextFocus: addressFocus,
                    hintKey: 'enter_email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textDirection: TextDirection.ltr,
                    validator: (val) => Validators.validateEmail(val, context),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  AppPickerField(
                    controller: governorateController,
                    hintKey: 'select_governorate',
                    icon: Icons.location_city_outlined,
                    onTap: onGovernorateTap,
                    validator: (val) => Validators.isEmptyValue(val, context),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  AppTextField(
                    controller: addressController,
                    focusNode: addressFocus,
                    nextFocus: passwordFocus,
                    hintKey: 'enter_address',
                    icon: Icons.place_outlined,
                    maxLines: 2,
                    validator: (val) => Validators.isEmptyValue(val, context),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  AppTextField(
                    controller: passwordController,
                    focusNode: passwordFocus,
                    nextFocus: emergencyFocus,
                    hintKey: 'password',
                    icon: Icons.lock_outline_rounded,
                    obscureText: obscurePassword,
                    textDirection: TextDirection.ltr,
                    suffix: IconButton(
                      onPressed: onTogglePassword,
                      icon: Icon(
                        obscurePassword
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
                  AppPhoneField(
                    controller: emergencyController,
                    focusNode: emergencyFocus,
                    hintKey: 'emergency_number',
                    icon: Icons.emergency_outlined,
                    textInputAction: TextInputAction.done,
                    validator: (val) => Validators.validatePhone(val, context),
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  Selectgender(
                    initialValue: selectedGender,
                    onGenderSelected: onGenderSelected,
                  ),
                  SizedBox(height: AppSpacing.xlg.h),
                  AppPrimaryButton(
                    isLoading: isLoading,
                    onPressed: onSubmit,
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  AuthLoginFooter(onTap: onLoginTap),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
