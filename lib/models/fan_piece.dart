import 'dart:math';
import 'dart:ui';

/// {@category Models}
/// {@template fan_piece}
/// Fan Piece is the smallest unit on the color picker wheel, it looks like a
/// piece of a donut
/// {@endtemplate}
class FanPiece {

  /// The follow four properties defines the shape of a piece of a donut
  /// starting radians of the fan piece.
  final double angleStart;

  /// how much radians this piece is going to cover.
  final double swipe;

  /// outer radius of this piece.
  final double radiusEnd;

  /// inner radius of this piece.
  final double radiusStart;

  /// color of this piece
  final Color color;

  /// center of the overall circle
  final Offset center;

  /// {@macro fan_piece}
  /// Fan piece is used by FanPieceWidget to hold its data.
  /// FanPiece model is responsible to convert spherical coordinates to
  /// cartesian coordinates
  FanPiece({
    required this.angleStart,
    required this.swipe,
    required this.radiusEnd,
    required this.radiusStart,
    required this.color,
    required this.center,
  });

  /// when drawing a donut in one stroke, starting from the outer perimeter,
  /// this is the starting point
  Offset get outerArcStart {
    double x = radiusEnd * cos(angleStart) + center.dx;
    double y = radiusEnd * sin(angleStart) + center.dy;
    return Offset(x,y);
  }

  /// when drawing a donut in one stroke, starting from the outer perimeter,
  /// this is the second point
  Offset get outerArcEnd {
    double x2 = radiusEnd * cos(angleStart + swipe) + center.dx;
    double y2 = radiusEnd * sin(angleStart + swipe) + center.dy;
    return Offset(x2,y2);
  }

  /// when drawing a donut in one stroke, starting from the outer perimeter,
  /// this is the third point, it lies on the inner perimeter of the donut
  Offset get innerArcEnd {
    double x3 = radiusStart * cos(angleStart + swipe) + center.dx;
    double y3 = radiusStart * sin(angleStart + swipe) + center.dy;
    return Offset(x3,y3);
  }

  /// when drawing a donut in one stroke, starting from the outer perimeter,
  /// this is the final point, it lies on the inner perimeter of the donut
  Offset get innerArcStart {
    double x4 = radiusStart * cos(angleStart) + center.dx;
    double y4 = radiusStart * sin(angleStart) + center.dy;
    return Offset(x4,y4);
  }

  /// this is the path which encloses the fan piece
  /// the path is !closed! thus it can be filled when rendering
  Path get path {
    Path p = Path();

    /// Just like drawing a donut from outer perimeter, we first move to the
    /// starting point.
    /// Note: if you don't move to the point first, flutter's Path will start at
    /// 0,0 which is not the desired behaviour here.
    p.moveTo(outerArcStart.dx, outerArcStart.dy);

    /// an arc which is outer perimeter
    p.arcToPoint(outerArcEnd, radius: Radius.circular(radiusEnd));

    /// a straight line to inner perimeter
    p.lineTo(innerArcEnd.dx, innerArcEnd.dy);

    /// an arc which is the inner perimeter, clockwise: false will keep the concavity correct
    p.arcToPoint(innerArcStart, radius: Radius.circular(radiusStart), clockwise: false);

    /// enclose the path
    p.close();

    return p;
  }

  @override
  String toString() {
    return '''FanPiece {
       angleStart: $angleStart,
       swipe: $swipe,
       radiusStart: $radiusStart,
       radiusEnd: $radiusEnd,
       color: $color,
       innerArcStart: $innerArcStart,
       innerArcEnd: $innerArcEnd,
       outerArcStart: $outerArcStart,
       outerArcEnd: $outerArcEnd,
    }''';
  }
}
