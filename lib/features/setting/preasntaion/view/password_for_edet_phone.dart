// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:waslne/Features/Auth/preasntaion/data/repo/cubit/cubit_forget_passwrde/cubit_state.dart';
// import 'package:waslne/Features/Auth/preasntaion/widhets/icon_bak.dart';
// import 'package:waslne/Features/menue/data/cubit/cubit_edit_phone/cubit.dart';
// import 'package:waslne/Features/menue/data/cubit/cubit_edit_phone/cubit_stat.dart'
//     hide ConfirmPasswordSuccess;
// import 'package:waslne/Features/menue/preasntaion/view/edet_phone.dart';
// import 'package:waslne/core/constant/app_colors.dart';
// import 'package:waslne/core/constant/app_spacing.dart';
// import 'package:waslne/core/utiles/valedator.dart';
// import 'package:waslne/core/widgets/custom_buttone.dart';
// import 'package:waslne/core/widgets/custom_text.dart';
// import 'package:waslne/core/widgets/custom_text_fild_name.dart';

// class PasswordForgetPhone extends StatefulWidget {
//   const PasswordForgetPhone({super.key});

//   @override
//   State<PasswordForgetPhone> createState() => _PasswordForgetPhoneState();
// }

// class _PasswordForgetPhoneState extends State<PasswordForgetPhone> {
//   final TextEditingController passwordController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocConsumer<UpdateMobileCubit, UpdateMobileState>(
//         listener: (context, state) {
//           if (state.runtimeType.toString() == 'ConfirmPasswordSuccess' ||
//               state is ConfirmPasswordSuccess) {
//             // 1. الانتقال فوراً
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => BlocProvider.value(
//                   value: context.read<UpdateMobileCubit>(),
//                   child: const EdetPhone(),
//                 ),
//               ),
//             );

//             // 2. إظهار الرسالة
//             // ScaffoldMessenger.of(context).showSnackBar(
//             //   const SnackBar(
//             //     content: Text("تم تأكيد كلمة المرور بنجاح، أدخل الرقم الجديد"),
//             //     backgroundColor: Colors.green,
//             //   ),
//             // );
//           } else if (state is UpdateMobileFailure) {
//             // ❌ إظهار الخطأ في حال كانت كلمة المرور خاطئة
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
//                         "ادخل كلمة المرور ",
//                         type: AppTextType.titleMedium,
//                         color: AppColors.secondary1,
//                       ),
//                     ),
//                     SizedBox(height: AppSpacing.lg),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20.w),
//                       child: CustomText(
//                         "أدخل كلمة المرور لتعديل رقم الجوال",
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
//                         "كلمة المرور",
//                         type: AppTextType.titleSmall,
//                         color: AppColors.secondary1,
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 12.w),
//                       child: CustomTextFieldname(
//                         controller: passwordController,
//                         hintText: "أدخل كلمة المرور",

//                         validator: (val) =>
//                             Validators.isEmptyValue(val, context),
//                       ),
//                     ),
//                     SizedBox(height: 250.h),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 24.w),
//                       child: state is UpdateMobileLoading
//                           ? const Center(
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                               ),
//                             )
//                           : CustomButton(
//                               title: "تأكيد",
//                               onTap: () {
//                                 if (_formKey.currentState!.validate()) {
//                                   // 🚀 استدعاء الكيوبت لتأكيد كلمة المرور أولاً
//                                   context
//                                       .read<UpdateMobileCubit>()
//                                       .confirmUserPassword(
//                                         passwordController.text,
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
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:drever_warr/features/setting/preasntaion/view/edet_phone.dart';
import 'package:flutter/material.dart';
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
              // SizedBox(height: AppSpacing.x70.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomText(
                  "password_label", // ترجمة: ادخل كلمة المرور
                  type: AppTextType.titleMedium,
                  color: AppColors.secondary2,
                ),
              ),
              SizedBox(height: AppSpacing.lg.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomText(
                  "enter_password_header", // ترجمة: أدخل كلمة المرور لتعديل رقم الجوال
                  type: AppTextType.titleSmall,
                  color: AppColors.secondary2,
                ),
              ),
              SizedBox(height: AppSpacing.x30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
                child: CustomText(
                  "password_label", // ترجمة: كلمة المرور
                  type: AppTextType.titleSmall,
                  color: AppColors.secondary2,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: AppCustomTextField(
                  // countryCode: "+963",
                  controller: passwordController,
                  hintText: "password_placeholder", // ترجمة: أدخل كلمة المرور
                  validator: (val) => Validators.isEmptyValue(val, context),
                ),
              ),
              SizedBox(height: 250.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: CustomButton(
                  title: "confirm", // ترجمة: تأكيد
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EdetPhone()),
                      );
                      print("Password entered");
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
