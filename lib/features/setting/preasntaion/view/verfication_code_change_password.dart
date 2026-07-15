import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/custom_button.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_verificationRepo/cubit.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_verificationRepo/cubite_state.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:drever_warr/features/preasntaion/widhets/row_verification_code.dart';
import 'package:drever_warr/features/preasntaion/widhets/text_verification_code.dart';
import 'package:drever_warr/features/setting/preasntaion/view/new_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';  

class VerificationCodeforgetpassword2 extends StatefulWidget {
  final String mobilePhone;
  const VerificationCodeforgetpassword2({super.key, required this.mobilePhone});

  @override
  State<VerificationCodeforgetpassword2> createState() =>
      _VerificationCodeforgetpasswordState();
}

class _VerificationCodeforgetpasswordState
    extends State<VerificationCodeforgetpassword2> {
  String otpCode = "";
  
  TextEditingController? _pinController;

  @override
  void initState() {
    super.initState();
    
    _pinController = TextEditingController();
  }

  @override
  void dispose() {
  
    _pinController?.dispose();
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

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NewPassword(mobilePhone1: widget.mobilePhone),
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
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: PinCodeTextField(
                            appContext: context,
                            length: 4,

                            keyboardType: TextInputType.number,
                            animationType: AnimationType.scale,
                            autoFocus: true,
                            cursorColor: AppColors.main1,

                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(12.r),
                              fieldHeight: 60.h,
                              fieldWidth: 60.w,
                              activeFillColor: Colors.white,
                              inactiveFillColor: Colors.white,
                              selectedFillColor: Colors.white,
                              activeColor: AppColors.main1,
                              inactiveColor: const Color(0xFFE0E0E0),
                              selectedColor: AppColors.main1,
                            ),

                            enableActiveFill: true,
                            animationDuration: const Duration(milliseconds: 300),
                            onChanged: (value) {
                              otpCode = value;
                            },
                            onCompleted: (value) {
                              // _verifyCodeAction(context);
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),


                      RowVerificationCode(

                        onResend: () {

                          String formattedPhone = widget.mobilePhone;
                          if (formattedPhone.startsWith('0')) {
                            formattedPhone = formattedPhone.substring(1);
                          }

                          context.read<VerificationCubit>().sendVerificationCode(
                            // الدمج الصحيح ليكون الناتج 963991111111
                            mobilePhone: "963$formattedPhone",
                            typeOfUse: "reset-password",
                          );
                        },
                      ),

                      const Spacer(),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.w,
                          vertical: 30.h,
                        ),
                        child: state is VerificationLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButton(
                                title: "verification_title",
                                onTap: () =>
                                    context.read<VerificationCubit>().verifyCode(
                                      mobilePhone: "963${widget.mobilePhone}",
                                      typeOfUse: "reset-password",
                                      code: otpCode,
                                    ),
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
