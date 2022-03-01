import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheel_color_picker/models/fan_piece.dart';


void main() {
  test('Can create FanPiece', () {
    FanPiece fanPiece = FanPiece(
      angleStart : pi,
      swipe: 0.5 ,
      radiusEnd: 50,
      radiusStart: 30,
      color: Colors.red,
      center: const Offset(80,80),
    );

    expect(fanPiece.center, const Offset(80,80));
    expect(fanPiece.angleStart, pi);
    expect(fanPiece.swipe, 0.5);
    expect(fanPiece.radiusEnd, 50);
    expect(fanPiece.radiusStart, 30);
    expect(fanPiece.color, Colors.red);
  });

  test('Can covert to cartesian properly', () {
    FanPiece fanPiece = FanPiece(
      angleStart : pi,
      swipe: 0.5 ,
      radiusEnd: 50,
      radiusStart: 30,
      color: Colors.red,
      center: const Offset(80,80),
    );

    expect(fanPiece.outerArcStart.dx, 30);
    expect(fanPiece.outerArcStart.dy, 80);
    expect(fanPiece.outerArcEnd.dx, 36.120871905481366);
    expect(fanPiece.outerArcEnd.dy, 56.028723069789855);
    expect(fanPiece.innerArcEnd.dx, 53.672523143288814);
    expect(fanPiece.innerArcEnd.dy, 65.61723384187391);
    expect(fanPiece.innerArcStart.dx, 50);
    expect(fanPiece.innerArcStart.dy, 80);
  });
}