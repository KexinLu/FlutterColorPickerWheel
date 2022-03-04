import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_color_picker_wheel/models/fan_piece.dart';
import 'package:flutter_color_picker_wheel/painters/fan_piece_painter.dart';

class TestCase {
  final FanPiece fanPiece;
  final int caseNumber;
  TestCase({
    required this.fanPiece,
    required this.caseNumber,
  });
}

class TestPainter extends CustomPainter{
  final Offset point;
  TestPainter({required this.point});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPoints(PointMode.points, [point], Paint()..color=Colors.white..strokeWidth=5);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

void main() {
  final TargetPlatformVariant platformVariant = TargetPlatformVariant.all();
  final ValueVariant<TestCase> fanPieceVariant = ValueVariant<TestCase>(
    <TestCase>{
      TestCase(
          fanPiece: FanPiece(angleStart: 0, swipe: 0.3*pi, radiusEnd: 80, radiusStart: 60, color: Colors.red, center: const Offset(155,155)),
          caseNumber: 1,
      ),
      TestCase(
        fanPiece: FanPiece(angleStart: pi, swipe: 0.2*pi, radiusEnd: 90, radiusStart: 70, color: Colors.green, center: const Offset(255,255)),
        caseNumber: 2,
      ),
      TestCase(
        fanPiece: FanPiece(angleStart: 2 * pi, swipe: 0.5*pi, radiusEnd: 180, radiusStart: 140, color: Colors.yellow, center: const Offset(125,125)),
        caseNumber: 3,
      )
    }
  );

  testWidgets(
      "Testing FanPiecePainter rendering",
          (WidgetTester tester) async {
        final GlobalKey target = GlobalKey();
        await tester.pumpWidget(
            Container(
                height: 800,
                width: 500,
                decoration: BoxDecoration(
                    border: Border.all(width: 2)
                ),
                child: Center(
                    child: CustomPaint(
                      key: target,
                      painter: FanPiecePainter(
                        fanPiece: fanPieceVariant.currentValue!.fanPiece,
                      ),
                    )
                )
            )
        );
        await expectLater(find.byKey(target).first, matchesGoldenFile('snapshots/fan_piece_painter_${fanPieceVariant.currentValue!.caseNumber}.png'));
      },
      variant: fanPieceVariant
  );

  testWidgets(
    "Testing FanPiecePainter hitTest",
        (WidgetTester tester) async {
      final GlobalKey target = GlobalKey();
      await tester.pumpWidget(

          Container(
              height: 1000,
              width: 1000,
              decoration: BoxDecoration(
                  border: Border.all(width: 2)
              ),
              child: Center(
                  child: CustomPaint(
                    key: target,
                    foregroundPainter: TestPainter(
                        point: const Offset(200,200)
                    ),
                    painter: FanPiecePainter(
                      fanPiece: FanPiece(angleStart: 0, swipe: 0.3*pi, radiusEnd: 80, radiusStart: 60, color: Colors.red, center: const Offset(155,155)),
                    ),
                  )
              )
          )
      );

      await expectLater(
          find.byKey(target).first,
          matchesGoldenFile('snapshots/fan_piece_painter_hitTest_${debugDefaultTargetPlatformOverride.toString()}.png')
      );

      RenderCustomPaint renderCustomPaint = target.currentContext!.findRenderObject() as RenderCustomPaint;
      expect(renderCustomPaint.hitTestSelf(const Offset(200, 200)), true);
    },
    variant: platformVariant
  );
}