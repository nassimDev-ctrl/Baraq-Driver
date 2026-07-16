import 'package:drever_warr/core/models/place_search_result.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/location_pick_constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// حالة الواجهة فقط — لا تحتوي على منطق أعمال.
class LocationPickUiState {
  const LocationPickUiState({
    this.cameraPosition = LocationPickConstants.defaultCameraPosition,
    this.lastReverseGeocodedPosition,
    this.predictions = const [],
    this.fullAddress = '',
    this.isDefaultAddress = true,
    this.latitude,
    this.longitude,
    this.gpsAccuracyMeters,
    this.isLoadingLocation = true,
    this.isResolvingAddress = false,
  });

  final LatLng cameraPosition;
  final LatLng? lastReverseGeocodedPosition;
  final List<PlaceSearchResult> predictions;
  final String fullAddress;
  final bool isDefaultAddress;
  final double? latitude;
  final double? longitude;

  /// دقة GPS بالأمتار — تُقرأ من [Geolocator.getCurrentPosition].
  /// انظر [LocationGpsMetrics] للتفاصيل.
  final double? gpsAccuracyMeters;

  final bool isLoadingLocation;
  final bool isResolvingAddress;

  bool get hasValidCoordinates => latitude != null && longitude != null;
  bool get isMapReady => !isLoadingLocation;

  LocationPickUiState copyWith({
    LatLng? cameraPosition,
    LatLng? lastReverseGeocodedPosition,
    bool clearLastReverseGeocodedPosition = false,
    List<PlaceSearchResult>? predictions,
    String? fullAddress,
    bool? isDefaultAddress,
    double? latitude,
    double? longitude,
    double? gpsAccuracyMeters,
    bool? isLoadingLocation,
    bool? isResolvingAddress,
  }) {
    return LocationPickUiState(
      cameraPosition: cameraPosition ?? this.cameraPosition,
      lastReverseGeocodedPosition: clearLastReverseGeocodedPosition
          ? null
          : (lastReverseGeocodedPosition ?? this.lastReverseGeocodedPosition),
      predictions: predictions ?? this.predictions,
      fullAddress: fullAddress ?? this.fullAddress,
      isDefaultAddress: isDefaultAddress ?? this.isDefaultAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      gpsAccuracyMeters: gpsAccuracyMeters ?? this.gpsAccuracyMeters,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      isResolvingAddress: isResolvingAddress ?? this.isResolvingAddress,
    );
  }
}
