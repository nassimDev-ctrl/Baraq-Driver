import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/custom_text.dart';
import 'package:drever_warr/features/my_tripe/data/cubit/cubit_ratting/cubit.dart';
import 'package:drever_warr/features/my_tripe/data/cubit/cubit_ratting/cubit_stat.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/top_coloumn_details_trip_end.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/detals_row.dart';
import 'package:drever_warr/features/presentation/widgets/icon_bak.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/translate/app_translate.dart';
import '../../data/cubit/cubit_details_single_trip/cubit.dart';
import '../../data/cubit/cubit_details_single_trip/cubit_state.dart';
import 'package:drever_warr/core/widgets/app_snack_bar.dart';

class DetailsOfTheCompletedTrip extends StatefulWidget {
  final String tripId;

  const DetailsOfTheCompletedTrip({super.key, required this.tripId});

  @override
  State<DetailsOfTheCompletedTrip> createState() =>
      _DetailsOfTheCompletedTripState();
}

class _DetailsOfTheCompletedTripState extends State<DetailsOfTheCompletedTrip> {
  final TextEditingController option = TextEditingController();
  int userRating = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SingleTripDetailsCubit>().getTripById(tripId: widget.tripId);
    });
  }

  @override
  void dispose() {
    option.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SingleTripDetailsCubit, SingleTripDetailsState>(
      listener: (context, state) {
        if (state is SingleTripDetailsFailure) {
          AppSnackBar.error(context, state.errMessage);
        }
      },
      builder: (context, state) {
        if (state is SingleTripDetailsLoading ||
            state is SingleTripDetailsInitial) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is SingleTripDetailsFailure) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Text(state.errMessage),
            ),
          );
        }

        final trip = (state as SingleTripDetailsSuccess).trip;
        userRating = trip.driverRating;

        return BlocConsumer<AddRatingCubit, AddRatingState>(
          listener: (context, state) {
            if (state is AddRatingSuccess) {
              AppSnackBar.success(context, state.message);
              Navigator.pop(context);
            } else if (state is AddRatingFailure) {
              AppSnackBar.error(context, state.errMessage);
            }
          },
          builder: (context, ratingState) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const IconBak(),
                    SizedBox(height: AppSpacing.xxxlg.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            AppTranslations.getText(context, "trip_details"),
                            style: TextStyle(fontSize: 30, color: AppColors.blue) ,

                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.xxxxlg.h),

                    TopColoumnDetailsTripEnd(
                      startAddress: trip.startAddress,
                      destinationAddress: trip.destinationAddress,
                    ),

                    SizedBox(height: AppSpacing.xxxlg.h),

                    DetailsRow(
                      t1: "${trip.distanceKmMeters} m",
                      t2: AppTranslations.getText(context, "distance_travelled"),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    DetailsRow(
                      t1: "${trip.durationInsideCar} min",
                      t2: AppTranslations.getText(context, "time_spent"),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    DetailsRow(
                      t1: "${trip.waitingDuration} min",
                      t2: AppTranslations.getText(context, "waiting_time_label"),
                    ),

                    SizedBox(height: AppSpacing.x45.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: CustomText(
                        AppTranslations.getText(context, "client_name"),
                        type: AppTextType.titleMedium,
                        color: AppColors.blue,
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomText(
                                trip.clientName,
                                type: AppTextType.titleSmall,
                                color: AppColors.secondary2,
                              ),
                              SizedBox(height: AppSpacing.xs.h),
                              CustomText(
                                trip.clientPhone,
                                type: AppTextType.titleSmall,
                                color: AppColors.secondary2,
                              ),
                            ],
                          ),
                          SizedBox(width: AppSpacing.sm.w),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSpacing.lg.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: CustomText(
                        AppTranslations.getText(context, "invoice_details"),
                        type: AppTextType.titleMedium,
                        color: AppColors.blue,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xxxlg.h),

                    DetailsRow(
                      t1:
                      "${trip.totalPrice} ${AppTranslations.getText(context, "currency_syp")}",
                      t2: AppTranslations.getText(context, "trip_price"),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    DetailsRow(
                      t1: "0 ${AppTranslations.getText(context, "currency_syp")}",
                      t2: AppTranslations.getText(context, "discount"),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    DetailsRow(
                      t1:
                      "${trip.totalPrice} ${AppTranslations.getText(context, "currency_syp")}",
                      t2: AppTranslations.getText(context, "total"),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    DetailsRow(
                      t1:
                      "${trip.commissionAmount} ${AppTranslations.getText(context, "currency_syp")}",
                      t2: AppTranslations.getText(context, "admin_commission"),
                    ),
                    SizedBox(height: AppSpacing.sm.h),

                    DetailsRow(
                      t1: trip.paymentWay == "cash"
                          ? AppTranslations.getText(context, "cash")
                          : trip.paymentWay,
                      t2: AppTranslations.getText(context, "payment_method_label"),
                    ),

                    SizedBox(height: AppSpacing.xxxxlg.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: CustomText(
                        AppTranslations.getText(context, "rating"),
                        type: AppTextType.titleMedium,
                        color: AppColors.blue,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(5, (index) {
                          return GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: SvgPicture.asset(
                                index < userRating
                                    ? IconAssets.staroption
                                    : IconAssets.stareoptionborder,
                                height: 35.h,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: AppSpacing.xxxxlg.h),
                    SizedBox(height: 40.h),

                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}