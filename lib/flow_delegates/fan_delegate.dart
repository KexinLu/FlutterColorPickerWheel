import 'package:flutter/animation.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:flutter/rendering.dart';

/// {@template fan_flow_delegation}
/// FanFlowDelegation is responsible for the slight rotation of the wheel
/// {@endtemplate}
class FanFlowDelegation extends FlowDelegate {
  /// rotation animation in angle
  Animation<double> animation;

  /// center of the wheel
  final Offset center;

  FanFlowDelegation({
    required this.animation,
    required this.center,
  }) : super(repaint: animation);

  @override
  void paintChildren(FlowPaintingContext context) {
    for (int i = context.childCount - 1; i >= 0; i--) {
      context.paintChild(
          i,
          /// rotate around the center
          transform: Matrix4Transform().rotateDegrees(animation.value, origin: center).matrix4
      );
    }
  }

  @override
  bool shouldRepaint(covariant FanFlowDelegation oldDelegate) {
    /// repaint when animation is changed, the super(repaint animation) should trigger
    /// this already, remove this at some point
    return animation != oldDelegate.animation;
  }
}

