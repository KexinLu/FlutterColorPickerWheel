import 'package:flutter/cupertino.dart';
import 'package:wheel_colorpicker/models/fan_piece.dart';
import 'package:wheel_colorpicker/painters/fan_piece_painter.dart';

/// {@template fan_piece_widget}
/// smallest widget unit in this library, a piece of the wheel
/// it holds a FanPiece object which holds its locational data and color data
/// {@endtemplate}
class FanPieceWidget extends StatefulWidget {
  /// see [FanPiece]
  final FanPiece fanPiece;

  /// parent widget should pass a callback which takes a [FanPiece]
  final void Function(FanPiece) callback;

  const FanPieceWidget({
    Key? key,
    required this.fanPiece,
    required this.callback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FanPieceWidgetState();
  }
}

/// {@macro fan_piece_widget}
class FanPieceWidgetState extends State<FanPieceWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          widget.callback(widget.fanPiece);
        },
        child: CustomPaint(
          /// See [FanPiecePainter]
          painter: FanPiecePainter(fanPiece: widget.fanPiece),
        )
    );
  }
}

