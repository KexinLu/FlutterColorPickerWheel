import 'package:flutter/cupertino.dart';
import 'package:wheel_colorpicker/models/fan_piece.dart';
import 'package:wheel_colorpicker/models/fan_slice.dart';
import 'package:wheel_colorpicker/utils/math_util.dart';
import 'package:wheel_colorpicker/widgets/fan_piece_widget.dart';
import 'package:wheel_colorpicker/flow_delegates/fan_slice_delegate.dart';

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

  /// callback function supplied to each piece, when the piece is clicked
  /// this function will get called
  final void Function(FanPiece) callback;

  /// entry Delay for the animation
  /// if we break down the animation of each piece entering the wheel into 3 parts
  /// wait -> move -> stop
  /// wait + move + stop = 1 which is 100%
  /// [entryDelayWeight] represents how much weight wait would induce
  /// eg. when wait = 0.5, then the piece is going to stay still for half of the
  /// animation duration then started moving
  final double entryDelayWeight;

  /// finish Delay for the animation
  /// if we break down the animation of each piece entering the wheel into 3 parts
  /// wait -> move -> stop
  /// wait + move + stop = 1 which is 100%
  /// [finishDelayWeight] represents how much weight wait would induce
  /// eg. when wait = 0.4, then the piece is going to move then stay at the destination
  /// for 40% of the animation duration.
  final double finishDelayWeight;

  /// {@macro fan_slice_widget}
  const FanSliceWidget({
    Key? key,
    required this.callback,
    required this.fanSlice,
    required this.controller,
    this.entryDelayWeight = 0,
    this.finishDelayWeight = 0,
  }) :
        /// opacity Animation requires finishDelayWeight to be less than 80%
        assert(finishDelayWeight < 0.8),
        /// Note: entryDelayWeight + finishDelayWeight < 1
        /// see [entryDelayWeight] and [finishDelayWeight]
        assert(entryDelayWeight + finishDelayWeight < 1),
        super(key: key);

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

  /// opacity Animation from 0 to 1 with some distribution curve
  late Animation<double> opacityAnimation;

  /// distance Animation represents the distance of current slice to wheel center
  late Animation<double> distanceAnimation;

  @override
  void initState() {
    super.initState();
    /// ![initAnimation] should only be called after initFanPieceList is finished
    initAnimations();
  }

  /// initialize all animations used by [FanSliceDelegate]
  void initAnimations() {
    initScaleAnimation();
    initOpacityAnimation();
    initDistanceAnimation();
  }

  /// initialize the scale animation of current slice
  void initScaleAnimation() {
    scaleAnimation = TweenSequence<double>(
            [
              /// stay 0 for 20% of the animation duration, this creates
              /// the popout effect when opening
              /// and the shrinking effect when closing
              TweenSequenceItem(tween: ConstantTween(0), weight: 0.8),

              /// scale up takes up 20% of the animation duration
              TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 0.2),

              /// scale will stay at 1 for 60% of the animation duration
              TweenSequenceItem(tween: ConstantTween(1), weight: 0.6),
            ]
        ).animate(
          widget.controller
        );
  }

  /// initialize the opacity animation of current slice
  void initOpacityAnimation() {
    opacityAnimation = TweenSequence<double>(
        [
          /// constant delay the increase of opacity to make sure opacity is delayed for 20% of animation duration
          TweenSequenceItem(tween: ConstantTween(0), weight: 0.2),
          TweenSequenceItem(
              tween: Tween(begin: 0, end: 1),
              /// since we used up 20% in waiting time, we only have 0.8 left
              weight: 0.8 - widget.finishDelayWeight
          ),
          ...widget.finishDelayWeight > 0 ? [
            /// finishDelayWeight makes sure tween stay at 1
            TweenSequenceItem(tween: ConstantTween(1), weight: widget.finishDelayWeight)
          ] : [],
        ]
    ).animate(
      /// add extra curve to the tween by introducing easeInQuad distribution
        CurvedAnimation(parent: widget.controller, curve: Curves.easeInQuad)
    );
  }

  /// initialize distance animation
  void initDistanceAnimation() {
    double entryDelay = MathUtil.randDouble(0.3);
    double finishDelay = MathUtil.randDouble(0.3);
    distanceAnimation = TweenSequence<double>([
      /// entryDelay will make the item stay at the starting position for a period of time
     /// ...widget.entryDelayWeight > 0 ? [
     ///   TweenSequenceItem(
     ///     /// starting distance
     ///       tween: ConstantTween(-totalHeight/2),
     ///       weight: widget.entryDelayWeight
     ///   )
     /// ] : [],
      TweenSequenceItem(
        /// starting distance
          tween: ConstantTween(-widget.fanSlice.height),
          weight: entryDelay,///widget.entryDelayWeight
      ),

      /// actual animation
      TweenSequenceItem(
          tween: Tween(begin: -widget.fanSlice.height, end: 0.0),
          weight: 1 - entryDelay - finishDelay
              ///widget.entryDelayWeight - widget.finishDelayWeight
      ),
      /// last phase where the slice stays in place
      ///...widget.finishDelayWeight > 0 ? [
        TweenSequenceItem(tween: ConstantTween(0), weight: finishDelay)///widget.finishDelayWeight)
      ///] : [],
    ]).animate(
        CurvedAnimation(
            parent: widget.controller,
            /// curve the animation with a delayed interval, so the
            /// slices will come in at different rate
           /// curve:
            curve:
           Interval(
               MathUtil.randDouble(0.5),
               1,
            curve: Curves.easeInOutCubic
           )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(child: Flow(
      /// see [FanSliceDelegate]
        delegate: FanSliceDelegate(
          angle: widget.fanSlice.angleStart,
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
                  key: GlobalKey(),
                  callback: widget.callback
              )
          )
        ]
    ));
  }
}
