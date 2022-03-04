import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_color_picker_wheel/flow_delegates/fan_slice_delegate.dart';

void main() {

  group("Testing FanSliceDelegate", () {
    testWidgets("Testing FanSliceDelegate can handle distance", (WidgetTester tester) async {
      final AnimationController controller = AnimationController(vsync: tester, duration: const Duration(milliseconds: 1500));
      Animation<double> distanceAnimation = Tween<double>(begin: -200, end: 100).animate(controller);
      Animation<double> opacityAnimation = ConstantTween<double>(1).animate(controller);
      Animation<double> rotationAnimation = ConstantTween<double>(0).animate(controller);
      Animation<double> scaleAnimation = ConstantTween<double>(1).animate(controller);

      /// shooting to the right
      double angle = 0;
      Offset center = const Offset(80,80);
      double radius = 80;

      GlobalKey target = GlobalKey();
      await tester.pumpWidget(
          FanSliceDelegateTestComponent(
              key: target,
              controller: controller,
              scaleAnimation: scaleAnimation,
              opacityAnimation: opacityAnimation,
              distanceAnimation: distanceAnimation,
              rotationAnimation: rotationAnimation,
              angle: angle,
              center: center,
              radius: radius
          )
      );
      Finder widget = find.byKey(target).first;
      await expectLater(
          widget,
          matchesGoldenFile('snapshots/distance/fan_slice_delegate_distance_start.png')
      );
      controller.forward(from: 0.0);
      await tester.pumpAndSettle();
      await expectLater(
          widget,
          matchesGoldenFile('snapshots/distance/fan_slice_rendering_distance_done.png')
      );
    });

    testWidgets("Testing FanSliceDelegate can handle Opacity Animation", (WidgetTester tester) async {
      final AnimationController controller = AnimationController(vsync: tester, duration: const Duration(milliseconds: 1500));
      Animation<double> distanceAnimation = ConstantTween<double>(0).animate(controller);
      Animation<double> opacityAnimation = Tween<double>(begin:0.5, end:1).animate(controller);
      Animation<double> rotationAnimation = ConstantTween<double>(0).animate(controller);
      Animation<double> scaleAnimation = ConstantTween<double>(1).animate(controller);
      double angle = 0;
      Offset center = const Offset(80,80);
      double radius = 0;

      GlobalKey target = GlobalKey();
      await tester.pumpWidget(
          FanSliceDelegateTestComponent(
              key: target,
              controller: controller,
              scaleAnimation: scaleAnimation,
              opacityAnimation: opacityAnimation,
              distanceAnimation: distanceAnimation,
              rotationAnimation: rotationAnimation,
              angle: angle,
              center: center,
              radius: radius
          )
      );
      Finder widget = find.byKey(target).first;
      await expectLater(
          widget,
          matchesGoldenFile('snapshots/opacity/fan_slice_delegate_opacity_start.png')
      );
      controller.forward(from: 0.0);
      await tester.pumpAndSettle();
      await expectLater(
          widget,
          matchesGoldenFile('snapshots/opacity/fan_slice_rendering_opacity_done.png')
      );
    });

    testWidgets("Testing FanSliceDelegate can handle rotation Animation", (WidgetTester tester) async {
      final AnimationController controller = AnimationController(vsync: tester, duration: const Duration(milliseconds: 1500));
      Animation<double> distanceAnimation = ConstantTween<double>(0).animate(controller);
      Animation<double> opacityAnimation = ConstantTween<double>(1).animate(controller);
      Animation<double> rotationAnimation = Tween<double>(begin: 0, end: 0.5 * pi).animate(controller);
      Animation<double> scaleAnimation = ConstantTween<double>(1).animate(controller);
      double angle = 0;
      Offset center = const Offset(500,500);
      double radius = 0;

      GlobalKey target = GlobalKey();
      await tester.pumpWidget(
          FanSliceDelegateTestComponent(
              key: target,
              controller: controller,
              scaleAnimation: scaleAnimation,
              opacityAnimation: opacityAnimation,
              distanceAnimation: distanceAnimation,
              rotationAnimation: rotationAnimation,
              angle: angle,
              center: center,
              radius: radius
          )
      );
      Finder widget = find.byKey(target).first;
      await expectLater(
          widget,
          matchesGoldenFile('snapshots/rotation/fan_slice_delegate_rotation_start.png')
      );
      controller.forward(from: 0.0);
      await tester.pumpAndSettle();
      await expectLater(
          widget,
          matchesGoldenFile('snapshots/rotation/fan_slice_rendering_rotation_done.png')
      );
    });


    testWidgets("Testing FanSliceDelegate can handle scale Animation", (WidgetTester tester) async {
      final AnimationController controller = AnimationController(vsync: tester, duration: const Duration(milliseconds: 1500));
      Animation<double> distanceAnimation = ConstantTween<double>(0).animate(controller);
      Animation<double> opacityAnimation = ConstantTween<double>(1).animate(controller);
      Animation<double> rotationAnimation = ConstantTween<double>(0).animate(controller);
      Animation<double> scaleAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(controller);
      double angle = 0;
      Offset center = const Offset(500,500);
      double radius = 0;

      GlobalKey target = GlobalKey();
      await tester.pumpWidget(
          FanSliceDelegateTestComponent(
              key: target,
              controller: controller,
              scaleAnimation: scaleAnimation,
              opacityAnimation: opacityAnimation,
              distanceAnimation: distanceAnimation,
              rotationAnimation: rotationAnimation,
              angle: angle,
              center: center,
              radius: radius
          )
      );
      Finder widget = find.byKey(target).first;
      await expectLater(
          widget,
          matchesGoldenFile('snapshots/scale/fan_slice_delegate_scale_start.png')
      );
      controller.forward(from: 0.0);
      await tester.pumpAndSettle();
      await expectLater(
          widget,
          matchesGoldenFile('snapshots/scale/fan_slice_rendering_scale_done.png')
      );
    });
  });
}

class FanSliceDelegateTestComponent extends StatefulWidget {
  final AnimationController controller;
  final Animation<double> scaleAnimation;
  final Animation<double> opacityAnimation;
  final Animation<double> distanceAnimation;
  final Animation<double> rotationAnimation;
  final double angle;
  final Offset center;
  final double radius;

  const FanSliceDelegateTestComponent(
      {
        Key? key,
        required this.controller,
        required this.scaleAnimation,
        required this.opacityAnimation,
        required this.distanceAnimation,
        required this.rotationAnimation,
        required this.angle,
        required this.center,
        required this.radius
      })
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FanSliceDelegateTestComponentState();
  }
}

class FanSliceDelegateTestComponentState extends State<FanSliceDelegateTestComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey,
        width: 1000,
        height: 1000,
        child: Center(
            child: Flow(
              delegate: FanSliceDelegate(
                  scaleAnimation: widget.scaleAnimation,
                  rotationAnimation: widget.rotationAnimation,
                  opacityAnimation: widget.opacityAnimation,
                  distanceAnimation: widget.distanceAnimation,
                  angle: widget.angle,
                  center: widget.center,
                  radius: widget.radius, 
                  referenceAnimation: Tween<double>(begin: 0, end: 1).animate(widget.controller),
              ),
              children: [
                Center(
                    child: Container(width: 100, height: 200, color: Colors.red)
                )
              ],
            )
        )
    );
  }
}