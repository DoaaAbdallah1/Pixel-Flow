
import 'package:flutter/material.dart';

class ArtworkStroke {
  final Color color;
  final List<Offset> points;

  ArtworkStroke({
    required this.color,
    required List<Offset> points,
  }) : points = List.unmodifiable(points);

  ArtworkStroke addPoint(Offset point) {
    return ArtworkStroke(
      color: color,
      points: [...points, point],
    );
  }
}
