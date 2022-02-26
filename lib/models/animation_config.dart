import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';
import 'package:wheel_colorpicker/flow_delegates/fan_delegate.dart';
import 'package:wheel_colorpicker/flow_delegates/fan_slice_delegate.dart';

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
    this.rayAnimationConfig = const RayAnimationConfig.defaultConfig(),
    this.rotationAnimationConfig = const RotationAnimationConfig.defaultConfig(),
    this.opacityAnimationConfig = const OpacityAnimationConfig.defaultConfig(),
    this.scaleAnimationConfig = const ScaleAnimationConfig.defaultConfig(),
    this.animationDurationInMillisecond = 1400,
  });

  const FanAnimationConfig.defaultConfig({
    this.rayAnimationConfig = const RayAnimationConfig.defaultConfig(),
    this.rotationAnimationConfig = const RotationAnimationConfig.defaultConfig(),
    this.opacityAnimationConfig = const OpacityAnimationConfig.defaultConfig(),
    this.scaleAnimationConfig = const ScaleAnimationConfig.defaultConfig(),
    this.animationDurationInMillisecond = 1400,
  });
}

abstract class AnimationConfig {
  final Curve curve;
  final bool enabled;
  final double animationStartDelay;
  final double animationFinishDelay;

  @required
  const AnimationConfig({
    this.curve = Curves.linear,
    this.enabled = false,
    this.animationStartDelay = 0,
    this.animationFinishDelay = 0,
  }) : assert(animationStartDelay + animationFinishDelay < 1);
}

class OpacityAnimationConfig extends AnimationConfig {
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
  const OpacityAnimationConfig.defaultConfig() : super();
}

class ScaleAnimationConfig extends AnimationConfig {
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
  const ScaleAnimationConfig.defaultConfig() : super();
}

class RotationAnimationConfig extends AnimationConfig {
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
  const RotationAnimationConfig.defaultConfig() : super();
}

class RayAnimationConfig extends AnimationConfig {
  final bool randomizeStartDelay;
  final bool randomizeFinishDelay;

  const RayAnimationConfig({
    this.randomizeStartDelay = false,
    this.randomizeFinishDelay = false,
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

  const RayAnimationConfig.defaultConfig() :
        randomizeStartDelay=true,
        randomizeFinishDelay= true,
        super();

}
