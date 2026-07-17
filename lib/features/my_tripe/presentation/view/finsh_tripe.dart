import 'package:drever_warr/core/cash/preferences_service.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/di/app_providers.dart';
import 'package:drever_warr/core/service/socket_service.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/cubit_finsh_trips/cubit.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/cubit_finsh_trips/cubit_stat.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/model/model_finsh_trips.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/cubit_current_trip/cubit.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/cubit_current_trip/cubit_state.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/model/accsept_model.dart';
import 'package:drever_warr/features/my_tripe/presentation/view/details_trip.dart';
import 'package:drever_warr/features/my_tripe/presentation/view/end_tripe.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/trips/trips_header.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/trips/trips_list.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/trips/trips_segmented_tabs.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/trips/trips_skeleton.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/trips/trips_statistics.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/trips/trips_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    if (!mounted || _tabController.indexIsChanging) return;
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _socketService.dispose();
    super.dispose();
  }

  void _openCurrentTrip(ActiveTripModel trip) {
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
  }

  void _openFinishedTrip(FinishedTripModel trip) {
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
  }

  int _tripsTodayCount(
    List<ActiveTripModel> current,
    List<FinishedTripModel> finished,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var count = current.length;

    for (final trip in finished) {
      final raw = trip.completedAt ?? trip.startedAt ?? trip.confirmedAt;
      if (raw == null || raw.isEmpty) continue;
      final parsed = DateTime.tryParse(raw)?.toLocal();
      if (parsed == null) continue;
      final day = DateTime(parsed.year, parsed.month, parsed.day);
      if (day == today) count++;
    }
    return count;
  }

  num _totalEarnings(List<FinishedTripModel> finished) {
    return finished.fold<num>(0, (sum, trip) => sum + trip.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: BlocBuilder<GetFinishedTripsCubit, GetFinishedTripsState>(
        builder: (context, finishedState) {
          return BlocBuilder<GetStartedTripsCubit, GetStartedTripsState>(
            builder: (context, currentState) {
              final finishedTrips = finishedState is GetFinishedTripsSuccess
                  ? finishedState.trips
                  : const <FinishedTripModel>[];
              final currentTrips = currentState is GetStartedTripsSuccess
                  ? currentState.trips
                  : const <ActiveTripModel>[];

              final isInitialLoading =
                  (finishedState is GetFinishedTripsLoading ||
                          finishedState is GetFinishedTripsInitial) &&
                      (currentState is GetStartedTripsLoading ||
                          currentState is GetStartedTripsInitial);

              final finishedFailed = finishedState is GetFinishedTripsFailure;
              final currentFailed = currentState is GetStartedTripsFailure;

              return Column(
                children: [
                  const TripsHeader(),
                  Expanded(
                    child: Transform.translate(
                      offset: Offset(0, -18.h),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: TripsUiConstants.horizontalPadding.w,
                        ),
                        child: Column(
                          children: [
                            if (isInitialLoading)
                              const Expanded(child: SingleChildScrollView(child: TripsSkeleton()))
                            else if (finishedFailed && currentFailed)
                              Expanded(
                                child: _TripsErrorState(
                                  message: finishedState.errMessage,
                                  onRetry: () {
                                    context
                                        .read<GetFinishedTripsCubit>()
                                        .fetchFinishedTrips();
                                    context
                                        .read<GetStartedTripsCubit>()
                                        .fetchStartedTrips();
                                  },
                                ),
                              )
                            else ...[
                              TripsStatistics(
                                totalTrips:
                                    currentTrips.length + finishedTrips.length,
                                tripsToday: _tripsTodayCount(
                                  currentTrips,
                                  finishedTrips,
                                ),
                                totalEarnings: _totalEarnings(finishedTrips),
                              ),
                              SizedBox(
                                height: TripsUiConstants.sectionSpacing.h,
                              ),
                              TripsSegmentedTabs(
                                selectedIndex: _tabController.index,
                                onChanged: (index) {
                                  _tabController.animateTo(index);
                                  setState(() {});
                                },
                              ),
                              SizedBox(
                                height: TripsUiConstants.sectionSpacing.h,
                              ),
                              Expanded(
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    _CurrentTabBody(
                                      state: currentState,
                                      onTripTap: _openCurrentTrip,
                                      onBackHome: () =>
                                          Navigator.maybePop(context),
                                      onRetry: () => context
                                          .read<GetStartedTripsCubit>()
                                          .fetchStartedTrips(),
                                    ),
                                    _FinishedTabBody(
                                      state: finishedState,
                                      onTripTap: _openFinishedTrip,
                                      onBackHome: () =>
                                          Navigator.maybePop(context),
                                      onRetry: () => context
                                          .read<GetFinishedTripsCubit>()
                                          .fetchFinishedTrips(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _CurrentTabBody extends StatelessWidget {
  const _CurrentTabBody({
    required this.state,
    required this.onTripTap,
    required this.onBackHome,
    required this.onRetry,
  });

  final GetStartedTripsState state;
  final ValueChanged<ActiveTripModel> onTripTap;
  final VoidCallback onBackHome;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final currentState = state;
    if (currentState is GetStartedTripsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (currentState is GetStartedTripsFailure) {
      return _TripsErrorState(
        message: currentState.errMessage,
        onRetry: onRetry,
      );
    }
    if (currentState is GetStartedTripsSuccess) {
      return TripsList.current(
        currentTrips: currentState.trips,
        onCurrentTap: onTripTap,
        onBackHome: onBackHome,
      );
    }
    return const SizedBox.shrink();
  }
}

class _FinishedTabBody extends StatelessWidget {
  const _FinishedTabBody({
    required this.state,
    required this.onTripTap,
    required this.onBackHome,
    required this.onRetry,
  });

  final GetFinishedTripsState state;
  final ValueChanged<FinishedTripModel> onTripTap;
  final VoidCallback onBackHome;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final finishedState = state;
    if (finishedState is GetFinishedTripsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (finishedState is GetFinishedTripsFailure) {
      return _TripsErrorState(
        message: finishedState.errMessage,
        onRetry: onRetry,
      );
    }
    if (finishedState is GetFinishedTripsSuccess) {
      return TripsList.finished(
        finishedTrips: finishedState.trips,
        onFinishedTap: onTripTap,
        onBackHome: onBackHome,
      );
    }
    return const SizedBox.shrink();
  }
}

class _TripsErrorState extends StatelessWidget {
  const _TripsErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 40.sp,
              color: AuthUiConstants.iconMuted,
            ),
            SizedBox(height: 12.h),
            Text(
              message.isNotEmpty
                  ? message
                  : AppTranslations.getText(context, 'error_occurred'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AuthUiConstants.textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(AppTranslations.getText(context, 'retry')),
              style: TextButton.styleFrom(foregroundColor: AppColors.main1),
            ),
          ],
        ),
      ),
    );
  }
}
