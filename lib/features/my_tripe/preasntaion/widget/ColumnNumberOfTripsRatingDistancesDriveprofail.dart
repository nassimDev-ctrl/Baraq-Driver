import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ColumnNumberOfTripsRatingDistancesDriveprofail extends StatelessWidget {
  const ColumnNumberOfTripsRatingDistancesDriveprofail({
    super.key,
    required this.image,
    required this.title1,
    required this.title2,
    required this.col,
  });
  final String image;
  final String title1;
  final Color col;

  final String title2;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(image, color: col),
        SizedBox(height: AppSpacing.xs.h),
        CustomText(title1, type: AppTextType.titleSmall, color: AppColors.blue),

        CustomText(
          title2,
          type: AppTextType.bodyMedium,
          color: AppColors.secondary2,
        ),
      ],
    );
  }
}
