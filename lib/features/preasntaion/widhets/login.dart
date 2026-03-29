// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:waslne/Features/Auth/preasntaion/data/repo/cubit/cubit_login/cubit.dart';
// import 'package:waslne/Features/Auth/preasntaion/data/repo/cubit/cubit_login/cubit_state.dart';
// import 'package:waslne/Features/Auth/preasntaion/view/forget_password_login.dart';
// import 'package:waslne/Features/home/preasntaion/view/home_view.dart';
// import 'package:waslne/core/asset/icone_asset.dart';
// import 'package:waslne/core/constant/app_colors.dart';
// import 'package:waslne/core/constant/app_spacing.dart';
// import 'package:waslne/core/utiles/valedator.dart';
// import 'package:waslne/core/widgets/custom_buttone.dart';
// import 'package:waslne/core/widgets/custom_text.dart';
// import 'package:waslne/core/widgets/custom_text_fild.dart';
// import 'package:waslne/core/widgets/custom_text_fild_name.dart';

// class Loginview extends StatelessWidget {
//   const Loginview({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // الوصول للـ Cubit
//     final cubit = context.read<LoginCubit>();

//     return Padding(
//       padding: EdgeInsets.all(15.r),
//       child: BlocConsumer<LoginCubit, LoginState>(
//         listener: (context, state) {
//           if (state is LoginSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text("تم تسجيل الدخول بنجاح"),
//                 backgroundColor: Colors.green,
//               ),
//             );
//             // الانتقال للشاشة الرئيسية
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const HomeMapView()),
//             );
//           } else if (state is LoginFailure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.errMessage),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           return SingleChildScrollView(
//             child: Form(
//               key: cubit.formKey, // استخدام الـ Key من الكيوبت
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 8.0,
//                       vertical: 10.h,
//                     ),
//                     child: CustomText(
//                       "phone_number",
//                       type: AppTextType.titleSmall,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Container(
//                         height: 40.h,
//                         width: 75.w,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF2F2F2),
//                           borderRadius: BorderRadius.circular(5),
//                           border: Border.all(color: AppColors.main2),
//                         ),
//                         child: const Text(
//                           "+963",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       SizedBox(width: AppSpacing.sm.w),
//                       Expanded(
//                         child: CustomTextFieldname(
//                           controller:
//                               cubit.mobilePhoneController, // ربط الكنترولر
//                           hintText: "",
//                           validator: (val) =>
//                               Validators.isEmptyValue(val, context),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 8.0,
//                       vertical: 10.h,
//                     ),
//                     child: CustomText("password", type: AppTextType.titleSmall),
//                   ),
//                   CustomTextField(
//                     iconImage: IconsAssets.eyeoff,
//                     h: 20,
//                     w: 20,
//                     controller: cubit.passwordController, // ربط الكنترولر
//                     hintText: "******",
//                     isPassword: true,
//                     validator: (val) => Validators.isEmptyValue(val, context),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 8.0,
//                       vertical: 10.h,
//                     ),
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const ForgetPasswordLogin(),
//                           ),
//                         );
//                       },
//                       child: CustomText(
//                         "forgot_password_question",
//                         type: AppTextType.titleSmall,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 270.h), // تقليل المسافة لتناسب التصميم
//                   // زر تسجيل الدخول مع حالة التحميل
//                   state is LoginLoading
//                       ? const Center(child: CircularProgressIndicator())
//                       : CustomButton(
//                           title: "login",
//                           onTap: () {
//                             cubit.loginUser();
//                           },
//                         ),
//                 ],
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
import 'package:drever_warr/core/widgets/logo_app.dart';

import 'package:drever_warr/features/preasntaion/view/forget_password_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // تعريف الكنترولرز هنا داخل الـ State لتبقى الواجهة مستقلة
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _mobilePhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _mobilePhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary1,
      body: Padding(
        padding: EdgeInsets.all(15.r),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: AppSpacing.lg.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        LogoSection(),
                        // SizedBox(height: AppSpacing.lg.h),
                        CustomText(
                          "login",
                          type: AppTextType.titleSmall,
                          color: AppColors.main1,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xxxlg.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 10.h,
                  ),
                  child: CustomText(
                    "phone_number",
                    type: AppTextType.titleSmall,
                  ),
                ),
                SizedBox(width: AppSpacing.sm.w),
                AppCustomTextField(
                  countryCode: "+963",
                  controller: _mobilePhoneController,
                  hintText: "",
                  validator: (val) => Validators.isEmptyValue(val, context),
                ),
                SizedBox(width: AppSpacing.sm.w),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 10.h,
                  ),
                  child: CustomText("password", type: AppTextType.titleSmall),
                ),
                AppCustomTextField(
                  iconImage: IconsAssets.eyeoff,

                  controller: _passwordController,
                  hintText: "",
                  isPassword: true,
                  validator: (val) => Validators.isEmptyValue(val, context),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 10.h,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgetPasswordLogin(),
                        ),
                      );
                    },
                    child: CustomText(
                      color: AppColors.blue,
                      "forgot_password_question",
                      type: AppTextType.titleSmall,
                    ),
                  ),
                ),
                SizedBox(height: 270.h),
                CustomButton(
                  title: "login",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const HomeMapView(),
                      //   ),
                      // );
                      // هنا تضع المنطق الخاص بك عند الضغط
                      debugPrint("Login Pressed");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
