import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/model/model_finsh_trips.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/model/accsept_model.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/trips/empty_trips_widget.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/trips/trip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripsList extends StatelessWidget {
  const TripsList.current({
    super.key,
    required this.currentTrips,
    required this.onCurrentTap,
    required this.onBackHome,
  })  : finishedTrips = const [],
        onFinishedTap = null,
        isFinished = false;

  const TripsList.finished({
    super.key,
    required this.finishedTrips,
    required this.onFinishedTap,
    required this.onBackHome,
  })  : currentTrips = const [],
        onCurrentTap = null,
        isFinished = true;

  final List<ActiveTripModel> currentTrips;
  final List<FinishedTripModel> finishedTrips;
  final ValueChanged<ActiveTripModel>? onCurrentTap;
  final ValueChanged<FinishedTripModel>? onFinishedTap;
  final VoidCallback onBackHome;
  final bool isFinished;

  @override
  Widget build(BuildContext context) {
    final isEmpty = isFinished ? finishedTrips.isEmpty : currentTrips.isEmpty;

    if (isEmpty) {
      return ListView(
        padding: EdgeInsets.only(bottom: 24.h),
        children: [
          EmptyTripsWidget(onBackHome: onBackHome),
        ],
      );
    }

    final titleKey =
        isFinished ? 'finished_trips_section' : 'current_trips_section';
    final count = isFinished ? finishedTrips.length : currentTrips.length;

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 24.h),
      itemCount: count + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    AppTranslations.getText(context, titleKey),
                    style: TextStyle(
                      color: AuthUiConstants.textPrimary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  AppTranslations.getText(context, 'view_all'),
                  style: TextStyle(
                    color: AppColors.main1,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.main1,
                  size: 18.sp,
                ),
              ],
            ),
          );
        }

        final itemIndex = index - 1;
        if (isFinished) {
          final trip = finishedTrips[itemIndex];
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: TripCard(
              animationIndex: itemIndex,
              status: trip.status.isNotEmpty ? trip.status : 'completed',
              pickup: trip.startAddress,
              destination: trip.destinationAddress,
              price: trip.totalPrice,
              time: trip.time,
              date: trip.date,
              distanceKm: trip.distanceKmMeters,
              durationMinutes: trip.durationMinutes,
              onTap: () => onFinishedTap?.call(trip),
            ),
          );
        }

        final trip = currentTrips[itemIndex];
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: TripCard(
            animationIndex: itemIndex,
            status: trip.status,
            pickup: trip.sourceAddress,
            destination: trip.destinationAddress,
            price: trip.totalPrice,
            distanceKm: trip.distance,
            durationMinutes: trip.durationMinutes,
            onTap: () => onCurrentTap?.call(trip),
          ),
        );
      },
    );
  }
}
