// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:waslne/Features/Auth/preasntaion/data/repo/cubit/cubit_forget_passwrde/cubit.dart';
// import 'package:waslne/Features/Auth/preasntaion/data/repo/cubit/cubit_forget_passwrde/cubit_state.dart';
// import 'package:waslne/Features/Auth/preasntaion/widhets/icon_bak.dart';
// import 'package:waslne/core/asset/icone_asset.dart';
// import 'package:waslne/core/constant/app_colors.dart';
// import 'package:waslne/core/constant/app_spacing.dart';
// import 'package:waslne/core/transleat/lunguesh_cubit.dart';
// import 'package:waslne/core/utiles/valedator.dart';
// import 'package:waslne/core/widgets/custom_buttone.dart';
// import 'package:waslne/core/widgets/custom_text.dart';
// import 'package:waslne/core/widgets/custom_text_fild.dart';

// class ConfermPassword extends StatefulWidget {
//   const ConfermPassword({super.key, required this.mobilePhone1});
//   final String mobilePhone1;

//   @override
//   State<ConfermPassword> createState() => _ConfermPasswordState();
// }

// class _ConfermPasswordState extends State<ConfermPassword> {
//   final TextEditingController password1Controller = TextEditingController();
//   final TextEditingController password2Controller = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     password1Controller.dispose();
//     password2Controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isArabic = context.read<LanguageCubit>().state == Language.arabic;
//     return Scaffold(
//       body: BlocConsumer<ConfirmPasswordCubit, ConfirmPasswordState>(
//         listener: (context, state) {
//           if (state is ConfirmPasswordSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text("تم تغيير كلمة المرور بنجاح"),
//                 backgroundColor: Colors.green,
//               ),
//             );
//           } else if (state is ConfirmPasswordFailure) {
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
//                       padding: EdgeInsets.symmetric(
//                         horizontal: isArabic ? 8.w : 18.w,
//                       ),
//                       child: CustomText(
//                         "new_password_title",
//                         type: AppTextType.titleMedium,
//                         color: AppColors.secondary1,
//                       ),
//                     ),
//                     SizedBox(height: AppSpacing.x45.h),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 20.w,
//                         vertical: 10.h,
//                       ),
//                       child: CustomText(
//                         "enter_new_password_hint",
//                         type: AppTextType.titleSmall,
//                         color: AppColors.secondary1,
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 18.w),
//                       child: CustomTextField(
//                         iconImage: IconsAssets.eyeoff,
//                         h: 20,
//                         w: 20,
//                         controller: password1Controller,
//                         hintText: "",
//                         isPassword: true,
//                         validator: (val) =>
//                             Validators.validatePassword(val, context),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 20.w,
//                         vertical: 10.h,
//                       ),
//                       child: CustomText(
//                         "confirm_password_label",
//                         type: AppTextType.titleSmall,
//                         color: AppColors.secondary1,
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 18.w),
//                       child: CustomTextField(
//                         iconImage: IconsAssets.eyeoff,
//                         h: 20,
//                         w: 20,
//                         controller: password2Controller,
//                         hintText: "",
//                         isPassword: true,
//                         validator: (val) {
//                           if (val != password1Controller.text) {
//                             return "كلمتا المرور غير متطابقتين";
//                           }
//                           return Validators.validatePassword(val, context);
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 250.h),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 40.w),
//                       child: state is ConfirmPasswordLoading
//                           ? const Center(
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                               ),
//                             )
//                           : CustomButton(
//                               title: "إرسال",
//                               onTap: () {
//                                 if (_formKey.currentState!.validate()) {
//                                   context
//                                       .read<ConfirmPasswordCubit>()
//                                       .confirmNewPassword(
//                                         password: password1Controller.text,
//                                         mobilphone: widget.mobilePhone1,
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
import 'package:drever_warr/core/widgets/customTextField.dart';
import 'package:drever_warr/core/widgets/logo_app.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfermPassword extends StatefulWidget {
  const ConfermPassword({super.key, required this.mobilePhone1});
  final String mobilePhone1;

  @override
  State<ConfermPassword> createState() => _ConfermPasswordState();
}

class _ConfermPasswordState extends State<ConfermPassword> {
  // تعريف الكنترولرز والـ Form Key
  final TextEditingController _password1Controller = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _password1Controller.dispose();
    _password2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // افترضنا أن اللغة عربية للتبسيط في الـ UI، يمكنك ربطها بمتغير لاحقاً
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
              SizedBox(height: AppSpacing.x25.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [LogoSection()],
              ),
              SizedBox(height: AppSpacing.x25.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomText(
                  "new_password_title",
                  type: AppTextType.titleMedium,
                  color: AppColors.secondary2,
                ),
              ),
              SizedBox(height: AppSpacing.x45.h),

              // حقل كلمة المرور الجديدة
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: CustomText(
                  "enter_new_password_hint",
                  type: AppTextType.titleSmall,
                  color: AppColors.secondary2,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: AppCustomTextField(
                  iconImage: IconsAssets.eyeoff,

                  controller: _password1Controller,
                  hintText: "",
                  isPassword: true,
                  validator: (val) => Validators.validatePassword(val, context),
                ),
              ),

              // حقل تأكيد كلمة المرور
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: CustomText(
                  "confirm_password_label",
                  type: AppTextType.titleSmall,
                  color: AppColors.secondary2,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: AppCustomTextField(
                  iconImage: IconsAssets.eyeoff,

                  controller: _password2Controller,
                  hintText: "",
                  isPassword: true,
                  validator: (val) {
                    if (val != _password1Controller.text) {
                      return "كلمتا المرور غير متطابقتين";
                    }
                    return Validators.validatePassword(val, context);
                  },
                ),
              ),

              SizedBox(height: 250.h),

              // زر الإرسال
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomButton(
                  title: "Send",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      // هنا تضع الأكشن الخاص بك، مثلاً طباعة القيم للتأكد
                      debugPrint(
                        "Password Changed for: ${widget.mobilePhone1}",
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
