import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/trips/trip_status_badge.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/trips/trips_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripCard extends StatelessWidget {
  const TripCard({
    super.key,
    required this.status,
    required this.pickup,
    required this.destination,
    required this.price,
    required this.onTap,
    this.time,
    this.date,
    this.distanceKm,
    this.durationMinutes,
    this.animationIndex = 0,
  });

  final String status;
  final String pickup;
  final String destination;
  final num price;
  final VoidCallback onTap;
  final String? time;
  final String? date;
  final num? distanceKm;
  final num? durationMinutes;
  final int animationIndex;

  String _formatPrice(BuildContext context) {
    final currency = AppTranslations.getText(context, 'currency_syp');
    final value = price.toStringAsFixed(price % 1 == 0 ? 0 : 2);
    final formatted = value.split('.').first.replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
    final fraction = value.contains('.') ? '.${value.split('.').last}' : '';
    return '$formatted$fraction $currency';
  }

  String _formatDistance(BuildContext context) {
    if (distanceKm == null) return '—';
    var km = distanceKm!.toDouble();
    // API field may be meters despite naming.
    if (km > 100) km = km / 1000;
    return '${km.toStringAsFixed(1)} ${AppTranslations.getText(context, 'km_unit')}';
  }

  String _formatDuration(BuildContext context) {
    if (durationMinutes == null) return '—';
    return '${durationMinutes!.toStringAsFixed(0)} ${AppTranslations.getText(context, 'min_unit')}';
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 280 + (animationIndex * 40).clamp(0, 240)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 14),
            child: child,
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(TripsUiConstants.cardRadius.r),
          child: Ink(
            padding: EdgeInsets.all(TripsUiConstants.cardPadding.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(TripsUiConstants.cardRadius.r),
              boxShadow: TripsUiConstants.softShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TripStatusBadge(status: status),
                    const Spacer(),
                    Text(
                      _formatPrice(context),
                      style: TextStyle(
                        color: AppColors.button,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                if ((time?.isNotEmpty ?? false) || (date?.isNotEmpty ?? false)) ...[
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14.sp,
                        color: AuthUiConstants.mutedText,
                      ),
                      SizedBox(width: 4.w),
                      if (time?.isNotEmpty ?? false)
                        Text(
                          time!,
                          style: TextStyle(
                            color: AuthUiConstants.mutedText,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      if ((time?.isNotEmpty ?? false) &&
                          (date?.isNotEmpty ?? false))
                        Text(
                          '  ·  ',
                          style: TextStyle(
                            color: AuthUiConstants.mutedText,
                            fontSize: 12.sp,
                          ),
                        ),
                      if (date?.isNotEmpty ?? false)
                        Text(
                          date!,
                          style: TextStyle(
                            color: AuthUiConstants.mutedText,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ],
                SizedBox(height: 14.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 10.r,
                          height: 10.r,
                          decoration: BoxDecoration(
                            color: AppColors.main1,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          width: 2,
                          height: 28.h,
                          margin: EdgeInsets.symmetric(vertical: 3.h),
                          color: const Color(0xFFD7DEE8),
                        ),
                        Icon(
                          Icons.location_on_rounded,
                          size: 16.sp,
                          color: AppColors.accentOrange,
                        ),
                      ],
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pickup,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AuthUiConstants.textPrimary,
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            destination,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AuthUiConstants.textPrimary,
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      width: 36.r,
                      height: 36.r,
                      decoration: BoxDecoration(
                        color: AppColors.main1.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.main1,
                        size: 22.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    _MetaChip(
                      icon: Icons.straighten_rounded,
                      label: _formatDistance(context),
                    ),
                    SizedBox(width: 8.w),
                    _MetaChip(
                      icon: Icons.timer_outlined,
                      label: _formatDuration(context),
                    ),
                    const Spacer(),
                    Text(
                      AppTranslations.getText(context, 'view_details'),
                      style: TextStyle(
                        color: AppColors.main1,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FA),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: AuthUiConstants.mutedText),
          SizedBox(width: 4.w),
          Text(
            label,
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
