import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/driver_available_cubit/cubit.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/driver_available_cubit/cubit_state.dart';
import 'package:drever_warr/features/home/presentation/view/wallt_screen.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/cubit_current_trip/cubit.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/cubit_current_trip/cubit_state.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/cubit_order/cubit.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/cubit_order/cubit_stat.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/model/accsept_model.dart';
import 'package:drever_warr/features/my_oreder/presentation/view/order_view.dart';
import 'package:drever_warr/features/my_tripe/presentation/view/finsh_tripe.dart';
import 'package:drever_warr/features/my_tripe/presentation/view/start_tripe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeDriverPanel extends StatelessWidget {
  const HomeDriverPanel({
    super.key,
    required this.imagePath,
    this.rating,
    this.tripsCount,
    this.distanceKm,
  });

  final String? imagePath;
  final num? rating;
  final int? tripsCount;
  final num? distanceKm;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverStatusCubit, DriverStatusState>(
      builder: (context, statusState) {
        final isOnline = switch (statusState) {
          DriverStatusLoaded(:final isAvailable) => isAvailable,
          _ => false,
        };

        return Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md.w,
              10.h,
              AppSpacing.md.w,
              MediaQuery.paddingOf(context).bottom + 12.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AuthUiConstants.fieldBorder,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                SizedBox(height: 12.h),
                _StatusBanner(isOnline: isOnline),
                SizedBox(height: 12.h),
                _ActiveTripBanner(imagePath: imagePath),
                SizedBox(height: 12.h),
                _StatsRow(
                  rating: rating ?? 0,
                  tripsCount: tripsCount ?? 0,
                  distanceKm: distanceKm ?? 0,
                ),
                SizedBox(height: 14.h),
                _QuickActions(imagePath: imagePath),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.isOnline});

  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isOnline
            ? AppColors.button.withValues(alpha: 0.1)
            : const Color(0xFFFFF1F1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isOnline
              ? AppColors.button.withValues(alpha: 0.25)
              : const Color(0xFFFECACA),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isOnline ? Icons.radar_rounded : Icons.pause_circle_outline_rounded,
            color: isOnline ? AppColors.button : const Color(0xFFDC2626),
            size: 22.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppTranslations.getText(
                    context,
                    isOnline ? 'driver_online' : 'driver_offline',
                  ),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: AuthUiConstants.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  AppTranslations.getText(
                    context,
                    isOnline ? 'waiting_for_orders' : 'go_online_hint',
                  ),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AuthUiConstants.mutedText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveTripBanner extends StatelessWidget {
  const _ActiveTripBanner({required this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetStartedTripsCubit, GetStartedTripsState>(
      builder: (context, state) {
        if (state is! GetStartedTripsSuccess || state.trips.isEmpty) {
          return const SizedBox.shrink();
        }

        final ActiveTripModel trip = state.trips.first;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LiveTripScreen(
                  trip: trip,
                  imagePath: imagePath,
                ),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.main1,
                  AppColors.blue,
                ],
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.navigation_rounded,
                    color: Colors.white,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppTranslations.getText(
                          context,
                          'continue_active_trip',
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        trip.destinationAddress.isNotEmpty
                            ? trip.destinationAddress
                            : trip.clientName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.rating,
    required this.tripsCount,
    required this.distanceKm,
  });

  final num rating;
  final int tripsCount;
  final num distanceKm;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.star_rounded,
            iconColor: const Color(0xFFF59E0B),
            label: AppTranslations.getText(context, 'rating'),
            value: rating.toStringAsFixed(1),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _StatCard(
            icon: Icons.route_rounded,
            iconColor: AppColors.main1,
            label: AppTranslations.getText(context, 'trips_count'),
            value: '$tripsCount',
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _StatCard(
            icon: Icons.straighten_rounded,
            iconColor: AppColors.button,
            label: AppTranslations.getText(context, 'distance_travelled'),
            value:
                '${distanceKm.toStringAsFixed(0)} ${AppTranslations.getText(context, 'km')}',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AuthUiConstants.fieldFill,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AuthUiConstants.fieldBorder),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 18.sp),
          SizedBox(height: 6.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
              color: AuthUiConstants.textPrimary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: AuthUiConstants.mutedText,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final ordersCount = context.select<SearchingTripsCubit, int>((cubit) {
      final state = cubit.state;
      if (state is SearchingTripsSuccess) return state.trips.length;
      return 0;
    });

    return Row(
      children: [
        Expanded(
          child: _ActionChip(
            icon: Icons.local_taxi_rounded,
            label: AppTranslations.getText(context, 'orders'),
            badge: ordersCount,
            color: AppColors.main1,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrdersScreen(imagePath: imagePath),
                ),
              );
            },
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _ActionChip(
            icon: Icons.history_rounded,
            label: AppTranslations.getText(context, 'my_trips'),
            color: const Color(0xFF7C3AED),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OngoingJourney()),
              );
            },
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _ActionChip(
            icon: Icons.account_balance_wallet_outlined,
            label: AppTranslations.getText(context, 'wallet'),
            color: AppColors.button,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WalletScreen()),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.badge = 0,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: color.withValues(alpha: 0.16)),
          ),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, color: color, size: 22.sp),
                  if (badge > 0)
                    Positioned(
                      top: -6,
                      right: -10,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC2626),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          badge > 9 ? '9+' : '$badge',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: AuthUiConstants.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
