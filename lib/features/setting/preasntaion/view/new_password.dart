 
import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/utiles/faledtor.dart';
import 'package:drever_warr/core/widgets/coustm_text_fild_all.dart';
import 'package:drever_warr/core/widgets/customButton.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_forget_passwrde/cubit_state.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_edit_passwrd/cubit.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_edit_passwrd/cubit_stat.dart';
import 'package:drever_warr/features/setting/preasntaion/view/user_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // أضف استيراد الـ bloc
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/password_helper.dart';

 

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

  @override
  void dispose() {
    _password1Controller.dispose();
    _password2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = true;

    return Scaffold(
      backgroundColor: AppColors.secondary1,
      // استخدمنا BlocConsumer للاستماع للحالات (Success/Failure) وبناء الـ UI (Loading)
      body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            FocusScope.of(context).unfocus();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );

            
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const UserInformation()),
              (route) => false,
            );
            
          } else if (state is ChangePasswordFailure) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            ImageAssets.logo_warr,
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
                    child: PasswordTextField(
                      hintText: "",
                      controller: _password1Controller,
                      iconImage: IconsAssets.eyeoff,
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
                      color: AppColors
                          .secondary2,  
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: PasswordTextField(
                      hintText: "",
                      controller: _password2Controller,
                      iconImage: IconsAssets.eyeoff,
                      validator: (val) =>
                          Validators.validateConfirmPassword(_password1Controller.text, val, context),
                    ),
                  ),
                  SizedBox(height: 250.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                   
                    child: state is ConfirmPasswordLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.secondary2,
                            ),
                          )
                        : CustomButton(
                            title: "Send",
                            onTap: () {
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
