import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
 

class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: AppSpacing.lg.h),
        Image.asset(
          ImageAssets.logo_warr,
          height: 110.h,
          // width: 130.w,
          fit: BoxFit.contain,
        ),

        SizedBox(height: AppSpacing.lg.h),

        // نص ترحيبي أو Widget إضافي كمثال
      ],
    );
  }
}
