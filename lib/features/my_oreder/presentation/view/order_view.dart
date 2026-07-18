import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/di/app_providers.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/app_snack_bar.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/home/presentation/view/menew.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/ScheduledTrips_cubit/cubit.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/ScheduledTrips_cubit/cubit_stat.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/accept_order_cubit/cubit.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/accept_order_cubit/cubit_stat.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/cubit_order/cubit.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/cubit_order/cubit_stat.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/model/accsept_model.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/model/scheduled_trips.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/scheduled_accept_order_cubit/cubit.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/scheduled_accept_order_cubit/cubit_state.dart';
import 'package:drever_warr/features/my_oreder/presentation/widget/header_order.dart';
import 'package:drever_warr/features/my_oreder/presentation/widget/order_button_status.dart';
import 'package:drever_warr/features/my_oreder/presentation/widget/orders_empty_state.dart';
import 'package:drever_warr/features/my_oreder/presentation/widget/orders_segmented_tabs.dart';
import 'package:drever_warr/features/my_oreder/presentation/widget/orders_ui_constants.dart';
import 'package:drever_warr/features/my_oreder/presentation/widget/urgent_orders_card.dart';
import 'package:drever_warr/features/my_tripe/presentation/view/start_tripe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;

export 'package:drever_warr/features/my_oreder/presentation/widget/order_button_status.dart';

