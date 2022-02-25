import 'dart:math';
import 'dart:ui';

import 'package:wheel_colorpicker/wheel_colorpicker.dart';

import 'fan_piece.dart';

/// {@category Models}
/// {@template fan_slice}
/// [FanSlice] contains a list of [FanPiece]
/// Slice of a donut
/// It also knows some meta info like angle start, swipe, innerRadius, outerRadius etc.
/// {@endtemplate}
class FanSlice {

  /// The follow four properties defines the shape of a piece of a donut
  /// starting radians of the fan piece.
  final double angleStart;

  /// how much radians this piece is going to cover.
  final double swipe;

  /// inner radius of this piece.
  final double innerRadius;

  /// center of the overall circle
  final Offset center;

  /// Fan Piece height
  final double pieceHeight ;


  /// list of fanPieces;
  List<FanPiece> fanPieceList = [];

  double currentStartRadius;

  double height = 0;

  /// {@macro fan_slice}
  FanSlice({
    required this.angleStart,
    required this.pieceHeight,
    required this.swipe,
    required this.innerRadius,
    required this.center,
  }) : currentStartRadius = innerRadius;

  void addFanPiece(Color color) {
    double outer = currentStartRadius + pieceHeight;
    fanPieceList.add(
        FanPiece(
            startAngle: angleStart,
            swipe: swipe,
            innerRadius: currentStartRadius,
            outerRadius: outer,
            color: color,
            center: center
        )
    );
    height += pieceHeight;
    currentStartRadius = outer;
  }
}

