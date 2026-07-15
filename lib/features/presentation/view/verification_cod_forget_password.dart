 
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/custom_button.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_verificationRepo/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_verificationRepo/cubite_state.dart';
import 'package:drever_warr/features/presentation/view/conferm_password.dart';
import 'package:drever_warr/features/presentation/widgets/icon_bak.dart';
import 'package:drever_warr/features/presentation/widgets/row_verification_code.dart';
import 'package:drever_warr/features/presentation/widgets/text_verification_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart'; 

class VerificationCodeforgetpassword extends StatefulWidget {
  final String mobilePhone;
  const VerificationCodeforgetpassword({super.key, required this.mobilePhone});

  @override
  State<VerificationCodeforgetpassword> createState() =>
      _VerificationCodeforgetpasswordState();
}

class _VerificationCodeforgetpasswordState
    extends State<VerificationCodeforgetpassword> {
  
   
  final TextEditingController _pinController = TextEditingController();
  String otpCode = "";

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.secondary1,
        resizeToAvoidBottomInset: true,
        body: BlocConsumer<VerificationCubit, VerificationState>(
          listener: (context, state) {
            if (state is VerifyMobileNumberSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ConfermPassword(mobilePhone1: widget.mobilePhone),
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
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      const IconBak(),
                      Image.asset(ImageAssets.phone, height: 250.h, width: 250.w),
                      TextVerificationCode(phone: widget.mobilePhone),
                      SizedBox(height: 25.h),
      
                    
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: PinCodeTextField(
                          appContext: context,
                          length: 4,
                          controller: _pinController,
                          keyboardType: TextInputType.number,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(12.r),
                            fieldHeight: 60.h,
                            fieldWidth: 60.w,
                            activeFillColor: Colors.white,
                            inactiveFillColor: Colors.white,
                            selectedFillColor: Colors.white,
                            activeColor: AppColors.main1,
                            inactiveColor: AppColors.main1.withValues(alpha: 0.5),
                            selectedColor: AppColors.main1,
                          ),
                          animationDuration: const Duration(milliseconds: 300),
                          backgroundColor: Colors.transparent,
                          enableActiveFill: true,
                          onChanged: (value) {
                            setState(() {
                              otpCode = value;
                            });
                          },
                          beforeTextPaste: (text) => true, 
                        ),
                      ),
                      
                      SizedBox(height: 20.h),
      
                      RowVerificationCode(
                        onResend: () {
                          context.read<VerificationCubit>().sendVerificationCode(
                                mobilePhone: widget.mobilePhone,
                                typeOfUse: "reset-password",
                              );
                        },
                      ),
      
                      SizedBox(height: AppSpacing.x110.h),
      
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: state is VerificationLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButton(
                                title: "verification_title",
                                onTap: () {
                                  if (otpCode.length == 4) {
                                    context.read<VerificationCubit>().verifyCode(
                                          mobilePhone: widget.mobilePhone,
                                          typeOfUse: "reset-password",
                                          code: otpCode,
                                        );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("يرجى إدخال الكود كاملاً"),
                                      ),
                                    );
                                  }
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}