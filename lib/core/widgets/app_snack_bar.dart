import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AppSnackBarType { error, success, info }

/// Unified floating snackbars used across the driver app.
abstract final class AppSnackBar {
  static void error(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(context, message, type: AppSnackBarType.error, duration: duration);
  }

  static void success(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(context, message, type: AppSnackBarType.success, duration: duration);
  }

  static void info(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(context, message, type: AppSnackBarType.info, duration: duration);
  }

  static void show(
    BuildContext context,
    String message, {
    AppSnackBarType type = AppSnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
          padding: EdgeInsets.zero,
          content: _AppSnackBarBody(message: message, type: type),
        ),
      );
  }
}

class _AppSnackBarBody extends StatelessWidget {
  const _AppSnackBarBody({
    required this.message,
    required this.type,
  });

  final String message;
  final AppSnackBarType type;

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(type);

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: style.background,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: style.border),
          boxShadow: [
            BoxShadow(
              color: style.shadow.withValues(alpha: 0.18),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: style.iconBackground,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(style.icon, color: style.accent, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: style.text,
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            InkWell(
              onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              borderRadius: BorderRadius.circular(8.r),
              child: Padding(
                padding: EdgeInsets.all(4.r),
                child: Icon(
                  Icons.close_rounded,
                  size: 18.sp,
                  color: style.text.withValues(alpha: 0.55),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static _SnackStyle _styleFor(AppSnackBarType type) {
    switch (type) {
      case AppSnackBarType.error:
        return const _SnackStyle(
          background: Color(0xFFFFF1F1),
          border: Color(0xFFFECACA),
          accent: Color(0xFFDC2626),
          iconBackground: Color(0xFFFEE2E2),
          text: Color(0xFF7F1D1D),
          shadow: Color(0xFFDC2626),
          icon: Icons.error_outline_rounded,
        );
      case AppSnackBarType.success:
        return _SnackStyle(
          background: const Color(0xFFF0FDF4),
          border: const Color(0xFFBBF7D0),
          accent: AppColors.button,
          iconBackground: const Color(0xFFDCFCE7),
          text: const Color(0xFF14532D),
          shadow: AppColors.button,
          icon: Icons.check_circle_outline_rounded,
        );
      case AppSnackBarType.info:
        return _SnackStyle(
          background: const Color(0xFFEFF6FF),
          border: const Color(0xFFBFDBFE),
          accent: AppColors.main1,
          iconBackground: const Color(0xFFDBEAFE),
          text: const Color(0xFF1E3A5F),
          shadow: AppColors.main1,
          icon: Icons.info_outline_rounded,
        );
    }
  }
}

class _SnackStyle {
  const _SnackStyle({
    required this.background,
    required this.border,
    required this.accent,
    required this.iconBackground,
    required this.text,
    required this.shadow,
    required this.icon,
  });

  final Color background;
  final Color border;
  final Color accent;
  final Color iconBackground;
  final Color text;
  final Color shadow;
  final IconData icon;
}
