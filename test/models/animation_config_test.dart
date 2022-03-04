import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_color_picker_wheel/models/animation_config.dart';

void main() {
  group('Testing OpacityAnimationConfig ', () {
    test('Have Default Config ', () {
      OpacityAnimationConfig config = const OpacityAnimationConfig();
      expect(config.animationStartDelay, 0);
      expect(config.animationFinishDelay, 0);
      expect(config.curve, Curves.linear);
      expect(config.enabled, false);
    });
  });

  group('Testing ScaleAnimationConfig ', () {
    test('Have Default Config ', () {
      ScaleAnimationConfig config = const ScaleAnimationConfig();
      expect(config.animationStartDelay, 0);
      expect(config.animationFinishDelay, 0);
      expect(config.curve, Curves.linear);
      expect(config.enabled, false);
    });
  });

  group('Testing RotationAnimationConfig', () {
    test('Have Default Config ', () {
      RotationAnimationConfig config = const RotationAnimationConfig();
      expect(config.animationStartDelay, 0);
      expect(config.animationFinishDelay, 0);
      expect(config.curve, Curves.linear);
      expect(config.enabled, false);
    });
  });

  group('Testing RayAnimationConfig', () {
    test('Have Default Config ', () {
      RayAnimationConfig config = const RayAnimationConfig();
      expect(config.animationStartDelay, 0);
      expect(config.animationFinishDelay, 0);
      expect(config.curve, Curves.linear);
      expect(config.enabled, false);
      expect(config.randomizeFinishDelay, true);
      expect(config.randomizeStartDelay, true);
    });
  });

  group('Testing FanAnimationConfig', () {
    test('Have Default Config', () {
      FanAnimationConfig defaultConfig = const FanAnimationConfig();
      expect(defaultConfig.animationDurationInMillisecond, 1400);
    });
  });
}