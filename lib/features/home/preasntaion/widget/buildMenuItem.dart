import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BuildMenuItem extends StatelessWidget {
  const BuildMenuItem({super.key, required this.icon, required this.title});
  final String title;
  final String icon;
  @override
  Widget build(BuildContext context) {
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
      child: isArabic
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomText(
                  color: AppColors.secondary1,
                  title,
                  type: AppTextType.titleSmall,  
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(icon), 
                ),
              ],
            )
          : Row(
            
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(icon),  
                ),
                SizedBox(width: 20.w),
                CustomText(
                  color: AppColors.secondary1,
                  title,
                  type: AppTextType.titleSmall,  
                ),
              ],
            ),
    );
    ;
  }
}
