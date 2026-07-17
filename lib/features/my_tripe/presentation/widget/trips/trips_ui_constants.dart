import 'package:flutter/material.dart';

abstract final class TripsUiConstants {
  static const headerHeight = 230.0;
  static const cardRadius = 26.0;
  static const statsCardRadius = 18.0;
  static const tabRadius = 24.0;
  static const horizontalPadding = 16.0;
  static const sectionSpacing = 16.0;
  static const cardPadding = 16.0;

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
