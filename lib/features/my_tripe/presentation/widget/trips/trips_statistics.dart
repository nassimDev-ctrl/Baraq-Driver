import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/trips/trips_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripsStatistics extends StatelessWidget {
  const TripsStatistics({
    super.key,
    required this.totalTrips,
    required this.tripsToday,
    required this.totalEarnings,
  });

  final int totalTrips;
  final int tripsToday;
  final num totalEarnings;

  String _formatAmount(num value) {
    final text = value.toStringAsFixed(value % 1 == 0 ? 0 : 2);
    final parts = text.split('.');
    final chars = parts[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    if (parts.length == 1) return chars;
    return '$chars.${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    final currency = AppTranslations.getText(context, 'currency_syp');
    final items = [
      _StatItem(
        icon: Icons.schedule_rounded,
        color: AppColors.accentOrange,
        value: '$totalTrips',
        labelKey: 'total_trips',
        subtitleKey: 'all_time',
      ),
      _StatItem(
        icon: Icons.directions_car_filled_rounded,
        color: AppColors.main1,
        value: '$tripsToday',
        labelKey: 'trips_today',
        subtitleKey: 'trip_unit',
      ),
      _StatItem(
        icon: Icons.account_balance_wallet_outlined,
        color: AppColors.button,
        value: _formatAmount(totalEarnings),
        labelKey: 'total_earnings',
        subtitle: currency,
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) SizedBox(width: 10.w),
          Expanded(child: _StatCard(item: items[i])),
        ],
      ],
    );
  }
}

class _StatItem {
  const _StatItem({
    required this.icon,
    required this.color,
    required this.value,
    required this.labelKey,
    this.subtitleKey,
    this.subtitle,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String labelKey;
  final String? subtitleKey;
  final String? subtitle;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.item});

  final _StatItem item;

  @override
  Widget build(BuildContext context) {
    final subtitle = item.subtitle ??
        AppTranslations.getText(context, item.subtitleKey ?? 'trip_unit');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TripsUiConstants.statsCardRadius.r),
        boxShadow: TripsUiConstants.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34.r,
            height: 34.r,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(item.icon, color: item.color, size: 18.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            item.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: item.color,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            AppTranslations.getText(context, item.labelKey),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AuthUiConstants.textPrimary,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AuthUiConstants.mutedText,
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
