import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_gradient_header.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthGradientHeader(
      height: AuthUiConstants.loginHeaderHeight,
      child: Positioned(
        left: AppSpacing.xlg.w,
        right: AppSpacing.xlg.w,
        bottom: (AuthUiConstants.cardOverlap + 20).h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 78.r,
                  height: 78.r,
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.22),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14.r),
                    child: Image.asset(
                      ImageAssets.logo,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.md.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppTranslations.getText(context, 'brand_name'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w900,
                          height: 1.05,
                          letterSpacing: 0.4,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        AppTranslations.getText(
                          context,
                          'driver_brand_name',
                        ),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.88),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md.h),
            Text(
              AppTranslations.getText(context, 'login'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              AppTranslations.getText(context, 'login_subtitle'),
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
    );
  }
}
