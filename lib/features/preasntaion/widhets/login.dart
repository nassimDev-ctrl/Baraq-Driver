import 'package:drever_warr/features/home/preasntaion/view/home_view.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_login/cubit.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_login/cubit_state.dart';
import 'package:drever_warr/features/preasntaion/view/waiting_review_screen.dart';
import 'package:drever_warr/features/preasntaion/view/location_drever.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/utiles/faledtor.dart';
import 'package:drever_warr/core/widgets/coustm_text_fild_all.dart';
import 'package:drever_warr/core/widgets/custom_button.dart';
import 'package:drever_warr/core/widgets/custom_text.dart';
import 'package:drever_warr/core/widgets/logo_app.dart';
import 'package:drever_warr/features/preasntaion/view/forget_password_login.dart';

import '../../../core/cash/preferences_servis.dart';
import '../../../core/service/notification_service.dart';
import '../../../core/widgets/password_helper.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<LoginCubit, LoginState>(
      listenWhen: (previous, current) => current is LoginSuccess || current is LoginFailure,
      listener: (context, state) async {
        if (state is LoginSuccess) {
          final cubit = context.read<LoginCubit>();
          await NotificationService.instance.syncToken();
          dynamic dataUser = state.data['data']['user'];
          cubit.mobilePhoneController.clear();
          cubit.passwordController.clear();

          final profile = dataUser['profile'];
          final status = profile?['status']?.toString() ?? dataUser['status']?.toString();
          if (status != null && status.isNotEmpty) {
            await CacheManager.saveData(CacheManager.statusKey, status);
          }

          final authUser = profile?['authUser']?.toString() ?? '';
          if (authUser.isNotEmpty) {
            await CacheManager.saveData(CacheManager.authUserKey, authUser);
          }

          if (!context.mounted) return;

          if (status == 'active' || status == 'change-category') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeView()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => WaitingReviewScreen()),
            );
          }


        } else if (state is LoginFailure) {
          _showError(context, state.errMessage);
        }
      },
      builder: (context, state) {
        final cubit = context.read<LoginCubit>();
        final isLoading = state is LoginLoading;

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
                    PasswordTextField(
                      hintText: "",
                      controller: cubit.passwordController,
                      iconImage: IconsAssets.eyeoff,
                      validator: (val) =>
                          Validators.validatePassword(val, context),
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

                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddLocation(),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 8.w,
                        ),
                        child: CustomText(
                          "create_new_account",
                          color: AppColors.blue,
                          type: AppTextType.titleSmall,
                        ),
                      ),
                    ),

                    SizedBox(height: 260.h),

                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                      title: "login",
                      onTap: () {
                        final form = cubit.formKey.currentState;
                        if (form == null) return;

                        if (!form.validate()) return;

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