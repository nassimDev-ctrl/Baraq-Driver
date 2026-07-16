import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/utils/validator.dart';
import 'package:drever_warr/core/widgets/auth/app_primary_button.dart';
import 'package:drever_warr/core/widgets/auth/app_text_field.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/core/widgets/custom_text.dart';
import 'package:drever_warr/features/presentation/widgets/icon_bak.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_edit_passwrd/cubit.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_edit_passwrd/cubit_stat.dart';
import 'package:drever_warr/features/setting/presentation/view/user_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:drever_warr/core/widgets/app_snack_bar.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key, required this.mobilePhone1});
  final String mobilePhone1;

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final TextEditingController _password1Controller = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword1 = true;
  bool _obscurePassword2 = true;

  @override
  void dispose() {
    _password1Controller.dispose();
    _password2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary1,
      body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            FocusScope.of(context).unfocus();

            AppSnackBar.success(context, state.message);

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const UserInformation()),
              (route) => false,
            );
          } else if (state is ChangePasswordFailure) {
            AppSnackBar.error(context, state.errMessage);
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const IconBak(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            ImageAssets.logoWarr,
                            height: 130.h,
                            width: 130.w,
                          ),
                          SizedBox(height: AppSpacing.x45.h),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: CustomText(
                      "new_password_title",
                      type: AppTextType.titleMedium,
                      color: AppColors.secondary2,
                    ),
                  ),
                  SizedBox(height: AppSpacing.x45.h),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child: CustomText(
                      "enter_new_password_hint",
                      type: AppTextType.titleSmall,
                      color: AppColors.secondary2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: AppTextField(
                      controller: _password1Controller,
                      hintKey: 'password',
                      icon: Icons.lock_outline_rounded,
                      obscureText: _obscurePassword1,
                      textDirection: TextDirection.ltr,
                      suffix: IconButton(
                        onPressed: () {
                          setState(
                            () => _obscurePassword1 = !_obscurePassword1,
                          );
                        },
                        icon: Icon(
                          _obscurePassword1
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AuthUiConstants.iconMuted,
                        ),
                      ),
                      validator: (val) =>
                          Validators.validatePassword(val, context),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child: CustomText(
                      "confirm_password_label",
                      type: AppTextType.titleSmall,
                      color: AppColors.secondary2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: AppTextField(
                      controller: _password2Controller,
                      hintKey: 'confirm_password_label',
                      icon: Icons.lock_outline_rounded,
                      obscureText: _obscurePassword2,
                      textDirection: TextDirection.ltr,
                      suffix: IconButton(
                        onPressed: () {
                          setState(
                            () => _obscurePassword2 = !_obscurePassword2,
                          );
                        },
                        icon: Icon(
                          _obscurePassword2
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AuthUiConstants.iconMuted,
                        ),
                      ),
                      validator: (val) => Validators.validateConfirmPassword(
                        _password1Controller.text,
                        val,
                        context,
                      ),
                    ),
                  ),
                  SizedBox(height: 250.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: AppPrimaryButton(
                      isLoading: state is ChangePasswordLoading,
                      labelKey: 'Send',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context
                              .read<ChangePasswordCubit>()
                              .changePassword(_password1Controller.text);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
