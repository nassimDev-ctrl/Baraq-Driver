import 'dart:async';
import 'dart:math' as math;

import 'package:drever_warr/features/my_tripe/presentation/widget/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:drever_warr/core/cash/preferences_service.dart';
import 'package:drever_warr/core/service/socket_service.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/model/accsept_model.dart';
import 'package:drever_warr/features/my_oreder/presentation/widget/header_order.dart';
import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/widgets/car_marker_painter.dart';
import 'package:drever_warr/core/widgets/animated_marker_controller.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/custom_text.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/trip_location_path.dart';
import 'package:drever_warr/features/my_tripe/presentation/view/end_tripe.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/cubit_start_order/cubit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/translate/app_translate.dart';
import '../../../home/presentation/data/cubit/cubit_update_location/cubit.dart';
import '../../../home/presentation/view/menew.dart';
import '../../../my_oreder/presentation/data/cubit/cubit_start_order/cubit_stat.dart';
import '../../../my_oreder/presentation/data/cubit/trip_details_cubit/cubit.dart';
import '../../../my_oreder/presentation/data/cubit/trip_details_cubit/cubit_state.dart';
import '../../../my_oreder/presentation/data/models/trip_response_model.dart';
import '../../data/cubit/cubit_trip_note/cubit.dart';
import '../../data/cubit/cubit_trip_note/cubit_state.dart';

class LiveTripScreen extends StatefulWidget {
  final ActiveTripModel trip;
  final String? imagePath;

  const LiveTripScreen({
    super.key,
    required this.trip,
    required this.imagePath,
  });

  @override
  State<LiveTripScreen> createState() => _LiveTripScreenState();
}

