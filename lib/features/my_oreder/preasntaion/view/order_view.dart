 
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/ScheduledTrips_cubit/cubit.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/ScheduledTrips_cubit/cubit_stat.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/accept_order_cubit/cubit.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/accept_order_cubit/cubit_stat.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/cubit_order/cubit.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/cubit_order/cubit_stat.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/model/accsept_model.dart'; // تأكد أن هذا يحتوي على ActiveTripModel
import 'package:drever_warr/features/my_oreder/preasntaion/widget/order_card.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/view/start_tripe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/widget/UrgentOrdersCard.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/widget/header_order.dart';

enum OrderButtonStatus { accept, accepted, loading }

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchingTripsCubit>().getSearchingTrips();
      context.read<ScheduledTripsCubit>().getScheduledTrips();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AcceptTripCubit, AcceptTripState>(
      listener: (context, state) {
        if (state is AcceptTripSuccess) {
      
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LiveTripScreen(trip: state.trip)),
          );
        } else if (state is AcceptTripFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              HeaderOrder(onMenuTap: () {}, con: true),
              SizedBox(height: 20.h),
              _buildTabs(),
              SizedBox(height: 10.h),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildUrgentOrdersList(),
                    _buildScheduledOrdersList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  Widget _buildUrgentOrdersList() {
    return BlocBuilder<SearchingTripsCubit, SearchingTripsState>(
      builder: (context, state) {
        if (state is SearchingTripsLoading) {
          return Center(child: CircularProgressIndicator(color: AppColors.main1));
        }
        if (state is SearchingTripsSuccess) {
          if (state.trips.isEmpty) {
            return const Center(child: CustomText("لا يوجد طلبات حالياً", type: AppTextType.bodySmall));
          }
          return RefreshIndicator(
            onRefresh: () => context.read<SearchingTripsCubit>().getSearchingTrips(),
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              itemCount: state.trips.length,
              itemBuilder: (context, index) {
                final trip = state.trips[index]; 

                return BlocBuilder<AcceptTripCubit, AcceptTripState>(
                  builder: (context, acceptState) {
                    bool isLoading = acceptState is AcceptTripLoading;

                    return UrgentOrdersCard(
                      userName: trip.clientName ?? "عميل واري",
                      phoneNumber: trip.clientPhone ?? "بدون رقم",
                      price: "${trip.totalPrice.toStringAsFixed(0)} SYP",
                      distance: "${trip.distance.toStringAsFixed(1)} K.m",
                      fromAddress: trip.sourceAddress,
                      toAddress: trip.destinationAddress,
                      buttonStatus: isLoading ? OrderButtonStatus.loading : OrderButtonStatus.accept,
                      onAccept: () {
                        if (!isLoading) {
                      
                          final activeTrip = ActiveTripModel(
                            id: trip.id,
                            clientName: trip.clientName ?? "عميل واري",
                            clientPhone: trip.clientPhone ?? "",
                            sourceAddress: trip.sourceAddress,
                            destinationAddress: trip.destinationAddress,
                            startLat: trip.startLat ?? 0.0,
                            startLng: trip.startLng ?? 0.0,
                            destinationLat: trip.destinationLat ?? 0.0,
                            destinationLng: trip.destinationLng ?? 0.0,
                            totalPrice: trip.totalPrice.toDouble(),
                            distance: trip.distance.toDouble(),
                            status: "accepted",
                          );

                          context.read<AcceptTripCubit>().acceptTrip(trip: activeTrip);
                        }
                      },
                    );
                  },
                );
              },
            ),
          );
        }
        return const Center(child: CustomText("حدث خطأ أثناء تحميل البيانات", type: AppTextType.bodySmall));
      },
    );
  }

  
  Widget _buildScheduledOrdersList() {
    return BlocBuilder<ScheduledTripsCubit, ScheduledTripsState>(
      builder: (context, state) {
        if (state is ScheduledTripsLoading) {
          return Center(child: CircularProgressIndicator(color: AppColors.main1));
        }
        if (state is ScheduledTripsSuccess) {
          if (state.trips.isEmpty) {
            return const Center(child: CustomText("لا يوجد طلبات مجدولة حالياً", type: AppTextType.bodySmall));
          }
          return RefreshIndicator(
            onRefresh: () => context.read<ScheduledTripsCubit>().getScheduledTrips(),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: state.trips.length,
              itemBuilder: (context, index) {
                return OrderCard(
                  trip: state.trips[index],
                  buttonStatus: OrderButtonStatus.accept,
                );
              },
            ),
          );
        }
        return const Center(child: CustomText("لا يوجد طلبات مجدولة حالياً", type: AppTextType.bodySmall));
      },
    );
  }

  Widget _buildTabs() {
    return TabBar(
      controller: _tabController,
      indicatorColor: Colors.transparent,
      dividerColor: Colors.transparent,
      tabs: [
        _buildTab(title: "الطلبات الفورية", index: 0),
        _buildTab(title: "الطلبات المجدولة", index: 1),
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
}