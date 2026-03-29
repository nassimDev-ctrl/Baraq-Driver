// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:waslne/Features/Auth/preasntaion/data/repo/cubit/cubit_governorates/cubit.dart';
// import 'package:waslne/Features/Auth/preasntaion/data/repo/cubit/cubit_governorates/cubit_state.dart';
// import 'package:waslne/Features/Auth/preasntaion/data/repo/cubit/cubit_regster.dart/cubit_regster_state.dart';
// import 'package:waslne/Features/Auth/preasntaion/data/repo/cubit/cubit_regster.dart/cubit_rejester.dart';
// import 'package:waslne/Features/Auth/preasntaion/data/repo/cubit/cubit_verificationRepo/cubit.dart';
// import 'package:waslne/Features/Auth/preasntaion/data/repo/cubit/cubit_verificationRepo/cubite_state.dart';
// import 'package:waslne/Features/Auth/preasntaion/view/verification_code_regster.dart';
// import 'package:waslne/Features/Auth/preasntaion/widhets/row_select_gender.dart';
// import 'package:waslne/core/asset/icone_asset.dart';
// import 'package:waslne/core/constant/app_colors.dart';
// import 'package:waslne/core/constant/app_spacing.dart';
// import 'package:waslne/core/utiles/valedator.dart';
// import 'package:waslne/core/widgets/custm_text_fild_mohafsa.dart';
// import 'package:waslne/core/widgets/custom_buttone.dart';
// import 'package:waslne/core/widgets/custom_text.dart';
// import 'package:waslne/core/widgets/custom_text_fild.dart';
// import 'package:waslne/core/widgets/custom_text_fild_name.dart';

// class Regsterview extends StatelessWidget {
//   const Regsterview({super.key});

//   static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final cubit = context.read<RegisterCubit>();

//     return MultiBlocListener(
//       listeners: [
//         BlocListener<VerificationCubit, VerificationState>(
//           listener: (context, state) {
//             if (state is CreateVerificationCodeSuccess) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => VerificationCodeRegster(
//                     phone: context.read<RegisterCubit>().mobilePhone.text,
//                   ),
//                 ),
//               );
//             } else if (state is VerificationFailure) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.errMessage),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             }
//           },
//         ),

//         BlocListener<RegisterCubit, RegisterState>(
//           listener: (context, state) {
//             if (state is RegisterFailure) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.errMessage),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             }
//           },
//         ),
//       ],
//       child: Padding(
//         padding: EdgeInsets.all(15.r),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 8.0,
//                     vertical: 10.h,
//                   ),
//                   child: CustomText("full_name", type: AppTextType.titleSmall),
//                 ),
//                 CustomTextFieldname(
//                   controller: cubit.firstName,
//                   hintText: "",
//                   validator: (val) => Validators.isEmptyValue(val, context),
//                 ),

