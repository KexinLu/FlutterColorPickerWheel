import 'dart:math';

import 'package:wheel_color_picker/utils/math_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Testing RandInt', () {
    test('Can generate random int in range', () {
      int r;
      for (var i = 0; i < 15; i++) {
        r = MathUtil.randInt(3);
        expect(r < 20, true);
        expect(r >= 0, true);
      }
    });

    test('Can handle max = 1', () {
      int result = MathUtil.randInt(1);
      expect(result, 0);
    });
  });

  group('Testing RandDouble', () {
    test('Can get random double', () {
      double r;
      for (var i = 0; i < 15; i++) {
        r = MathUtil.randDouble(3.1);
        expect(r < 3.1, true);
        expect(r >= 0, true);
      }
    });
  });

  group('Testing getRadians', () {
    test('Can get correct radians', () {
      Offset from = const Offset(1,1);
      Offset to = const Offset(6,6);
      double error = 0.0000001;
      double angle = MathUtil.getRadians(center: from, point: to);
      expect(angle, closeTo(pi/4, error));
    });
  });
}