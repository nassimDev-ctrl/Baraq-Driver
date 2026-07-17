import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/api_constants.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/profile/profile_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleInformationCard extends StatelessWidget {
  const VehicleInformationCard({
    super.key,
    required this.carName,
    required this.carColor,
    required this.carNumber,
    this.carYear,
    this.carImage,
  });

  final String carName;
  final String carColor;
  final String carNumber;
  final int? carYear;
  final String? carImage;

  @override
  Widget build(BuildContext context) {
    final imageUrl = ApiConstants.resolveMediaUrl(carImage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(start: 4.w, bottom: 10.h),
          child: Text(
            AppTranslations.getText(context, 'vehicle_info'),
            style: TextStyle(
              color: AuthUiConstants.mutedText,
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ProfileUiConstants.cardRadius.r),
            boxShadow: ProfileUiConstants.cardShadow,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: Container(
                      width: 64.r,
                      height: 64.r,
                      color: AppColors.main1.withValues(alpha: 0.08),
                      child: imageUrl != null
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.directions_car_filled_rounded,
                                color: AppColors.main1,
                                size: 28.sp,
                              ),
                            )
                          : Image.asset(
                              ImageAssets.driverCar,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.directions_car_filled_rounded,
                                color: AppColors.main1,
                                size: 28.sp,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          carName.isEmpty ? '—' : carName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AuthUiConstants.textPrimary,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: [
                            if (carColor.isNotEmpty)
                              _InfoChip(
                                icon: Icons.palette_outlined,
                                label: carColor,
                                color: AppColors.main1,
                              ),
                            if (carYear != null && carYear! > 0)
                              _InfoChip(
                                icon: Icons.calendar_today_rounded,
                                label: '$carYear',
                                color: const Color(0xFF0EA5E9),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: AppColors.accentOrange.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppColors.accentOrange.withValues(alpha: 0.18),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.pin_outlined,
                        color: AppColors.accentOrange,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppTranslations.getText(context, 'car_number'),
                            style: TextStyle(
                              color: AuthUiConstants.mutedText,
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            carNumber.isEmpty ? '—' : carNumber,
                            style: TextStyle(
                              color: AuthUiConstants.textPrimary,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: color),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
