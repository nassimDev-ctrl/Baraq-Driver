import 'package:drever_warr/features/presentation/widgets/location_pick/location_pick_theme.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/scale_tap_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MapFloatingButtons extends StatelessWidget {
  const MapFloatingButtons({
    super.key,
    required this.onRecenterTap,
    this.enabled = true,
  });

  final VoidCallback onRecenterTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ScaleTapButton(
      onTap: enabled ? onRecenterTap : null,
      enabled: enabled,
      child: Material(
        color: Colors.white,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.12),
        shape: const CircleBorder(),
        child: Container(
          width: 52.r,
          height: 52.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: LocationPickTheme.cardShadow,
          ),
          child: Icon(
            Icons.my_location_rounded,
            color: LocationPickTheme.textPrimary,
            size: 24.sp,
          ),
        ),
      ),
    );
  }
}
