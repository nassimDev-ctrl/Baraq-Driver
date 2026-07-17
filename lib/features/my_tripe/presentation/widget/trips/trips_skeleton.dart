import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/trips/trips_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripsSkeleton extends StatelessWidget {
  const TripsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            for (var i = 0; i < 3; i++) ...[
              if (i > 0) SizedBox(width: 10.w),
              Expanded(
                child: _Bone(
                  height: 96.h,
                  radius: TripsUiConstants.statsCardRadius,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: TripsUiConstants.sectionSpacing.h),
        _Bone(height: 56.h, radius: TripsUiConstants.tabRadius),
        SizedBox(height: TripsUiConstants.sectionSpacing.h),
        for (var i = 0; i < 3; i++) ...[
          _Bone(height: 150.h, radius: TripsUiConstants.cardRadius),
          SizedBox(height: 12.h),
        ],
      ],
    );
  }
}

class _Bone extends StatelessWidget {
  const _Bone({
    required this.height,
    required this.radius,
  });

  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: AuthUiConstants.fieldFill,
        borderRadius: BorderRadius.circular(radius.r),
      ),
    );
  }
}
