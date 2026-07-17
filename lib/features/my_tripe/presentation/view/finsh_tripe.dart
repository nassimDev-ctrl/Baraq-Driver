import 'dart:async';

import 'package:drever_warr/core/cash/preferences_service.dart';
import 'package:drever_warr/core/di/app_providers.dart';
import 'package:drever_warr/core/service/socket_service.dart';
import 'package:drever_warr/core/widgets/custom_text.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/cubit_finsh_trips/cubit.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/cubit_finsh_trips/cubit_stat.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/model/model_finsh_trips.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/model/accsept_model.dart';
import 'package:drever_warr/features/my_tripe/presentation/view/details_trip.dart';
import 'package:drever_warr/features/my_tripe/presentation/view/end_tripe.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/countainer_journy_ongoing.dart';
import 'package:drever_warr/features/presentation/widgets/icon_bak.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/asset/icon_asset.dart';
import '../../../../core/asset/image_asset.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/translate/app_translate.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../my_oreder/presentation/data/cubit/cubit_current_trip/cubit.dart';
import '../../../my_oreder/presentation/data/cubit/cubit_current_trip/cubit_state.dart';

class OngoingJourney extends StatefulWidget {
  const OngoingJourney({super.key});

  @override
  State<OngoingJourney> createState() => _OngoingJourneyState();
}

class _OngoingJourneyState extends State<OngoingJourney>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TripSocketService _socketService = TripSocketService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<GetFinishedTripsCubit>().fetchFinishedTrips();
      context.read<GetStartedTripsCubit>().fetchStartedTrips();
      _connectSocket();
    });
  }

  Future<void> _connectSocket() async {
    final token = await CacheManager.getData('token');
    if (token != null && token.toString().isNotEmpty) {
      _socketService.connect(token.toString());
    }
  }

  void _onTabChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _socketService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GetFinishedTripsCubit, GetFinishedTripsState>(
        builder: (context, state) {
          if (state is GetFinishedTripsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetFinishedTripsFailure) {
            return Center(child: Text(state.errMessage));
          } else if (state is GetFinishedTripsSuccess) {
            return Column(
              children: [
                const IconBak(),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomText(
                        "trips",
                        color: Colors.blue.shade400,
                        type: AppTextType.titleMedium,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                _buildTabs(),
                SizedBox(height: 10.h),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildCurrentTripTab(),
                      _buildFinishedTripsTab(state.trips),

                    ],
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildTabs() {
    return TabBar(
      controller: _tabController,
      indicatorColor: Colors.transparent,
      dividerColor: Colors.transparent,
      tabs: [
        _buildTab(
          title: AppTranslations.getText(context, "current_trip"),
          index: 0,
        ),
        _buildTab(
          title: "finished_trips",
          index: 1,
        ),
      ],
    );
  }

  Widget _buildTab({required String title, required int index}) {
    final bool isSelected = _tabController.index == index;

    return Tab(
      child: Column(
        children: [
          CustomText(
            title,
            type: AppTextType.titleSmall,
            color: isSelected ? AppColors.main1 : Colors.black,
          ),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 4,
            width: 80.w,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.main1 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishedTripsTab(List<FinishedTripModel> trips) {
    if (trips.isEmpty) {
      return Center(
        child: Text(
          AppTranslations.getText(context, "no_finished_trips"),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 10.h),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.h),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => withTripFlow(
                    DetailsOfTheCompletedTrip(
                      tripId: trip.id.toString(),
                    ),
                  ),
                ),
              );
            },
            child: CountainerJournyOngoing(
              time: trip.time,
              date: trip.date,
              carName: trip.carName,
              totalPrice: trip.totalPrice.toStringAsFixed(0),
              startAddress: trip.startAddress,
              latitude: trip.startLat,
              longitude: trip.startLng,
              mapHeight: 160,
            )
          ),
        );
      },
    );
  }

  Widget _buildCurrentTripTab() {
    return BlocBuilder<GetStartedTripsCubit, GetStartedTripsState>(
      builder: (context, state) {
        if (state is GetStartedTripsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetStartedTripsFailure) {
          return Center(child: Text(state.errMessage));
        } else if (state is GetStartedTripsSuccess) {
          final trips = state.trips;

          if (trips.isEmpty) {
            return Center(
              child: Text(
                AppTranslations.getText(context, "no_current_trip"),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];

              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0.h),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => withTripFlow(
                          EndTripe(
                            trip: trip,
                            socketService: _socketService,
                          ),
                        ),
                      ),
                    );
                  },
                  child: CountainerJournyOngoing(
                    time: trip.sourceAddress,
                    date: "",
                    carName: "",
                    totalPrice: trip.totalPrice.toStringAsFixed(0),
                    startAddress: trip.destinationAddress,
                    latitude: trip.startLat,
                    longitude: trip.startLng,
                    mapHeight: 420,
                  )
                ),
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}

class CountainerCurrentJourney extends StatelessWidget {
  final ActiveTripModel trip;

  const CountainerCurrentJourney({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.main1,
          borderRadius: BorderRadius.circular(15.r),
          border: const Border(bottom: BorderSide(color: Colors.white)),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: CustomText(
                    color: AppColors.secondary1,
                    trip.status.isNotEmpty ? trip.status : "current trip",
                    type: AppTextType.titleSmall,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: SizedBox(
                height: 130.h,
                child: Image.asset(
                  ImageAssets.mape,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: CustomText(
                    color: AppColors.secondary1,
                    trip.clientName.isNotEmpty ? trip.clientName : "عميل غير معروف",
                    type: AppTextType.bodyMedium,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    color: AppColors.secondary1,
                    "${trip.totalPrice.toStringAsFixed(0)} ",
                    type: AppTextType.bodyMedium,
                  ),
                  Row(
                    children: [
                      CustomText(
                        color: AppColors.secondary1,
                        trip.sourceAddress,
                        type: AppTextType.bodyMedium,
                        maxLines: 1,
                      ),
                      SizedBox(width: 5.w),
                      SvgPicture.asset(
                        IconAssets.locationsearch,
                        height: 15.h,
                        width: 15.w,
                        colorFilter: ColorFilter.mode(
                          AppColors.secondary1,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    color: AppColors.secondary1,
                    "${trip.distance.toStringAsFixed(1)} km",
                    type: AppTextType.bodyMedium,
                  ),
                  CustomText(
                    color: AppColors.secondary1,
                    trip.destinationAddress,
                    type: AppTextType.bodyMedium,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}