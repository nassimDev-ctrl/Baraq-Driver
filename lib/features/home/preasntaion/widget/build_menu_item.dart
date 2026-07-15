import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BuildMenuItem extends StatelessWidget {
  const BuildMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.isDestructive = false,
  });

  final String title;
  final String icon;
  final VoidCallback? onTap;
  final bool isDestructive;

  static bool isRtlLocale(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode;
    return code == 'ar' || code == 'ku';
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = isRtlLocale(context);
    final textColor = isDestructive
        ? const Color(0xFFFFCDD2)
        : AppColors.secondary1;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          splashColor: Colors.white.withValues(alpha: 0.12),
          highlightColor: Colors.white.withValues(alpha: 0.06),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
            child: Row(
              textDirection:
                  isRtl ? TextDirection.rtl : TextDirection.ltr,
              children: [
                SizedBox(
                  width: 22.w,
                  height: 22.w,
                  child: SvgPicture.asset(
                    icon,
                    colorFilter: ColorFilter.mode(
                      textColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomText(
                    title,
                    color: textColor,
                    type: AppTextType.titleSmall,
                    textAlign: isRtl ? TextAlign.right : TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
