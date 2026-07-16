import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    this.labelKey = 'next',
  });

  final bool isLoading;
  final VoidCallback onPressed;
  final String labelKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AuthUiConstants.buttonHeight.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.button,
          disabledBackgroundColor: AppColors.button.withValues(alpha: 0.55),
          foregroundColor: Colors.white,
          elevation: 0,
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
                AppTranslations.getText(context, labelKey),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }
}

class AuthLoginFooter extends StatelessWidget {
  const AuthLoginFooter({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          Text(
            AppTranslations.getText(context, 'have_account'),
            style: TextStyle(
              fontSize: 13.sp,
              color: AuthUiConstants.mutedText,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              AppTranslations.getText(context, 'login'),
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.main1,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
