import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wheel_color_picker/models/fan_piece.dart';
import 'package:wheel_color_picker/widgets/fan_piece_widget.dart';

/// {@template fan_piece_painter}
/// FanPiecePainter is responsible to paint a piece of the fan on th the canvas
/// It is used by [FanPieceWidget] to render [FanPiece]
/// {@endtemplate}
class FanPiecePainter extends CustomPainter {
  /// holds the fan piece model
  final FanPiece _fanPiece;
  FanPiece get fanPiece => _fanPiece;

  /// {@macro fan_piece_painter}
  FanPiecePainter({
    required FanPiece fanPiece,
    }) :
  _fanPiece = fanPiece;


  @override
  void paint(Canvas canvas, Size size) {
    /// Since path is already calculated by [FanPiece] model,
    /// all we need to do here is to fill the color
    canvas.drawPath(
        fanPiece.path,
        Paint()
        /// Important thing here is the PaintingStyle.fill, which will fill the path
        /// AND! the [PaintingStyle.fill] also makes the path.contains(point) a viable
        /// hit testing source
          ..isAntiAlias=true
          ..style=PaintingStyle.fill
          ..color=fanPiece.color
    );
  }

  @override
  bool? hitTest(Offset position)  {
    /// since we used [PaintingStyle.fill], fanPiece.path will contain position as
    /// long as the position is within the boundary drawn by the path.
    return fanPiece.path.contains(position);
  }

  @override
  bool shouldRepaint(covariant FanPiecePainter oldDelegate) {
    return oldDelegate.fanPiece.center != fanPiece.center;
  }
}
