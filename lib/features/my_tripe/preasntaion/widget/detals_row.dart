import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class details_row extends StatelessWidget {
  const details_row({super.key, required this.t1, required this.t2});
  final String t1;
  final String t2;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          CustomText(
            t1,
            type: AppTextType.titleSmall,
            color: AppColors.secondary2,
          ),
          CustomText(
            t2,
            type: AppTextType.titleSmall,
            color: AppColors.secondary2,
          ),
        ],
      ),
    );
  }
}
