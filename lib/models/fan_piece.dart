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
  final double startAngle;

  /// how much radians this piece is going to cover.
  final double swipe;

  /// outer radius of this piece.
  final double outerRadius;

  /// inner radius of this piece.
  final double innerRadius;

  /// color of this piece
  final Color color;

  /// center of the overall circle
  final Offset center;

  /// {@macro fan_piece}
  /// Fan piece is used by FanPieceWidget to hold its data.
  /// FanPiece model is responsible to convert spherical coordinates to
  /// cartesian coordinates
  FanPiece({
    required this.startAngle,
    required this.swipe,
    required this.outerRadius,
    required this.innerRadius,
    required this.color,
    required this.center,
  });

  /// when drawing a donut in one stroke, starting from the outer perimeter,
  /// this is the starting point
  Offset get outerArcStart {
    double x = outerRadius * cos(startAngle) + center.dx;
    double y = outerRadius * sin(startAngle) + center.dy;
    return Offset(x,y);
  }

  /// when drawing a donut in one stroke, starting from the outer perimeter,
  /// this is the second point
  Offset get outerArcEnd {
    double x2 = outerRadius * cos(startAngle + swipe) + center.dx;
    double y2 = outerRadius * sin(startAngle + swipe) + center.dy;
    return Offset(x2,y2);
  }

  /// when drawing a donut in one stroke, starting from the outer perimeter,
  /// this is the third point, it lies on the inner perimeter of the donut
  Offset get innerArcEnd {
    double x3 = innerRadius * cos(startAngle + swipe) + center.dx;
    double y3 = innerRadius * sin(startAngle + swipe) + center.dy;
    return Offset(x3,y3);
  }

  /// when drawing a donut in one stroke, starting from the outer perimeter,
  /// this is the final point, it lies on the inner perimeter of the donut
  Offset get innerArcStart {
    double x4 = innerRadius * cos(startAngle) + center.dx;
    double y4 = innerRadius * sin(startAngle) + center.dy;
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
    p.arcToPoint(outerArcEnd, radius: Radius.circular(outerRadius));

    /// a straight line to inner perimeter
    p.lineTo(innerArcEnd.dx, innerArcEnd.dy);

    /// an arc which is the inner perimeter, clockwise: false will keep the concavity correct
    p.arcToPoint(innerArcStart, radius: Radius.circular(innerRadius), clockwise: false);

    /// enclose the path
    p.close();

    return p;
  }
}