class _LiveTripScreenState extends State<LiveTripScreen>
    with TickerProviderStateMixin {
  final Completer<GoogleMapController> _mapController = Completer();
  final TripSocketService _socketService = TripSocketService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TripResponseModel? _tripDetails;

  final PolylinePoints polylinePoints = PolylinePoints(
    apiKey: "AIzaSyC7HVNoQEjaMe07kLwpKAO7k_ZbDpZTpI4",
  );

  List<LatLng> polylineCoordinates = [];
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  LatLng? _currentPosition;
  StreamSubscription<Position>? _positionStream;

  Timer? _confirmationTimer;
  bool _isStartUnlocked = false;

  BitmapDescriptor? _driverMarkerIcon;
  LatLng? _previousPosition;
  double _markerRotation = 0.0;
  AnimatedMarkerController? _markerAnimController;

  @override
  void initState() {
    super.initState();
    _initEverything();

    context.read<TripDetailsCubit>().fetchTripDetails(
      tripId: widget.trip.id.toString(),
    );

    context.read<TripNoteCubit>().fetchTripNote(
      tripId: widget.trip.id.toString(),
    );

    _startConfirmationPolling();
  }

  Future<void> _loadDriverMarkerIcon() async {
    try {
      _driverMarkerIcon = await DriverMarkerHelper.loadIcon();
    } catch (e) {
      debugPrint('Failed to load driver marker icon: $e');
      _driverMarkerIcon = null;
    }
  }

  double _normalizeAngle(double angle) {
    final normalized = angle % 360.0;
    return normalized < 0 ? normalized + 360.0 : normalized;
  }

  double _bearingBetween(LatLng from, LatLng to) {
    final lat1 = from.latitude * math.pi / 180.0;
    final lat2 = to.latitude * math.pi / 180.0;
    final dLon = (to.longitude - from.longitude) * math.pi / 180.0;

    final y = math.sin(dLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    final bearing = math.atan2(y, x) * 180.0 / math.pi;
    return _normalizeAngle(bearing);
  }

  void _updateMarkerRotation(Position pos, LatLng newPosition) {
    final bool hasHeading =
        pos.speed > 0.5 && pos.heading >= 0 && pos.heading <= 360;

    double rotation;

    if (_previousPosition != null) {
      final bearing = _bearingBetween(_previousPosition!, newPosition);

      // Image front faces left, so add 90 degrees to align it with travel direction.
      rotation = _normalizeAngle(bearing);
    } else if (hasHeading) {
      rotation = _normalizeAngle(pos.heading);
    } else {
      rotation = _markerRotation;
    }

    _markerRotation = rotation;
    _previousPosition = newPosition;
  }

  Future<void> _initEverything() async {
    String? token = await CacheManager.getData('token');
    if (token != null) {
      _socketService.connect(token);
    }

    _socketService.joinTrip(widget.trip.id.toString());
    _setupSocketListener();

    await _loadDriverMarkerIcon();

    Position position = await Geolocator.getCurrentPosition();
    _currentPosition = LatLng(position.latitude, position.longitude);
    _previousPosition = _currentPosition;

    if (position.heading >= 0) {
      _markerRotation = _normalizeAngle(position.heading);
    }

    _markerAnimController = AnimatedMarkerController(
      vsync: this,
      onUpdate: () {
        if (!mounted) return;
        _currentPosition = _markerAnimController!.position;
        _markerRotation = _markerAnimController!.rotation;
        _updateUI();
      },
      initialPosition: _currentPosition!,
      initialRotation: _markerRotation,
    );

    _socketService.sendLocation(
      tripId: widget.trip.id.toString(),
      location: _currentPosition!,
    );

    _updateUI();
    _startTracking();

    _checkTripConfirmationOnce();
  }

  void _setupSocketListener() {
    _socketService.listenToDriverLocationUpdates((data) {
      try {
        final payload = _extractPayload(data);
        final encodedPolyline = _extractEncodedPolyline(payload);

        if (!mounted) return;

        if (encodedPolyline != null) {
          setState(() {
            polylineCoordinates = _decodePolyline(encodedPolyline);
          });
          _updateUI();
        }
      } catch (e) {
        debugPrint('Socket polyline parse error: $e');
      }
    });
  }

  Map<String, dynamic> _extractPayload(dynamic data) {
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      if (map['data'] is Map) {
        return Map<String, dynamic>.from(map['data'] as Map);
      }
      return map;
    }
    return <String, dynamic>{};
  }

  String? _extractEncodedPolyline(Map<String, dynamic> payload) {
    final candidates = [
      payload['polyline'],
      payload['encodedPolyline'],
      payload['encoded_polyline'],
      payload['overview_polyline'],
    ];

    for (final value in candidates) {
      if (value is String && value.isNotEmpty) return value;
    }

    final trip = payload['trip'];
    if (trip is Map) {
      final tripMap = Map<String, dynamic>.from(trip);
      final tripCandidates = [
        tripMap['polyline'],
        tripMap['encodedPolyline'],
        tripMap['encoded_polyline'],
      ];
      for (final value in tripCandidates) {
        if (value is String && value.isNotEmpty) return value;
      }
    }

    return null;
  }

  List<LatLng> _decodePolyline(String encoded) {
    final List<LatLng> points = [];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int shift = 0;
      int result = 0;
      int byte;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      shift = 0;
      result = 0;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  void _startConfirmationPolling() {
    _confirmationTimer?.cancel();

    _confirmationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_isStartUnlocked) {
        timer.cancel();
        return;
      }

      _checkTripConfirmationOnce();
    });
  }

  void _checkTripConfirmationOnce() {
    if (!mounted) return;

    context
        .read<TripDetailsCubit>()
        .checkIfClientConfirmed(tripId: widget.trip.id.toString());
  }

  void _startTracking() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((pos) async {
      final newPos = LatLng(pos.latitude, pos.longitude);

      _updateMarkerRotation(pos, newPos);
      _sendDriverLocation(pos, widget.trip.id.toString());

      if (_markerAnimController != null) {
        _markerAnimController!.animateTo(newPos, _markerRotation);
      } else {
        _currentPosition = newPos;
        _updateUI();
      }
    });
  }

  TripDataModel? get _loadedTrip => _tripDetails?.data;

  String get _clientName {
    final client = _loadedTrip?.client;
    return client?.fullName ?? widget.trip.clientName;
  }

  String get _clientPhone {
    final client = _loadedTrip?.client;
    return client?.mobilePhone ?? widget.trip.clientPhone;
  }

  Future<void> _sendDriverLocation(Position position, String tripId) async {
    final address = await _getAddressFromLatLng(
      position.latitude,
      position.longitude,
    );

    if (!mounted) return;

    context.read<DriverLocationCubit>().updateDriverLocationForTrip(
      longitude: position.longitude,
      latitude: position.latitude,
      address: address,
      tripId: tripId,
    );
  }

  Future<String> _getAddressFromLatLng(
      double latitude,
      double longitude,
      ) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return [
          place.street,
          place.subLocality,
          place.locality,
          place.country,
        ].whereType<String>().where((e) => e.isNotEmpty).join(', ');
      }
    } catch (_) {}

    return '';
  }

  void _updateUI() {
    if (_currentPosition == null) return;

    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId("driver"),
          position: _currentPosition!,
          icon: _driverMarkerIcon ??
              BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure,
              ),
          rotation: _markerRotation,
          flat: true,
          anchor: const Offset(0.5, 0.5),
          infoWindow: InfoWindow(
            title: AppTranslations.getText(context, "your_current_location"),
          ),
        ),
        Marker(
          markerId: const MarkerId("customer"),
          position: LatLng(widget.trip.startLat, widget.trip.startLng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: AppTranslations.getText(context, "passenger_location"),
          ),
        ),
      };

      if (polylineCoordinates.isNotEmpty) {
        _polylines = {
          Polyline(
            polylineId: const PolylineId("route_line"),
            points: polylineCoordinates,
            color: AppColors.main1,
            width: 6,
            jointType: JointType.round,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
          ),
        };
      }
    });
  }

  @override
  void dispose() {
    _markerAnimController?.dispose();
    _positionStream?.cancel();
    _confirmationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MultiBlocListener(
        listeners: [
          BlocListener<TripDetailsCubit, TripDetailsState>(
            listener: (context, state) async {
              if (state is TripDetailsSuccess) {
                String? authUser = state.tripData.data.driver?.authUser;
                await CacheManager.saveData('authUser', authUser!);
                setState(() {
                  _tripDetails = state.tripData;
                });
              }

              if (state is TripStatusCheckSuccess) {
                if (state.isClientConfirmed) {
                  if (!mounted) return;

                  setState(() {
                    _isStartUnlocked = true;
                  });

                  _confirmationTimer?.cancel();
                }
              }
            },
          ),
          BlocListener<StartTripCubit, StartTripState>(
            listener: (context, state) {
              if (state is StartTripSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EndTripe(
                      trip: widget.trip,
                      socketService: _socketService,
                    ),
                  ),
                );
              } else if (state is StartTripFailure) {
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
        child: Scaffold(
          drawer: const MenueView(),
          backgroundColor: Colors.white,
          drawerScrimColor: Colors.transparent,
          key: _scaffoldKey,
          body: Stack(
            children: [
              _currentPosition == null
                  ? const Center(child: CircularProgressIndicator())
                  : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _currentPosition!,
                  zoom: 17,
                ),
                onMapCreated: (c) => _mapController.complete(c),
                markers: _markers,
                polylines: _polylines,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                padding: EdgeInsets.only(
                  bottom: 220.h,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: AppColors.secondary1,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                  ),
                  child: HeaderOrder(
                    con: false,
                    onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                    urgentCount: 5,
                    scheduledCount: 5,
                    imagePath: widget.imagePath,
                  ),
                ),
              ),
              Positioned(
                bottom: 300.h,
                left: 20.w,
                child: BlocBuilder<StartTripCubit, StartTripState>(
                  builder: (context, state) {
                    final bool isLoading = state is StartTripLoading;

                    return GestureDetector(
                      onTap: (_isStartUnlocked && !isLoading)
                          ? () => context.read<StartTripCubit>().startTrip(
                        tripId: widget.trip.id.toString(),
                      )
                          : null,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: _isStartUnlocked
                              ? const Color(0xFF9C4DB9)
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: isLoading
                            ? SizedBox(
                          width: 18.w,
                          height: 18.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : CustomText(
                          _isStartUnlocked
                              ? AppTranslations.getText(
                            context,
                            "trip_started",
                          )
                              : AppTranslations.getText(
                            context,
                            "waiting_passenger_confirmation",
                          ),
                          color: Colors.white,
                          type: AppTextType.titleMedium,
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildTripDetailsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripDetailsCard() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 280.h,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      _clientName,
                      type: AppTextType.titleSmall,
                    ),
                    CustomText(
                      _clientPhone,
                      color: Colors.grey,
                      type: AppTextType.titleMedium,
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    final String phoneNumber = widget.trip.clientPhone;
                    final Uri url = Uri(
                      scheme: 'tel',
                      path: phoneNumber.startsWith('+')
                          ? phoneNumber
                          : '+$phoneNumber',
                    );

                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: _buildCircleIcon(
                    IconAssets.phonee,
                    const Color(0xFF68B11E),
                  ),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: _tripDetails == null
                      ? null
                      : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DriverChatScreen(
                          socketService: _socketService,
                          trip: _tripDetails!,
                        ),
                      ),
                    );
                  },
                  child: Opacity(
                    opacity: _tripDetails == null ? 0.5 : 1,
                    child: _buildCircleIcon(
                      IconAssets.masseage,
                      const Color(0xFF9C4DB9),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _buildTripNoteSection(),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: TripLocationPath(
                    startLocation: widget.trip.sourceAddress,
                    endLocation: widget.trip.destinationAddress,
                    dashHeight: 30,
                  ),
                ),
                Column(
                  children: [
                    CustomText(
                      "${widget.trip.totalPrice.toStringAsFixed(0)} ${AppTranslations.getText(context, "currency_syp_short")}",
                      color: AppColors.main1,
                      type: AppTextType.titleSmall,
                    ),
                    CustomText(
                      "${widget.trip.distance.toStringAsFixed(1)} ${AppTranslations.getText(context, "distance_km")}",
                      type: AppTextType.titleSmall,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripNoteSection() {
    return BlocBuilder<TripNoteCubit, TripNoteState>(
      builder: (context, state) {
        if (state is TripNoteLoading || state is TripNoteInitial) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F3FB),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: const Color(0xFF9C4DB9).withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF9C4DB9),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    AppTranslations.getText(context, "loading_note"),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                Icon(
                  Icons.sticky_note_2_outlined,
                  color: const Color(0xFF9C4DB9),
                  size: 20.sp,
                ),
              ],
            ),
          );
        }

        if (state is TripNoteFailure) {
          return const SizedBox.shrink();
        }

        final note = (state as TripNoteSuccess).note.trim();

        if (note.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F3FB),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: const Color(0xFF9C4DB9).withValues(alpha: 0.18),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.sticky_note_2_outlined,
                color: const Color(0xFF9C4DB9),
                size: 22.sp,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppTranslations.getText(context, "trip_note"),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF9C4DB9),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      note,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 13.sp,
                        height: 1.4,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCircleIcon(String path, Color color) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: SvgPicture.asset(
        path,
        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
        width: 20.sp,
      ),
    );
  }
}