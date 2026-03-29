// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:warr2/core/asset/icon_asset.dart';
// import 'package:warr2/core/constant/app_colors.dart';
// import 'package:warr2/core/constant/app_spacing.dart';
// import 'package:warr2/core/transleat/app_translat.dart';
// import 'package:warr2/core/transleat/lunguesh_cubit.dart';
// import 'package:warr2/features/menue/preasntaion/view/user_information.dart';
// import 'package:warr2/features/menue/preasntaion/widgets/container_for_settings.dart';

// class SettingsScreen extends StatefulWidget {
//   @override
//   _SettingsScreenState createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   bool soundEnabled = true;
//   bool locationEnabled = false;
//   bool isLangMenuOpen = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.main1,
//       body: Column(
//         children: [
//           SizedBox(height: AppSpacing.x70.h),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: SvgPicture.asset(IconsAssets.back),
//                 ),
//                 SizedBox(width: 180.w),
//                 Text(
//                   AppTranslations.getText(context, "title"),
//                   style: TextStyle(color: Colors.white, fontSize: 25),
//                 ),
//                 SizedBox(width: 10.w),
//                 SvgPicture.asset(IconsAssets.setting, matchTextDirection: true),
//               ],
//             ),
//           ),
//           SizedBox(height: AppSpacing.x70.h),

//           Column(
//             children: [
//               SettingItemContainer(
//                 onTap: () {
//                   setState(() {
//                     isLangMenuOpen = !isLangMenuOpen;
//                   });
//                 },
//                 title: "language", // استبدلها بـ S.of(context).language للترجمة
//                 iconPath: IconsAssets.language,
//                 trailing: Icon(
//                   isLangMenuOpen
//                       ? Icons.keyboard_arrow_up
//                       : Icons.keyboard_arrow_down,
//                   color: Colors.white,
//                   size: 28.sp,
//                 ),
//               ),

//               // قائمة اللغات المنسدلة (تظهر فقط عند الضغط)
//               if (isLangMenuOpen)
//                 Container(
//                   margin: EdgeInsets.symmetric(
//                     horizontal: 40.w,
//                   ), // أصغر قليلاً من الحاوية الأصلية
//                   padding: EdgeInsets.all(8.w),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF072F6D).withOpacity(0.8),
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(15.r),
//                       bottomRight: Radius.circular(15.r),
//                     ),
//                     border: Border.all(color: Colors.white.withOpacity(0.3)),
//                   ),
//                   child: BlocBuilder<LanguageCubit, Language>(
//                     builder: (context, currentLang) {
//                       return Column(
//                         children: [
//                           _buildLangOption(
//                             context,
//                             label: "العربية",
//                             isSelected: currentLang == Language.arabic,
//                             onTap: () {
//                               context.read<LanguageCubit>().setLanguage(
//                                 Language.arabic,
//                               );
//                               setState(() => isLangMenuOpen = false);
//                             },
//                           ),
//                           Divider(color: Colors.white30, thickness: 1.h),
//                           _buildLangOption(
//                             context,
//                             label: "English",
//                             isSelected: currentLang == Language.english,
//                             onTap: () {
//                               context.read<LanguageCubit>().setLanguage(
//                                 Language.english,
//                               );
//                               setState(() => isLangMenuOpen = false);
//                             },
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//             ],
//           ),
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => UserInformation()),
//               );
//             },
//             child: SettingItemContainer(
//               title: "personal_info",
//               iconPath: IconsAssets.userinformation,
//             ),
//           ),

//           SettingItemContainer(
//             title: "sound_vibration",
//             iconPath: IconsAssets.sounds,
//             trailing: Switch(
//               value: soundEnabled,
//               onChanged: (val) => setState(() => soundEnabled = val),
//               activeColor: Colors.blue,
//             ),
//           ),

