// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:waslne/Features/Auth/preasntaion/data/repo/cubit/cubit_verificationRepo/cubit.dart';
// import 'package:waslne/Features/Auth/preasntaion/data/repo/cubit/cubit_verificationRepo/cubite_state.dart';
// import 'package:waslne/Features/Auth/preasntaion/view/verification_cod_forget_password.dart';
// import 'package:waslne/Features/Auth/preasntaion/widhets/icon_bak.dart';
// import 'package:waslne/core/constant/app_colors.dart';
// import 'package:waslne/core/constant/app_spacing.dart';
// import 'package:waslne/core/transleat/lunguesh_cubit.dart';
// import 'package:waslne/core/utiles/valedator.dart';
// import 'package:waslne/core/widgets/custom_buttone.dart';
// import 'package:waslne/core/widgets/custom_text.dart';
// import 'package:waslne/core/widgets/custom_text_fild_name.dart';

// class ForgetPasswordLogin extends StatefulWidget {
//   const ForgetPasswordLogin({super.key});

//   @override
//   State<ForgetPasswordLogin> createState() => _ForgetPasswordLoginState();
// }

// class _ForgetPasswordLoginState extends State<ForgetPasswordLogin> {
//   final TextEditingController phoneController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     phoneController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isArabic = context.read<LanguageCubit>().state == Language.arabic;

//     // الآن يمكنك استخدامه في أي مكان:
//     // isArabic ? "يمين" : "يسار"
//     return Scaffold(
//       body: BlocConsumer<VerificationCubit, VerificationState>(
//         listener: (context, state) {
//           if (state is CreateVerificationCodeSuccess) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => VerificationCodeforgetpassword(
//                   mobilePhone: "963${phoneController.text}",
//                 ),
//               ),
//             );
//           } else if (state is VerificationFailure) {
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
//                       padding: EdgeInsets.symmetric(horizontal: 8.w),
//                       child: CustomText(
//                         "forgot_password_question",
//                         type: AppTextType.titleMedium,
//                         color: AppColors.secondary1,
//                       ),
//                     ),
//                     SizedBox(height: AppSpacing.lg),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: isArabic ? 10.w : 4.w,
//                       ),
//                       child: CustomText(
//                         "enter_phone_reset_password",
//                         type: AppTextType.titleSmall,
//                         color: AppColors.secondary1,
//                       ),
//                     ),
//                     SizedBox(height: AppSpacing.x30.h),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 18.w,
//                         vertical: 16.h,
//                       ),
//                       child: CustomText(
//                         "phone_number",
//                         type: AppTextType.titleSmall,
//                         color: AppColors.secondary1,
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 12.w),
//                       child: Row(
//                         children: [
//                           Container(
//                             height: 40.h, // تم تعديل الطول ليناسب الحقل
//                             width: 75.w,
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFF2F2F2),
//                               borderRadius: BorderRadius.circular(5),
//                               border: Border.all(color: AppColors.main2),
//                             ),
//                             child: const Text(
//                               "+963",
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           SizedBox(width: AppSpacing.sm.w),
//                           Expanded(
//                             child: CustomTextFieldname(
//                               controller: phoneController,
//                               hintText: "",
//                               validator: (val) =>
//                                   Validators.isEmptyValue(val, context),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 300.h),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 24.w),
//                       child: state is VerificationLoading
//                           ? const Center(
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                               ),
//                             )
//                           : CustomButton(
//                               title: "Send",
//                               onTap: () {
//                                 if (_formKey.currentState!.validate()) {
//                                   // 🚀 استدعاء الكيوبت لإرسال الكود
//                                   context
//                                       .read<VerificationCubit>()
//                                       .sendVerificationCode(
//                                         mobilePhone:
//                                             "963${phoneController.text}",
//                                         typeOfUse:
//                                             "reset-password", // النوع الخاص بنسيان كلمة السر
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
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/utiles/faledtor.dart';
import 'package:drever_warr/core/widgets/coustm_text_fild_all.dart';
import 'package:drever_warr/core/widgets/customButton.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/core/widgets/customTextFieldname.dart';
import 'package:drever_warr/core/widgets/logo_app.dart';
import 'package:drever_warr/features/preasntaion/view/verification_cod_forget_password.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetPasswordLogin extends StatefulWidget {
  const ForgetPasswordLogin({super.key});

  @override
  State<ForgetPasswordLogin> createState() => _ForgetPasswordLoginState();
}

class _ForgetPasswordLoginState extends State<ForgetPasswordLogin> {
  // الكنترولرز والـ Key لإدارة الحالة محلياً
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // فرضنا أن اللغة عربية للـ UI
    bool isArabic = true;

    return Scaffold(
      backgroundColor: AppColors.secondary1,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const IconBak(), // زر الرجوع
              SizedBox(height: AppSpacing.lg.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [LogoSection()],
              ),
              SizedBox(height: AppSpacing.xlg.h),
              // سؤال نسيان كلمة السر
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: CustomText(
                  "forgot_password_question",
                  type: AppTextType.titleMedium,
                  color: AppColors.secondary2,
                ),
              ),
              SizedBox(height: AppSpacing.lg.h),

              // تعليمات إدخال الرقم
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isArabic ? 14.w : 4.w,
                ),
                child: CustomText(
                  "enter_phone_reset_password",

                  textAlign: TextAlign.end,
                  type: AppTextType.titleSmall,
                  color: AppColors.secondary2,
                ),
              ),
              SizedBox(height: AppSpacing.x30.h),

              // نص "رقم الهاتف" فوق الحقل
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                child: CustomText(
                  "phone_number",
                  type: AppTextType.titleSmall,
                  color: AppColors.secondary2,
                ),
              ),

              // حقل الإدخال مع كود الدولة
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: AppCustomTextField(
                  countryCode: "+963",
                  controller: _phoneController,
                  hintText: "",
                  validator: (val) => Validators.isEmptyValue(val, context),
                ),
              ),

              SizedBox(height: 250.h),

              // زر الإرسال
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: CustomButton(
                  title: "Send",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      // الانتقال لصفحة كود التحقق (UI التجريبي)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerificationCodeforgetpassword(
                            mobilePhone: "963${_phoneController.text}",
                          ),
                        ),
                      );
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
