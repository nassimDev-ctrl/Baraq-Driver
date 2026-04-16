 
import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/model/model_finsh_trips.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CountainerJournyOngoing extends StatelessWidget {
  final FinishedTripModel trip; 
  const CountainerJournyOngoing({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.main1,
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
        child: Column(
          children: [
            SizedBox(height: AppSpacing.xs.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: CustomText(
                    color: AppColors.secondary1,
                    "${trip.time}   ${trip.date}", 
                    type: AppTextType.titleSmall,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.h, top: 8.h),
              child: Image.asset(ImageAssets.mape),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: CustomText(
                    color: AppColors.secondary1,
                    trip.carName,  
                    type: AppTextType.bodyMedium,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    color: AppColors.secondary1,
                    "${trip.totalPrice} ",  
                    type: AppTextType.bodyMedium,
                  ),
                 
                  Row(
                    children: [
                      CustomText(
                        color: AppColors.secondary1,
                        trip.startAddress, 
                        type: AppTextType.bodyMedium,
                        maxLines: 1,
                      ),
                      SizedBox(width: 5.w),
                      SvgPicture.asset(
                        IconsAssets.locationsearch,
                        height: 15.h,
                        width: 15.w,
                        color: AppColors.secondary1,
                      ),
                    ],
                  ),
                   
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xs.h),
          ],
        ),
      ),
    );
  }
}
