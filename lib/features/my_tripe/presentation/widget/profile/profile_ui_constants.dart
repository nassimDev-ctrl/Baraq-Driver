import 'package:flutter/material.dart';

abstract final class ProfileUiConstants {
  static const headerHeight = 210.0;
  static const avatarSize = 110.0;
  static const profileCardOverlap = 58.0;
  static const cardRadius = 28.0;
  static const fieldRadius = 16.0;
  static const horizontalPadding = 16.0;
  static const sectionSpacing = 14.0;

  static const softShadow = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 18,
      offset: Offset(0, 8),
    ),
  ];

  static const cardShadow = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 14,
      offset: Offset(0, 6),
    ),
  ];
}
