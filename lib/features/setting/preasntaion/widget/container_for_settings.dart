import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/transleat/app_translat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SettingItemContainer extends StatelessWidget {
  final String title;
  final String iconPath;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingItemContainer({
    super.key,
    required this.title,
    required this.iconPath,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.secondary1,
          borderRadius: BorderRadius.circular(15.r),
          border: const Border(bottom: BorderSide(color: Colors.white)),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           
            trailing ??
                Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.secondary1,
                  size: 18.sp,
                ),

          
            Row(
              children: [
                Text(
                  AppTranslations.getText(context, title),
                  style: TextStyle(
                    color: AppColors.secondary2,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 12.w),
                SvgPicture.asset(
                  iconPath,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: ColorFilter.mode(
                    AppColors.secondary2,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
