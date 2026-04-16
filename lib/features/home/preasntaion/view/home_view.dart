 
import 'package:drever_warr/features/home/preasntaion/view/menew.dart';
import 'package:drever_warr/features/home/preasntaion/widget/header_home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

 
import 'package:drever_warr/features/setting/data/cubit/cubit_profail/cubit.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_profail/cubit_stat.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/cubit_wallat/cubit.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/cubit_wallat/cubit_stat.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  bool _isLoading = true;

  
  static const CameraPosition _kDefaultLocation = CameraPosition(
    target: LatLng(35.5112, 35.7908),
    zoom: 14.5,
  );

  @override
  void initState() {
    super.initState();

    
    context.read<ProfileCubit>().getProfileData();

    
    context.read<WalletCubit>().fetchWalletOperations();

    
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (mounted) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
      _moveCameraToCurrentPosition();
    }
  }

  void _moveCameraToCurrentPosition() {
    if (_mapController != null && _currentPosition != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 16),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        drawerScrimColor: Colors.transparent,
        key: _scaffoldKey,
        drawer: const MenueView(),
        body: Column(
          children: [
           
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, profileState) {
                return BlocBuilder<WalletCubit, WalletState>(
                  builder: (context, walletState) {
                    String? imagePath;
                    num balance = 0;

                    
                    if (profileState is ProfileSuccess) {
                      imagePath = profileState.data.data?.profileImage;
                    }

                   
                    if (walletState is WalletSuccess) {
                      balance = walletState.walletData.driverBalance;
                    }

                    return HeaderHomeView(
                      imagePath: imagePath,
                      driverBalance: balance,
                      onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                    );
                  },
                );
              },
            ),

            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: _kDefaultLocation,
                    mapType: MapType.normal,
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                      if (_currentPosition != null) {
                        _moveCameraToCurrentPosition();
                      }
                    },
                  ),

                  if (_isLoading)
                    const Center(child: CircularProgressIndicator()),

                  
                  Positioned(
                    bottom: 20.h,
                    right: 20.w,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: Colors.white,
                      onPressed: _determinePosition,
                      child: const Icon(Icons.my_location, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
