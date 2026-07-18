import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/translate/language_cubit.dart';
import 'package:drever_warr/core/widgets/app_snack_bar.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_update_language/cubit.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_update_language/cubit_state.dart';
import 'package:drever_warr/features/setting/presentation/view/user_information.dart';
import 'package:drever_warr/features/setting/presentation/widget/settings/language_picker_sheet.dart';
import 'package:drever_warr/features/setting/presentation/widget/settings/settings_header.dart';
import 'package:drever_warr/features/setting/presentation/widget/settings/settings_item_tile.dart';
import 'package:drever_warr/features/setting/presentation/widget/settings/settings_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool soundEnabled = true;

  String _langCode(Language lang) {
    switch (lang) {
      case Language.arabic:
        return 'ar';
      case Language.english:
        return 'en';
    }
  }

  String _langLabel(Language lang) {
    switch (lang) {
      case Language.arabic:
        return 'العربية';
      case Language.english:
        return 'English';
    }
  }

  Future<void> _changeLanguage(Language lang) async {
    final code = _langCode(lang);
    await context.read<UpdateLanguageCubit>().changeLanguage(code);
    if (!mounted) return;
    context.read<LanguageCubit>().setLanguage(lang);
  }

  Future<void> _openLanguagePicker() async {
    final current = context.read<LanguageCubit>().state;
    await showLanguagePickerSheet(
      context: context,
      currentLanguage: current,
      onSelected: _changeLanguage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateLanguageCubit, UpdateLanguageState>(
      listener: (context, state) {
        if (state is UpdateLanguageSuccess) {
          AppSnackBar.success(context, state.message);
        } else if (state is UpdateLanguageFailure) {
          AppSnackBar.error(context, state.errMessage);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FB),
        body: Column(
          children: [
            const SettingsHeader(),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  SettingsUiConstants.horizontalPadding.w,
                  16.h,
                  SettingsUiConstants.horizontalPadding.w,
                  28.h,
                ),
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 380),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, (1 - value) * 14),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        SettingsSectionCard(
                          children: [
                            BlocBuilder<LanguageCubit, Language>(
                              builder: (context, currentLang) {
                                return SettingsItemTile(
                                  titleKey: 'language',
                                  icon: Icons.language_rounded,
                                  iconColor: AppColors.main1,
                                  subtitle: _langLabel(currentLang),
                                  onTap: _openLanguagePicker,
                                  trailing: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: AuthUiConstants.iconMuted,
                                    size: 24.sp,
                                  ),
                                );
                              },
                            ),
                            SettingsItemTile(
                              titleKey: 'personal_info',
                              icon: Icons.person_outline_rounded,
                              iconColor: const Color(0xFF0EA5E9),
                              showDivider: false,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const UserInformation(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SettingsUiConstants.sectionSpacing.h,
                        ),
                        SettingsSectionCard(
                          titleKey: 'menu_section_more',
                          children: [
                            SettingsItemTile(
                              titleKey: 'sound_vibration',
                              icon: Icons.notifications_active_outlined,
                              iconColor: AppColors.accentOrange,
                              showDivider: false,
                              trailing: SettingsToggle(
                                value: soundEnabled,
                                onChanged: (value) {
                                  setState(() => soundEnabled = value);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          AppTranslations.getText(context, 'settings'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AuthUiConstants.mutedText,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
