import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/my_oreder/presentation/widget/orders_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersEmptyState extends StatelessWidget {
  const OrdersEmptyState({
    super.key,
    required this.isScheduled,
  });

  final bool isScheduled;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(OrdersUiConstants.cardRadius.r),
            boxShadow: OrdersUiConstants.cardShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72.r,
                height: 72.r,
                decoration: BoxDecoration(
                  color: AppColors.main1.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isScheduled
                      ? Icons.event_busy_rounded
                      : Icons.local_taxi_outlined,
                  size: 34.sp,
                  color: AppColors.main1,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                AppTranslations.getText(
                  context,
                  isScheduled
                      ? 'no_scheduled_orders_now'
                      : 'no_orders_now',
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AuthUiConstants.textPrimary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                AppTranslations.getText(context, 'waiting_for_orders'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AuthUiConstants.mutedText,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
