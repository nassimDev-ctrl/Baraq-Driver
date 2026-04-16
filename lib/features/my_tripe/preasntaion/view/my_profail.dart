 
import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/widget/ColumnImageNamePhoneProfaildriver.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/widget/ColumnNumberOfTripsRatingDistancesDriveprofail.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/widget/ColumnTypecarePhondrive.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/widget/OpinionsAboutDrive.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
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
                        image: IconsAssets.distances,
                        title1: "${profile?.distancePassed ?? 0} k.m",
                        title2: "distances",
                        col: AppColors.secondary2,
                      ),
                      ColumnNumberOfTripsRatingDistancesDriveprofail(
                        image: IconsAssets.stare,
                        title1: "${profile?.rating ?? 00}",
                        title2: "rating",
                        col: Colors.yellow,
                      ),
                      ColumnNumberOfTripsRatingDistancesDriveprofail(
                        col: AppColors.secondary2,
                        image: IconsAssets.Numberoftrips,
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
                      carNumber: profile?.car?.carPlateNumber ?? "---",
                      carType:
                          "${profile?.car?.carName ?? 'N/A'} (${profile?.car?.carColor ?? ''})",
                      driverPhone: profile?.authUser?.mobilePhone ?? "N/A",
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

               
                  Expanded(
                    child: ListView.builder(
                      itemCount: 3,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: OpinionsAboutDrive(),
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
