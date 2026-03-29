import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/widget/header_order.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/view/end_tripe.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/widget/TripLocationPath.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class LiveTripScreen extends StatefulWidget {
  const LiveTripScreen({super.key});

  @override
  State<LiveTripScreen> createState() => _LiveTripScreenState();
}

class _LiveTripScreenState extends State<LiveTripScreen> {
  String tripStatus = "بدأت الرحلة";

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F1F1),
        body: Stack(
          children: [
            // 1. الخريطة (الخلفية)
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              height: double.infinity,
            ),

            // 2. الهيدر العلوي
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.r),
                    bottomRight: Radius.circular(8.r),
                  ),
                  color: AppColors.secondary1,
                ),
                padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
                child: HeaderOrder(con: false, onMenuTap: () {}),
              ),
            ),

            _buildMapOverlays(),

            // 4. البطاقة السفلية (ملتصقة بالأسفل تماماً)
            _buildTripDetailsCard(),

            // 5. زر "بدأت الرحلة" (فوق البطاقة)
            Positioned(
              bottom: 255.h, // تم تعديله ليتناسب مع البطاقة الملتصقة
              left: 20.w,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EndTripe()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9C4DB9),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: CustomText(
                    tripStatus,
                    color: Colors.white,
                    type: AppTextType.titleSmall,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripDetailsCard() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 220,
        width: double.infinity, // لجعلها تأخذ كامل العرض
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          // جعل الزوايا دائرية من الأعلى فقط لتلتصق بالأسفل
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
           
            Align(
              alignment: Alignment.topLeft,
              child: SvgPicture.asset(
                IconsAssets.close,
                height: 15.h,
                color: AppColors.secondary2,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText("عبد الله محمد", type: AppTextType.titleSmall),
                    CustomText(
                      "0966621475",
                      type: AppTextType.titleSmall,
                      color: Colors.black54,
                    ),
                  ],
                ),
                const Spacer(),
                _buildRoundIconButton(
                  IconsAssets.phonee,
                  Colors.white,
                  const Color(0xFF68B11E),
                ),
                SizedBox(width: 10.w),
                _buildRoundIconButton(
                  IconsAssets.masseage,
                  Colors.white,
                  const Color(0xFF9C4DB9),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TripLocationPath(
                  startLocation: "مشروع شريتح شارع المكاتب",
                  endLocation: " الزراعة ",
                  dashHeight: 30,
                  endIconColor: AppColors.main1,
                  startIconColor: AppColors.secondary2,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "25000 SYP",
                      color: const Color(0xFF43B7E8),
                      type: AppTextType.titleSmall,
                    ),
                    SizedBox(height: 1.w),
                    CustomText(
                      "4 K.m",
                      type: AppTextType.titleSmall,
                      color: const Color(0xFF43B7E8),
                    ),
                  ],
                ),
              ],
            ),
            // SizedBox(height: 10.h), // مساحة إضافية للأسفل
          ],
        ),
      ),
    );
  }

  Widget _buildRoundIconButton(
    String iconPath,
    Color iconColor,
    Color bgColor,
  ) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: SvgPicture.asset(iconPath, color: iconColor, width: 18.sp),
    );
  }

  Widget _buildMapOverlays() {
    return Stack(
      children: [
        Positioned(
          bottom: 240.h,
          right: 30.w,
          child: Image.asset(ImageAssets.emergency, width: 50.sp),
        ),
      ],
    );
  }
}
