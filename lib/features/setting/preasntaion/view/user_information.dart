// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:waslne/Features/Auth/preasntaion/data/repo/cubit/cubit_governorates/cubit.dart';
// import 'package:waslne/Features/Auth/preasntaion/data/repo/cubit/cubit_governorates/cubit_state.dart';
// import 'package:waslne/Features/Auth/preasntaion/widhets/icon_bak.dart';
// import 'package:waslne/Features/menue/data/cubit/cubit_update_profail/cubit.dart';
// import 'package:waslne/Features/menue/data/cubit/cubit_update_profail/cubit_state.dart';
// import 'package:waslne/Features/menue/preasntaion/view/password_for_edet_phone.dart';
// import 'package:waslne/core/asset/icone_asset.dart';
// import 'package:waslne/core/constant/app_colors.dart';
// import 'package:waslne/core/constant/app_spacing.dart';
// import 'package:waslne/core/utiles/valedator.dart';
// import 'package:waslne/core/widgets/custm_text_fild_mohafsa.dart';
// import 'package:waslne/core/widgets/custom_buttone.dart';
// import 'package:waslne/core/widgets/custom_text.dart';
// import 'package:waslne/core/widgets/custom_text_fild.dart';

// class UserInformation extends StatefulWidget {
//   const UserInformation({super.key});

//   @override
//   State<UserInformation> createState() => _UserInformationState();
// }

// class _UserInformationState extends State<UserInformation> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController provinceController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   String? selectedGovernorateId; // لتخزين الـ ID الذي سيرسل للـ API
//   @override
//   void dispose() {
//     nameController.dispose();
//     phoneController.dispose();
//     provinceController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
//         listener: (context, state) {
//           if (state is UpdateProfileSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.green,
//               ),
//             );
//           } else if (state is UpdateProfileFailure) {
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
//             child: SafeArea(
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16.w),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         const IconBak(),
//                         SizedBox(height: 20.h),