//           // SettingItemContainer(
//           //   title: "صلاحيات الموقع",
//           //   iconPath: IconsAssets.permissionlocation,
//           //   trailing: Switch(
//           //     value: locationEnabled,
//           //     onChanged: (val) => setState(() => locationEnabled = val),
//           //     activeColor: Colors.blue,
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLangOption(
//     BuildContext context, {
//     required String label,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             if (isSelected) Icon(Icons.check, color: Colors.blue, size: 20.sp),
//             Text(
//               label,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16.sp,
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/transleat/app_translat.dart';
import 'package:drever_warr/core/transleat/lunguesh_cubit.dart';
import 'package:drever_warr/features/setting/preasntaion/view/user_information.dart';
import 'package:drever_warr/features/setting/preasntaion/widget/container_for_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
 
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool soundEnabled = true;
  bool isLangMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main1,
      body: GestureDetector(
        onTap: () {
          if (isLangMenuOpen) {
            setState(() {
              isLangMenuOpen = false;
            });
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            // الطبقة الأولى: محتوى الصفحة الأساسي
            Column(
              children: [
                SizedBox(height: AppSpacing.x70.h),

                // الهيدر (العنوان وزر الرجوع)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset(
                          IconsAssets.back,
                          matchTextDirection: true,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            AppTranslations.getText(context, "title"),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          SvgPicture.asset(IconsAssets.setting),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSpacing.x70.h),

                // خيار اللغة
                SettingItemContainer(
                  onTap: () {
                    setState(() {
                      isLangMenuOpen = !isLangMenuOpen;
                    });
                  },
                  title: "language",
                  iconPath: IconsAssets.language,
                  trailing: Icon(
                    isLangMenuOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black,
                    size: 28.sp,
                  ),
                ),

                // خيار المعلومات الشخصية
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserInformation(),
                      ),
                    );
                  },
                  child: SettingItemContainer(
                    title: "personal_info",
                    
                    iconPath: IconsAssets.userinformation,
                  ),
                ),

                // خيار الصوت والاهتزاز
                SettingItemContainer(
                  title: "sound_vibration",
                  iconPath: IconsAssets.sounds,
                  trailing: GestureDetector(
                    onTap: () {
                      setState(() {
                        soundEnabled = !soundEnabled;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 50.w, // عرض الزر
                      height: 26.h, // ارتفاع الزر
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        // تغيير اللون بناءً على الحالة (أزرق في التفعيل، رمادي في الإيقاف)
                        color: soundEnabled
                            ? const Color(0xFF1595C7)
                            : Colors.grey.shade400,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 200),
                        // تحريك الدائرة يمين أو يسار حسب الحالة
                        alignment: soundEnabled
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          width: 20.w,
                          height: 20.h,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white, // الدائرة البيضاء
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // الطبقة الثانية: القائمة المنبثقة للغات (تظهر فوق العناصر الأخرى)
            if (isLangMenuOpen)
              Positioned(
                top: 215.h, // مكان الظهور أسفل حقل اللغة مباشرة
                left: 40.w, // محاذاة لليسار كما في الصورة
                child: _buildLanguagePopup(),
              ),
          ],
        ),
      ),
    );
  }

  // ويدجت القائمة المنبثقة
  Widget _buildLanguagePopup() {
    return Container(
      width: 170.w, // عرض القائمة المنبثقة
      decoration: BoxDecoration(
        color: const Color(0xFFA349CD), // اللون البنفسجي المطبق في الصورة
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: BlocBuilder<LanguageCubit, Language>(
        builder: (context, currentLang) {
          return Column(
            // mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLangOptionItem("العربية", Language.arabic, currentLang),
              _buildDivider(),
              _buildLangOptionItem("English", Language.english, currentLang),
              _buildDivider(),
              _buildLangOptionItem(
                "الكردية الكرمانجية",
                Language.kurdish,
                currentLang,
              ),
            ],
          );
        },
      ),
    );
  }

  // خيار لغة واحد داخل القائمة
  Widget _buildLangOptionItem(
    String label,
    Language lang,
    Language currentLang,
  ) {
    bool isSelected = lang == currentLang;
    return InkWell(
      onTap: () {
        context.read<LanguageCubit>().setLanguage(lang);
        setState(() => isLangMenuOpen = false);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
        child: Text(
          label,
          textAlign: TextAlign.end,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // خط فاصل رفيع جداً
  Widget _buildDivider() {
    return Divider(
      color: Colors.white.withOpacity(0.4),
      thickness: 0.5.h,
      height: 0,
    );
  }
}
