import 'dart:async';
import 'dart:math' as math;

import 'package:drever_warr/features/home/preasntaion/data/cubit/cubit_update_location/cubit_state.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/model/model_finsh_trips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/service/soket_serves.dart';

import '../../../../core/cash/preferences_servis.dart';
import '../../../../core/transleat/app_translat.dart';
import '../../../home/preasntaion/data/cubit/cubit_update_location/cubit.dart';
import '../../../home/preasntaion/view/home_view.dart';
import '../../../my_oreder/preasntaion/data/cubit/cubet_end_tripe/cubit.dart';
import '../../../my_oreder/preasntaion/data/cubit/cubet_end_tripe/cubit_stat.dart';
import '../../../my_oreder/preasntaion/data/cubit/model/accsept_model.dart';
import '../widget/TripLocationPath.dart';
import 'details_trip.dart';

class EndTripe extends StatefulWidget {
  final ActiveTripModel trip;
  final TripSocketService socketService;

  const EndTripe({
    super.key,
    required this.trip,
    required this.socketService,
  });

  @override
  State<EndTripe> createState() => _EndTripeState();
}

class _EndTripeState extends State<EndTripe> {
  final Completer<GoogleMapController> _mapController = Completer();

  final PolylinePoints polylinePoints = PolylinePoints(
    apiKey: "AIzaSyC7HVNoQEjaMe07kLwpKAO7k_ZbDpZTpI4",
  );

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];

  LatLng? _currentPosition;
  LatLng? _previousPosition;
  StreamSubscription<Position>? _positionStream;

  double? _priceNow;
  DateTime? _lastPriceUpdate;

  BitmapDescriptor? _driverMarkerIcon;
  double _markerRotation = 90.0; // image front is facing left

  @override
  void initState() {
    super.initState();
    _initEverything();
  }

  Future<void> _initEverything() async {
    await _loadDriverMarkerIcon();
    await _loadInitialPosition();
    _startTracking();
    _setupSocketListener();
    await _getRoutePolyline();
    _updateUI();
  }

  Future<void> _loadDriverMarkerIcon() async {
    try {
      _driverMarkerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(64, 64)),
        ImageAssets.care,
      );
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

  void _updateMarkerRotation(Position position, LatLng newPosition) {
    final bool hasGoodHeading =
        position.speed > 0.5 && position.heading >= 0 && position.heading <= 360;

    double rotation;

    if (_previousPosition != null) {
      final bearing = _bearingBetween(_previousPosition!, newPosition);

      // The car image faces left, so add 90 degrees to align it with travel direction.
      rotation = _normalizeAngle(bearing + 90.0);
    } else if (hasGoodHeading) {
      rotation = _normalizeAngle(position.heading + 90.0);
    } else {
      rotation = _markerRotation;
    }

    _markerRotation = rotation;
    _previousPosition = newPosition;
  }

  Future<void> _loadInitialPosition() async {
    final position = await Geolocator.getCurrentPosition();
    _currentPosition = LatLng(position.latitude, position.longitude);
    _previousPosition = _currentPosition;

    if (position.heading >= 0) {
      _markerRotation = _normalizeAngle(position.heading + 90.0);
    }
  }

  void _setupSocketListener() {
    widget.socketService.joinTrip(widget.trip.id.toString());

    widget.socketService.listenToDriverLocationUpdates((data) {
      try {
        final payload = _extractPayload(data);

        final price = _extractPriceNow(payload);
        final socketLocation = _extractLocation(payload);

        if (!mounted) return;

        setState(() {
          if (price != null) {
            _priceNow = price;
            _lastPriceUpdate = DateTime.now();
          }

          if (socketLocation != null) {
            // Kept intentionally for future use.
          }
        });
      } catch (e) {
        debugPrint('Socket price parse error: $e');
      }
    });
  }

  void _startTracking() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((pos) async {
      final newPosition = LatLng(pos.latitude, pos.longitude);

      _updateMarkerRotation(pos, newPosition);
      _currentPosition = newPosition;

      _sendDriverLocation(pos, widget.trip.id.toString());

      try {
        final GoogleMapController controller = await _mapController.future;
        controller.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
      } catch (_) {}

      _updateUI();
    });
  }

  Future<void> _getRoutePolyline() async {
    if (_currentPosition == null) return;

    final destination = LatLng(
      widget.trip.destinationLat ?? 35.5111,
      widget.trip.destinationLng ?? 35.7922,
    );

    final result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        ),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      _polylineCoordinates = result.points
          .map((p) => LatLng(p.latitude, p.longitude))
          .toList();
    } else {
      _polylineCoordinates = [_currentPosition!, destination];
    }
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

  Future<void> _sendEmergencyLocation(LatLng? position, String tripId) async {
    if (position == null) return;

    final address = await _getAddressFromLatLng(
      position.latitude,
      position.longitude,
    );

    if (!mounted) return;

    context.read<DriverLocationCubit>().updateEmergencyLocationForTrip(
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
        ].where((e) => e != null && e!.isNotEmpty).map((e) => e!).join(', ');
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
        ),
        Marker(
          markerId: const MarkerId("destination"),
          position: LatLng(
            widget.trip.destinationLat ?? 35.5111,
            widget.trip.destinationLng ?? 35.7922,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet,
          ),
        ),
      };

      _polylines = {
        Polyline(
          polylineId: const PolylineId("route_line"),
          points: _polylineCoordinates.isNotEmpty
              ? _polylineCoordinates
              : [
            _currentPosition!,
            LatLng(
              widget.trip.destinationLat ?? 35.5111,
              widget.trip.destinationLng ?? 35.7922,
            ),
          ],
          color: AppColors.main1,
          width: 6,
        ),
      };
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

  double? _extractPriceNow(Map<String, dynamic> payload) {
    final candidates = <dynamic>[
      payload['priceNow'],
      payload['price_now'],
      payload['currentPrice'],
      payload['current_price'],
      payload['price'],
      payload['fare'],
      payload['tripPrice'],
    ];

    for (final value in candidates) {
      final parsed = _toDouble(value);
      if (parsed != null) return parsed;
    }

    final nestedTrip = payload['trip'];
    if (nestedTrip is Map) {
      final nestedMap = Map<String, dynamic>.from(nestedTrip);
      final nestedCandidates = <dynamic>[
        nestedMap['priceNow'],
        nestedMap['price_now'],
        nestedMap['currentPrice'],
        nestedMap['current_price'],
        nestedMap['price'],
        nestedMap['fare'],
      ];

      for (final value in nestedCandidates) {
        final parsed = _toDouble(value);
        if (parsed != null) return parsed;
      }
    }

    return null;
  }

  LatLng? _extractLocation(Map<String, dynamic> payload) {
    final candidates = <dynamic>[
      payload['location'],
      payload['driverLocation'],
      payload['currentLocation'],
      payload['position'],
    ];

    for (final item in candidates) {
      if (item is Map) {
        final map = Map<String, dynamic>.from(item);

        final lat = _toDouble(
          map['lat'] ?? map['latitude'] ?? map['y'],
        );
        final lng = _toDouble(
          map['lng'] ?? map['longitude'] ?? map['x'],
        );

        if (lat != null && lng != null) {
          return LatLng(lat, lng);
        }
      }
    }

    final lat = _toDouble(payload['lat'] ?? payload['latitude']);
    final lng = _toDouble(payload['lng'] ?? payload['longitude']);

    if (lat != null && lng != null) {
      return LatLng(lat, lng);
    }

    return null;
  }

  double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  String _formatPrice(double price) {
    final isWhole = price == price.roundToDouble();
    return isWhole ? price.toInt().toString() : price.toStringAsFixed(2);
  }

  Widget _buildPriceCard() {
    final hasPrice = _priceNow != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.main1.withOpacity(0.45),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.main1,
            offset: const Offset(0, 3),
            blurRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 8),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.main1.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.payments_outlined,
              color: AppColors.main1,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'السعر الحالي',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  hasPrice ? _formatPrice(_priceNow!) : 'جاري التحديث...',
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: hasPrice ? AppColors.main1 : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (_lastPriceUpdate != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'آخر تحديث',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  TimeOfDay.fromDateTime(_lastPriceUpdate!).format(context),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _positionStream?.cancel();

    try {
      widget.socketService.socket.off('driver_location_update');
    } catch (_) {}

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocListener<EndTripCubit, EndTripState>(
        listener: (context, state) {
          if (!mounted) return;

          if (state is EndTripSuccess) {
            widget.socketService.dispose();

            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppTranslations.getText(
                    context,
                    "trip_finished_successfully",
                  ),
                ),
                backgroundColor: Colors.green,
              ),
            );

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsOfTheCompletedTrip(
                    tripId: widget.trip.id.toString(),
                  ),
                ),
              );
            });
          } else if (state is EndTripFailure) {
            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocListener<DriverLocationCubit, DriverLocationState>(
          listener: (context, state) {
            if (state is DriverLocationFailure) {
              debugPrint('Location update failed: ${state.errMessage}');
            }

            if (state is DriverLocationSuccess) {
              debugPrint('Location updated successfully');
            }
          },
          child: Scaffold(
            body: Stack(
              children: [
                _currentPosition == null
                    ? const Center(child: CircularProgressIndicator())
                    : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition!,
                    zoom: 15,
                  ),
                  onMapCreated: (c) => _mapController.complete(c),
                  markers: _markers,
                  polylines: _polylines,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                ),
                Positioned(
                  top: 60.h,
                  left: 20.w,
                  right: 20.w,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                        color: AppColors.main1.withOpacity(0.5),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.main1,
                          offset: const Offset(0, 3),
                          blurRadius: 0,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          offset: const Offset(0, 8),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: TripLocationPath(
                      startLocation: widget.trip.sourceAddress,
                      endLocation: widget.trip.destinationAddress,
                      dashHeight: 30,
                      startIconColor: Colors.blue,
                      endIconColor: Colors.purple,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 120.h,
                  left: 20.w,
                  right: 20.w,
                  child: _buildPriceCard(),
                ),
                Positioned(
                  bottom: 40.h,
                  left: 20.w,
                  child: BlocBuilder<EndTripCubit, EndTripState>(
                    builder: (context, state) {
                      if (state is EndTripLoading) {
                        return const CircularProgressIndicator();
                      }
                      return ElevatedButton(
                        onPressed: () {
                          context.read<EndTripCubit>().completeTrip(
                            tripId: widget.trip.id.toString(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 10.h,
                          ),
                        ),
                        child: Text(
                          AppTranslations.getText(context, "end_trip"),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 30.h,
                  right: 20.w,
                  child: GestureDetector(
                    onTap: () {
                      if (_currentPosition != null) {
                        _sendEmergencyLocation(
                          _currentPosition,
                          widget.trip.id.toString(),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppTranslations.getText(context, "emergency_sent"),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Image.asset(ImageAssets.emergency, height: 65.h),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}