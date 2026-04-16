 
import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';


class TopColoumnDetailsTripEnd extends StatelessWidget {
  
  final String startAddress;
  final String destinationAddress;

  const TopColoumnDetailsTripEnd({
    super.key,
    required this.startAddress,
    required this.destinationAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 20.h),
                
                CustomText(
                  startAddress,
                  type: AppTextType.titleSmall,
                  color: AppColors.secondary2,
                  maxLines: 2, 
                ),
                SizedBox(height: 40.h),
              
                CustomText(
                  destinationAddress,
                  type: AppTextType.titleSmall,
                  color: AppColors.secondary2,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          SizedBox(width: 30.w),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                IconsAssets.caree,
                height: 50.h,
                fit: BoxFit.contain,
              ),
              Container(
                height: 40.h,
                width: 1.5.w,
                color: Colors.grey.withOpacity(0.5),
              ),
              SvgPicture.asset(
                IconsAssets.locationsearch,
                height: 35.h,
                color: AppColors.main1,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
