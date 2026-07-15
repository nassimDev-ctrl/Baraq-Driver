 
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/utiles/faledtor.dart';
import 'package:drever_warr/core/utiles/normlize_number.dart';
import 'package:drever_warr/core/widgets/coustm_text_fild_all.dart';
import 'package:drever_warr/core/widgets/custom_button.dart';
import 'package:drever_warr/core/widgets/custom_text.dart';
import 'package:drever_warr/core/widgets/logo_app.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_verificationRepo/cubit.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_verificationRepo/cubite_state.dart';
import 'package:drever_warr/features/preasntaion/view/verification_cod_forget_password.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerificationCubit, VerificationState>(
      listener: (context, state) {
        if (state is CreateVerificationCodeSuccess) {
           
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationCodeforgetpassword(
                mobilePhone: "963${normalizePhone(_phoneController.text) }",
              ),
            ),
          );
        } else if (state is VerificationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.secondary1,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const IconBak(),
                SizedBox(height: AppSpacing.lg.h),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [LogoSection()],
                ),
                SizedBox(height: AppSpacing.xlg.h),
                _buildHeaderText(
                  "forgot_password_question",
                  AppTextType.titleMedium,
                ),
                SizedBox(height: AppSpacing.lg.h),
                _buildHeaderText(
                  "enter_phone_reset_password",
                  AppTextType.titleSmall,
                ),
                SizedBox(height: AppSpacing.x30.h),

                
                _buildLabel("phone_number"),

               
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: AppCustomTextField(
                    countryCode: "+963",
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    hintText: "",
                    validator: (val) => Validators.validatePhone(val, context),
                  ),
                ),

                SizedBox(height: 300.h),  
              
                BlocBuilder<VerificationCubit, VerificationState>(
                  builder: (context, state) {
                    if (state is VerificationLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: CustomButton(
                        title: "Send",
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                           
                            context.read<VerificationCubit>().sendVerificationCode(
                              mobilePhone: "963${normalizePhone(_phoneController.text)}",
                              typeOfUse:
                                  "reset-password", // تأكد من هذا النوع مع الباك إند
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
  Widget _buildHeaderText(String key, AppTextType type) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: CustomText(key, type: type, color: AppColors.secondary2),
    );
  }

  Widget _buildLabel(String key) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
      child: CustomText(
        key,
        type: AppTextType.titleSmall,
        color: AppColors.secondary2,
      ),
    );
  }
}
