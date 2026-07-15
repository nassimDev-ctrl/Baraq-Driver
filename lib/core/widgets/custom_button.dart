import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.title, required this.onTap});
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 45.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xs.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.button,
          ),
          child: Center(
            child: CustomText(
              title,
              type: AppTextType.titleMedium,
              color: TextColors.textInverse,
            ),
          ),
        ),
      ),
    );
  }
}
