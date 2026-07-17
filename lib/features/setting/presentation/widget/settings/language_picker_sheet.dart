import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/translate/language_cubit.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/setting/presentation/widget/settings/settings_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showLanguagePickerSheet({
  required BuildContext context,
  required Language currentLanguage,
  required ValueChanged<Language> onSelected,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          boxShadow: SettingsUiConstants.softShadow,
        ),
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 24.h),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                AppTranslations.getText(context, 'language'),
                style: TextStyle(
                  color: AuthUiConstants.textPrimary,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 16.h),
              _LangOption(
                label: 'العربية',
                selected: currentLanguage == Language.arabic,
                onTap: () {
                  Navigator.pop(context);
                  onSelected(Language.arabic);
                },
              ),
              SizedBox(height: 8.h),
              _LangOption(
                label: 'English',
                selected: currentLanguage == Language.english,
                onTap: () {
                  Navigator.pop(context);
                  onSelected(Language.english);
                },
              ),
              SizedBox(height: 8.h),
              _LangOption(
                label: 'الكردية الكرمانجية',
                selected: currentLanguage == Language.kurdish,
                onTap: () {
                  Navigator.pop(context);
                  onSelected(Language.kurdish);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _LangOption extends StatelessWidget {
  const _LangOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.main1.withValues(alpha: 0.1)
          : const Color(0xFFF5F8FC),
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: selected
                        ? AppColors.main1
                        : AuthUiConstants.textPrimary,
                    fontSize: 15.sp,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ),
              if (selected)
                Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.main1,
                  size: 22.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
