import 'package:drever_warr/features/my_oreder/presentation/data/cubit/ScheduledTrips_cubit/cubit.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/ScheduledTrips_cubit/cubit_stat.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/accept_order_cubit/cubit.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/accept_order_cubit/cubit_stat.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/cubit_order/cubit.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/cubit_order/cubit_stat.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/model/accsept_model.dart';
import 'package:drever_warr/features/my_tripe/presentation/view/start_tripe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/custom_text.dart';
import 'package:drever_warr/features/my_oreder/presentation/widget/urgent_orders_card.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../core/translate/app_translate.dart';
import '../../../home/presentation/view/menew.dart';
import '../data/cubit/model/scheduled_trips.dart';
import '../data/cubit/scheduled_accept_order_cubit/cubit.dart';
import '../data/cubit/scheduled_accept_order_cubit/cubit_state.dart';
import '../widget/header_order.dart';

enum OrderButtonStatus { accept, start, accepted, loading }

class OrdersScreen extends StatefulWidget {
  final String? imagePath;
  const OrdersScreen({super.key, required this.imagePath});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchingTripsCubit>().getSearchingTrips();
      context.read<ScheduledTripsCubit>().getScheduledTrips();
    });
  }

  void _onTabChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  bool _isClientConfirmed(ScheduledTripModel trip) {
    return trip.status.trim().toLowerCase() == 'client_confirmed';
  }

  void _acceptScheduledTrip(ScheduledTripModel trip) {
    final activeTrip = _mapScheduledTripToActiveTrip(trip);
    context.read<ScheduledAcceptTripCubit>().acceptScheduledTrip(
      trip: activeTrip,
    );
  }

  ActiveTripModel _mapToActiveTrip(dynamic trip) {
    return ActiveTripModel(
      id: trip.id,
      clientName: trip.clientName ?? "عميل برق",
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
      durationMinutes: trip.durationMinutes,
    );
  }

  ActiveTripModel _mapScheduledTripToActiveTrip(ScheduledTripModel trip) {
    return ActiveTripModel(
      id: trip.id,
      clientName: trip.clientName ?? "عميل برق",
      clientPhone: trip.clientPhone ?? "",
      sourceAddress: trip.sourceAddress,
      destinationAddress: trip.destinationAddress,
      startLat: trip.startLat,
      startLng: trip.startLng,
      destinationLat: trip.destinationLat,
      destinationLng: trip.destinationLng,
      totalPrice: trip.totalPrice.toDouble(),
      distance: trip.distance,
      status: "accepted",
      durationMinutes: trip.durationMinutes ?? 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchingState = context.watch<SearchingTripsCubit>().state;
    final scheduledState = context.watch<ScheduledTripsCubit>().state;

    final urgentCount =
    searchingState is SearchingTripsSuccess ? searchingState.trips.length : 0;
    final scheduledCount =
    scheduledState is ScheduledTripsSuccess ? scheduledState.trips.length : 0;

    return MultiBlocListener(
      listeners: [
        BlocListener<AcceptTripCubit, AcceptTripState>(
          listener: (context, state) {
            if (!mounted) return;

            if (state is AcceptTripSuccess) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LiveTripScreen(
                    trip: state.trip,
                    imagePath: widget.imagePath,
                  ),
                ),
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
        ),
        BlocListener<ScheduledAcceptTripCubit, ScheduledAcceptTripState>(
          listener: (context, state) {
            if (!mounted) return;

            if (state is ScheduledAcceptTripSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Order accepted."),
                  backgroundColor: Colors.green,
                ),
              );

              // Pull fresh data from the server so the card switches to "Start"
              // only when the backend status becomes "client_confirmed".
              context.read<ScheduledTripsCubit>().getScheduledTrips();
            } else if (state is ScheduledAcceptTripFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          drawer: const MenueView(),
          backgroundColor: Colors.white,
          drawerScrimColor: Colors.transparent,
          key: _scaffoldKey,
          body: SafeArea(
            child: Column(
              children: [
                HeaderOrder(
                  onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                  con: true,
                  urgentCount: urgentCount,
                  scheduledCount: scheduledCount,
                  imagePath: widget.imagePath,
                ),
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
      ),
    );
  }

  Widget _buildUrgentOrdersList() {
    return BlocBuilder<SearchingTripsCubit, SearchingTripsState>(
      builder: (context, state) {
        if (state is SearchingTripsLoading) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.main1),
          );
        }

        if (state is SearchingTripsSuccess) {

          return RefreshIndicator(
            onRefresh: () => context.read<SearchingTripsCubit>().getSearchingTrips(),
            child: state.trips.isEmpty
                ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 0.35.sh),
                Center(
                  child: CustomText(
                    AppTranslations.getText(context, "no_orders_now"),
                    type: AppTextType.bodySmall,
                  ),
                ),
              ],
            )
                : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              itemCount: state.trips.length,
              itemBuilder: (context, index) {
                final trip = state.trips[index];
                final acceptState = context.watch<AcceptTripCubit>().state;
                final isLoading =
                    acceptState is AcceptTripLoading &&
                        acceptState.tripId == trip.id;

                return UrgentOrdersCard(
                  userName: trip.clientName ??
                      AppTranslations.getText(context, "default_client_name"),
                  phoneNumber: trip.clientPhone ??
                      AppTranslations.getText(context, "no_phone"),
                  price:
                  "${trip.totalPrice.toStringAsFixed(0)} ${AppTranslations.getText(context, "currency_syp_short")}",
                  distance:
                  "${trip.distance.toStringAsFixed(1)} ${AppTranslations.getText(context, "distance_km")}",
                  fromAddress: trip.sourceAddress,
                  toAddress: trip.destinationAddress,
                  buttonStatus: isLoading
                      ? OrderButtonStatus.loading
                      : OrderButtonStatus.accept,
                  onAccept: () {
                    if (isLoading) return;

                    final activeTrip = _mapToActiveTrip(trip);
                    context.read<AcceptTripCubit>().acceptTrip(
                      trip: activeTrip,
                    );
                  },
                );
              },
            ),
          );
        }

        return Center(
          child: CustomText(
            AppTranslations.getText(context, "error_loading_data"),
            type: AppTextType.bodySmall,
          ),
        );
      },
    );
  }

  Widget _buildScheduledOrdersList() {
    return BlocBuilder<ScheduledTripsCubit, ScheduledTripsState>(
      builder: (context, state) {
        if (state is ScheduledTripsLoading) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.main1),
          );
        }

        if (state is ScheduledTripsSuccess) {
          return RefreshIndicator(
            onRefresh: () => context.read<ScheduledTripsCubit>().getScheduledTrips(),
            child: state.trips.isEmpty
                ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 0.35.sh),
                Center(
                  child: CustomText(
                    AppTranslations.getText(context, "no_scheduled_orders_now"),
                    type: AppTextType.bodySmall,
                  ),
                ),
              ],
            )
                : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: state.trips.length,
              itemBuilder: (context, index) {
                final trip = state.trips[index];

                final scheduledAcceptState =
                    context.watch<ScheduledAcceptTripCubit>().state;

                final isAcceptLoading =
                    scheduledAcceptState is ScheduledAcceptTripLoading &&
                        scheduledAcceptState.tripId == trip.id;

                final isClientConfirmed = _isClientConfirmed(trip);
                DateTime date = DateTime.parse(trip.scheduledDate!);
                String formatted = intl.DateFormat('yyyy-MM-dd – kk:mm').format(date);

                final buttonStatus = isAcceptLoading
                    ? OrderButtonStatus.loading
                    : isClientConfirmed
                    ? OrderButtonStatus.start
                    : OrderButtonStatus.accept;

                return UrgentOrdersCard(
                  userName: trip.clientName ??
                      AppTranslations.getText(context, "default_client_name"),
                  phoneNumber: trip.clientPhone ??
                      AppTranslations.getText(context, "no_phone"),
                  price:
                  "${trip.totalPrice.toStringAsFixed(0)} ${AppTranslations.getText(context, "currency_syp_short")}",
                  distance:
                  "${trip.distance.toStringAsFixed(1)} ${AppTranslations.getText(context, "distance_km")}",
                  fromAddress: trip.sourceAddress,
                  toAddress: trip.destinationAddress,
                  date: formatted,
                  buttonStatus: buttonStatus,
                  onAccept: () {
                    if (isAcceptLoading) return;

                    if (isClientConfirmed) {
                      final activeTrip =
                      _mapScheduledTripToActiveTrip(trip);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LiveTripScreen(
                            trip: activeTrip,
                            imagePath: widget.imagePath,
                          ),
                        ),
                      );
                    } else {
                      _acceptScheduledTrip(trip);
                    }
                  },
                );
              },
            ),
          );
        }

        return Center(
          child: CustomText(
            AppTranslations.getText(context, "no_scheduled_orders_now"),
            type: AppTextType.bodySmall,
          ),
        );
      },
    );
  }

  Widget _buildTabs() {
    return TabBar(
      controller: _tabController,
      indicatorColor: Colors.transparent,
      dividerColor: Colors.transparent,
      tabs: [
        _buildTab(
          title: AppTranslations.getText(context, "urgent_orders"),
          index: 0,
        ),
        _buildTab(
          title: AppTranslations.getText(context, "scheduled_orders"),
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
}