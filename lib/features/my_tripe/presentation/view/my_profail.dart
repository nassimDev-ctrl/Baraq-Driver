 
import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:drever_warr/core/constant/app_colors.dart';

import 'package:drever_warr/core/constant/app_spacing.dart';

import 'package:drever_warr/core/widgets/custom_text.dart';

import 'package:drever_warr/features/my_tripe/presentation/widget/column_image_name_phone_profail_driver.dart';

import 'package:drever_warr/features/my_tripe/presentation/widget/column_number_of_trips_rating_distances_drive_profail.dart';

import 'package:drever_warr/features/my_tripe/presentation/widget/column_type_care_phone_drive.dart';

import 'package:drever_warr/features/my_tripe/presentation/widget/opinions_about_drive.dart';

import 'package:drever_warr/features/presentation/widgets/icon_bak.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

 
import 'package:drever_warr/features/setting/data/cubit/cubit_profail/cubit.dart';

import 'package:drever_warr/features/setting/data/cubit/cubit_profail/cubit_stat.dart';

class DriverProfail extends StatefulWidget {
  const DriverProfail({super.key});

  @override
  State<DriverProfail> createState() => _DriverProfailState();
}

class _DriverProfailState extends State<DriverProfail> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileSuccess) {
              final profile = state.data.data;

              return Column(
                children: [
                  const IconBak(),
                  SizedBox(height: AppSpacing.lg.h),

                  
                  ColumnImageNamePhoneProfaildriver(
                    imagePath: profile?.profileImage,
                    fullName:
                        "${profile?.firstName ?? ''} ${profile?.lastName ?? ''}",
                    phone: profile?.authUser?.mobilePhone ?? "N/A",
                  ),

                  SizedBox(height: AppSpacing.xlg.h),

                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ColumnNumberOfTripsRatingDistancesDriveprofail(
                        image: IconAssets.distances,
                        title1: "${profile?.distancePassed ?? 0} k.m",
                        title2: "distances",
                        col: AppColors.secondary2,
                      ),
                      ColumnNumberOfTripsRatingDistancesDriveprofail(
                        image: IconAssets.stare,
                        title1: "${profile?.rating ?? 00}",
                        title2: "rating",
                        col: Colors.yellow,
                      ),
                      ColumnNumberOfTripsRatingDistancesDriveprofail(
                        col: AppColors.secondary2,
                        image: IconAssets.numberOfTrips,
                        title1: "${profile?.numberOfTrips ?? 00}",
                        title2: "trips_count",
                      ),
                    ],
                  ),

                 
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 40.h,
                    ),
                    child: ColumnTypecarePhondrive(
                      carNumber: profile?.car?.carPlateNumber ?? '', // ✅ Empty fallback
                      carType: () {
                        final name = profile?.car?.carName ?? '';
                        final color = profile?.car?.carColor ?? '';
                        AppLogger.debug("name $name");
                        AppLogger.debug("color $color");

                        return '$name ($color)'.trim();
                      }(),
                      driverPhone: profile?.authUser?.mobilePhone ?? '',
                      colors: AppColors.secondary2,
                      diplay: false,
                      tybe: AppTextType.bodyLarge,
                    ),
                  ),

                  SizedBox(height: AppSpacing.xs.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: CustomText(
                          "reviews",
                          type: AppTextType.titleMedium,
                          color: AppColors.blue,
                        ),
                      ),
                    ],
                  ),


                  // 📍 In the ListView.builder section (replace the hardcoded one):
                  Expanded(
                    child: ListView.builder(
                      itemCount: profile?.evaluations?.length ?? 0, // ✅ Real count from API
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: OpinionsAboutDrive(
                          note: profile?.evaluations?[index].note ?? '', // ✅ Dynamic note
                          rating: profile?.evaluations?[index].rating != null
                              ? double.tryParse(profile!.evaluations![index].rating!) ?? 0
                              : 0, // ✅ Dynamic rating (parsed from String)
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            if (state is ProfileFailure) {
              return Center(child: Text(state.errMessage));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}