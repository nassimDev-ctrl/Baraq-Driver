import 'dart:ui';

import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/location_pick_theme.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/scale_tap_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationHeader extends StatelessWidget {
  const LocationHeader({
    super.key,
    required this.onBack,
    required this.onGpsTap,
    this.isLoading = false,
  });

  final VoidCallback onBack;
  final VoidCallback onGpsTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: LocationPickTheme.radius28,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            borderRadius: LocationPickTheme.radius28,
            border: Border.all(color: Colors.white.withValues(alpha: 0.65)),
            boxShadow: LocationPickTheme.cardShadow,
          ),
          child: Row(
            children: [
              ScaleTapButton(
                onTap: onBack,
                child: _CircleIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  iconColor: LocationPickTheme.textPrimary,
                  backgroundColor: const Color(0xFFF3F5F9),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppTranslations.getText(
                        context,
                        'departure_location_title',
                      ),
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: LocationPickTheme.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      AppTranslations.getText(
                        context,
                        'departure_location_subtitle',
                      ),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: LocationPickTheme.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              ScaleTapButton(
                onTap: isLoading ? null : onGpsTap,
                enabled: !isLoading,
                child: _CircleIconButton(
                  icon: Icons.gps_fixed_rounded,
                  iconColor: AppColors.main1,
                  backgroundColor: AppColors.main1.withValues(alpha: 0.12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42.r,
      height: 42.r,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: iconColor, size: 20.sp),
    );
  }
}
