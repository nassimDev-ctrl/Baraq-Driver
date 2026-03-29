import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/widget/TripLocationPath.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CountainerJournyOngoing extends StatelessWidget {
  const CountainerJournyOngoing({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          // 1. نجعل الإطار موحد اللون والسماكة ليعمل الـ borderRadius
          border: Border.all(color: AppColors.main1.withOpacity(0.5), width: 1),
          // 2. نستخدم الظل لمحاكاة الخط السفلي السميك (بدون بلر وبإزاحة لأسفل)
          boxShadow: [
            BoxShadow(
              color: AppColors.main1, // نفس لون الخط السفلي الذي تريده
              offset: const Offset(
                0,
                3,
              ), // الإزاحة لأسفل فقط (قيمة الـ 3 هي سماكة الخط)
              blurRadius: 0, // نجعله 0 ليكون الخط حاداً وليس ضبابياً
            ),
            // ظل إضافي جمالي (اختياري)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 8),
              blurRadius: 10,
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
                    color: AppColors.secondary2,
                    "10:23 Am   اليوم",
                    type: AppTextType.bodySmall,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.h, top: 8.h),
              child: Image.asset(ImageAssets.mape),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     Padding(
            //       padding: EdgeInsets.symmetric(horizontal: 12.w),
            //       child: CustomText(
            //         color: AppColors.secondary1,
            //         "نوع السيارة",
            //         type: AppTextType.bodyMedium,
            //       ),
            //     ),
            //   ],
            // ),
            // TripLocationPath(
            //   startLocation: "مشروع شريتح شارع المكاتب",
            //   endLocation: " الزراعة ",
            //   dashHeight: 15,
            //   endIconColor: AppColors.main1,
            //   startIconColor: AppColors.blue,
            // ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomText(
                  color: AppColors.blue,
                  "12000 SYP",
                  type: AppTextType.bodyMedium,
                ),
                TripLocationPath(
                  startLocation: "مشروع شريتح شارع المكاتب",
                  endLocation: " الزراعة ",
                  dashHeight: 15,
                  endIconColor: AppColors.main1,
                  startIconColor: AppColors.blue,
                ),

                // CustomText(
                //   color: AppColors.secondary1,
                //   "دوار الزراعة ، Lattakia ,Syria",
                //   type: AppTextType.bodyMedium,
                // ),
                // SizedBox(width: 5),
                // SvgPicture.asset(
                //   IconsAssets.locationsearch,
                //   height: 15.h,
                //   width: 15.w,
                //   color: AppColors.secondary1,
                // ),
                // SizedBox(width: 50.w),
              ],
            ),
            SizedBox(height: AppSpacing.xs.h),
          ],
        ),
      ),
    );
  }
}
