import 'dart:async';

import 'package:dio/dio.dart';
import 'package:drever_warr/core/models/place_search_result.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/location_pick_animations.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/location_pick_constants.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/location_pick_loading_view.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/location_pick_map_layer.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/location_pick_overlay_layer.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/models/location_pick_ui_state.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/services/location_geocoding_service.dart';
import 'package:drever_warr/features/presentation/widgets/login.dart';
import 'package:drever_warr/features/presentation/widgets/regster.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final LocationGeocodingService _geocodingService = LocationGeocodingService();

  GoogleMapController? _mapController;
  Timer? _searchDebounce;
  late final LocationPickAnimations _animations;

  LocationPickUiState _state = const LocationPickUiState();
  LatLng _liveCameraPosition = LocationPickConstants.defaultCameraPosition;

  @override
  void initState() {
    super.initState();
    _animations = LocationPickAnimations(vsync: this)..playEntrance();
    _loadCurrentLocationFirst();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _geocodingService.cancelAutocomplete();
    _animations.dispose();
    _searchFocusNode.dispose();
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _updateState(LocationPickUiState Function(LocationPickUiState) updater) {
    if (!mounted) return;
    setState(() => _state = updater(_state));
  }

  Future<void> _loadCurrentLocationFirst() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        _updateState((s) => s.copyWith(isLoadingLocation: false));
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _updateState((s) => s.copyWith(isLoadingLocation: false));
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final current = LatLng(position.latitude, position.longitude);

      if (!mounted) return;

      _updateState(
        (s) => s.copyWith(
          cameraPosition: current,
          latitude: position.latitude,
          longitude: position.longitude,
          gpsAccuracyMeters: position.accuracy,
          isLoadingLocation: false,
        ),
      );
      _liveCameraPosition = current;

      await _resolveAddressFor(current);
      await _animateTo(current);
      _animations.playMarkerBounce();
    } catch (e) {
      debugPrint('Current Location Error: $e');
      _updateState((s) => s.copyWith(isLoadingLocation: false));
    }
  }

  Future<void> _resolveAddressFor(LatLng position) async {
    if (_state.isResolvingAddress) return;

    final last = _state.lastReverseGeocodedPosition;
    if (last != null && _isSameLocation(last, position)) return;

    _updateState((s) => s.copyWith(isResolvingAddress: true));

    try {
      final address = await _geocodingService.reverseGeocode(position);
      if (!mounted || address == null) return;

      _updateState(
        (s) => s.copyWith(
          fullAddress: address,
          isDefaultAddress: false,
          latitude: position.latitude,
          longitude: position.longitude,
          lastReverseGeocodedPosition: position,
          isResolvingAddress: false,
        ),
      );
    } catch (e) {
      debugPrint('Geocoding Error: $e');
      _updateState((s) => s.copyWith(isResolvingAddress: false));
    }
  }

  void _onSearchChanged(String input) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(
      const Duration(milliseconds: LocationPickConstants.searchDebounceMs),
      () => _fetchAutocomplete(input),
    );
  }

  Future<void> _fetchAutocomplete(String input) async {
    try {
      final predictions = await _geocodingService.autocomplete(input);
      if (!mounted) return;
      _updateState((s) => s.copyWith(predictions: predictions));
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) return;
      debugPrint('Autocomplete Error: $e');
    } catch (e) {
      debugPrint('Autocomplete Error: $e');
    }
  }

  Future<void> _searchAndNavigate([String? customAddress]) async {
    final address = (customAddress ?? _searchController.text).trim();
    if (address.isEmpty) return;

    FocusScope.of(context).unfocus();

    try {
      final result = await _geocodingService.geocodeAddress(address);
      if (!mounted || result == null) return;

      await _animateTo(result.position);

      _updateState(
        (s) => s.copyWith(
          cameraPosition: result.position,
          predictions: const [],
          fullAddress: result.address,
          isDefaultAddress: false,
          latitude: result.position.latitude,
          longitude: result.position.longitude,
          lastReverseGeocodedPosition: result.position,
        ),
      );
      _liveCameraPosition = result.position;
      _searchController.clear();
      _animations.playMarkerBounce();
    } catch (e) {
      debugPrint('Search Error: $e');
    }
  }

  Future<void> _onPredictionTap(PlaceSearchResult place) async {
    FocusScope.of(context).unfocus();

    final position = LatLng(place.latitude, place.longitude);
    await _animateTo(position);

    _updateState(
      (s) => s.copyWith(
        cameraPosition: position,
        predictions: const [],
        fullAddress: place.displayName,
        isDefaultAddress: false,
        latitude: place.latitude,
        longitude: place.longitude,
        lastReverseGeocodedPosition: position,
      ),
    );
    _liveCameraPosition = position;
    _searchController.clear();
    _animations.playMarkerBounce();
  }

  void _onMapTap(LatLng tappedPoint) {
    _liveCameraPosition = tappedPoint;
    _updateState(
      (s) => s.copyWith(
        cameraPosition: tappedPoint,
        predictions: const [],
      ),
    );
    _mapController?.animateCamera(CameraUpdate.newLatLng(tappedPoint));
    _resolveAddressFor(tappedPoint);
    FocusScope.of(context).unfocus();
  }

  void _onCameraIdle() {
    _resolveAddressFor(_liveCameraPosition);
    _animations.playMarkerBounce();
  }

  Future<void> _animateTo(LatLng target) {
    return _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            target,
            LocationPickConstants.mapZoom,
          ),
        ) ??
        Future.value();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _animateTo(_state.cameraPosition);
  }

  void _onConfirmLocation() {
    final lat = _state.latitude;
    final lng = _state.longitude;
    if (lat == null || lng == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Regsterview(
          initialAddress: _state.fullAddress,
          lat: lat,
          lng: lng,
        ),
      ),
    );
  }

  void _onBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginView()),
    );
  }

  bool _isSameLocation(LatLng a, LatLng b) {
    return a.latitude == b.latitude && a.longitude == b.longitude;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          if (_state.isMapReady)
            LocationPickMapLayer(
              state: _state,
              onMapCreated: _onMapCreated,
              onTap: _onMapTap,
              onCameraMove: (position) {
                _liveCameraPosition = position.target;
              },
              onCameraIdle: _onCameraIdle,
            )
          else
            const LocationPickLoadingView(),
          LocationPickOverlayLayer(
            state: _state,
            animations: _animations,
            searchController: _searchController,
            searchFocusNode: _searchFocusNode,
            onBack: _onBack,
            onGpsTap: _loadCurrentLocationFirst,
            onSearchChanged: _onSearchChanged,
            onSearchSubmitted: _searchAndNavigate,
            onSearchTap: () => _searchAndNavigate(),
            onUseCurrentLocationTap: _loadCurrentLocationFirst,
            onPredictionTap: _onPredictionTap,
            onEditLocationTap: () => _searchFocusNode.requestFocus(),
            onConfirmTap: _onConfirmLocation,
          ),
        ],
      ),
    );
  }
}
