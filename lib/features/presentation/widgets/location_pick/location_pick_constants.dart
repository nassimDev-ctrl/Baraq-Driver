import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract final class LocationPickConstants {
  static const defaultCameraPosition = LatLng(37.0500, 41.2200);
  static const mapZoom = 16.0;
  static const initialMapZoom = 14.0;

  static const searchDebounceMs = 350;

  static const markerBottomOffset = 150.0;
  static const recenterButtonBottom = 250.0;

  static const headerAnimationMs = 650;
  static const sheetAnimationMs = 700;
  static const markerBounceMs = 450;
}
