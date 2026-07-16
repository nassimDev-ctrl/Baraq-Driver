import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_gradient_header.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/presentation/widgets/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthGradientHeader(
      height: AuthUiConstants.headerHeight,
      mapOpacity: 0.14,
      overlayTopAlpha: 0.04,
      overlayBottomAlpha: 0.22,
      child: Stack(
        children: [
          PositionedDirectional(
            top: AppSpacing.md.h,
            start: AppSpacing.md.w,
            child: Material(
              color: Colors.white.withValues(alpha: 0.16),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginView()),
                    );
                  }
                },
                child: SizedBox(
                  width: 42.r,
                  height: 42.r,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.xlg.w,
            right: AppSpacing.xlg.w,
            bottom: (AuthUiConstants.cardOverlap + 28).h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppTranslations.getText(context, 'register_title'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  AppTranslations.getText(context, 'register_subtitle'),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
