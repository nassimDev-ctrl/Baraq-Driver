import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/widgets/custom_text.dart';
import 'package:drever_warr/features/my_oreder/presentation/widget/card_point_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
// تأكد من استيراد ملفاتك الخاصة هنا
// import 'package:drever_warr/core/widgets/custom_text.dart';
// import 'package:drever_warr/core/constant/app_colors.dart';

class TripLocationPath extends StatelessWidget {
  final String startLocation;
  final String endLocation;
  final Color? startIconColor;
  final Color? endIconColor;
  final double? dashHeight;

  const TripLocationPath({
    super.key,
    required this.startLocation,
    required this.endLocation,
    this.startIconColor = Colors.grey,
    this.endIconColor,  
    this.dashHeight,
  });

  @override
  Widget build(BuildContext context) {
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return isArabic
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    startLocation,
                    type: AppTextType.bodySmall,
                    maxLines: 1,
                  ),
                  SizedBox(height: dashHeight),
                  CustomText(
                    endLocation,
                    type: AppTextType.bodySmall,
                    maxLines: 1,
                  ),
                ],
              ),
              SizedBox(width: 8.w),
              Column(
                children: [
                  Icon(
                    Icons.radio_button_unchecked,
                    color: startIconColor,
                    size: 16.sp,
                  ),
                  CustomPaint(
                    size: Size(1, dashHeight ?? 30.h),
                    painter:
                        DashedLinePainter(), 
                  ),
                  SvgPicture.asset(
                    IconAssets.locationsearch,
                    colorFilter: ColorFilter.mode(
                      endIconColor ?? AppColors.main1,
                      BlendMode.srcIn,
                    ),
                    height: 20,
                  ),
                  
                ],
              ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    startLocation,
                    type: AppTextType.bodySmall,
                    maxLines: 1,
                  ),
                  SizedBox(height: dashHeight),
                  CustomText(
                    endLocation,
                    type: AppTextType.bodySmall,
                    maxLines: 1,
                  ),
                ],
              ),
              SizedBox(width: 8.w),
              Column(
                children: [
                  Icon(
                    Icons.radio_button_unchecked,
                    color: startIconColor,
                    size: 16.sp,
                  ),
                  CustomPaint(
                    size: Size(1, dashHeight ?? 30.h),
                    painter:
                        DashedLinePainter(), 
                  ),
                  SvgPicture.asset(
                    IconAssets.locationsearch,
                    colorFilter: ColorFilter.mode(
                      endIconColor ?? AppColors.main1,
                      BlendMode.srcIn,
                    ),
                    height: 20,
                  ),
                  
                ],
              ),
            ],
          );
  }
}
