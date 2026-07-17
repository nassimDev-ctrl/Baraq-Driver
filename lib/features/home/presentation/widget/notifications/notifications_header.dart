import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/features/home/presentation/widget/notifications/notifications_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsHeader extends StatelessWidget {
  const NotificationsHeader({
    super.key,
    this.count = 0,
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: NotificationsUiConstants.headerHeight.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Soft modern gradient base
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A6FD4),
                  Color(0xFF0C4588),
                  Color(0xFF072F6D),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28.r),
                bottomRight: Radius.circular(28.r),
              ),
            ),
          ),

          // Decorative soft orbs
          Positioned(
            top: -36.h,
            right: -20.w,
            child: _SoftOrb(size: 140.r, alpha: 0.12),
          ),
          Positioned(
            bottom: 8.h,
            left: -28.w,
            child: _SoftOrb(size: 90.r, alpha: 0.10),
          ),
          Positioned(
            top: 48.h,
            left: 72.w,
            child: _SoftOrb(size: 36.r, alpha: 0.14),
          ),

          // Large faded bell watermark
          PositionedDirectional(
            end: -8.w,
            bottom: -6.h,
            child: Icon(
              Icons.notifications_rounded,
              size: 118.sp,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),

          // Content
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md.w,
                AppSpacing.xs.h,
                AppSpacing.md.w,
                18.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Compact top bar
                  Row(
                    children: [
                      _HeaderCircleButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.maybePop(context),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 7.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.18),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.notifications_active_rounded,
                              size: 14.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              '$count',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Large modern title
                  Text(
                    AppTranslations.getText(context, 'notifications'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                      letterSpacing: -0.4,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5CE1A8),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF5CE1A8)
                                  .withValues(alpha: 0.45),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          count == 0
                              ? AppTranslations.getText(
                                  context,
                                  'no_notifications',
                                )
                              : AppTranslations.getText(
                                  context,
                                  'notifications_count',
                                ).replaceAll('{n}', '$count'),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.88),
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
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

class _HeaderCircleButton extends StatelessWidget {
  const _HeaderCircleButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.16),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 42.r,
          height: 42.r,
          child: Icon(icon, color: Colors.white, size: 18.sp),
        ),
      ),
    );
  }
}

class _SoftOrb extends StatelessWidget {
  const _SoftOrb({required this.size, required this.alpha});

  final double size;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: alpha),
      ),
    );
  }
}
