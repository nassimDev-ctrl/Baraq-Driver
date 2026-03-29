// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:waslne/Features/Auth/preasntaion/data/repo/cubit/cubit_regster.dart/cubit_regster_state.dart';
// import 'package:waslne/Features/Auth/preasntaion/data/repo/cubit/cubit_regster.dart/cubit_rejester.dart';
// import 'package:waslne/Features/Auth/preasntaion/data/repo/cubit/cubit_verificationRepo/cubit.dart';
// import 'package:waslne/Features/Auth/preasntaion/widhets/icon_bak.dart';
// import 'package:waslne/Features/Auth/preasntaion/widhets/row_verification_code.dart';
// import 'package:waslne/Features/Auth/preasntaion/widhets/text_verification_code.dart';
// import 'package:waslne/core/asset/image_asset.dart';
// import 'package:waslne/core/constant/app_spacing.dart';
// import 'package:waslne/core/widgets/custom_buttone.dart';

// class VerificationCodeRegster extends StatefulWidget {
//   const VerificationCodeRegster({super.key, required this.phone});
//   final String phone;
//   @override
//   State<VerificationCodeRegster> createState() =>
//       _VerificationCodeRegsterState();
// }

// class _VerificationCodeRegsterState extends State<VerificationCodeRegster> {
//   String otpCode = "";

//   @override
//   Widget build(BuildContext context) {
//     final registerCubit = context.read<RegisterCubit>();

//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: BlocListener<RegisterCubit, RegisterState>(
//         listener: (context, state) {
//           if (state is RegisterSuccess) {
//             print("🎉 تم إنشاء الحساب بنجاح!");
//             // هنا تضع الكود للانتقال للشاشة التالية
//             // Navigator.pushReplacementNamed(context, AppRoutes.home);
//           } else if (state is RegisterFailure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.errMessage),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         child: Container(
//           height: double.infinity,
//           width: double.infinity,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//               colors: [Color(0xFF031D4E), Color(0xFF0C4588), Color(0xFF072F6D)],
//             ),
//           ),
//           child: CustomScrollView(
//             slivers: [
//               SliverFillRemaining(
//                 hasScrollBody: false,
//                 child: Column(
//                   children: [
//                     const IconBak(),
//                     Image.asset(ImageAssets.phone, height: 250.h, width: 250.w),
//                     TextVerificationCode(phone: widget.phone),
//                     SizedBox(height: 25.h),
//                     PinCodeTextField(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       appContext: context,
//                       length: 4,
//                       onChanged: (value) => otpCode = value,
//                       keyboardType: TextInputType.number,
//                       pinTheme: PinTheme(
//                         shape: PinCodeFieldShape.box,
//                         borderRadius: BorderRadius.circular(12.r),
//                         fieldHeight: 60.h,
//                         fieldWidth: 60.w,
//                         fieldOuterPadding: EdgeInsets.symmetric(
//                           horizontal: 10.w,
//                         ),
//                         activeFillColor: Colors.white,
//                         inactiveFillColor: Colors.white,
//                         selectedFillColor: Colors.white,
//                         activeColor: Colors.transparent,
//                         inactiveColor: Colors.transparent,
//                         selectedColor: Colors.green,
//                       ),
//                       enableActiveFill: true,
//                     ),
//                     SizedBox(height: 20.h),
//                     RowVerificationCode(
//                       onResend: () {
//                         context.read<VerificationCubit>().sendVerificationCode(
//                           mobilePhone: "+963${widget.phone}",
//                           typeOfUse: "reset-password",
//                         );
//                       },
//                     ),
//                     SizedBox(height: AppSpacing.x110.h),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 40.w),
//                       child: BlocBuilder<RegisterCubit, RegisterState>(
//                         builder: (context, state) {
//                           if (state is RegisterLoading) {
//                             return const Center(
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                               ),
//                             );
//                           }
//                           return CustomButton(
//                             title: "Send",
//                             onTap: () {
//                               if (otpCode.length == 4) {
//                                 // نرسل طلب التسجيل النهائي مباشرة مع الكود
//                                 registerCubit.registerUser(otp: otpCode);
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text("يرجى إدخال كود التحقق"),
//                                   ),
//                                 );
//                               }
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/customButton.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:drever_warr/features/preasntaion/widhets/row_verification_code.dart';
import 'package:drever_warr/features/preasntaion/widhets/text_verification_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
 

