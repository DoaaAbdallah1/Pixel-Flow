
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/artwork_stroke.dart';

class PixelGridPainter extends CustomPainter {
  final List<ArtworkStroke> strokes;

  const PixelGridPainter({
    required this.strokes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    // Adjust grid density according to the available space.
    final spacing = (size.shortestSide / 34).clamp(9.0, 16.0);
    final baseRadius = spacing * 0.13;
    final brushRadius = spacing * 1.4;

    final columns = (size.width / spacing).floor() + 1;
    final rows = (size.height / spacing).floor() + 1;

    final gridWidth = (columns - 1) * spacing;
    final gridHeight = (rows - 1) * spacing;

    final startX = (size.width - gridWidth) / 2;
    final startY = (size.height - gridHeight) / 2;

    final dotPaint = Paint()..isAntiAlias = true;
    final glowPaint = Paint()..isAntiAlias = true;

    for (int row = 0; row < rows; row++) {
      for (int column = 0; column < columns; column++) {
        final position = Offset(
          startX + column * spacing,
          startY + row * spacing,
        );

        final baseColor = _getBaseColor(
          position.dy / size.height,
        );

        double glow = 0;
        Color? artworkColor;

        for (final stroke in strokes) {
          final distance = _distanceToStroke(
            position,
            stroke.points,
          );

          if (distance > brushRadius) continue;

          final influence = math.exp(
            -(distance * distance) /
                (2 * math.pow(spacing * 0.7, 2)),
          );

          if (influence > glow) {
            glow = influence;
            artworkColor = stroke.color;
          }
        }

        final finalColor = artworkColor == null
            ? baseColor
            : Color.lerp(
                baseColor,
                artworkColor,
                glow,
              )!;

        final radius = baseRadius + glow * spacing * 0.18;

        if (glow > 0.05) {
          glowPaint.color = finalColor.withOpacity(glow * 0.35);

          canvas.drawCircle(
            position,
            radius + spacing * 0.27,
            glowPaint,
          );
        }

        dotPaint.color = finalColor.withOpacity(
          0.65 + glow * 0.35,
        );

        canvas.drawCircle(
          position,
          radius,
          dotPaint,
        );
      }
    }
  }

  double _distanceToStroke(
    Offset position,
    List<Offset> points,
  ) {
    double minDistance = double.infinity;

    for (final point in points) {
      final distance = (position - point).distance;

      minDistance = math.min(minDistance, distance);
    }

    return minDistance;
  }

  Color _getBaseColor(double progress) {
    if (progress < 0.5) {
      return Color.lerp(
        AppColors.pink,
        AppColors.purple,
        progress * 2,
      )!;
    }

    return Color.lerp(
      AppColors.purple,
      AppColors.blue,
      (progress - 0.5) * 2,
    )!;
  }

  @override
  bool shouldRepaint(covariant PixelGridPainter oldDelegate) {
    return !identical(oldDelegate.strokes, strokes);
  }
}
