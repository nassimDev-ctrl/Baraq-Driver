import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/home/presentation/widget/complaints/complaints_painters.dart';
import 'package:drever_warr/features/home/presentation/widget/complaints/complaints_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComplaintsHeader extends StatelessWidget {
  const ComplaintsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: ComplaintsUiConstants.headerHeight.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AuthUiConstants.headerGradient,
              ),
            ),
          ),

          // Soft glow
          Positioned(
            top: -40.h,
            right: -30.w,
            child: Container(
              width: 160.r,
              height: 160.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: 20.h,
            left: 40.w,
            child: Container(
              width: 90.r,
              height: 90.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),

          // Skyline
          Positioned.fill(
            child: CustomPaint(
              painter: SkylinePainter(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),

          // Route line
          Positioned.fill(
            child: CustomPaint(
              painter: RouteLinePainter(
                color: AppColors.accentOrange.withValues(alpha: 0.85),
              ),
            ),
          ),

          // Location pin
          Positioned(
            right: 28.w,
            top: 78.h,
            child: Icon(
              Icons.location_on_rounded,
              color: AppColors.accentOrange,
              size: 36.sp,
              shadows: [
                Shadow(
                  color: AppColors.accentOrange.withValues(alpha: 0.45),
                  blurRadius: 12,
                ),
              ],
            ),
          ),

          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md.w,
                AppSpacing.xs.h,
                AppSpacing.md.w,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 2,
                    shadowColor: Colors.black26,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => Navigator.maybePop(context),
                      child: SizedBox(
                        width: 40.r,
                        height: 40.r,
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AuthUiConstants.textPrimary,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 220.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            AppTranslations.getText(
                              context,
                              'comments_and_complaints',
                            ),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            AppTranslations.getText(
                              context,
                              'complaints_header_subtitle',
                            ),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.88),
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