class VerificationCodeRegster extends StatefulWidget {
  const VerificationCodeRegster({super.key, required this.phone});
  final String phone;

  @override
  State<VerificationCodeRegster> createState() =>
      _VerificationCodeRegsterState();
}

class _VerificationCodeRegsterState extends State<VerificationCodeRegster> {
  // متغير لتخزين الكود المدخل محلياً
  String otpCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                const IconBak(), // زر الرجوع للخلف

                Image.asset(ImageAssets.phone, height: 250.h, width: 250.w),

                TextVerificationCode(phone: widget.phone),

                SizedBox(height: 25.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(4, (index) {
                    // غير 4 لـ 6 إذا كان الكود أطول
                    return SizedBox(
                      height: 60.h,
                      width: 60.w,
                      child: TextFormField(
                        onChanged: (value) {
                          if (value.length == 1 && index < 3) {
                            FocusScope.of(
                              context,
                            ).nextFocus(); // ينتقل للمربع التالي تلقائياً
                          }
                          if (value.isEmpty && index > 0) {
                            FocusScope.of(
                              context,
                            ).previousFocus(); // يرجع للمربع السابق عند الحذف
                          }
                          // هنا يمكنك تجميع الكود في متغير otpCode
                        },
                        style: Theme.of(context).textTheme.headlineMedium,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          // يمنع إدخال أكثر من رقم واحد في المربع
                          //  import 'package:flutter/services.dart'; // تحتاج لهذا الـ import
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: AppColors.main1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: AppColors
                                  .main1, // غير اللون من هنا (مثلاً رمادي فاتح)
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: AppColors.main1,
                            ), // لون المربع عند الاختيار
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                // حقول إدخال الكود (OTP Fields)
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 20.w),
                //   child: PinCodeTextField(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     appContext: context,
                //     length: 4,
                //     onChanged: (value) => otpCode = value,
                //     keyboardType: TextInputType.number,
                //     animationType: AnimationType.fade,
                //     pinTheme: PinTheme(
                //       shape: PinCodeFieldShape.box,
                //       borderRadius: BorderRadius.circular(12.r),
                //       fieldHeight: 60.h,
                //       fieldWidth: 60.w,
                //       fieldOuterPadding: EdgeInsets.symmetric(horizontal: 10.w),
                //       activeFillColor: Colors.white,
                //       inactiveFillColor: Colors.white,
                //       selectedFillColor: Colors.white,
                //       activeColor: Colors.transparent,
                //       inactiveColor: Colors.transparent,
                //       selectedColor: Colors.green,
                //     ),
                //     enableActiveFill: true,
                //   ),
                // ),
                SizedBox(height: 20.h),

                // سطر "إعادة إرسال الكود"
                RowVerificationCode(
                  onResend: () {
                    debugPrint("Resending code to ${widget.phone}");
                    // منطق إعادة الإرسال يوضع هنا لاحقاً
                  },
                ),

                SizedBox(height: AppSpacing.x110.h),

                // زر الإرسال النهائي
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: CustomButton(
                    title: "Send",
                    onTap: () {
                      if (otpCode.length == 4) {
                        debugPrint(
                          "OTP entered: $otpCode. Account creation logic goes here.",
                        );
                        // هنا يمكنك إضافة Navigator للانتقال للصفحة الرئيسية مثلاً
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("يرجى إدخال كود التحقق"),
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
      ),
    );
  }
}
