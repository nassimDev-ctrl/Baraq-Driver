import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/location_pick_helpers.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/location_pick_theme.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/scale_tap_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurrentLocationSheet extends StatelessWidget {
  const CurrentLocationSheet({
    super.key,
    required this.address,
    required this.isResolvingAddress,
    required this.isDefaultAddress,
    required this.accuracyMeters,
    required this.isLoading,
    required this.onEditTap,
    required this.onConfirmTap,
  });

  final String address;
  final bool isResolvingAddress;
  final bool isDefaultAddress;
  final double? accuracyMeters;
  final bool isLoading;
  final VoidCallback onEditTap;
  final VoidCallback onConfirmTap;

  @override
  Widget build(BuildContext context) {
    final parts = parseAddressParts(address);
    final displayAddress = parts.fullAddress.isNotEmpty
        ? parts.fullAddress
        : AppTranslations.getText(context, 'detecting_location');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: LocationPickTheme.sheetTopRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 28,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCE1EA),
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46.r,
                    height: 46.r,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: LocationPickTheme.textSecondary,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppTranslations.getText(context, 'current_location'),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: LocationPickTheme.textPrimary,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        if (isResolvingAddress || isDefaultAddress)
                          SizedBox(
                            height: 18.h,
                            width: 18.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.main1,
                            ),
                          )
                        else ...[
                          if (parts.areaName.isNotEmpty)
                            Text(
                              parts.areaName,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: LocationPickTheme.textPrimary,
                                height: 1.35,
                              ),
                            ),
                          if (parts.cityName.isNotEmpty) ...[
                            SizedBox(height: 2.h),
                            Text(
                              parts.cityName,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: LocationPickTheme.textSecondary,
                                height: 1.35,
                              ),
                            ),
                          ],
                          if (parts.areaName.isEmpty && parts.cityName.isEmpty)
                            Text(
                              displayAddress,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: LocationPickTheme.textSecondary,
                                height: 1.35,
                              ),
                            ),
                        ],
                        SizedBox(height: 10.h),
                        _SignalQualityBadge(
                          label: signalQualityLabel(context, accuracyMeters),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  OutlinedButton.icon(
                    onPressed: onEditTap,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.main1,
                      side: BorderSide(
                        color: AppColors.main1.withValues(alpha: 0.45),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 8.h,
                      ),
                    ),
                    icon: Icon(Icons.edit_outlined, size: 16.sp),
                    label: Text(
                      AppTranslations.getText(context, 'edit_location'),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              ConfirmLocationButton(
                enabled: !isLoading,
                onTap: onConfirmTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignalQualityBadge extends StatelessWidget {
  const _SignalQualityBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: LocationPickTheme.signalGreenBg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.signal_cellular_alt_rounded,
            size: 14.sp,
            color: LocationPickTheme.signalGreen,
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: LocationPickTheme.signalGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmLocationButton extends StatelessWidget {
  const ConfirmLocationButton({
    super.key,
    required this.onTap,
    required this.enabled,
  });

  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ScaleTapButton(
      onTap: enabled ? onTap : null,
      enabled: enabled,
      child: Material(
        color: enabled ? AppColors.button : AppColors.button.withValues(alpha: 0.45),
        borderRadius: LocationPickTheme.radius20,
        child: Container(
          width: double.infinity,
          height: 60.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: LocationPickTheme.radius20,
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: AppColors.button.withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppTranslations.getText(context, 'confirm_location_depart'),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Icon(
                Icons.navigation_rounded,
                color: Colors.white,
                size: 22.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
