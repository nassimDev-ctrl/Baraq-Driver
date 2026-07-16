import 'package:drever_warr/features/presentation/widgets/location_pick/location_pick_constants.dart';
import 'package:flutter/material.dart';

class LocationPickAnimations {
  LocationPickAnimations({required TickerProvider vsync}) {
    headerController = AnimationController(
      vsync: vsync,
      duration: const Duration(
        milliseconds: LocationPickConstants.headerAnimationMs,
      ),
    );
    sheetController = AnimationController(
      vsync: vsync,
      duration: const Duration(
        milliseconds: LocationPickConstants.sheetAnimationMs,
      ),
    );
    markerBounceController = AnimationController(
      vsync: vsync,
      duration: const Duration(
        milliseconds: LocationPickConstants.markerBounceMs,
      ),
    );

    headerSlide = _slideAnimation(headerController, fromTop: true);
    sheetSlide = _slideAnimation(sheetController, fromTop: false);
  }

  late final AnimationController headerController;
  late final AnimationController sheetController;
  late final AnimationController markerBounceController;
  late final Animation<Offset> headerSlide;
  late final Animation<Offset> sheetSlide;

  void playEntrance() {
    headerController.forward();
    sheetController.forward();
  }

  void playMarkerBounce() => markerBounceController.forward(from: 0);

  void dispose() {
    headerController.dispose();
    sheetController.dispose();
    markerBounceController.dispose();
  }

  Animation<Offset> _slideAnimation(
    AnimationController controller, {
    required bool fromTop,
  }) {
    return Tween<Offset>(
      begin: Offset(0, fromTop ? -1 : 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
    );
  }
}
