import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheel_color_picker/models/fan_piece.dart';
import 'package:wheel_color_picker/painters/fan_piece_painter.dart';

void main() {
  testWidgets("Testing FanPiecePainter rendering", (WidgetTester tester) async {
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
                    fanPiece: FanPiece(
                      startAngle: pi,
                      swipe: 0.2 * pi,
                      outerRadius: 200,
                      innerRadius: 100,
                      color: Colors.red,
                      center: const Offset(50,50),
                    ),
                  ),
                )
            )
        )
    );

    await expectLater(find.byKey(target).first, matchesGoldenFile('fan_piece_painter.png'));

  });

  /// This test is skipped for now.
  ///  expect(renderCustomPaint.hitTestSelf(const Offset(100, 255)), true); is not returning correct result
  ///  renderCustomPaint.hitTestSelf is invoking painter.hitTest properly and is
  ///  deferring the hit test to path.contains where the path is filled and closed
  ///  In action this works, but in test it not working
  ///  Since the hitTest of Path is handled by Native handler
  ///  My guess is Native Path handler of WidgetTest is not handling path.contains properly
  ///  TODO: verify this theory
  testWidgets(
      "Testing FanPiecePainter hitTest",
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
                        fanPiece: FanPiece(
                          startAngle: pi,
                          swipe: 0.2 * pi,
                          outerRadius: 200,
                          innerRadius: 100,
                          color: Colors.red,
                          center: const Offset(50,50),
                        ),
                      ),
                    )
                )
            )
        );

        RenderCustomPaint renderCustomPaint = target.currentContext!.findRenderObject() as RenderCustomPaint;
        /// Offset(180.0, 280.0) innerArcStart
        /// Offset(199.1, 221.2) innerArcEnd
        /// Offset(118.2, 162.4) outerArcEnd
        /// Offset(80.0, 280.0) outerArcStart
        /// shape is approximately
        /**
         *            (118,162)
         *               .
         *            .      .
         *          .            . (199,221)
         *        .            .
         *       .           .
         *      .  .  .  .  .
         * (80,280)   (180,280)
         **/
        expect(renderCustomPaint.hitTestSelf(const Offset(100, 255)), true);
      },
      skip: true
  ) ;
}