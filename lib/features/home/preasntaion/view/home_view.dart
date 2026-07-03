import 'dart:async';
import 'dart:math' as math;

import 'package:drever_warr/features/home/preasntaion/view/menew.dart';
import 'package:drever_warr/features/home/preasntaion/widget/header_home_view.dart';
import 'package:drever_warr/core/cash/preferences_servis.dart';
import 'package:drever_warr/core/service/notification_service.dart';
import 'package:drever_warr/features/preasntaion/widhets/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_profail/cubit.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_profail/cubit_stat.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/cubit_wallat/cubit.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/cubit_wallat/cubit_stat.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/transleat/app_translat.dart';
import '../data/cubit/cubit_update_location/cubit.dart';
import '../data/cubit/cubit_update_location/cubit_state.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GoogleMapController? _mapController;
  LatLng? _currentPosition;

  bool _isInitialLoading = true;
  bool _isSendingLocation = false;
  bool _mapReady = false;
  bool _locationPermissionGranted = false;

  bool _profileLoaded = false;
  bool _walletLoaded = false;
  bool _locationAttemptFinished = false;

  bool _showBlockingError = false;
  bool _permissionDeniedError = false;
  String _blockingErrorMessage = '';

  int _redirectSecondsLeft = 3;
  Timer? _redirectTimer;

  StreamSubscription<Position>? _positionSubscription;

  LatLng? _lastSentPosition;
  DateTime? _lastSentAt;

  LatLng? _previousPosition;
  double _markerRotation = 100.0;

  BitmapDescriptor? _carMarkerIcon;

  static const CameraPosition _kDefaultLocation = CameraPosition(
    target: LatLng(35.5112, 35.7908),
    zoom: 14.5,
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _startInitialLoad();
    });
  }

  @override
  void dispose() {
    _redirectTimer?.cancel();
    _positionSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  void _startInitialLoad() {
    _redirectTimer?.cancel();

    setState(() {
      _isInitialLoading = true;
      _showBlockingError = false;
      _permissionDeniedError = false;
      _blockingErrorMessage = '';
      _redirectSecondsLeft = 3;

      _profileLoaded = false;
      _walletLoaded = false;
      _locationAttemptFinished = false;
    });

    context.read<ProfileCubit>().getProfileData();
    context.read<WalletCubit>().fetchWalletOperations();
    _determinePosition();
  }

  void _refreshAllData() {
    _startInitialLoad();
  }

  Future<void> _loadCarMarkerIcon() async {
    try {
      _carMarkerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(96, 96)),
        ImageAssets.care,
      );
    } catch (e) {
      debugPrint('Failed to load car marker icon: $e');
      _carMarkerIcon = null;
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
    double rotation;

    final bool hasGoodHeading =
        position.speed > 0.5 && position.heading >= 0 && position.heading <= 360;

    if (_previousPosition != null) {
      final bearing = _bearingBetween(_previousPosition!, newPosition);

      // The car image points LEFT by default, so add 90 degrees
      // to align the front of the image with the travel direction.
      rotation = _normalizeAngle(bearing + 90.0);
    } else if (hasGoodHeading) {
      rotation = _normalizeAngle(position.heading + 90.0);
    } else {
      rotation = _markerRotation;
    }

    _markerRotation = rotation;
    _previousPosition = newPosition;
  }

  Future<void> _determinePosition() async {
    try {
      await _loadCarMarkerIcon();

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            _isInitialLoading = false;
            _locationPermissionGranted = false;
            _locationAttemptFinished = true;
          });
        }
        _maybeFinishInitialLoading();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _isInitialLoading = false;
            _locationPermissionGranted = false;
            _locationAttemptFinished = true;
          });
        }
        _maybeFinishInitialLoading();
        return;
      }

      _locationPermissionGranted = true;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;

      final current = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentPosition = current;
        _previousPosition = current;
        _markerRotation = _normalizeAngle(position.heading + 90.0);
        _locationAttemptFinished = true;
      });

      await _moveCameraToCurrentPosition(force: true);
      await _sendDriverLocation(position, force: true);
      _startLocationTracking();
      _maybeFinishInitialLoading();
    } catch (e) {
      debugPrint('Determine position error: $e');
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
          _locationPermissionGranted = false;
          _locationAttemptFinished = true;
        });
      }
      _maybeFinishInitialLoading();
    }
  }

  void _startLocationTracking() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionSubscription?.cancel();
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((position) async {
      if (!mounted) return;

      final newPosition = LatLng(position.latitude, position.longitude);

      _updateMarkerRotation(position, newPosition);

      setState(() {
        _currentPosition = newPosition;
      });

      await _moveCameraToCurrentPosition();
      await _sendDriverLocation(position);
    });
  }

  Future<void> _moveCameraToCurrentPosition({bool force = false}) async {
    if (_mapController == null || _currentPosition == null) return;
    if (!_mapReady && !force) return;

    try {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 16),
      );
    } catch (e) {
      debugPrint('Camera move error: $e');
    }
  }

  Future<void> _sendDriverLocation(Position position, {bool force = false}) async {
    if (_isSendingLocation) return;

    final currentLatLng = LatLng(position.latitude, position.longitude);

    if (!force && _lastSentPosition != null) {
      final distance = Geolocator.distanceBetween(
        _lastSentPosition!.latitude,
        _lastSentPosition!.longitude,
        currentLatLng.latitude,
        currentLatLng.longitude,
      );

      final now = DateTime.now();
      final lastSentTooRecently =
          _lastSentAt != null && now.difference(_lastSentAt!).inSeconds < 5;

      if (distance < 10 && lastSentTooRecently) {
        return;
      }
    }

    _isSendingLocation = true;

    try {
      final address = await _getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      context.read<DriverLocationCubit>().updateDriverLocation(
        longitude: position.longitude,
        latitude: position.latitude,
        address: address,
      );

      _lastSentPosition = currentLatLng;
      _lastSentAt = DateTime.now();
    } catch (e) {
      debugPrint('Send driver location error: $e');
    } finally {
      _isSendingLocation = false;
    }
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
    } catch (e) {
      debugPrint('Reverse geocoding error: $e');
    }

    return '';
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapReady = true;

    if (_currentPosition != null) {
      _moveCameraToCurrentPosition(force: true);
    }
  }

  void _maybeFinishInitialLoading() {
    if (!mounted) return;
    if (_showBlockingError || _permissionDeniedError) return;

    if (_profileLoaded && _walletLoaded && _locationAttemptFinished) {
      setState(() {
        _isInitialLoading = false;
      });
    }
  }

  bool _looksLikePermissionDenied(String message) {
    final lower = message.toLowerCase();
    return lower.contains('permission denied') ||
        lower.contains('unauthorized') ||
        lower.contains('not authorized') ||
        lower.contains('401') ||
        lower.contains('403');
  }

  Future<bool> _showExitAppDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22.r),
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
                  color: Colors.black.withOpacity(0.08),
                  offset: const Offset(0, 10),
                  blurRadius: 18,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withOpacity(0.08),
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 34.sp,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  AppTranslations.getText(context, "leave_app"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  AppTranslations.getText(context, "work_not_saved"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    height: 1.4,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 22.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext, false);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors.main1,
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 13.h),
                        ),
                        child: Text(
                          AppTranslations.getText(context, "stay"),
                          style: TextStyle(
                            color: AppColors.main1,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext, true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.main1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 13.h),
                          elevation: 0,
                        ),
                        child: Text(
                          AppTranslations.getText(context, "leave"),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    return result ?? false;
  }

  String _extractStateMessage(dynamic state) {
    try {
      final dynamic msg = state.errMessage;
      if (msg != null && msg.toString().trim().isNotEmpty) {
        return msg.toString();
      }
    } catch (_) {}

    try {
      final dynamic msg = state.message;
      if (msg != null && msg.toString().trim().isNotEmpty) {
        return msg.toString();
      }
    } catch (_) {}

    return state.toString();
  }

  void _showRetryableError(String message) {
    if (!mounted) return;

    _redirectTimer?.cancel();

    setState(() {
      _isInitialLoading = false;
      _showBlockingError = true;
      _permissionDeniedError = false;
      _blockingErrorMessage = message.trim().isNotEmpty
          ? message
          : AppTranslations.getText(context, "general_retry_error");
    });
  }

  void _showPermissionDeniedError(String message) {
    if (!mounted) return;

    _redirectTimer?.cancel();

    setState(() {
      _isInitialLoading = false;
      _showBlockingError = true;
      _permissionDeniedError = true;
      _blockingErrorMessage = message.trim().isNotEmpty
          ? message
          : AppTranslations.getText(context, "permission_denied_login_again");
      _redirectSecondsLeft = 3;
    });

    _startLoginRedirectCountdown();
  }

  void _startLoginRedirectCountdown() {
    _redirectTimer?.cancel();

    _redirectTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_redirectSecondsLeft <= 1) {
        timer.cancel();
        _goToLogin();
        return;
      }

      setState(() {
        _redirectSecondsLeft--;
      });
    });
  }

  Future<void> _goToLogin() async {
    if (!mounted) return;

    await NotificationService.instance.clearToken();
    await CacheManager.clearSession();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginView(),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: Container(
          color: Colors.black.withOpacity(0.08),
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 24.h),
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.88),
                borderRadius: BorderRadius.circular(22.r),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                    color: Colors.black.withOpacity(0.08),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    AppTranslations.getText(context, "detecting_location"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorOverlay() {
    final bool isPermissionDenied = _permissionDeniedError;

    return Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: Container(
          color: Colors.black.withOpacity(0.12),
          child: Center(
            child: Container(
              width: 300.w,
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.92),
                borderRadius: BorderRadius.circular(22.r),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                    color: Colors.black.withOpacity(0.10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 58.w,
                    height: 58.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(0.08),
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 34.sp,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    _blockingErrorMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  if (!isPermissionDenied)
                    GestureDetector(
                      onTap: _refreshAllData,
                      child: Container(
                        width: 56.w,
                        height: 56.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 1.5,
                          ),
                          color: Colors.transparent,
                        ),
                        child: Icon(
                          Icons.refresh_rounded,
                          size: 30.sp,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  else
                    Text(
                      AppTranslations.getText(context, "redirecting_to_login_in")
                          .replaceAll('{seconds}', '$_redirectSecondsLeft'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDriverMarker() {
    return Transform.rotate(
      angle: _markerRotation * math.pi / 180.0,
      child: Image.asset(
        ImageAssets.care,
        width: 56.w,
        height: 56.w,
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = context.watch<ProfileCubit>().state;
    final walletState = context.watch<WalletCubit>().state;
    final bool isProfileLoading = profileState is ProfileLoading;

    String? imagePath;
    num balance = 0;

    if (profileState is ProfileSuccess) {
      imagePath = profileState.data.data?.profileImage;
    }

    if (walletState is WalletSuccess) {
      balance = walletState.walletData.driverBalance;
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;

          final shouldExit = await _showExitAppDialog();
          if (shouldExit && mounted) {
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          drawerScrimColor: Colors.transparent,
          key: _scaffoldKey,
          drawer: const MenueView(),
          body: MultiBlocListener(
            listeners: [
              BlocListener<ProfileCubit, ProfileState>(
                listener: (context, state) {
                  final typeName = state.runtimeType.toString().toLowerCase();

                  if (typeName.contains('success')) {
                    if (!mounted) return;
                    setState(() {
                      _profileLoaded = true;
                    });
                    _maybeFinishInitialLoading();
                    return;
                  }

                  if (typeName.contains('failure') || typeName.contains('error')) {
                    final message = _extractStateMessage(state);
                    if (_looksLikePermissionDenied(message)) {
                      _showPermissionDeniedError(
                        AppTranslations.getText(context, "permission_denied_login_again"),
                      );
                    } else {
                      _showRetryableError(
                        message.isNotEmpty
                            ? message
                            : AppTranslations.getText(context, "failed_load_profile"),
                      );
                    }
                  }
                },
              ),
              BlocListener<WalletCubit, WalletState>(
                listener: (context, state) {
                  final typeName = state.runtimeType.toString().toLowerCase();

                  if (typeName.contains('success')) {
                    if (!mounted) return;
                    setState(() {
                      _walletLoaded = true;
                    });
                    _maybeFinishInitialLoading();
                    return;
                  }

                  if (typeName.contains('failure') || typeName.contains('error')) {
                    final message = _extractStateMessage(state);
                    if (_looksLikePermissionDenied(message)) {
                      _showPermissionDeniedError(
                        AppTranslations.getText(context, "permission_denied_login_again"),
                      );
                    } else {
                      _showRetryableError(
                        message.isNotEmpty
                            ? message
                            : AppTranslations.getText(context, "failed_load_wallet"),
                      );
                    }
                  }
                },
              ),
              BlocListener<DriverLocationCubit, DriverLocationState>(
                listener: (context, state) {
                  if (state is DriverLocationFailure) {
                    debugPrint('Location update failed: ${state.errMessage}');
                  }
                },
              ),
            ],
            child: Stack(
              children: [
                Column(
                  children: [
                    HeaderHomeView(
                      imagePath: imagePath,
                      driverBalance: balance,
                      isProfileLoading: isProfileLoading,
                      onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          _currentPosition == null
                              ? const Center(child: CircularProgressIndicator())
                              : GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: _currentPosition!,
                              zoom: 15,
                            ),
                            mapType: MapType.normal,
                            zoomControlsEnabled: false,
                            myLocationButtonEnabled: false,
                            myLocationEnabled: false,
                            onMapCreated: _onMapCreated,
                            onCameraMove: (position) {
                              _currentPosition = position.target;
                            },
                            markers: {
                              Marker(
                                markerId: const MarkerId('driver_location'),
                                position: _currentPosition!,
                                icon: _carMarkerIcon ??
                                    BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueAzure,
                                    ),
                                rotation: _markerRotation,
                                flat: true,
                                anchor: const Offset(0.5, 0.5),
                              ),
                            },
                          ),
                          Positioned(
                            bottom: 20.h,
                            right: 20.w,
                            child: FloatingActionButton(
                              mini: true,
                              backgroundColor: Colors.white,
                              onPressed: _determinePosition,
                              child: const Icon(
                                Icons.my_location,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (_isInitialLoading) _buildLoadingOverlay(),
                if (_showBlockingError) _buildErrorOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}