class OrdersScreen extends StatefulWidget {
  final String? imagePath;
  const OrdersScreen({super.key, required this.imagePath});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

/// Stateless ticker mixin avoided: IndexedStack tabs do not need TabController.
/// Hot Restart if you still see a stale `_ticker` error after reload.
class _OrdersScreenState extends State<OrdersScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchingTripsCubit>().getSearchingTrips();
      context.read<ScheduledTripsCubit>().getScheduledTrips();
    });
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
      clientName: trip.clientName ?? 'عميل برق',
      clientPhone: trip.clientPhone ?? '',
      sourceAddress: trip.sourceAddress,
      destinationAddress: trip.destinationAddress,
      startLat: trip.startLat ?? 0.0,
      startLng: trip.startLng ?? 0.0,
      destinationLat: trip.destinationLat ?? 0.0,
      destinationLng: trip.destinationLng ?? 0.0,
      totalPrice: trip.totalPrice.toDouble(),
      distance: trip.distance.toDouble(),
      status: 'accepted',
      durationMinutes: trip.durationMinutes,
    );
  }

  ActiveTripModel _mapScheduledTripToActiveTrip(ScheduledTripModel trip) {
    return ActiveTripModel(
      id: trip.id,
      clientName: trip.clientName ?? 'عميل برق',
      clientPhone: trip.clientPhone ?? '',
      sourceAddress: trip.sourceAddress,
      destinationAddress: trip.destinationAddress,
      startLat: trip.startLat,
      startLng: trip.startLng,
      destinationLat: trip.destinationLat,
      destinationLng: trip.destinationLng,
      totalPrice: trip.totalPrice.toDouble(),
      distance: trip.distance,
      status: 'accepted',
      durationMinutes: trip.durationMinutes ?? 0.0,
    );
  }

  String _formatDuration(BuildContext context, num? minutes) {
    if (minutes == null) return '';
    return '${minutes.toStringAsFixed(0)} ${AppTranslations.getText(context, 'min_unit')}';
  }

  @override
  Widget build(BuildContext context) {
    final searchingState = context.watch<SearchingTripsCubit>().state;
    final scheduledState = context.watch<ScheduledTripsCubit>().state;

    final urgentCount =
        searchingState is SearchingTripsSuccess ? searchingState.trips.length : 0;
    final scheduledCount = scheduledState is ScheduledTripsSuccess
        ? scheduledState.trips.length
        : 0;

    return MultiBlocListener(
      listeners: [
        BlocListener<AcceptTripCubit, AcceptTripState>(
          listener: (context, state) {
            if (!mounted) return;

            if (state is AcceptTripSuccess) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => withTripFlow(
                    LiveTripScreen(
                      trip: state.trip,
                      imagePath: widget.imagePath,
                    ),
                  ),
                ),
              );
            } else if (state is AcceptTripFailure) {
              AppSnackBar.error(context, state.errMessage);
            }
          },
        ),
        BlocListener<ScheduledAcceptTripCubit, ScheduledAcceptTripState>(
          listener: (context, state) {
            if (!mounted) return;

            if (state is ScheduledAcceptTripSuccess) {
              AppSnackBar.success(context, 'Order accepted.');
              context.read<ScheduledTripsCubit>().getScheduledTrips();
            } else if (state is ScheduledAcceptTripFailure) {
              AppSnackBar.error(context, state.errMessage);
            }
          },
        ),
      ],
      child: Scaffold(
        drawer: const MenueView(),
        backgroundColor: const Color(0xFFF5F7FB),
        drawerScrimColor: Colors.transparent,
        key: _scaffoldKey,
        body: Column(
          children: [
            HeaderOrder(
              onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
              con: true,
              urgentCount: urgentCount,
              scheduledCount: scheduledCount,
              imagePath: widget.imagePath,
            ),
            Expanded(
              child: Transform.translate(
                offset: Offset(0, -14.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: OrdersUiConstants.horizontalPadding.w,
                  ),
                  child: Column(
                    children: [
                      OrdersSegmentedTabs(
                        selectedIndex: _selectedTab,
                        urgentCount: urgentCount,
                        scheduledCount: scheduledCount,
                        onChanged: (index) {
                          setState(() => _selectedTab = index);
                        },
                      ),
                      SizedBox(height: 12.h),
                      Expanded(
                        child: IndexedStack(
                          index: _selectedTab,
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
          ],
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
            color: AppColors.main1,
            onRefresh: () =>
                context.read<SearchingTripsCubit>().getSearchingTrips(),
            child: state.trips.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    children: [
                      SizedBox(height: 0.12.sh),
                      const OrdersEmptyState(isScheduled: false),
                    ],
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: EdgeInsets.only(bottom: 20.h),
                    itemCount: state.trips.length,
                    itemBuilder: (context, index) {
                      final trip = state.trips[index];
                      final acceptState = context.watch<AcceptTripCubit>().state;
                      final isLoading = acceptState is AcceptTripLoading &&
                          acceptState.tripId == trip.id;

                      return UrgentOrdersCard(
                        animationIndex: index,
                        userName: trip.clientName ??
                            AppTranslations.getText(
                              context,
                              'default_client_name',
                            ),
                        phoneNumber: trip.clientPhone ??
                            AppTranslations.getText(context, 'no_phone'),
                        price:
                            '${trip.totalPrice.toStringAsFixed(0)} ${AppTranslations.getText(context, 'currency_syp_short')}',
                        distance:
                            '${trip.distance.toStringAsFixed(1)} ${AppTranslations.getText(context, 'distance_km')}',
                        duration: _formatDuration(
                          context,
                          trip.durationMinutes,
                        ),
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
          child: Text(
            AppTranslations.getText(context, 'error_loading_data'),
            style: TextStyle(
              color: AuthUiConstants.mutedText,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
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
            color: AppColors.main1,
            onRefresh: () =>
                context.read<ScheduledTripsCubit>().getScheduledTrips(),
            child: state.trips.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    children: [
                      SizedBox(height: 0.12.sh),
                      const OrdersEmptyState(isScheduled: true),
                    ],
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: EdgeInsets.only(bottom: 20.h),
                    itemCount: state.trips.length,
                    itemBuilder: (context, index) {
                      final trip = state.trips[index];
                      final scheduledAcceptState =
                          context.watch<ScheduledAcceptTripCubit>().state;
                      final isAcceptLoading =
                          scheduledAcceptState is ScheduledAcceptTripLoading &&
                              scheduledAcceptState.tripId == trip.id;
                      final isClientConfirmed = _isClientConfirmed(trip);

                      String formatted = '';
                      if (trip.scheduledDate != null &&
                          trip.scheduledDate!.isNotEmpty) {
                        try {
                          final date = DateTime.parse(trip.scheduledDate!);
                          formatted = intl.DateFormat('yyyy-MM-dd – HH:mm')
                              .format(date);
                        } catch (_) {
                          formatted = trip.scheduledDate!;
                        }
                      }

                      final buttonStatus = isAcceptLoading
                          ? OrderButtonStatus.loading
                          : isClientConfirmed
                              ? OrderButtonStatus.start
                              : OrderButtonStatus.accept;

                      return UrgentOrdersCard(
                        animationIndex: index,
                        isScheduled: true,
                        userName: trip.clientName ??
                            AppTranslations.getText(
                              context,
                              'default_client_name',
                            ),
                        phoneNumber: trip.clientPhone ??
                            AppTranslations.getText(context, 'no_phone'),
                        price:
                            '${trip.totalPrice.toStringAsFixed(0)} ${AppTranslations.getText(context, 'currency_syp_short')}',
                        distance:
                            '${trip.distance.toStringAsFixed(1)} ${AppTranslations.getText(context, 'distance_km')}',
                        duration: _formatDuration(
                          context,
                          trip.durationMinutes,
                        ),
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
                                builder: (context) => withTripFlow(
                                  LiveTripScreen(
                                    trip: activeTrip,
                                    imagePath: widget.imagePath,
                                  ),
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
          child: Text(
            AppTranslations.getText(context, 'no_scheduled_orders_now'),
            style: TextStyle(
              color: AuthUiConstants.mutedText,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }
}
