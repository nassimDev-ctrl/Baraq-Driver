import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverMarkerHelper {
  static BitmapDescriptor? _cachedIcon;
  static bool _loading = false;

  static const int _markerSize = 55;

  static Future<BitmapDescriptor> loadIcon() async {
    if (_cachedIcon != null) return _cachedIcon!;
    if (_loading) {
      while (_cachedIcon == null) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      return _cachedIcon!;
    }
    _loading = true;

    final data = await rootBundle.load('asets/image/car_pin.png');
    final bytes = data.buffer.asUint8List();

    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: _markerSize,
      targetHeight: _markerSize,
    );
    final frame = await codec.getNextFrame();
    final resized = frame.image;

    final byteData = await resized.toByteData(format: ui.ImageByteFormat.png);
    resized.dispose();

    _cachedIcon = BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
    _loading = false;
    return _cachedIcon!;
  }

  static void clearCache() {
    _cachedIcon = null;
    _loading = false;
  }
}
