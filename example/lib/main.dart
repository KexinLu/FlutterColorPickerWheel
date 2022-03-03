import 'package:example/example_custom_animation.dart';
import 'package:example/example_custom_color_set.dart';
import 'package:example/example_detached.dart';
import 'package:example/example_detached_with_gap.dart';
import 'package:example/example_fan_default.dart';
import 'package:example/example_fan_default_tap.dart';
import 'package:example/example_fan_simple.dart';
import 'package:example/example_fan_simple_tap.dart';
import 'package:example/example_ray_default.dart';
import 'package:example/example_ray_default_tap.dart';
import 'package:example/example_ray_simple.dart';
import 'package:example/example_ray_simple_tap.dart';
import 'package:example/example_use_overlay_without_button.dart';
import 'package:flutter/material.dart';

import 'package:dashbook/dashbook.dart';

void main() {
  final dashbook = Dashbook(
    title: "Flutter Wheel Color Picker ",

  );

  dashbook
      .storiesOf('Attached To Button - Long Press')
      .decorator(CenterDecorator())
      .add('SunRayAnimation - Simple Color Preset', (ctx) => const ExampleRaySimple())
      .add('SunRayAnimation - Default Color Preset', (ctx) => const ExampleRayDefault())
      .add('FanAnimation - Simple Color Preset', (ctx) => const ExampleFanSimple())
      .add('FanAnimation - Default Color Preset', (ctx) => const ExampleFanDefault())
  ;
  dashbook
      .storiesOf('Attached To Button - Tap')
      .decorator(CenterDecorator())
      .add('SunRayAnimation - Simple Color Preset', (ctx) => const ExampleRaySimpleTap())
      .add('SunRayAnimation - Default Color Preset', (ctx) => const ExampleRayDefaultTap())
      .add('FanAnimation - Simple Color Preset', (ctx) => const ExampleFanSimpleTap())
      .add('FanAnimation - Default Color Preset', (ctx) => const ExampleFanDefaultTap())
  ;
  dashbook
      .storiesOf('Detached from Button - Tap')
      .decorator(CenterDecorator())
      .add('Detached', (ctx) => const ExampleDetached())
      .add('Detached with Gap', (ctx) => const ExampleDetachedWithGap())
  ;
  dashbook
      .storiesOf('Customized')
      .decorator(CenterDecorator())
      .add('Custom Color Set', (ctx) => const ExampleCustomColorSet())
      .add('Custom Animation', (ctx) => const ExampleCustomAnimation())
      .add('Use WheelOverlayEntry only', (ctx) => const ExampleUseOverlayOnly())
  ;

  // Since dashbook is a widget itself, you can just call runApp passing it as a parameter
  runApp(dashbook);
}