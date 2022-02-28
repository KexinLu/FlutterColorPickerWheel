import 'package:flutter/widgets.dart';
import 'package:wheel_color_picker/flow_delegates/fan_delegate.dart';
import 'package:wheel_color_picker/flow_delegates/fan_slice_delegate.dart';

/// {@category Models}
/// {@template animation_config}
/// [FanAnimationConfig] is used by [FanSliceDelegate] and [FanFlowDelegation]
/// to determine the animation pattern of the wheel
/// {@endtemplate}
class FanAnimationConfig {
  final OpacityAnimationConfig opacityAnimationConfig;
  final ScaleAnimationConfig scaleAnimationConfig;
  final RotationAnimationConfig rotationAnimationConfig;
  final RayAnimationConfig rayAnimationConfig;
  final int animationDurationInMillisecond;

  const FanAnimationConfig({
    this.rayAnimationConfig = const RayAnimationConfig(),
    this.rotationAnimationConfig = const RotationAnimationConfig(),
    this.opacityAnimationConfig = const OpacityAnimationConfig(),
    this.scaleAnimationConfig = const ScaleAnimationConfig(),
    this.animationDurationInMillisecond = 1400,
  });
}

abstract class SubAnimationConfig {
  final Curve curve;
  final bool enabled;
  final double animationStartDelay;
  final double animationFinishDelay;

  @required
  const SubAnimationConfig({
    this.curve = Curves.linear,
    this.enabled = false,
    this.animationStartDelay = 0,
    this.animationFinishDelay = 0,
  }) : assert(animationStartDelay + animationFinishDelay < 1);
}

class OpacityAnimationConfig extends SubAnimationConfig {
  const OpacityAnimationConfig({
    Curve curve = Curves.linear,
    bool enabled = false,
    double animationStartDelay = 0,
    double animationFinishDelay = 0,
  }): super(
    curve: curve,
    enabled: enabled,
    animationStartDelay: animationStartDelay,
    animationFinishDelay: animationFinishDelay,
  );
}

class ScaleAnimationConfig extends SubAnimationConfig {
  const ScaleAnimationConfig({
    Curve curve = Curves.linear,
    bool enabled = false,
    double animationStartDelay = 0,
    double animationFinishDelay = 0,
  }): super(
    curve: curve,
    enabled: enabled,
    animationStartDelay: animationStartDelay,
    animationFinishDelay: animationFinishDelay,
  );
}

class RotationAnimationConfig extends SubAnimationConfig {
  const RotationAnimationConfig({
    Curve curve = Curves.linear,
    bool enabled = false,
    double animationStartDelay = 0,
    double animationFinishDelay = 0,
  }): super(
    curve: curve,
    enabled: enabled,
    animationStartDelay: animationStartDelay,
    animationFinishDelay: animationFinishDelay,
  );
}

class RayAnimationConfig extends SubAnimationConfig {
  final bool randomizeStartDelay;
  final bool randomizeFinishDelay;

  const RayAnimationConfig({
    this.randomizeStartDelay = true,
    this.randomizeFinishDelay = true,
    Curve curve = Curves.linear,
    bool enabled = false,
    double animationStartDelay = 0,
    double animationFinishDelay = 0,
  }): super(
    curve: curve,
    enabled: enabled,
    animationStartDelay: animationStartDelay,
    animationFinishDelay: animationFinishDelay,
  );
}
