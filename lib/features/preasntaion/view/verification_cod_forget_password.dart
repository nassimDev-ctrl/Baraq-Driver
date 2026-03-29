// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:waslne/Features/Auth/preasntaion/data/repo/cubit/cubit_verificationRepo/cubit.dart';
// import 'package:waslne/Features/Auth/preasntaion/data/repo/cubit/cubit_verificationRepo/cubite_state.dart';
// import 'package:waslne/Features/Auth/preasntaion/view/conferm_password.dart';
// import 'package:waslne/Features/Auth/preasntaion/widhets/icon_bak.dart';
// import 'package:waslne/Features/Auth/preasntaion/widhets/row_verification_code.dart';
// import 'package:waslne/Features/Auth/preasntaion/widhets/text_verification_code.dart';
// import 'package:waslne/core/asset/image_asset.dart';
// import 'package:waslne/core/constant/app_spacing.dart';
// import 'package:waslne/core/widgets/custom_buttone.dart';

// class VerificationCodeforgetpassword extends StatefulWidget {
//   // يفضل تمرير رقم الهاتف من الصفحة السابقة لضمان استخدامه في التحقق
//   final String mobilePhone;
//   const VerificationCodeforgetpassword({super.key, required this.mobilePhone});

//   @override
//   State<VerificationCodeforgetpassword> createState() =>
//       _VerificationCodeforgetpasswordState();
// }

// class _VerificationCodeforgetpasswordState
//     extends State<VerificationCodeforgetpassword> {
//   String otpCode = "";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: BlocConsumer<VerificationCubit, VerificationState>(
//         listener: (context, state) {
//           if (state is VerifyMobileNumberSuccess) {
//             // ✅ الكود صحيح، ننتقل لصفحة تعيين كلمة المرور الجديدة
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                     ConfermPassword(mobilePhone1: widget.mobilePhone),
//               ),
//             );
//           } else if (state is VerificationFailure) {
//             // ❌ الكود خاطئ أو انتهت صلاحيته
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.errMessage),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           return Container(
//             height: double.infinity,
//             width: double.infinity,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//                 colors: [
//                   Color(0xFF031D4E),
//                   Color(0xFF0C4588),
//                   Color(0xFF072F6D),
//                 ],
//               ),
//             ),
//             child: CustomScrollView(
//               slivers: [
//                 SliverFillRemaining(
//                   hasScrollBody: false,
//                   child: Column(
//                     children: [
//                       const IconBak(),
//                       Image.asset(
//                         ImageAssets.phone,
//                         height: 250.h,
//                         width: 250.w,
//                       ),
//                       TextVerificationCode(phone: widget.mobilePhone),
//                       SizedBox(height: 25.h),
//                       PinCodeTextField(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         appContext: context,
//                         length: 4,
//                         onChanged: (value) => otpCode = value,
//                         keyboardType: TextInputType.number,
//                         animationType: AnimationType.fade,
//                         pinTheme: PinTheme(
//                           shape: PinCodeFieldShape.box,
//                           borderRadius: BorderRadius.circular(12.r),
//                           fieldHeight: 60.h,
//                           fieldWidth: 60.w,
//                           fieldOuterPadding: EdgeInsets.symmetric(
//                             horizontal: 15.w,
//                           ),
//                           activeFillColor: Colors.white,
//                           inactiveFillColor: Colors.white,
//                           selectedFillColor: Colors.white,
//                           activeColor: Colors.transparent,
//                           inactiveColor: Colors.transparent,
//                           selectedColor: Colors.green,
//                         ),
//                         cursorColor: Colors.black,
//                         enableActiveFill: true,
//                       ),
//                       SizedBox(height: 20.h),
//                       RowVerificationCode(
//                         onResend: () {
//                           context
//                               .read<VerificationCubit>()
//                               .sendVerificationCode(
//                                 mobilePhone: widget.mobilePhone,
//                                 typeOfUse: "reset-password",
//                               );
//                         },
//                       ),
//                       //  const RowVerificationCode(),
//                       SizedBox(height: AppSpacing.x110.h),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 40.w),
//                         child: state is VerificationLoading
//                             ? const Center(
//                                 child: CircularProgressIndicator(
//                                   color: Colors.white,
//                                 ),
//                               )
//                             : CustomButton(
//                                 title: "verification_title",
//                                 onTap: () {
//                                   if (otpCode.length == 4) {
//                                     // 🚀 استدعاء الكيوبت للتحقق من الكود
//                                     context
//                                         .read<VerificationCubit>()
//                                         .verifyCode(
//                                           mobilePhone: widget.mobilePhone,
//                                           typeOfUse: "reset-password",
//                                           code: otpCode,
//                                         );
//                                   } else {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text(
//                                           "يرجى إدخال الكود كاملاً",
//                                         ),
//                                       ),
//                                     );
//                                   }
//                                 },
//                               ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/customButton.dart';
import 'package:drever_warr/features/preasntaion/view/conferm_password.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:drever_warr/features/preasntaion/widhets/row_verification_code.dart';
import 'package:drever_warr/features/preasntaion/widhets/text_verification_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerificationCodeforgetpassword extends StatefulWidget {
  final String mobilePhone;
  const VerificationCodeforgetpassword({super.key, required this.mobilePhone});

  @override
  State<VerificationCodeforgetpassword> createState() =>
      _VerificationCodeforgetpasswordState();
}

class _VerificationCodeforgetpasswordState
    extends State<VerificationCodeforgetpassword> {
  // متغير لتخزين الكود المدخل
  // String otpCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary1,
      resizeToAvoidBottomInset: true,
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                const IconBak(), // زر الرجوع

                Image.asset(ImageAssets.phone, height: 250.h, width: 250.w),

                // النص اللي بيعرض الرقم اللي انرسل له الكود
                TextVerificationCode(phone: widget.mobilePhone),

                SizedBox(height: 25.h),

                // حقول إدخال الكود (PIN Code)
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
                //     cursorColor: Colors.black,
                //     enableActiveFill: true,
                //   ),
                // ),
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
                SizedBox(height: 20.h),

                // السطر الخاص بإعادة الإرسال
                RowVerificationCode(
                  onResend: () {
                    // منطق إعادة الإرسال (UI فقط حالياً)
                    debugPrint("Resending code to ${widget.mobilePhone}");
                  },
                ),

                SizedBox(height: AppSpacing.x110.h),

                // زر التحقق
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: CustomButton(
                    title: "verification_title",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ConfermPassword(mobilePhone1: widget.mobilePhone),
                        ),
                      );
                      // if (otpCode.length == 4) {
                      //   // الانتقال لصفحة تعيين كلمة المرور الجديدة (UI Flow)
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => ConfermPassword(
                      //         mobilePhone1: widget.mobilePhone,
                      //       ),
                      //     ),
                      //   );
                      // } else {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(
                      //       content: Text("يرجى إدخال الكود كاملاً"),
                      //     ),
                      //   );
                      // }
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
