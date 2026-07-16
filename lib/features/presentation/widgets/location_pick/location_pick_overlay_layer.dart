import 'package:drever_warr/core/models/place_search_result.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/current_location_sheet.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/location_header.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/location_map_marker.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/location_pick_animations.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/location_pick_constants.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/location_predictions_list.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/map_floating_buttons.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/models/location_pick_ui_state.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/search_location_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationPickOverlayLayer extends StatelessWidget {
  const LocationPickOverlayLayer({
    super.key,
    required this.state,
    required this.animations,
    required this.searchController,
    required this.searchFocusNode,
    required this.onBack,
    required this.onGpsTap,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
    required this.onSearchTap,
    required this.onUseCurrentLocationTap,
    required this.onPredictionTap,
    required this.onEditLocationTap,
    required this.onConfirmTap,
  });

  final LocationPickUiState state;
  final LocationPickAnimations animations;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final VoidCallback onBack;
  final VoidCallback onGpsTap;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSearchSubmitted;
  final VoidCallback onSearchTap;
  final VoidCallback onUseCurrentLocationTap;
  final ValueChanged<PlaceSearchResult> onPredictionTap;
  final VoidCallback onEditLocationTap;
  final VoidCallback onConfirmTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (state.isMapReady)
          Align(
            alignment: Alignment.center,
            child: LocationMapMarker(
              bounceAnimation: animations.markerBounceController,
              bottomOffset: LocationPickConstants.markerBottomOffset.h,
              accuracyMeters: state.gpsAccuracyMeters,
            ),
          ),
        SafeArea(
          bottom: false,
          child: Column(
            children: [
              _slide(
                LocationHeader(
                  onBack: onBack,
                  onGpsTap: onGpsTap,
                  isLoading: state.isLoadingLocation,
                ),
              ),
              _slide(
                SearchLocationCard(
                  controller: searchController,
                  focusNode: searchFocusNode,
                  onChanged: onSearchChanged,
                  onSubmitted: onSearchSubmitted,
                  onSearchTap: onSearchTap,
                  onUseCurrentLocationTap: onUseCurrentLocationTap,
                ),
              ),
              _slide(
                LocationPredictionsList(
                  predictions: state.predictions,
                  onPredictionTap: onPredictionTap,
                ),
              ),
            ],
          ),
        ),
        if (state.isMapReady)
          Positioned(
            right: 16.w,
            bottom: LocationPickConstants.recenterButtonBottom.h,
            child: MapFloatingButtons(onRecenterTap: onGpsTap),
          ),
        SlideTransition(
          position: animations.sheetSlide,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: CurrentLocationSheet(
              address: state.fullAddress,
              isResolvingAddress: state.isResolvingAddress,
              isDefaultAddress: state.isDefaultAddress,
              accuracyMeters: state.gpsAccuracyMeters,
              isLoading: state.isLoadingLocation,
              onEditTap: onEditLocationTap,
              onConfirmTap: onConfirmTap,
            ),
          ),
        ),
      ],
    );
  }

  Widget _slide(Widget child) {
    return SlideTransition(position: animations.headerSlide, child: child);
  }
}
