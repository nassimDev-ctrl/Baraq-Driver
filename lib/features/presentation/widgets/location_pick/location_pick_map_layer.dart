import 'package:drever_warr/features/presentation/widgets/location_pick/location_pick_constants.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/models/location_pick_ui_state.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickMapLayer extends StatelessWidget {
  const LocationPickMapLayer({
    super.key,
    required this.state,
    required this.onMapCreated,
    required this.onTap,
    required this.onCameraMove,
    required this.onCameraIdle,
  });

  final LocationPickUiState state;
  final ValueChanged<GoogleMapController> onMapCreated;
  final ValueChanged<LatLng> onTap;
  final ValueChanged<CameraPosition> onCameraMove;
  final VoidCallback onCameraIdle;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: state.cameraPosition,
          zoom: LocationPickConstants.initialMapZoom,
        ),
        onMapCreated: onMapCreated,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        onTap: onTap,
        onCameraMove: onCameraMove,
        onCameraIdle: onCameraIdle,
      ),
    );
  }
}
