import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shared auth header background: brand gradient + map overlay.
class AuthGradientHeader extends StatelessWidget {
  const AuthGradientHeader({
    super.key,
    required this.height,
    required this.child,
    this.mapOpacity = 0.12,
    this.overlayTopAlpha = 0.02,
    this.overlayBottomAlpha = 0.18,
    this.backgroundImage = ImageAssets.mape,
    this.backgroundFit = BoxFit.cover,
    this.backgroundAlignment = Alignment.center,
  });

  final double height;
  final Widget child;
  final double mapOpacity;
  final double overlayTopAlpha;
  final double overlayBottomAlpha;
  final String backgroundImage;
  final BoxFit backgroundFit;
  final Alignment backgroundAlignment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AuthUiConstants.headerGradient,
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Opacity(
                  opacity: mapOpacity,
                  child: Image.asset(
                    backgroundImage,
                    fit: backgroundFit,
                    alignment: backgroundAlignment,
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: overlayTopAlpha),
                        Colors.black.withValues(alpha: overlayBottomAlpha),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}
