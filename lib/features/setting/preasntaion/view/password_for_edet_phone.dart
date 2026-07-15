import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/utiles/faledtor.dart';
import 'package:drever_warr/core/widgets/coustm_text_fild_all.dart';
import 'package:drever_warr/core/widgets/custom_button.dart';
import 'package:drever_warr/core/widgets/custom_text.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_updet_phone/cubit.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_updet_phone/cubit_stat.dart';
import 'package:drever_warr/features/setting/preasntaion/view/edet_phone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordForgetPhone extends StatefulWidget {
  const PasswordForgetPhone({super.key});

  @override
  State<PasswordForgetPhone> createState() => _PasswordForgetPhoneState();
}

class _PasswordForgetPhoneState extends State<PasswordForgetPhone> {
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary1,
      body: BlocConsumer<UpdateMobileCubit, UpdateMobileState>(
        listener: (context, state) {
        
          if (state is ConfirmPasswordSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<UpdateMobileCubit>(),
                  child: const EdetPhone(),
                ),
              ),
            );
          } else if (state is UpdateMobileFailure) {
           
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
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: CustomText(
                      "password_label",
                      type: AppTextType.titleMedium,
                      color: AppColors.secondary2,
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: CustomText(
                      "enter_password_header",
                      type: AppTextType.titleSmall,
                      color: AppColors.secondary2,
                    ),
                  ),
                  SizedBox(height: AppSpacing.x30.h),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 16.h,
                    ),
                    child: CustomText(
                      "password_label",
                      type: AppTextType.titleSmall,
                      color: AppColors.secondary2,
                    ),
                  ),
                 
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: AppCustomTextField(
                      controller: passwordController,
                      hintText: "",
                      validator: (val) => Validators.validatePassword(val, context),
                    ),
                  ),
                  SizedBox(height: 250.h),
                 
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: state is UpdateMobileLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            title: "confirm",
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                
                                context
                                    .read<UpdateMobileCubit>()
                                    .confirmUserPassword(
                                      passwordController.text,
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
