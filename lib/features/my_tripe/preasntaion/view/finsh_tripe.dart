 
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/cubit_finsh_trips/cubit.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/cubit_finsh_trips/cubit_stat.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/view/details_trip.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/widget/CountainerJournyOngoing.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OngoingJourney extends StatefulWidget {
  const OngoingJourney({super.key});

  @override
  State<OngoingJourney> createState() => _OngoingJourneyState();
}

class _OngoingJourneyState extends State<OngoingJourney> {
  @override
  void initState() {
    super.initState();
    
    context.read<GetFinishedTripsCubit>().fetchFinishedTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GetFinishedTripsCubit, GetFinishedTripsState>(
        builder: (context, state) {
          if (state is GetFinishedTripsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetFinishedTripsSuccess) {
            if (state.trips.isEmpty) {
              return const Center(child: Text("لا يوجد رحلات حالية"));
            }

            return Column(
              children: [
                IconBak(),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomText(
                        "finished_trips",
                        color: Colors.blue.shade400,  
                        type: AppTextType
                            .titleMedium, 
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 0.w,
                      vertical: 10.h,
                    ),
                    itemCount: state.trips.length,  
                    itemBuilder: (context, index) {
                      final trip = state.trips[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0.h),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsOfTheCompletedTrip(
                                  trip:
                                      trip, 
                                ),
                              ),
                            );
                          },
                          child: CountainerJournyOngoing(
                            trip: trip,
                          ),  
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is GetFinishedTripsFailure) {
            return Center(child: Text(state.errMessage));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
