import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OpinionsAboutDrive extends StatelessWidget {
  const OpinionsAboutDrive({super.key});

  @override
  Widget build(BuildContext context) {
    double userRating = 4.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        
        border: Border.all(color: AppColors.main1.withOpacity(0.5), width: 1),
        
        boxShadow: [
          BoxShadow(
            color: AppColors.main1, 
            offset: const Offset(
              0,
              3,
            ),  
            blurRadius: 0,  
          ),
           
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 8),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                color: AppColors.secondary2,
                "تجربة ممتازة والسائق وصل في ",
                type: AppTextType.titleSmall,
              ),
              CustomText(
                "الوقت المحدد.",
                type: AppTextType.titleSmall,
                color: AppColors.secondary2,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(ImageAssets.imageprofail, height: 60.h, width: 60.w),
              SizedBox(height: 8.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return SvgPicture.asset(
                    index < userRating
                        ? IconsAssets.staroption
                        : IconsAssets.stareoptionborder,
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
