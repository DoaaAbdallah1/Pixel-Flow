
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/artwork_stroke.dart';
import '../painters/pixel_grid_painter.dart';

class ArtworkCanvas extends StatelessWidget {
  final List<ArtworkStroke> strokes;
  final GlobalKey repaintKey;

  final ValueChanged<Offset> onPointerDown;
  final ValueChanged<Offset> onPointerMove;
  final VoidCallback onPointerUp;

  const ArtworkCanvas({
    super.key,
    required this.strokes,
    required this.repaintKey,
    required this.onPointerDown,
    required this.onPointerMove,
    required this.onPointerUp,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: RepaintBoundary(
        key: repaintKey,
        child: ColoredBox(
          color: AppColors.background,
          child: Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: (event) {
              onPointerDown(event.localPosition);
            },
            onPointerMove: (event) {
              onPointerMove(event.localPosition);
            },
            onPointerUp: (_) => onPointerUp(),
            onPointerCancel: (_) => onPointerUp(),
            child: CustomPaint(
              painter: PixelGridPainter(strokes: strokes),
              child: const SizedBox.expand(),
            ),
          ),
        ),
      ),
    );
  }
}
