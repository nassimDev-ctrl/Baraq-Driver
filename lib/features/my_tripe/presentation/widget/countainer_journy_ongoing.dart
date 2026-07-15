import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/translate/app_translate.dart';

class CountainerJournyOngoing extends StatelessWidget {
  final String time;
  final String date;
  final String carName;
  final String totalPrice;
  final String startAddress;
  final double latitude;
  final double longitude;
  final double mapHeight;
  final String googleMapsApiKey;
  final int zoom;

  const CountainerJournyOngoing({
    super.key,
    required this.time,
    required this.date,
    required this.carName,
    required this.totalPrice,
    required this.startAddress,
    required this.latitude,
    required this.longitude,
    this.googleMapsApiKey = "AIzaSyC7HVNoQEjaMe07kLwpKAO7k_ZbDpZTpI4",
    this.mapHeight = 140,
    this.zoom = 15,
  });

  String _buildStaticMapUrl() {
    final marker = '$latitude,$longitude';
    return 'https://maps.googleapis.com/maps/api/staticmap'
        '?center=$marker'
        '&zoom=$zoom'
        '&size=900x450'
        '&scale=2'
        '&maptype=roadmap'
        '&markers=color:red%7C$marker'
        '&key=$googleMapsApiKey';
  }

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
              color: Colors.white.withValues(alpha: 0.2),
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
                    "$time   $date",
                    type: AppTextType.titleSmall,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.h, top: 8.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SizedBox(
                  height: mapHeight.h,
                  width: double.infinity,
                  child: Image.network(
                    _buildStaticMapUrl(),
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.white.withValues(alpha: 0.08),
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 22.w,
                          height: 22.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.white.withValues(alpha: 0.12),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.map_outlined,
                          color: AppColors.secondary1,
                          size: 34.sp,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: CustomText(
                    color: AppColors.secondary1,
                    carName,
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
                    "$totalPrice ${AppTranslations.getText(context, "currency_syp")}",
                    type: AppTextType.bodyMedium,
                  ),
                  Row(
                    children: [
                      CustomText(
                        color: AppColors.secondary1,
                        startAddress,
                        type: AppTextType.bodyMedium,
                        maxLines: 1,
                      ),
                      SizedBox(width: 5.w),
                      SvgPicture.asset(
                        IconAssets.locationsearch,
                        height: 15.h,
                        width: 15.w,
                        colorFilter: ColorFilter.mode(
                          AppColors.secondary1,
                          BlendMode.srcIn,
                        ),
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