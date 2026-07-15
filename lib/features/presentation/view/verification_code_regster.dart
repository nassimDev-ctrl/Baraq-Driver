 
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/custom_button.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_regster.dart/cubit_regster_state.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_regster.dart/cubit_rejester.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_verificationRepo/cubit.dart';
import 'package:drever_warr/features/presentation/view/register_photo_screen.dart';
import 'package:drever_warr/features/presentation/widgets/icon_bak.dart';
import 'package:drever_warr/features/presentation/widgets/row_verification_code.dart';
import 'package:drever_warr/features/presentation/widgets/text_verification_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart'; 

class VerificationCodeRegster extends StatefulWidget {
  const VerificationCodeRegster({super.key, required this.phone});
  final String phone;

  @override
  State<VerificationCodeRegster> createState() =>
      _VerificationCodeRegsterState();
}

class _VerificationCodeRegsterState extends State<VerificationCodeRegster> {
  String otpCode = "";
  final TextEditingController pinController = TextEditingController();

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registerCubit = context.read<RegisterCubit>();

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterPhotoScreen(isUpdate: false,),
                ),
              );
            } else if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    const IconBak(),
                    Image.asset(ImageAssets.phone, height: 250.h, width: 250.w),
                    TextVerificationCode(phone: widget.phone),
                    SizedBox(height: 25.h),


                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: PinCodeTextField(
                        appContext: context,
                        length: 4,
                        controller: pinController,
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
                        onCompleted: (v) {
                          otpCode = v;
                        },
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
                          mobilePhone: "963${widget.phone}",
                          typeOfUse:
                              "activate-account",
                        );
                      },
                    ),

                    SizedBox(height: AppSpacing.x110.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: BlocBuilder<RegisterCubit, RegisterState>(
                        builder: (context, state) {
                          if (state is RegisterLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return CustomButton(
                            title: "Send",
                            onTap: () {
                              if (otpCode.length == 4) {
                                registerCubit.registerUser(otp: otpCode);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("يرجى إدخال كود التحقق كاملاً"),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
