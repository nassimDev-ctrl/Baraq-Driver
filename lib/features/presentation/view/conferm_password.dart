 
import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/utils/validator.dart';
import 'package:drever_warr/core/widgets/custom_button.dart';
import 'package:drever_warr/core/widgets/custom_text.dart';
import 'package:drever_warr/core/widgets/logo_app.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_forget_passwrde/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_forget_passwrde/cubit_state.dart';
import 'package:drever_warr/features/presentation/widgets/icon_bak.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widgets/password_helper.dart';

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
      body: BlocConsumer<ConfirmPasswordCubit, ConfirmPasswordState>(
        listener: (context, state) {
          if (state is ConfirmPasswordSuccess) {
            _password2Controller.clear();
            _password1Controller.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("تم تغيير كلمة المرور بنجاح"),
                backgroundColor: Colors.green,
              ),
            );
            
          } else if (state is ConfirmPasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const IconBak(),  
                  SizedBox(height: AppSpacing.x25.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [LogoSection()],
                  ),
                  SizedBox(height: AppSpacing.x25.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                    child: PasswordTextField(
                      hintText: "",
                      controller: _password1Controller,
                      iconImage: IconAssets.eyeoff,
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

                    child: PasswordTextField(
                      hintText: "",
                      controller: _password2Controller,
                      iconImage: IconAssets.eyeoff,
                      validator: (val) {
                        if (val != _password1Controller.text) {
                          return "كلمتا المرور غير متطابقتين";
                        }
                        return Validators.validatePassword(val, context);
                      },
                    ),
                  ),

                  SizedBox(height: 250.h),

                 
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: state is ConfirmPasswordLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.main1,
                            ),
                          )
                        : CustomButton(
                            title: "Send",
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                               
                                context
                                    .read<ConfirmPasswordCubit>()
                                    .confirmNewPassword(
                                      password: _password1Controller.text,
                                      mobilphone: widget.mobilePhone1,
                                    );
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
