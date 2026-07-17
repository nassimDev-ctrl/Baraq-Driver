import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/profile/profile_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileStatisticsSection extends StatelessWidget {
  const ProfileStatisticsSection({
    super.key,
    required this.tripsCount,
    required this.rating,
    required this.distanceKm,
  });

  final int tripsCount;
  final num rating;
  final num distanceKm;

  String _formatDistance(BuildContext context) {
    final value = distanceKm.toDouble();
    final text = value >= 1000
        ? value.toStringAsFixed(0).replaceAllMapped(
              RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
              (m) => '${m[1]},',
            )
        : value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatItem(
        icon: Icons.directions_car_filled_rounded,
        color: AppColors.main1,
        value: '$tripsCount',
        unit: '',
        labelKey: 'trips_count',
      ),
      _StatItem(
        icon: Icons.star_rounded,
        color: const Color(0xFFF59E0B),
        value: rating.toStringAsFixed(1),
        unit: '',
        labelKey: 'rating',
      ),
      _StatItem(
        icon: Icons.route_rounded,
        color: const Color(0xFF0EA5E9),
        value: _formatDistance(context),
        unit: AppTranslations.getText(context, 'km'),
        labelKey: 'distances',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(start: 4.w, bottom: 10.h),
          child: Text(
            AppTranslations.getText(context, 'statistics'),
            style: TextStyle(
              color: AuthUiConstants.mutedText,
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Row(
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) SizedBox(width: 10.w),
              Expanded(child: _StatTile(item: items[i])),
            ],
          ],
        ),
      ],
    );
  }
}

class _StatItem {
  const _StatItem({
    required this.icon,
    required this.color,
    required this.value,
    required this.unit,
    required this.labelKey,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String unit;
  final String labelKey;
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.item});

  final _StatItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: ProfileUiConstants.cardShadow,
      ),
      child: Column(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(item.icon, color: item.color, size: 20.sp),
          ),
          SizedBox(height: 10.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.value,
                  style: TextStyle(
                    color: AuthUiConstants.textPrimary,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                if (item.unit.isNotEmpty) ...[
                  SizedBox(width: 3.w),
                  Text(
                    item.unit,
                    style: TextStyle(
                      color: AuthUiConstants.mutedText,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            AppTranslations.getText(context, item.labelKey),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AuthUiConstants.mutedText,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
