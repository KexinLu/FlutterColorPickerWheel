import 'package:flutter/cupertino.dart';
import 'package:wheel_color_picker/models/animation_config.dart';
import 'package:wheel_color_picker/models/fan_piece.dart';
import 'package:wheel_color_picker/models/fan_slice.dart';
import 'package:wheel_color_picker/utils/math_util.dart';
import 'package:wheel_color_picker/widgets/fan_piece_widget.dart';
import 'package:wheel_color_picker/flow_delegates/fan_slice_delegate.dart';

/// {@template fan_slice_widget}
/// FanSliceWidget is responsible to render a slice of the wheel, just like a
/// slice of birthday cake.
/// It is responsible to hold/draw the FanPieces in the same group
/// {@endtemplate}
class FanSliceWidget extends StatefulWidget {
  /// [FanSlice] model which holds a list of fan piece
  final FanSlice fanSlice;

  /// animationController responsible to control the open and the close animation
  final AnimationController controller;

  /// callback function supplied to each piece, when a piece is clicked
  /// this function will be invoked
  final void Function(FanPiece) callback;

  /// animation config used by FanSliceDelegate
  final FanAnimationConfig fanAnimationConfig;

  /// border size of each fan piece
  final double pieceBorderSize;

  /// {@macro fan_slice_widget}
  const FanSliceWidget({
    Key? key,
    required this.fanAnimationConfig,
    required this.callback,
    required this.fanSlice,
    required this.controller,
    this.pieceBorderSize = 0,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FanSliceWidgetState();
  }
}

/// {@macro fan_slice_widget}
class FanSliceWidgetState extends State<FanSliceWidget> {
  /// totalHeight is fan_piece_count * fan_piece_height
  double totalHeight = 0;

  /// scale Animation from 0 to 1 with some distribution curve
  late Animation<double> scaleAnimation;

  /// rotation Animation
  late Animation<double> rotationAnimation;

  /// opacity Animation from 0 to 1 with some distribution curve
  late Animation<double> opacityAnimation;

  /// distance Animation represents the distance of current slice to wheel center
  late Animation<double> distanceAnimation;

  @override
  void initState() {
    super.initState();
    initAnimations();
  }

  /// initialize all animations used by [FanSliceDelegate]
  void initAnimations() {
    final FanAnimationConfig config = widget.fanAnimationConfig;

    initScaleAnimation(config.scaleAnimationConfig);
    initRotationAnimation(config.rotationAnimationConfig);
    initOpacityAnimation(config.opacityAnimationConfig);
    initDistanceAnimation(config.rayAnimationConfig);
  }

  /// initialize the scale animation of current slice
  void initScaleAnimation(ScaleAnimationConfig config) {
    if (!config.enabled) {
      scaleAnimation = ConstantTween<double>(1).animate(widget.controller);
      return;
    }

    List<TweenSequenceItem<double>> sequenceItemList = [];
    if (config.animationStartDelay > 0) {
      sequenceItemList.add(
          TweenSequenceItem(
              tween: ConstantTween(0),
              weight: config.animationStartDelay
          )
      );
    }

    sequenceItemList.add(
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 1 - config.animationFinishDelay - config.animationStartDelay),
    );

    if (config.animationFinishDelay > 0) {
      sequenceItemList.add(
          TweenSequenceItem(
              tween: ConstantTween(1),
              weight: config.animationFinishDelay
          )
      );
    }

    scaleAnimation = TweenSequence<double>(sequenceItemList).animate(widget.controller);
  }

