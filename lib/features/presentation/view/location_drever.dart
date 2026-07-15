import 'dart:async';

import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/custom_text_field_search.dart';
import 'package:drever_warr/features/presentation/widgets/login.dart';
import 'package:drever_warr/features/presentation/widgets/regster.dart';
import 'package:drever_warr/features/presentation/widgets/row_search.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/translate/app_translate.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  GoogleMapController? mapController;
  final TextEditingController searchController = TextEditingController();

  final Dio _dio = Dio();
  Timer? _debounce;
  CancelToken? _autocompleteCancelToken;

  LatLng _currentCameraPosition = const LatLng(37.0500, 41.2200);
  LatLng? _lastReverseGeocodedPosition;

  List<dynamic> _predictions = [];
  final String apiKey = "AIzaSyC7HVNoQEjaMe07kLwpKAO7k_ZbDpZTpI4";

  String _currentFullAddress = "";
  bool _isDefaultAddress = true;
  double? _lat;
  double? _lng;

  bool _isLoadingLocation = true;
  bool _isResolvingAddress = false;


  @override
  void initState() {
    super.initState();
    _loadCurrentLocationFirst();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _autocompleteCancelToken?.cancel();
    searchController.dispose();
    mapController?.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentLocationFirst() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() => _isLoadingLocation = false);
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() => _isLoadingLocation = false);
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final current = LatLng(position.latitude, position.longitude);

      if (!mounted) return;

      setState(() {
        _currentCameraPosition = current;
        _lat = position.latitude;
        _lng = position.longitude;
        _isLoadingLocation = false;
      });

      await _getAddressFromLatLng(current);

      await mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(current, 16),
      );
    } catch (e) {
      debugPrint("Current Location Error: $e");
      if (mounted) {
        setState(() => _isLoadingLocation = false);
      }
    }
  }

  bool _isSameLocation(LatLng a, LatLng b) {
    return a.latitude == b.latitude && a.longitude == b.longitude;
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    if (_isResolvingAddress) return;

    if (_lastReverseGeocodedPosition != null &&
        _isSameLocation(_lastReverseGeocodedPosition!, position)) {
      return;
    }

    _isResolvingAddress = true;

    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {
          'latlng': '${position.latitude},${position.longitude}',
          'key': apiKey,
          'language': 'ar',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        final results = response.data['results'] as List<dynamic>;
        if (results.isNotEmpty) {
          setState(() {
            _currentFullAddress = results[0]['formatted_address'];
            _isDefaultAddress = false;
            _lat = position.latitude;
            _lng = position.longitude;
            _lastReverseGeocodedPosition = position;
          });
        }
      }
    } catch (e) {
      debugPrint("Geocoding Error: $e");
    } finally {
      _isResolvingAddress = false;
    }
  }

  void _onSearchChanged(String input) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 350), () {
      _getAutocompleteSuggestions(input);
    });
  }

  Future<void> _getAutocompleteSuggestions(String input) async {
    if (input.trim().isEmpty) {
      if (mounted) {
        setState(() => _predictions = []);
      }
      return;
    }

    _autocompleteCancelToken?.cancel();
    _autocompleteCancelToken = CancelToken();

    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: {
          'input': input.trim(),
          'key': apiKey,
          'language': 'ar',
          'types': 'geocode',
        },
        cancelToken: _autocompleteCancelToken,
      );

      if (!mounted) return;

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        setState(() => _predictions = response.data['predictions'] ?? []);
      } else {
        setState(() => _predictions = []);
      }
    } catch (e) {
      if (e is DioException && CancelToken.isCancel(e)) return;
      debugPrint("Autocomplete Error: $e");
    }
  }

  Future<void> _searchAndNavigate([String? customAddress]) async {
    final address = (customAddress ?? searchController.text).trim();
    if (address.isEmpty) return;

    FocusScope.of(context).unfocus();

    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {
          'address': address,
          'key': apiKey,
          'language': 'ar',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        final location = response.data['results'][0]['geometry']['location'];
        final target = LatLng(location['lat'], location['lng']);

        await mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(target, 16),
        );

        setState(() {
          _currentCameraPosition = target;
          _predictions = [];
          searchController.clear();
          _currentFullAddress = response.data['results'][0]['formatted_address'];
          _lat = target.latitude;
          _lng = target.longitude;
          _lastReverseGeocodedPosition = target;
        });
      }
    } catch (e) {
      debugPrint("Search Error: $e");
    }
  }

  void _onMapTap(LatLng tappedPoint) {
    setState(() {
      _currentCameraPosition = tappedPoint;
      _predictions = [];
    });

    mapController?.animateCamera(CameraUpdate.newLatLng(tappedPoint));
    _getAddressFromLatLng(tappedPoint);
    FocusScope.of(context).unfocus();
  }

  void _onMapCameraIdle() {
    _getAddressFromLatLng(_currentCameraPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          if (!_isLoadingLocation)
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentCameraPosition,
                zoom: 14,
              ),
              onMapCreated: (controller) {
                mapController = controller;
                mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(_currentCameraPosition, 16),
                );
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              onTap: _onMapTap,
              onCameraMove: (position) {
                _currentCameraPosition = position.target;
              },
              onCameraIdle: _onMapCameraIdle,
            )
          else
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColors.main1),
                    SizedBox(height: 16.h),
                    Text(
                      AppTranslations.getText(context, "detecting_location"),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Column(
            children: [
              SizedBox(height: 45.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.w, top: 60.h, right: 16.w),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginView(),
                                  ),
                                );
                                },
                              child: SvgPicture.asset(
                                IconAssets.close,
                                colorFilter: ColorFilter.mode(
                                  AppColors.secondary2,
                                  BlendMode.srcIn,
                                ),
                                matchTextDirection: true, //
                              ),
                            ),
                          ],
                        ),
                      ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.x45.h),
              Container(
                height: 70.h,
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.main1.withValues(alpha: 0.5),
                    width: 1.2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextFieldsearch(
                        hintText: _isDefaultAddress
                            ? AppTranslations.getText(context, "search_location_hint")
                            : _currentFullAddress,
                        controller: searchController,
                        onChanged: _onSearchChanged,
                        onSubmitted: (_) => _searchAndNavigate(),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _searchAndNavigate(),
                      child: SvgPicture.asset(
                        IconAssets.locationsearch,
                        colorFilter: ColorFilter.mode(
                          AppColors.main1,
                          BlendMode.srcIn,
                        ),
                        height: 24.h,
                      ),
                    ),
                  ],
                ),
              ),
              if (_predictions.isNotEmpty)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 5.h),
                  constraints: BoxConstraints(maxHeight: 250.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 10),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: _predictions.length,
                    itemBuilder: (context, index) => ListTile(
                      leading: Icon(
                        Icons.location_on,
                        color: AppColors.main1,
                        size: 20.sp,
                      ),
                      title: Text(
                        _predictions[index]['description'],
                        style: TextStyle(fontSize: 13.sp),
                      ),
                      onTap: () => _searchAndNavigate(
                        _predictions[index]['description'],
                      ),
                    ),
                  ),
                ),
              const RowSearch(),
            ],
          ),
          if (!_isLoadingLocation)
            IgnorePointer(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 35.h),
                  child: Icon(
                    Icons.location_on,
                    size: 48.sp,
                    color: AppColors.main1,
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 30.h,
            left: 50.w,
            right: 50.w,
            child: ElevatedButton(
              onPressed: _isLoadingLocation
                  ? null
                  : () {
                if (_lat == null || _lng == null) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Regsterview(
                      initialAddress: _currentFullAddress,
                      lat: _lat!,
                      lng: _lng!,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.main1,
                minimumSize: Size(double.infinity, 55.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 5,
              ),
              child: Text(
                AppTranslations.getText(context, "confirm_location_continue"),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}