import 'package:flutter/material.dart';

class ScaleTap extends StatefulWidget {
  const ScaleTap({
    super.key,
    required this.onTap,
    required this.child,
    this.scale = 0.96,
    this.borderRadius,
  });

  final VoidCallback onTap;
  final Widget child;
  final double scale;
  final BorderRadius? borderRadius;

  @override
  State<ScaleTap> createState() => _ScaleTapState();
}

class _ScaleTapState extends State<ScaleTap> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? widget.scale : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        borderRadius: widget.borderRadius,
        child: InkWell(
          onTap: widget.onTap,
          onHighlightChanged: (value) => setState(() => _pressed = value),
          borderRadius: widget.borderRadius,
          child: widget.child,
        ),
      ),
    );
  }
}
