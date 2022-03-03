import 'package:flutter/material.dart';
import 'package:wheel_color_picker/models/animation_config.dart';

const FanAnimationConfig fanLikeAnimationConfig = FanAnimationConfig(
  animationDurationInMillisecond: 1200,
  rotationAnimationConfig: RotationAnimationConfig(
    enabled: true,
    curve: Curves.easeInOutCubic,
    animationStartDelay: 0.2,
    animationFinishDelay: 0,
  ),
  opacityAnimationConfig: OpacityAnimationConfig(
    enabled: true,
    curve: Curves.easeInOutCubic,
    animationStartDelay: 0,
    animationFinishDelay: 0.6,
  )
);

const FanAnimationConfig sunRayLikeAnimationConfig = FanAnimationConfig(
    animationDurationInMillisecond: 1400,
    rayAnimationConfig: RayAnimationConfig(
      enabled: true,
      randomizeStartDelay: true,
      randomizeFinishDelay: true,
      curve: Curves.easeInOut
    ),
    opacityAnimationConfig: OpacityAnimationConfig(
      enabled: true,
      curve: Curves.easeInOutCubic,
      animationStartDelay: 0,
      animationFinishDelay: 0.6,
    )
);
