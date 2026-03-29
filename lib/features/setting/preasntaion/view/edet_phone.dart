// // ... (الواردات السابقة) ...
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class EdetPhone extends StatefulWidget {
//   const EdetPhone({super.key});

//   @override
//   State<EdetPhone> createState() => _EdetPhoneState();
// }

// class _EdetPhoneState extends State<EdetPhone> {
//   final TextEditingController phoneController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     phoneController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // استخدمنا BlocConsumer للـ VerificationCubit بدلاً من UpdateMobileCubit
//     return Scaffold(
//       body: BlocConsumer<VerificationCubit, VerificationState>(
//         listener: (context, state) {
//           if (state is CreateVerificationCodeSuccess) {
//             // ✅ تم إرسال الكود بنجاح، الآن ننتقل لصفحة التحقق
//             Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => BlocProvider.value(
//           value: context.read<VerificationCubit>(), // تمرير الكيوبت الحالي ليُستخدم في الصفحة التالية
//           child: VerficationcodeEdetphone(
//             phoneNumber: "963${phoneController.text}", // تمرير الرقم لتأكيده هناك
//           ),
//         ),
//       ),
//     );

//             // هنا تضع Navigator للانتقال لصفحة الـ OTP التي تدخل فيها الـ 6 أرقام
//             // Navigator.push(context, MaterialPageRoute(builder: (_) => VerifyOtpPage(phone: phoneController.text)));
//           } else if (state is VerificationFailure) {
//             // ❌ فشل إرسال الكود
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
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Color(0xFF031D4E),
//                   Color(0xFF0C4588),
//                   Color(0xFF072F6D),
//                 ],
//               ),
//             ),
//             child: Form(
//               key: _formKey,
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     const IconBak(),
//                     SizedBox(height: AppSpacing.x70.h),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 15.w),
//                       child: CustomText(
//                         "تعديل رقم الجوال",
//                         type: AppTextType.titleMedium,
//                         color: AppColors.secondary1,
//                       ),
//                     ),
//                     SizedBox(height: AppSpacing.lg),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20.w),
//                       child: CustomText(
//                         "أدخل رقم الجوال الجديد لتصلك رسالة التحقق.",
//                         type: AppTextType.titleSmall,
//                         color: AppColors.secondary1,
//                       ),
//                     ),
//                     SizedBox(height: AppSpacing.x30.h),
//                     // ... (حقل إدخال الرقم) ...
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 12.w),
//                       child: CustomTextFieldmohafsa(
//                         controller: phoneController,
//                         hintText: "9xx xxx xxx",
//                         iconImage: IconsAssets.editee,
//                         validator: (val) =>
//                             Validators.isEmptyValue(val, context),
//                       ),
//                     ),
//                     SizedBox(height: 250.h),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 24.w),
//                       child: state is VerificationLoading
//                           ? const Center(
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                               ),
//                             )
//                           : CustomButton(
//                               title: "إرسال كود التحقق",
//                               onTap: () {
//                                 if (_formKey.currentState!.validate()) {
//                                   // 🚀 استدعاء كود التحقق بدلاً من التحديث المباشر
//                                   context
//                                       .read<VerificationCubit>()
//                                       .sendVerificationCode(
//                                         mobilePhone:
//                                             "963${phoneController.text}",
//                                         typeOfUse: "change-mobile-phone",
//                                         // هذا الـ type يحدده الباك اند
//                                       );
//                                 }
//                               },
//                             ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/utiles/faledtor.dart';
import 'package:drever_warr/core/widgets/coustm_text_fild_all.dart';
import 'package:drever_warr/core/widgets/customButton.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/core/widgets/customTextFieldmohafsa.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:drever_warr/features/setting/preasntaion/view/verficationcode_edetphone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EdetPhone extends StatefulWidget {
  const EdetPhone({super.key});

  @override
  State<EdetPhone> createState() => _EdetPhoneState();
}

class _EdetPhoneState extends State<EdetPhone> {
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary1,
      body: Form(
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
              //  SizedBox(height: AppSpacing.x70.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomText(
                  "edit_mobile_number", // استخدم الترجمة هنا
                  type: AppTextType.titleMedium,
                  color: AppColors.secondary2,
                ),
              ),
              SizedBox(height: AppSpacing.lg.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomText(
                  "enter_new_mobile_hint", // استخدم الترجمة هنا
                  type: AppTextType.titleSmall,
                  color: AppColors.secondary2,
                ),
              ),
              SizedBox(height: AppSpacing.x30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: AppCustomTextField(
                  countryCode: "+963",
                  controller: phoneController,
                  hintText: "",
                  // iconImage: IconsAssets.editee,
                  validator: (val) => Validators.isEmptyValue(val, context),
                ),
              ),
              SizedBox(height: 250.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: CustomButton(
                  title: "send_verification_code", // استخدم الترجمة هنا
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerficationcodeEdetphone(
                            mobilePhone: "996688957",
                          ),
                        ),
                      );
                      print("Phone: ${phoneController.text}");
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
