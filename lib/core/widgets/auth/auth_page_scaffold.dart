import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_gradient_header.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shared auth page shell: gradient header + overlapping white card.
class AuthPageScaffold extends StatelessWidget {
  const AuthPageScaffold({
    super.key,
    required this.icon,
    required this.titleKey,
    required this.subtitleKey,
    required this.child,
    this.isLoading = false,
    this.headerHeight = 200,
  });

  final IconData icon;
  final String titleKey;
  final String subtitleKey;
  final Widget child;
  final bool isLoading;
  final double headerHeight;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(bottom: bottomInset + AppSpacing.lg.h),
            child: Column(
              children: [
                _AuthPageHeader(
                  icon: icon,
                  titleKey: titleKey,
                  subtitleKey: subtitleKey,
                  height: headerHeight,
                  onBack: () => Navigator.maybePop(context),
                ),
                Transform.translate(
                  offset: Offset(0, -AuthUiConstants.cardOverlap.h),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
                    child: Material(
                      elevation: 10,
                      shadowColor: Colors.black.withValues(alpha: 0.12),
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AuthUiConstants.cardTopRadius.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          AppSpacing.lg.w,
                          AppSpacing.xlg.h,
                          AppSpacing.lg.w,
                          AppSpacing.xlg.h,
                        ),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: isLoading ? 0.72 : 1,
                          child: IgnorePointer(
                            ignoring: isLoading,
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthPageHeader extends StatelessWidget {
  const _AuthPageHeader({
    required this.icon,
    required this.titleKey,
    required this.subtitleKey,
    required this.height,
    required this.onBack,
  });

  final IconData icon;
  final String titleKey;
  final String subtitleKey;
  final double height;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return AuthGradientHeader(
      height: height,
      mapOpacity: 0.12,
      overlayTopAlpha: 0.03,
      overlayBottomAlpha: 0.2,
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
                onTap: onBack,
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
            bottom: (AuthUiConstants.cardOverlap + 24).h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56.r,
                  height: 56.r,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Icon(icon, color: Colors.white, size: 28.sp),
                ),
                SizedBox(height: AppSpacing.sm.h),
                Text(
                  AppTranslations.getText(context, titleKey),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  AppTranslations.getText(context, subtitleKey),
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
