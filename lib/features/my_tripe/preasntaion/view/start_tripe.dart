 
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';  

 
import 'package:drever_warr/core/cash/preferences_servis.dart';
import 'package:drever_warr/core/service/soket_serves.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/model/accsept_model.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/widget/header_order.dart';
import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/widget/TripLocationPath.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/view/end_tripe.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/cubit_start_order/cubit.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/cubit_start_order/cubit_stat.dart';

class LiveTripScreen extends StatefulWidget {
  final ActiveTripModel trip;
  const LiveTripScreen({super.key, required this.trip});

  @override
  State<LiveTripScreen> createState() => _LiveTripScreenState();
}

class _LiveTripScreenState extends State<LiveTripScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  final TripSocketService _socketService = TripSocketService();

   
  final PolylinePoints polylinePoints = PolylinePoints(
    apiKey: "YOUR_GOOGLE_MAPS_API_KEY",
  );
  List<LatLng> polylineCoordinates = [];

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  LatLng? _currentPosition;
  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _initEverything();
  }

  Future<void> _initEverything() async {
    String? token = await CacheManager.getData('token');
    if (token != null) _socketService.connect(token);
    _socketService.joinTrip(widget.trip.id.toString());

    Position position = await Geolocator.getCurrentPosition();
    _currentPosition = LatLng(position.latitude, position.longitude);

     
    await _getPolyline();

    _updateUI();
    _startTracking();
  }

   
  Future<void> _getPolyline() async {
    if (_currentPosition == null) return;

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
       
      request: PolylineRequest(
        origin: PointLatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        ),
        destination: PointLatLng(widget.trip.startLat, widget.trip.startLng),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates.clear();
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      _updateUI();
    }
  }

  void _startTracking() {
    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,  
          ),
        ).listen((pos) async {
          _currentPosition = LatLng(pos.latitude, pos.longitude);

          _socketService.sendLocation(
            tripId: widget.trip.id.toString(),
            location: _currentPosition!,
          );

          final GoogleMapController controller = await _mapController.future;
          controller.animateCamera(CameraUpdate.newLatLng(_currentPosition!));

          
          _updateUI();
        });
  }

  void _updateUI() {
    if (_currentPosition == null) return;

    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId("driver"),
          position: _currentPosition!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: const InfoWindow(title: "موقعك الحالي"),
        ),
        Marker(
          markerId: const MarkerId("customer"),
          position: LatLng(widget.trip.startLat, widget.trip.startLng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: "موقع الركب"),
        ),
      };

      _polylines = {
        Polyline(
          polylineId: const PolylineId("route_line"),
          points: polylineCoordinates.isEmpty
              ? [
                  _currentPosition!,
                  LatLng(widget.trip.startLat, widget.trip.startLng),
                ]
              : polylineCoordinates,
          color: AppColors.main1,
          width: 6,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      };
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocListener<StartTripCubit, StartTripState>(
        listener: (context, state) {
          if (state is StartTripSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EndTripe(trip: widget.trip, socketService: _socketService),
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
                      myLocationEnabled: true,
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
                  child: HeaderOrder(con: false, onMenuTap: () {}),
                ),
              ),

              
              Positioned(
                bottom: 235.h,
                left: 20.w,
                child: BlocBuilder<StartTripCubit, StartTripState>(
                  builder: (context, state) {
                    if (state is StartTripLoading)
                      return const CircularProgressIndicator();
                    return GestureDetector(
                      onTap: () => context.read<StartTripCubit>().startTrip(
                        tripId: widget.trip.id.toString(),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9C4DB9),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: const CustomText(
                          "بدأت الرحلة",
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
        height: 220.h,
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
                      widget.trip.clientName,
                      type: AppTextType.titleSmall,
                    ),
                    CustomText(
                      widget.trip.clientPhone,
                      color: Colors.grey,
                      type: AppTextType.titleMedium,
                    ),
                  ],
                ),
                const Spacer(),
                _buildCircleIcon(IconsAssets.phonee, const Color(0xFF68B11E)),
                SizedBox(width: 10.w),
                _buildCircleIcon(IconsAssets.masseage, const Color(0xFF9C4DB9)),
              ],
            ),
            SizedBox(height: 15.h),
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
                      "${widget.trip.totalPrice.toStringAsFixed(0)} SYP",
                      color: AppColors.main1,
                      type: AppTextType.titleSmall,
                    ),
                    CustomText(
                      "${widget.trip.distance.toStringAsFixed(1)} كم",
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

  Widget _buildCircleIcon(String path, Color color) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: SvgPicture.asset(path, color: Colors.white, width: 20.sp),
    );
  }
}
