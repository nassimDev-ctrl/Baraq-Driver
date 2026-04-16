 
import 'package:drever_warr/features/home/preasntaion/view/home_view.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_login/cubit.dart'; // تأكد من المسار
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_login/cubit_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

 
import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/utiles/faledtor.dart';
import 'package:drever_warr/core/widgets/coustm_text_fild_all.dart';
import 'package:drever_warr/core/widgets/customButton.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/core/widgets/logo_app.dart';
import 'package:drever_warr/features/preasntaion/view/forget_password_login.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.read<LoginCubit>().mobilePhoneController.clear();
          context.read<LoginCubit>().passwordController.clear();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeView()),
          );
          
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        var cubit = context.read<LoginCubit>();

        return Scaffold(
          backgroundColor: AppColors.secondary1,
          body: Padding(
            padding: EdgeInsets.all(15.r),
            child: SingleChildScrollView(
              child: Form(
                key: cubit.formKey,  
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: AppSpacing.lg.h),
                    Center(
                      child: Column(
                        children: [
                          const LogoSection(),
                          CustomText(
                            "login",
                            type: AppTextType.titleSmall,
                            color: AppColors.main1,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.xxxlg.h),

                    _buildLabel("phone_number"),
                    AppCustomTextField(
                      countryCode: "+963",
                      controller: cubit.mobilePhoneController, 
                      hintText: "",
                      keyboardType: TextInputType.phone,
                      validator: (val) => Validators.isEmptyValue(val, context),
                    ),

                    _buildLabel("password"),
                    AppCustomTextField(
                      iconImage: IconsAssets.eyeoff,
                      controller: cubit.passwordController, 
                      hintText: "",
                      isPassword: true,
                      validator: (val) => Validators.isEmptyValue(val, context),
                    ),

                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgetPasswordLogin(),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 8.w,
                        ),
                        child: CustomText(
                          "forgot_password_question",
                          color: AppColors.blue,
                          type: AppTextType.titleSmall,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 300.h,
                    ),  
                    state is LoginLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            title: "login",
                            onTap: () {
                              cubit.loginUser();  
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

   
  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.h),
      child: CustomText(text, type: AppTextType.titleSmall),
    );
  }
}