//                         // --- الجزء الخاص بالصورة الشخصية ---
//                         Center(
//                           child: Stack(
//                             clipBehavior: Clip.none,
//                             alignment: Alignment.center,
//                             children: [
//                               Container(
//                                 height: 100.h,
//                                 width: 100.w,
//                                 decoration: const BoxDecoration(
//                                   color: Colors.white,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: ClipOval(
//                                   child: Image.network(
//                                     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSf_jUfM_jUfM_jUfM_jUfM_jUfM_jUfM_jUfM&s',
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 0,
//                                 right: 0,
//                                 child: Container(
//                                   padding: EdgeInsets.all(5.w),
//                                   decoration: const BoxDecoration(
//                                     color: Colors.white,
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: SvgPicture.asset(
//                                     IconsAssets.editee,
//                                     height: 15.h,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                         SizedBox(height: 30.h),
//                         _buildSectionTitle("المعلومات الشخصية"),

//                         // --- حقل الاسم ---
//                         _buildInputLabel("الاسم"),
//                         CustomTextField(
//                           iconImage: IconsAssets.editee,
//                           controller: nameController,
//                           hintText: "",
//                           validator: (val) =>
//                               Validators.isEmptyValue(val, context),
//                         ),

//                         _buildInputLabel("الرقم"),
//                         Row(
//                           children: [
//                             _buildCountryCode(),
//                             SizedBox(width: 8.w),
//                             Expanded(
//                               child: CustomTextField(
//                                 onIconTap: () => Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         const PasswordForgetPhone(),
//                                   ),
//                                 ),
//                                 controller: phoneController,
//                                 hintText: "",
//                                 iconImage: IconsAssets.editee,
//                                 validator: (val) =>
//                                     Validators.isEmptyValue(val, context),
//                               ),
//                             ),
//                           ],
//                         ),

//                         _buildInputLabel("المحافظة"),

//                         GestureDetector(
//                           onTap: () {
//                             context.read<GovernoratesCubit>().getGovernorates();

//                             showModalBottomSheet(
//                               context: context,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.vertical(
//                                   top: Radius.circular(20.r),
//                                 ),
//                               ),
//                               builder: (context) {
//                                 return BlocBuilder<
//                                   GovernoratesCubit,
//                                   GovernoratesState
//                                 >(
//                                   builder: (context, state) {
//                                     if (state is GovernoratesLoading) {
//                                       return const SizedBox(
//                                         height: 200,
//                                         child: Center(
//                                           child: CircularProgressIndicator(),
//                                         ),
//                                       );
//                                     } else if (state is GovernoratesSuccess) {
//                                       return ListView.builder(
//                                         itemCount: state.governorates.length,
//                                         itemBuilder: (context, index) {
//                                           final gov = state.governorates[index];
//                                           return ListTile(
//                                             title: Text(
//                                               gov.name,
//                                               textAlign: TextAlign.right,
//                                             ),
//                                             onTap: () {
//                                               setState(() {
//                                                 // 1. تحديث النص الظاهر في الحقل
//                                                 provinceController.text =
//                                                     gov.name;
//                                                 // 2. تخزين الـ ID لإرساله للـ API
//                                                 selectedGovernorateId = gov.id;
//                                               });
//                                               Navigator.pop(context);
//                                             },
//                                           );
//                                         },
//                                       );
//                                     } else if (state is GovernoratesFailure) {
//                                       return Center(
//                                         child: Text(state.errMessage),
//                                       );
//                                     }
//                                     return const Center(
//                                       child: Text("لا توجد بيانات"),
//                                     );
//                                   },
//                                 );
//                               },
//                             );
//                           },
//                           child: AbsorbPointer(
//                             child: CustomTextFieldmohafsa(
//                               iconImage: IconsAssets.drowpdawn,
//                               controller:
//                                   provinceController, // تأكد من تمرير المتحكم هنا
//                               h: 15,
//                               w: 15,
//                               hintText: "اختر المحافظة",
//                               validator: (val) =>
//                                   Validators.isEmptyValue(val, context),
//                             ),
//                           ),
//                         ),
//                         _buildInputLabel("كلمة المرور لتأكيد التعديل"),
//                         CustomTextField(
//                           iconImage: IconsAssets.editee,
//                           controller: passwordController,
//                           hintText: "",
//                           isPassword: true,
//                           validator: (val) =>
//                               Validators.isEmptyValue(val, context),
//                         ),

//                         SizedBox(height: 40.h),

//                         // --- زر الحفظ مع معالجة حالة التحميل ---
//                         state is UpdateProfileLoading
//                             ? const Center(
//                                 child: CircularProgressIndicator(
//                                   color: Colors.white,
//                                 ),
//                               )
//                             : CustomButton(
//                                 title: "حفظ التغييرات",
//                                 onTap: () {
//                                   if (_formKey.currentState!.validate()) {
//                                     context
//                                         .read<UpdateProfileCubit>()
//                                         .updateUserData(
//                                           firstName: nameController.text,
//                                           lastName:
//                                               "", // يمكنك تقسيم الاسم لو أردت
//                                           governorate:
//                                               selectedGovernorateId!, // نرسل الـ ID المختار ديناميكياً
//                                         );
//                                   }
//                                 },
//                               ),
//                         SizedBox(height: 40.h),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // ميثودات مساعدة لتحسين شكل الكود
//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10.h),
//       child: CustomText(
//         title,
//         type: AppTextType.titleMedium,
//         color: AppColors.secondary1,
//       ),
//     );
//   }

//   Widget _buildInputLabel(String label) {
//     return Padding(
//       padding: EdgeInsets.only(top: 15.h, bottom: 5.h),
//       child: CustomText(
//         label,
//         type: AppTextType.titleSmall,
//         color: AppColors.secondary1,
//       ),
//     );
//   }

//   Widget _buildCountryCode() {
//     return Container(
//       height: 40.h,
//       width: 60.w,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         color: const Color(0xFFF2F2F2),
//         borderRadius: BorderRadius.circular(4.r),
//         border: Border.all(color: AppColors.main2),
//       ),
//       child: const CustomText(
//         "963+",
//         color: Colors.black,
//         type: AppTextType.bodyMedium,
//       ),
//     );
//   }
// }
import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/utiles/faledtor.dart';
import 'package:drever_warr/core/widgets/coustm_text_fild_all.dart';
import 'package:drever_warr/core/widgets/customButton.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/core/widgets/customTextField.dart';
import 'package:drever_warr/core/widgets/customTextFieldmohafsa.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:drever_warr/features/setting/preasntaion/view/Verficationcode_change_password.dart';
import 'package:drever_warr/features/setting/preasntaion/view/password_for_edet_phone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({super.key});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    provinceController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary1,

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const IconBak(),
                  SizedBox(height: 20.h),

                  // --- صورة الملف الشخصي ---
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 100.h,
                          width: 100.w,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              ImageAssets.imageprofail,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(5.w),
                            decoration: BoxDecoration(
                              color: AppColors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              IconsAssets.editee,
                              height: 15.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30.h),
                  _buildSectionTitle("personal_info"), // المعلومات الشخصية
                  // --- حقل الاسم ---
                  _buildInputLabel("full_name"), // الاسم
                  AppCustomTextField(
                    iconImage: IconsAssets.editee,
                    controller: nameController,
                    hintText: "",
                    validator: (val) => Validators.isEmptyValue(val, context),
                  ),

                  // --- حقل الرقم ---
                  _buildInputLabel("phone_number"), // الرقم
                  AppCustomTextField(
                    countryCode: "+963",
                    onIconTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PasswordForgetPhone(),
                        ),
                      );
                    },
                    controller: phoneController,
                    hintText: "",
                    iconImage: IconsAssets.editee,
                    validator: (val) => Validators.isEmptyValue(val, context),
                  ),

                  // --- حقل المحافظة ---
                  _buildInputLabel("governorate"), // المحافظة
                  GestureDetector(
                    onTap: () {
                      // هنا يمكنك فتح BottomSheet ثابتة للعرض فقط
                    },
                    child: AbsorbPointer(
                      child: AppCustomTextField(
                        iconImage: IconsAssets.drowpdawn,
                        controller: provinceController,

                        hintText: "", // اختر المحافظة
                        validator: (val) =>
                            Validators.isEmptyValue(val, context),
                      ),
                    ),
                  ),

                  // --- حقل كلمة المرور ---
                  _buildInputLabel("password"), // كلمة المرور لتأكيد التعديل
                  AppCustomTextField(
                    onIconTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerificationCodeforgetpassword2(
                            mobilePhone: "996688957",
                          ),
                        ),
                      );
                    },
                    iconImage: IconsAssets.editee,
                    controller: passwordController,
                    hintText: "",
                    isPassword: true,
                    readOnly: true,
                    validator: (val) => Validators.isEmptyValue(val, context),
                  ),

                  SizedBox(height: 40.h),

                  // --- زر الحفظ ---
                  CustomButton(
                    title: "save", // حفظ التغييرات
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        print("UI validated - Ready to save");
                      }
                    },
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ميثودات مساعدة
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
      child: CustomText(
        title,
        type: AppTextType.titleMedium,
        color: AppColors.blue,
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 12.h),
      child: CustomText(
        label,
        type: AppTextType.titleSmall,
        color: AppColors.secondary2,
      ),
    );
  }

  Widget _buildCountryCode() {
    return Container(
      height: 40.h,
      width: 60.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: AppColors.main2),
      ),
      child: const CustomText(
        "963+",
        color: Colors.black,
        type: AppTextType.bodyMedium,
      ),
    );
  }
}