//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 8.0,
//                     vertical: 10.h,
//                   ),
//                   child: CustomText(
//                     "phone_number",
//                     type: AppTextType.titleSmall,
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Container(
//                       height: 40.h,
//                       width: 75,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF2F2F2),
//                         borderRadius: BorderRadius.circular(5),
//                         border: Border.all(color: AppColors.main2),
//                       ),
//                       child: const Text(
//                         "+963",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     SizedBox(width: AppSpacing.sm.w),
//                     Expanded(
//                       child: CustomTextFieldname(
//                         controller: cubit.mobilePhone,
//                         hintText: "",
//                         validator: (val) =>
//                             Validators.validatePhone(val, context),
//                       ),
//                     ),
//                   ],
//                 ),

//                 /// --- حقل المحافظة ---
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 8.0,
//                     vertical: 10.h,
//                   ),
//                   child: CustomText(
//                     " select_governorate",
//                     type: AppTextType.titleSmall,
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     context.read<GovernoratesCubit>().getGovernorates();

//                     showModalBottomSheet(
//                       context: context,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.vertical(
//                           top: Radius.circular(20.r),
//                         ),
//                       ),
//                       builder: (context) {
//                         return BlocBuilder<
//                           GovernoratesCubit,
//                           GovernoratesState
//                         >(
//                           builder: (context, state) {
//                             if (state is GovernoratesLoading) {
//                               return const Center(
//                                 child: CircularProgressIndicator(),
//                               );
//                             } else if (state is GovernoratesSuccess) {
//                               return ListView.builder(
//                                 itemCount: state.governorates.length,
//                                 itemBuilder: (context, index) {
//                                   final gov = state.governorates[index];
//                                   return ListTile(
//                                     title: Text(
//                                       gov.name,
//                                       textAlign: TextAlign.right,
//                                     ),
//                                     onTap: () {
//                                       cubit.governorate.text = gov.name;

//                                       Navigator.pop(context);
//                                     },
//                                   );
//                                 },
//                               );
//                             } else if (state is GovernoratesFailure) {
//                               return Center(child: Text(state.errMessage));
//                             }
//                             return const Center(child: Text("لا توجد بيانات"));
//                           },
//                         );
//                       },
//                     );
//                   },
//                   child: AbsorbPointer(
//                     child: CustomTextFieldmohafsa(
//                       iconImage: IconsAssets.drowpdawn,
//                       controller: cubit.governorate,
//                       h: 10,
//                       w: 10,
//                       hintText: "",
//                       validator: (val) => Validators.isEmptyValue(val, context),
//                     ),
//                   ),
//                 ),

//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 8.0,
//                     vertical: 10.h,
//                   ),
//                   child: CustomText("password", type: AppTextType.titleSmall),
//                 ),
//                 CustomTextField(
//                   iconImage: IconsAssets.eyeoff,
//                   h: 20,
//                   w: 20,
//                   controller: cubit.password,
//                   hintText: "",
//                   isPassword: true,
//                   validator: (val) => Validators.validatePassword(val, context),
//                 ),

//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 8.0,
//                     vertical: 10.h,
//                   ),
//                   child: CustomText(
//                     "emergency_number",
//                     type: AppTextType.titleSmall,
//                   ),
//                 ),
//                 CustomTextField(
//                   iconImage: IconsAssets.emergemcy,
//                   h: 20,
//                   w: 20,
//                   controller: cubit.emergencyNumber,
//                   hintText: "emergency_hint",
//                   validator: (val) => Validators.validatePhone(val, context),
//                 ),

//                 SizedBox(height: AppSpacing.lg.h),
//                 const Selectgender(),
//                 SizedBox(height: AppSpacing.x30.h),

//                 context.watch<VerificationCubit>().state is VerificationLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : CustomButton(
//                         title: "next",
//                         onTap: () {
//                           if (_formKey.currentState!.validate()) {
//                             // 1. نطلب إرسال كود التحقق أولاً
//                             context
//                                 .read<VerificationCubit>()
//                                 .sendVerificationCode(
//                                   mobilePhone: "963${cubit.mobilePhone.text}",
//                                   typeOfUse: "activate-account",
//                                 );
//                           }
//                         },
//                       ),
//               ],
//             ),
//           ),
//         ),
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
import 'package:drever_warr/core/widgets/customTextFieldmohafsa.dart';
import 'package:drever_warr/core/widgets/customTextFieldname.dart';
import 'package:drever_warr/features/preasntaion/view/registerPhotoScreen.dart';
import 'package:drever_warr/features/preasntaion/view/verification_code_regster.dart';
import 'package:drever_warr/features/preasntaion/widhets/login.dart';
import 'package:drever_warr/features/preasntaion/widhets/row_select_gender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/utiles/faledtor.dart';
import 'package:drever_warr/core/widgets/coustm_text_fild_all.dart';
import 'package:drever_warr/core/widgets/customButton.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/core/widgets/customTextField.dart';
import 'package:drever_warr/core/widgets/customTextFieldmohafsa.dart';
import 'package:drever_warr/core/widgets/customTextFieldname.dart';
import 'package:drever_warr/core/widgets/logo_app.dart';
import 'package:drever_warr/features/preasntaion/view/registerPhotoScreen.dart';
import 'package:drever_warr/features/preasntaion/view/verification_code_regster.dart';
import 'package:drever_warr/features/preasntaion/widhets/login.dart';
import 'package:drever_warr/features/preasntaion/widhets/row_select_gender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Regsterview extends StatefulWidget {
  const Regsterview({super.key});

  @override
  State<Regsterview> createState() => _RegsterviewState();
}

