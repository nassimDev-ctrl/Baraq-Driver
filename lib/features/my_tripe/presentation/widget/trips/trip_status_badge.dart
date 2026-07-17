import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum TripStatusKind {
  ongoing,
  waitingClient,
  onTheWay,
  completed,
  cancelled,
  unknown,
}

abstract final class TripStatusMapper {
  static TripStatusKind fromRaw(String? raw) {
    final status = (raw ?? '').trim().toLowerCase();
    if (status.isEmpty) return TripStatusKind.unknown;

    if (status.contains('cancel')) return TripStatusKind.cancelled;
    if (status.contains('complete') ||
        status.contains('finish') ||
        status.contains('ended') ||
        status == 'done') {
      return TripStatusKind.completed;
    }
    if (status.contains('wait') ||
        status.contains('client_confirmed') ||
        status.contains('arrived') ||
        status.contains('pending')) {
      return TripStatusKind.waitingClient;
    }
    if (status.contains('way') ||
        status.contains('accepted') ||
        status.contains('going') ||
        status.contains('pickup')) {
      return TripStatusKind.onTheWay;
    }
    if (status.contains('start') ||
        status.contains('progress') ||
        status.contains('ongoing') ||
        status.contains('active') ||
        status.contains('in_trip')) {
      return TripStatusKind.ongoing;
    }
    return TripStatusKind.unknown;
  }

  static String labelKey(TripStatusKind kind) {
    switch (kind) {
      case TripStatusKind.ongoing:
        return 'status_ongoing';
      case TripStatusKind.waitingClient:
        return 'status_waiting_client';
      case TripStatusKind.onTheWay:
        return 'status_on_the_way';
      case TripStatusKind.completed:
        return 'status_completed';
      case TripStatusKind.cancelled:
        return 'status_cancelled';
      case TripStatusKind.unknown:
        return 'status_ongoing';
    }
  }

  static Color color(TripStatusKind kind) {
    switch (kind) {
      case TripStatusKind.ongoing:
        return AppColors.button;
      case TripStatusKind.waitingClient:
        return AppColors.accentOrange;
      case TripStatusKind.onTheWay:
        return AppColors.main1;
      case TripStatusKind.completed:
        return const Color(0xFF64748B);
      case TripStatusKind.cancelled:
        return const Color(0xFFEF4444);
      case TripStatusKind.unknown:
        return AppColors.main1;
    }
  }
}

class TripStatusBadge extends StatelessWidget {
  const TripStatusBadge({
    super.key,
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    final kind = TripStatusMapper.fromRaw(status);
    final color = TripStatusMapper.color(kind);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        AppTranslations.getText(context, TripStatusMapper.labelKey(kind)),
        style: TextStyle(
          color: color,
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
