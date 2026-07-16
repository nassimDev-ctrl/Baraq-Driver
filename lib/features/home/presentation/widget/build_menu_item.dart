import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BuildMenuItem extends StatelessWidget {
  const BuildMenuItem({
    super.key,
    required this.title,
    this.icon,
    this.iconData,
    this.onTap,
    this.isDestructive = false,
    this.accentColor,
  }) : assert(icon != null || iconData != null);

  final String title;
  final String? icon;
  final IconData? iconData;
  final VoidCallback? onTap;
  final bool isDestructive;
  final Color? accentColor;

  static bool isRtlLocale(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode;
    return code == 'ar' || code == 'ku';
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = isRtlLocale(context);
    final color = isDestructive
        ? const Color(0xFFDC2626)
        : (accentColor ?? AppColors.main1);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 3.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          splashColor: color.withValues(alpha: 0.08),
          highlightColor: color.withValues(alpha: 0.04),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
            decoration: BoxDecoration(
              color: isDestructive
                  ? const Color(0xFFFFF1F1)
                  : AuthUiConstants.fieldFill,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: isDestructive
                    ? const Color(0xFFFECACA)
                    : AuthUiConstants.fieldBorder,
              ),
            ),
            child: Row(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              children: [
                Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  child: Center(
                    child: iconData != null
                        ? Icon(iconData, color: color, size: 18.sp)
                        : SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: SvgPicture.asset(
                              icon!,
                              colorFilter: ColorFilter.mode(
                                color,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    AppTranslations.getText(context, title),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: isRtl ? TextAlign.right : TextAlign.left,
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w700,
                      color: isDestructive
                          ? const Color(0xFF7F1D1D)
                          : AuthUiConstants.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  isRtl
                      ? Icons.chevron_left_rounded
                      : Icons.chevron_right_rounded,
                  size: 20.sp,
                  color: isDestructive
                      ? const Color(0xFFFCA5A5)
                      : AuthUiConstants.iconMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerSectionTitle extends StatelessWidget {
  const DrawerSectionTitle(this.titleKey, {super.key});

  final String titleKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 6.h),
      child: Text(
        AppTranslations.getText(context, titleKey),
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
          color: AuthUiConstants.mutedText,
        ),
      ),
    );
  }
}
