 
import 'package:drever_warr/core/constant/api_constants.dart';
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ColumnImageNamePhoneProfaildriver extends StatelessWidget {
  final String? imagePath;
  final String fullName;
  final String phone;

  const ColumnImageNamePhoneProfaildriver({
    super.key,
    this.imagePath,
    required this.fullName,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = ApiConstants.resolveMediaUrl(imagePath);

    return Column(
      children: [
       
        ClipOval(
          child: resolvedUrl != null
              ? Image.network(
                  resolvedUrl,
                  height: 121.h,
                  width: 121.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset(ImageAssets.imageprofail, height: 121.h, width: 121.w),
                )
              : Image.asset(ImageAssets.imageprofail, height: 121.h, width: 121.w),
        ),
        SizedBox(height: AppSpacing.md.h),
        CustomText(
          fullName,
          type: AppTextType.titleSmall,
          color: AppColors.secondary2,
        ),
        SizedBox(height: AppSpacing.sm.h),
        CustomText(
          phone,
          type: AppTextType.titleSmall,
          color: AppColors.secondary2,
        ),
      ],
    );
  }
}