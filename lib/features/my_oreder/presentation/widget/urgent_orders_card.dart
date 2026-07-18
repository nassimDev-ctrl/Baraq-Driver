import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/my_oreder/presentation/widget/order_button_status.dart';
import 'package:drever_warr/features/my_oreder/presentation/widget/orders_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UrgentOrdersCard extends StatelessWidget {
  final OrderButtonStatus buttonStatus;
  final String userName;
  final String phoneNumber;
  final String price;
  final String distance;
  final String fromAddress;
  final String toAddress;
  final String? date;
  final String? duration;
  final bool isScheduled;
  final VoidCallback onAccept;
  final int animationIndex;

  const UrgentOrdersCard({
    super.key,
    required this.buttonStatus,
    required this.userName,
    required this.phoneNumber,
    required this.price,
    required this.distance,
    required this.fromAddress,
    required this.toAddress,
    this.date,
    this.duration,
    this.isScheduled = false,
    required this.onAccept,
    this.animationIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration:
          Duration(milliseconds: 280 + (animationIndex * 40).clamp(0, 240)),
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
      child: Container(
        margin: EdgeInsets.only(bottom: OrdersUiConstants.sectionSpacing.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(OrdersUiConstants.cardRadius.r),
          boxShadow: OrdersUiConstants.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: (isScheduled
                            ? const Color(0xFF0EA5E9)
                            : AppColors.accentOrange)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isScheduled
                            ? Icons.event_available_rounded
                            : Icons.flash_on_rounded,
                        size: 14.sp,
                        color: isScheduled
                            ? const Color(0xFF0EA5E9)
                            : AppColors.accentOrange,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        AppTranslations.getText(
                          context,
                          isScheduled ? 'scheduled_orders' : 'urgent_orders',
                        ),
                        style: TextStyle(
                          color: isScheduled
                              ? const Color(0xFF0EA5E9)
                              : AppColors.accentOrange,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  price,
                  style: TextStyle(
                    color: AppColors.button,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Row(
              children: [
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: AppColors.main1.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    color: AppColors.main1,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AuthUiConstants.textPrimary,
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        phoneNumber,
                        style: TextStyle(
                          color: AuthUiConstants.mutedText,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.main1,
                          width: 2.5,
                        ),
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 28.h,
                      margin: EdgeInsets.symmetric(vertical: 3.h),
                      color: const Color(0xFFD5DEEA),
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
                        fromAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AuthUiConstants.textPrimary,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Text(
                        toAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AuthUiConstants.textPrimary,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                _MetaChip(
                  icon: Icons.route_rounded,
                  label: distance,
                ),
                if (duration != null && duration!.isNotEmpty)
                  _MetaChip(
                    icon: Icons.schedule_rounded,
                    label: duration!,
                  ),
                if (date != null && date!.isNotEmpty)
                  _MetaChip(
                    icon: Icons.calendar_month_rounded,
                    label: date!,
                  ),
              ],
            ),
            SizedBox(height: 14.h),
            SizedBox(
              width: double.infinity,
              height: OrdersUiConstants.buttonHeight.h,
              child: ElevatedButton(
                onPressed: buttonStatus == OrderButtonStatus.loading
                    ? null
                    : onAccept,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: buttonStatus == OrderButtonStatus.start
                      ? AppColors.button
                      : AppColors.main1,
                  disabledBackgroundColor:
                      AppColors.main1.withValues(alpha: 0.65),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: buttonStatus == OrderButtonStatus.loading
                      ? SizedBox(
                          key: const ValueKey('loading'),
                          width: 22.r,
                          height: 22.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          AppTranslations.getText(
                            context,
                            buttonStatus == OrderButtonStatus.start
                                ? 'start'
                                : buttonStatus == OrderButtonStatus.accepted
                                    ? 'accepted'
                                    : 'accept',
                          ),
                          key: ValueKey(buttonStatus.name),
                          style: TextStyle(
                            fontSize: 14.5.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FC),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: AuthUiConstants.iconMuted),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              color: AuthUiConstants.mutedText,
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
