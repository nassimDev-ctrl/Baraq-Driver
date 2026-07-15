
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

import '../../data/cubit/cubit_update_language/cubit.dart';
import '../../data/cubit/cubit_update_language/cubit_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool soundEnabled = true;
  bool isLangMenuOpen = false;

  final LayerLink _languageMenuLink = LayerLink();

  String _langCode(Language lang) {
    switch (lang) {
      case Language.arabic:
        return 'ar';
      case Language.english:
        return 'en';
      case Language.kurdish:
        return 'ku';
    }
  }

  void _toggleLanguageMenu() {
    setState(() {
      isLangMenuOpen = !isLangMenuOpen;
    });
  }

  void _closeLanguageMenu() {
    if (!isLangMenuOpen) return;
    setState(() {
      isLangMenuOpen = false;
    });
  }

  Future<void> _changeLanguage(Language lang) async {
    final code = _langCode(lang);

    _closeLanguageMenu();
    await context.read<UpdateLanguageCubit>().changeLanguage(code);

    if (!mounted) return;
    context.read<LanguageCubit>().setLanguage(lang);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateLanguageCubit, UpdateLanguageState>(
      listener: (context, state) {
        if (state is UpdateLanguageSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is UpdateLanguageFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.main1,
        body: GestureDetector(
          onTap: _closeLanguageMenu,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  SizedBox(height: AppSpacing.x70.h),
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
                              AppTranslations.getText(context, 'title'),
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
                  SettingItemContainer(
                    onTap: _toggleLanguageMenu,
                    title: 'language',
                    iconPath: IconsAssets.language,
                    trailing: CompositedTransformTarget(
                      link: _languageMenuLink,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          isLangMenuOpen
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.black,
                          size: 28.sp,
                        ),
                      ),
                    ),
                  ),
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
                      title: 'personal_info',
                      iconPath: IconsAssets.userinformation,
                    ),
                  ),
                  SettingItemContainer(
                    title: 'sound_vibration',
                    iconPath: IconsAssets.sounds,
                    trailing: GestureDetector(
                      onTap: () {
                        setState(() {
                          soundEnabled = !soundEnabled;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 50.w,
                        height: 26.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: soundEnabled
                              ? const Color(0xFF1595C7)
                              : Colors.grey.shade400,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 200),
                          alignment: soundEnabled
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Container(
                            width: 20.w,
                            height: 20.h,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
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
              if (isLangMenuOpen)
                CompositedTransformFollower(
                  link: _languageMenuLink,
                  showWhenUnlinked: false,
                  targetAnchor: Alignment.bottomCenter,
                  followerAnchor: Alignment.topCenter,
                  offset: Offset(0, 8.h),
                  child: _buildLanguagePopup(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguagePopup() {
    return Container(
      width: 100.w,
      decoration: BoxDecoration(
        color: const Color(0xFFA349CD),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: BlocBuilder<LanguageCubit, Language>(
        builder: (context, currentLang) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLangOptionItem('العربية', Language.arabic, currentLang),
              _buildDivider(),
              _buildLangOptionItem('English', Language.english, currentLang),
              _buildDivider(),
              _buildLangOptionItem(
                'الكردية الكرمانجية',
                Language.kurdish,
                currentLang,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLangOptionItem(
      String label,
      Language lang,
      Language currentLang,
      ) {
    final bool isSelected = lang == currentLang;

    return InkWell(
      onTap: () => _changeLanguage(lang),
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

  Widget _buildDivider() {
    return Divider(
      color: Colors.white.withValues(alpha: 0.4),
      thickness: 0.5.h,
      height: 0,
    );
  }
}