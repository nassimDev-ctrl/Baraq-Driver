
import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class RowSearch extends StatelessWidget {
  final VoidCallback? onTap;  

  const RowSearch({super.key, this.onTap});  

  @override
  Widget build(BuildContext context) {
   
    if (onTap == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: onTap, 
            child: CustomText(
              "select_on_map",
              type: AppTextType.titlelarge,
              color: AppColors.secondary2,
            ),
          ),
          SizedBox(width: AppSpacing.xs.w),
          SvgPicture.asset(
            IconsAssets.determinelocation,
            colorFilter: ColorFilter.mode(
              AppColors.main1,
              BlendMode.srcIn,
            ),
            height: 30.w,
            width: 30.w,
          ),
        ],
      ),
    );
  }
}