import 'dart:ui';
class DrawingGroup {
  final Color color;
  final List<DrawingPoint> points;

  DrawingGroup({required this.color, required this.points});
}

class DrawingPoint {
  final Offset? point;

  DrawingPoint(this.point);
}