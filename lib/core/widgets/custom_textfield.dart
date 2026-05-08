import 'package:flutter/material.dart';

class NotebookTextField extends StatelessWidget {
  final TextEditingController? controller;
  final int lines;
  final String? hint;


  final double rowHeight;

  final Color lineColor;
  final double lineThickness;
  final EdgeInsets padding;

  const NotebookTextField({
    super.key,
    this.controller,
    this.lines = 7,
    this.hint,
    this.rowHeight = 34, // tweak this
    this.lineColor = const Color(0xFF9E9E9E),
    this.lineThickness = 1,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  });

  @override
  Widget build(BuildContext context) {
    const fontSize = 18.0;

    final strut = StrutStyle(
      fontSize: fontSize,
      height: rowHeight / fontSize, // force EXACT rowHeight
      forceStrutHeight: true,
    );

    return SizedBox(
      height: padding.vertical + (lines * rowHeight),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _NotebookLinesPainter(
                lines: lines,
                padding: padding,
                rowHeight: rowHeight,
                lineColor: lineColor,
                thickness: lineThickness,
                devicePixelRatio: MediaQuery.of(context).devicePixelRatio,
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: padding,
              child: TextField(
                controller: controller,
                minLines: lines,
                maxLines: lines,
                style: const TextStyle(
                  fontSize: fontSize,
                ),
                strutStyle: strut,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  isCollapsed: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotebookLinesPainter extends CustomPainter {
  final int lines;
  final EdgeInsets padding;
  final double rowHeight;
  final Color lineColor;
  final double thickness;
  final double devicePixelRatio;

  _NotebookLinesPainter({
    required this.lines,
    required this.padding,
    required this.rowHeight,
    required this.lineColor,
    required this.thickness,
    required this.devicePixelRatio,
  });

  double _snap(double y) {
    // Snap to physical pixel grid to avoid cumulative anti-alias drift
    return (y * devicePixelRatio).round() / devicePixelRatio;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    // Draw underline for each row.
    // Underline sits at the bottom of each row box.
    for (int i = 1; i <= lines; i++) {
      final y = _snap(padding.top + (i * rowHeight));
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NotebookLinesPainter old) {
    return old.lines != lines ||
        old.padding != padding ||
        old.rowHeight != rowHeight ||
        old.lineColor != lineColor ||
        old.thickness != thickness ||
        old.devicePixelRatio != devicePixelRatio;
  }
}