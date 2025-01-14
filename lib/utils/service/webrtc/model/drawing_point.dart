import 'dart:ui';
class DrawingGroup {
  final Color color;
  final List<DrawingPoint> points;
  final int imageNumber;

  DrawingGroup({required this.color, required this.points, required this.imageNumber});
}

class DrawingPoint {
  final Offset? point;

  DrawingPoint(this.point);
}