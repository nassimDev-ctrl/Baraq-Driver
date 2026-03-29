import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
 

class ColumnImageNamePhoneProfaildriver extends StatelessWidget {
  const ColumnImageNamePhoneProfaildriver({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(ImageAssets.imageprofail, height: 121.h, width: 121.w),
        SizedBox(height: AppSpacing.md.h),
        CustomText(
          "اسم السائق",
          type: AppTextType.titleSmall,
          color: AppColors.secondary1,
        ),
        SizedBox(height: AppSpacing.sm.h),
        CustomText(
          "+970 6666666666",
          type: AppTextType.titleSmall,
          color: AppColors.secondary1,
        ),
      ],
    );
  }
}
