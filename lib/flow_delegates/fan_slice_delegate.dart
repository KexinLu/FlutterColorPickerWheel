import 'package:flutter/animation.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:flutter/rendering.dart';

/// {@template fan_slice_delegate}
/// {@endtemplate}
class FanSliceDelegate extends FlowDelegate {
  /// scale animation from 0 to 1
  final Animation scaleAnimation;

  /// opacity animation from 0 to 1
  final Animation opacityAnimation;

  /// distance animation from -TotalHeight/2 to innerRadius
  final Animation<double> distanceAnimation;

  /// center of wheel
  final Offset center;

  /// angle with respect to 0 in spherical coordinate
  final double angle;

  /// radius of the inner boundary
  final double radius;

  /// {@macro fan_slice_delegate}
  FanSliceDelegate({
    required this.scaleAnimation,
    required this.opacityAnimation,
    required this.distanceAnimation,
    required this.angle,
    required this.center,
    required this.radius,
  }) : super(repaint: distanceAnimation);

  /// [paintChildren] is responsible to draw the children elements
  @override
  void paintChildren(FlowPaintingContext context) {
    for (int i = context.childCount - 1; i >= 0; i--) {
      context.paintChild(
          i,
          ///opacity: opacityAnimation.value,
          /// transform the child element
          transform: Matrix4Transform().scale(
            scaleAnimation.value,
            origin:center,
          ).direction(
            /// angle of the transformation
              angle,
              /// distance from center
              distanceAnimation.value
          ).matrix4
      );
    }
  }

  @override
  bool shouldRepaint(covariant FanSliceDelegate oldDelegate) {
    /// when one of these changes, repaint
    return scaleAnimation != oldDelegate.scaleAnimation
        || opacityAnimation != oldDelegate.opacityAnimation
        || distanceAnimation != oldDelegate.distanceAnimation
    ;
  }
}