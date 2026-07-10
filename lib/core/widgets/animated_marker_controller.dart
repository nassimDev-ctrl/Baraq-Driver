import 'package:flutter/animation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AnimatedMarkerController {
  final TickerProvider vsync;
  final VoidCallback onUpdate;

  late final AnimationController _controller;

  LatLng _fromPos;
  LatLng _toPos;
  double _fromRot;
  double _toRot;

  AnimatedMarkerController({
    required this.vsync,
    required this.onUpdate,
    required LatLng initialPosition,
    double initialRotation = 0,
    Duration duration = const Duration(milliseconds: 1200),
  })  : _fromPos = initialPosition,
        _toPos = initialPosition,
        _fromRot = initialRotation,
        _toRot = initialRotation {
    _controller = AnimationController(vsync: vsync, duration: duration)
      ..addListener(onUpdate);
  }

  LatLng get position => LatLng(
        _lerp(_fromPos.latitude, _toPos.latitude, _curve),
        _lerp(_fromPos.longitude, _toPos.longitude, _curve),
      );

  double get rotation =>
      _normalizeAngle(_fromRot + _shortestRotation(_fromRot, _toRot) * _curve);

  double get _curve => Curves.easeInOut.transform(_controller.value);

  void animateTo(LatLng pos, double rot) {
    _fromPos = position;
    _fromRot = rotation;
    _toPos = pos;
    _toRot = rot;
    _controller.forward(from: 0);
  }

  void snapTo(LatLng pos, double rot) {
    _controller.stop();
    _fromPos = pos;
    _toPos = pos;
    _fromRot = rot;
    _toRot = rot;
    onUpdate();
  }

  void dispose() {
    _controller.dispose();
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;

  static double _normalizeAngle(double a) {
    final n = a % 360.0;
    return n < 0 ? n + 360.0 : n;
  }

  static double _shortestRotation(double from, double to) {
    double diff = (to - from) % 360.0;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;
    return diff;
  }
}