class _RegsterviewState extends State<Regsterview> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _governorateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emergencyController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _governorateController.dispose();
    _passwordController.dispose();
    _emergencyController.dispose();
    super.dispose();
  }

  void _showGovernoratesSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        List<String> governorates = [
          "دمشق",
          "حلب",
          "حمص",
          "اللاذقية",
          "طرطوس",
          "حماة",
          "إدلب",
          "دير الزور",
          "الرقة",
          "الحسكة",
          "درعا",
          "السويداء",
          "القنيطرة",
          "ريف دمشق",
        ];

        return ListView.builder(
          itemCount: governorates.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(governorates[index], textAlign: TextAlign.right),
              onTap: () {
                setState(() {
                  _governorateController.text = governorates[index];
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary1,
      body: SafeArea(
        child: Column(
          children: [
            // --- القسم الثابت: اللوغو وكلمة Register ---
            SizedBox(height: AppSpacing.lg.h),
            const LogoSection(),
            CustomText(
              "Register",
              type: AppTextType.titleSmall,
              color: AppColors.main1,
            ),
            SizedBox(height: AppSpacing.md.h),

            // --- القسم القابل للتمرير: الحقول والأزرار ---
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // الاسم الكامل
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 10.w,
                        ),
                        child: CustomText(
                          "full_name",
                          type: AppTextType.titleSmall,
                        ),
                      ),
                      AppCustomTextField(
                        controller: _nameController,
                        hintText: "",
                        validator: (val) =>
                            Validators.isEmptyValue(val, context),
                      ),

                      // رقم الهاتف
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 10.w,
                        ),
                        child: CustomText(
                          "phone_number",
                          type: AppTextType.titleSmall,
                        ),
                      ),
                      AppCustomTextField(
                        countryCode: "+963",
                        controller: _phoneController,
                        hintText: "",
                        validator: (val) =>
                            Validators.validatePhone(val, context),
                      ),

                      // اختيار المحافظة
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 10.w,
                        ),
                        child: CustomText(
                          "select_governorate",
                          type: AppTextType.titleSmall,
                        ),
                      ),
                      PopupMenuButton<String>(
                        // التحكم في عرض ومكان القائمة
                        offset: Offset(0, 50.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 4,
                        // عند اختيار محافظة
                        onSelected: (String value) {
                          setState(() {
                            _governorateController.text = value;
                          });
                        },
                        // بناء عناصر القائمة (المستطيل)
                        itemBuilder: (BuildContext context) {
                          List<String> governorates = [
                            "دمشق",
                            "حلب",
                            "حمص",
                            "اللاذقية",
                            "طرطوس",
                            "حماة",
                            "إدلب",
                            "دير الزور",
                            "الرقة",
                            "الحسكة",
                            "درعا",
                            "السويداء",
                            "القنيطرة",
                            "ريف دمشق",
                          ];
                          return governorates.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.centerRight,
                                child: CustomText(
                                  choice,
                                  type: AppTextType
                                      .bodyMedium, // استخدم النوع المناسب لخطك
                                ),
                              ),
                            );
                          }).toList();
                        },

                        child: AbsorbPointer(
                          child: AppCustomTextField(
                            iconImage: IconsAssets.drowpdawn,
                            controller: _governorateController,
                            iconSize: 10.sp,
                            hintText: "",
                            validator: (val) =>
                                Validators.isEmptyValue(val, context),
                          ),
                        ),
                      ),

                      // كلمة المرور
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 10.w,
                        ),
                        child: CustomText(
                          "password",
                          type: AppTextType.titleSmall,
                        ),
                      ),
                      AppCustomTextField(
                        iconImage: IconsAssets.eyeoff,
                        controller: _passwordController,
                        hintText: "",
                        isPassword: true,
                        validator: (val) =>
                            Validators.validatePassword(val, context),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 10.w,
                        ),
                        child: CustomText(
                          "emergency_number",
                          type: AppTextType.titleSmall,
                        ),
                      ),
                      AppCustomTextField(
                        iconImage: IconsAssets.emergemcy,
                        controller: _emergencyController,
                        hintText: "emergency_hint",
                        validator: (val) =>
                            Validators.validatePhone(val, context),
                      ),

                      SizedBox(height: AppSpacing.lg.h),
                      const Selectgender(),

                      SizedBox(height: AppSpacing.x30.h),

                      // زر الدخول (Login)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 45.w),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginView(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: AppSpacing.xxs.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: AppColors.main1),
                            ),
                            child: Center(
                              child: CustomText(
                                "login",
                                type: AppTextType.titleMedium,
                                color: TextColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: AppSpacing.lg.h),

                      // زر التالي (Next)
                      CustomButton(
                        title: "next",
                        onTap: () {
                          // if (_formKey.currentState!.validate()) {
                          // هنا ننتقل لصفحة الكود يدوياً للتجربة
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPhotoScreen(),
                            ),
                          );
                        },
                        //  },
                      ),

                      SizedBox(height: 30.h), // مساحة إضافية مريحة تحت السكرول
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
