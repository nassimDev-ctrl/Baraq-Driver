import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/location_pick_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationMapMarker extends StatelessWidget {
  const LocationMapMarker({
    super.key,
    required this.bounceAnimation,
    this.bottomOffset = 0,
    this.accuracyMeters,
  });

  final Animation<double> bounceAnimation;
  final double bottomOffset;
  final double? accuracyMeters;

  @override
  Widget build(BuildContext context) {
    final circleSize = (accuracyMeters ?? 8) * 10.0;
    final clampedSize = circleSize.clamp(110.0, 180.0);

    return IgnorePointer(
      child: RepaintBoundary(
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomOffset),
          child: AnimatedBuilder(
            animation: bounceAnimation,
            builder: (context, child) {
              final bounce = Curves.easeOut.transform(bounceAnimation.value);
              final lift = (1 - bounce) * 14.h;

              return Transform.translate(
                offset: Offset(0, -lift),
                child: child,
              );
            },
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: clampedSize.w,
                  height: clampedSize.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: LocationPickTheme.gpsBlue.withValues(alpha: 0.14),
                    border: Border.all(
                      color: LocationPickTheme.gpsBlue.withValues(alpha: 0.22),
                      width: 1.5,
                    ),
                  ),
                ),
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: LocationPickTheme.gpsBlue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: LocationPickTheme.gpsBlue.withValues(alpha: 0.35),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: clampedSize.w * 0.34,
                  child: _MapPin(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: -4.h,
          child: Container(
            width: 22.w,
            height: 7.h,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
        Icon(
          Icons.location_on_rounded,
          size: 54.sp,
          color: AppColors.main1,
          shadows: [
            Shadow(
              color: AppColors.main1.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        Positioned(
          top: 11.h,
          child: Container(
            width: 11.w,
            height: 11.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
