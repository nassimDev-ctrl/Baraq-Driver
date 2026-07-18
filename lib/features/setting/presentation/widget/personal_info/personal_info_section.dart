import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/setting/presentation/widget/personal_info/personal_info_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalInfoSectionCard extends StatelessWidget {
  const PersonalInfoSectionCard({
    super.key,
    required this.titleKey,
    required this.children,
  });

  final String titleKey;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(start: 4.w, bottom: 10.h),
          child: Text(
            AppTranslations.getText(context, titleKey),
            style: TextStyle(
              color: AuthUiConstants.mutedText,
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(PersonalInfoUiConstants.cardRadius.r),
            boxShadow: PersonalInfoUiConstants.cardShadow,
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class PersonalInfoFieldLabel extends StatelessWidget {
  const PersonalInfoFieldLabel({super.key, required this.labelKey});

  final String labelKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 6.h),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          AppTranslations.getText(context, labelKey),
          style: TextStyle(
            color: AuthUiConstants.textPrimary,
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class PersonalInfoSaveButton extends StatelessWidget {
  const PersonalInfoSaveButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.main1,
          disabledBackgroundColor: AppColors.main1.withValues(alpha: 0.7),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22.r,
                height: 22.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.white,
                ),
              )
            : Text(
                AppTranslations.getText(context, 'save_changes'),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }
}
