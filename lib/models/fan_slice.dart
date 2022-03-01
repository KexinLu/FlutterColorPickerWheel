import 'dart:ui';

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
  Offset _center;
  Offset get center => _center;

  /// Fan Piece height
  final double pieceHeight ;

  /// list of fanPieces held by this fan slice
  final List<FanPiece> _fanPieceList = [];

  /// getter of _fanPieceList, private to protect it from alteration
  List<FanPiece> get fanPieceList => _fanPieceList;

  /// radius start of the last piece, default to innerRadius of this fan slice
  double _startRadiusOfLastPiece;
  /// getter, for testing
  double get startRadiusOfLastPiece => _startRadiusOfLastPiece;

  /// current outer radius of this slice
  double get outerRadius => innerRadius + _height;

  /// height of this slice, for now it is piece_count * piece_height
  double _height = 0;

  /// getter of height, height is private to protect it from alteration from outside
  double get height => _height;

  /// {@macro fan_slice}
  FanSlice({
    required this.angleStart,
    required this.pieceHeight,
    required this.swipe,
    required this.innerRadius,
    required Offset center,
  }) :
        _startRadiusOfLastPiece = innerRadius,
        _center = center
  ;

  void updateCenter(Offset newCenter) {
    _center = newCenter;
  }

  void addFanPiece(Color color) {
    double outer = _startRadiusOfLastPiece + pieceHeight;
    _fanPieceList.add(
        FanPiece(
            angleStart: angleStart,
            swipe: swipe,
            radiusStart: _startRadiusOfLastPiece,
            radiusEnd: outer,
            color: color,
            center: center
        )
    );
    _height += pieceHeight;
    _startRadiusOfLastPiece = outer;
  }
}

