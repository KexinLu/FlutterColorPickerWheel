import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheel_color_picker/models/fan_slice.dart';


void main() {
  group('Testing FanSlice constructor', () {
    test('Can construct', () {
      final FanSlice fanSlice = FanSlice(
          angleStart: pi,
          pieceHeight: 55,
          swipe: 0.2 * pi,
          innerRadius: 180,
          center: const Offset(55, 66)
      );

      expect(fanSlice.swipe, 0.2 * pi);
      expect(fanSlice.angleStart, pi);
      expect(fanSlice.pieceHeight, 55);
      expect(fanSlice.innerRadius, 180);
      expect(fanSlice.startRadiusOfLastPiece, 180);
      expect(fanSlice.height, 0);
      expect(fanSlice.outerRadius, 180);
      expect(fanSlice.fanPieceList, []);
    });
  });

  group('Testing FanSlice addFanSlice', () {
    test('addFanPiece', () {
      final FanSlice fanSlice = FanSlice(
          angleStart: pi,
          pieceHeight: 55,
          swipe: 0.2 * pi,
          innerRadius: 180,
          center: const Offset(55, 66)
      );
      fanSlice.addFanPiece(Colors.red);
      fanSlice.addFanPiece(Colors.green);

      expect(fanSlice.swipe, 0.2 * pi);
      expect(fanSlice.angleStart, pi);
      expect(fanSlice.pieceHeight, 55);
      expect(fanSlice.innerRadius, 180);
      expect(fanSlice.startRadiusOfLastPiece, 290);
      expect(fanSlice.height, 110);
      expect(fanSlice.outerRadius, 290);

      expect(fanSlice.fanPieceList[0].radiusStart, 180);
      expect(fanSlice.fanPieceList[0].radiusEnd, 235);
      expect(fanSlice.fanPieceList[0].angleStart, pi);
      expect(fanSlice.fanPieceList[0].swipe, 0.2 * pi);
      expect(fanSlice.fanPieceList[0].color, Colors.red);

      expect(fanSlice.fanPieceList[1].radiusStart, 235);
      expect(fanSlice.fanPieceList[1].radiusEnd, 290);
      expect(fanSlice.fanPieceList[1].angleStart, pi);
      expect(fanSlice.fanPieceList[1].swipe, 0.2 * pi);
      expect(fanSlice.fanPieceList[1].color, Colors.green);
    });
  });
}