  /// initialize the rotation animation of current slice
  void initRotationAnimation(RotationAnimationConfig config) {
    if (!config.enabled) {
      rotationAnimation = ConstantTween<double>(0).animate(widget.controller);
      return;
    }

    List<TweenSequenceItem<double>> sequenceItemList = [];
    if (config.animationStartDelay > 0) {
      sequenceItemList.add(
        TweenSequenceItem(
            tween: ConstantTween(
              - widget.fanSlice.angleStart - 0.5 * widget.fanSlice.swipe,
            ),
            weight: config.animationStartDelay
        ),
      );
    }

    sequenceItemList.add(
      TweenSequenceItem(
          tween: Tween(
              begin: - widget.fanSlice.angleStart - 0.5 * widget.fanSlice.swipe,
              end: 0
          ),
          weight: 1 - config.animationFinishDelay - config.animationStartDelay
      ),
    );

    if (config.animationFinishDelay > 0) {
      sequenceItemList.add(
          TweenSequenceItem(
            tween: ConstantTween(0),
            weight: config.animationFinishDelay,
          )
      );
    }

    rotationAnimation = TweenSequence<double>(sequenceItemList).animate(
        CurvedAnimation(
          parent: widget.controller,
          curve: config.curve,
        )
    );
  }

  /// initialize the opacity animation of current slice
  void initOpacityAnimation(OpacityAnimationConfig config) {
    if (!config.enabled) {
      opacityAnimation = ConstantTween<double>(1).animate(widget.controller);
      return;
    }

    List<TweenSequenceItem<double>> sequenceItemList = [];
    if (config.animationStartDelay > 0) {
      sequenceItemList.add(
        TweenSequenceItem(tween: Tween(
            begin: 0,
            end: 0
        ), weight: config.animationStartDelay),
      );
    }

    sequenceItemList.add(
      TweenSequenceItem(
          tween: Tween(
              begin: 0,
              end: 1,
          ),
          weight: 1 - config.animationFinishDelay - config.animationStartDelay
      ),
    );

    if (config.animationFinishDelay > 0) {
      sequenceItemList.add(
          TweenSequenceItem(
            tween: ConstantTween(1),
            weight: config.animationFinishDelay,
          )
      );
    }

    opacityAnimation = TweenSequence<double>(
        sequenceItemList
    ).animate(
        CurvedAnimation(
            parent: widget.controller,
            curve: config.curve
        )
    );
  }

  /// initialize distance animation
  void initDistanceAnimation(RayAnimationConfig config) {
    if (!config.enabled) {
      distanceAnimation = ConstantTween<double>(0).animate(widget.controller);
      return;
    }

    double entryDelay = config.randomizeStartDelay
        ? MathUtil.randDouble(0.3)
        : config.animationStartDelay;

    double finishDelay = config.randomizeFinishDelay
        ? MathUtil.randDouble(0.3)
        : config.animationFinishDelay;

    List<TweenSequenceItem<double>> sequenceItemList = [];

    if (entryDelay > 0) {
      sequenceItemList.add(
          TweenSequenceItem(
              tween: Tween<double>(
                begin: -widget.fanSlice.height,
                end: 0,
              ),
              weight: entryDelay
          )
      );
    }

    TweenSequenceItem(
        tween: Tween(begin: -widget.fanSlice.height, end: 0.0),
        weight: 1 - entryDelay - finishDelay
    );

    if (finishDelay > 0) {
      sequenceItemList.add(
          TweenSequenceItem(
              tween: ConstantTween(0),
              weight: finishDelay
          )
      );
    }

    var curve = config.curve;
    if (config.randomizeStartDelay) {
      curve = Interval(
          MathUtil.randDouble(0.5),
          1,
          curve: curve
      );
    }
    distanceAnimation = TweenSequence<double>(
        sequenceItemList
    ).animate(
        CurvedAnimation(
            parent: widget.controller,
            curve: curve
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(child: Flow(
      /// see [FanSliceDelegate]
        delegate: FanSliceDelegate(
          angle: widget.fanSlice.angleStart,
          rotationAnimation: rotationAnimation,
          opacityAnimation: opacityAnimation,
          distanceAnimation: distanceAnimation,
          scaleAnimation: scaleAnimation,
          center: widget.fanSlice.center,
          radius: widget.fanSlice.angleStart,
        ),
        children: [
          ...widget.fanSlice.fanPieceList.map((e) =>
              FanPieceWidget(
                  fanPiece: e,
                  callback: widget.callback,
                  pieceBorderSize: widget.pieceBorderSize,
              )
          )
        ]
    ));
  }
}
