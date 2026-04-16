 
import 'dart:async';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/cubet_end_tripe/cubit.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/cubet_end_tripe/cubit_stat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

 
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/widget/TripLocationPath.dart';
import 'package:drever_warr/core/service/soket_serves.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/model/accsept_model.dart';

 

class EndTripe extends StatefulWidget {
  final ActiveTripModel trip;
  final TripSocketService socketService; 

  const EndTripe({super.key, required this.trip, required this.socketService});

  @override
  _EndTripeState createState() => _EndTripeState();
}

class _EndTripeState extends State<EndTripe> {
  final Completer<GoogleMapController> _mapController = Completer();

  Set<Marker> _markers = {};
  LatLng? _currentPosition;
  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _initTracking();
  }

  Future<void> _initTracking() async {
    Position position = await Geolocator.getCurrentPosition();
    _currentPosition = LatLng(position.latitude, position.longitude);
    _updateUI();

    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5,
          ),
        ).listen((pos) {
          _currentPosition = LatLng(pos.latitude, pos.longitude);

          // نستمر بإرسال الموقع عبر السوكيت المفتوح
          widget.socketService.sendLocation(
            tripId: widget.trip.id.toString(),
            location: _currentPosition!,
          );

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
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    
    // widget.socketService.dispose(widget.trip.id.toString());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
       
      child: BlocListener<EndTripCubit, EndTripState>(
        listener: (context, state) {
          if (state is EndTripSuccess) {
            
            widget.socketService.dispose(widget.trip.id.toString());

           
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("تم إنهاء الرحلة بنجاح"),
                backgroundColor: Colors.green,
              ),
            );

           
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (state is EndTripFailure) {
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
                      myLocationEnabled: true,
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
                      child: const Text(
                        "انتهت الرحلة",
                        style: TextStyle(
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
                      widget.socketService.sendEmergency(
                        tripId: widget.trip.id.toString(),
                        location: _currentPosition!,
                        userId: "driver_id",  
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("تم إرسال إشارة الطوارئ!"),
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
    );
  }
}
