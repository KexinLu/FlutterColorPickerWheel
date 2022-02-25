import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wheel_colorpicker/flow_delegates/flow_delegates.dart';
import 'package:wheel_colorpicker/models/fan_piece.dart';
import 'package:wheel_colorpicker/models/fan_slice.dart';
import 'package:wheel_colorpicker/utils/math_util.dart';
import 'package:wheel_colorpicker/wheel_colorpicker.dart';
import 'package:wheel_colorpicker/available_colors.dart';
import 'fan_slice_widget.dart';

/// {@template wheel_color_picker}
/// A button which you can click to pop out an overlay containing a wheel
/// of color pieces.
/// {@endtemplate}
class WheelColorPicker extends StatefulWidget {
  /// List of slice of colors you want to show
  /// The inner list represents a slice of colors
  final List<List<Color>> colors;

  /// inner radius of the wheel
  final double innerRadius;

  /// color picking button's radius
  final double buttonRadius;

  /// height of each fan piece
  final double pieceHeight;

  /// how long does it take for the fan to fully expand
  final int animationDuration;

  /// default button color
  final Color defaultColor;

  /// count of FanPieces in the tallest slice
  final int maxItemCount;

  /// {@macro wheel_color_picker}
  const WheelColorPicker({
    Key? key,
    required this.defaultColor,
    required this.animationDuration,
    required this.innerRadius,
    required this.maxItemCount,
    required this.pieceHeight,
    required this.buttonRadius,
    this.colors = defaultAvailableColors,
  }) :
  /// at least one of colors or fanSliceList should be provided
  /// providing fanSliceList would result in better performance
  /// since initState no-longer have to generate all the fanPieces on the fly
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WheelColorPickerState();
  }
}

/// {@macro wheel_color_picker}
class WheelColorPickerState extends State<WheelColorPicker> with TickerProviderStateMixin {
  /// animation controller controlling opening animation
  late AnimationController controller;

  /// center of this wheel
  late Offset center;

  /// rotation animation, other animations are handled individually by each slice
  /// see [FanSliceWidget]
  late Animation<double> animation;

  /// current color of the button
  late Color color;

  /// List of fan pieces generated on initialization with respect to colors
  List<FanSlice> fanSliceList = [];

  /// overlay entry (the wheel)
  late OverlayEntry overlayEntry;

  OverlayState? overlayState;

  late double maxRadius;

  /// angle offset value notifier, initialized with 0 rotation
  /// when user pan on the wheel, rotate the wheel with angle
  /// ValueNotifier is used to reduce the amount of repaint
  ValueNotifier<double> angleOffsetNotifier = ValueNotifier(0);

  void increaseAngleOffset(double move) {
    /// rotate the wheel
    angleOffsetNotifier.value += move;
  }

  /// initialize the list of fan items
  void initFanSliceList() {
    /// calculate the swipe of each slice by dividing 360(2pi) by slice count
    final double swipe = 2 * pi / widget.colors.length;

    /// start from 0 degree
    double startAngle = 0;

    for (var colorsInSlice in widget.colors) {
      /// for each color list create a new list of fan piece
      FanSlice slice = FanSlice(
          angleStart: startAngle,
          pieceHeight: widget.pieceHeight,
          swipe: swipe,
          innerRadius: widget.innerRadius,
          center: center
      );

      for (var color in colorsInSlice) {
        slice.addFanPiece(color);
      }

      fanSliceList.add(slice);

      /// move to the next angle
      startAngle += swipe;
    }
  }

  @override
  void initState() {
    super.initState();
    /// center needs to be established before
    maxRadius = widget.innerRadius + widget.maxItemCount * widget.pieceHeight;
    center = Offset(
      maxRadius,
      maxRadius,
    );
    color = widget.defaultColor;
    initFanSliceList();


    /// create the animation controller for all animation
    /// this widget only uses one animation controller
    controller = AnimationController(
      duration: Duration(milliseconds: widget.animationDuration),
      vsync: this,
    );

    /// this is for a slight rotation when expanding the wheel
    var tween = Tween<double>(begin: pi, end: 0);
    animation = tween.animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.ease,
      ),
    );
  }

  /// [FanPieceWidget] onClick will call this function
  void callback (FanPiece fanPiece) {
    /// change the color of current button
    setState(() {
      color = fanPiece.color;
    });

    /// closing animation
    controller.reverse();

    /// hide the overlay
    _hideOverlay();
  }

  OverlayEntry genEntry(BuildContext context) {
    return OverlayEntry(builder: (context) {
      return Positioned(
          left: MediaQuery.of(context).size.width * 0.5 - maxRadius,
          top:  MediaQuery.of(context).size.height * 0.5 - maxRadius + widget.buttonRadius/2,
          child: GestureDetector(
              onPanUpdate: (d) {
                final newR = MathUtil.getRadians(center: center, point: d.localPosition);
                final oldR = MathUtil.getRadians(center: center, point: Offset( d.localPosition.dx - d.delta.dx,d.localPosition.dy - d.delta.dy));
                increaseAngleOffset(oldR - newR);
              },
              behavior: HitTestBehavior.translucent,
              child: ValueListenableBuilder(
                  valueListenable: angleOffsetNotifier,
                  builder: (context, value, child) {
                    return Transform.rotate(
                        angle: angleOffsetNotifier.value,
                        child: SizedBox(
                            width: maxRadius * 2,
                            height: maxRadius * 2,
                            child: Flow(
                                delegate: FanFlowDelegation(center: center, animation: animation),
                                children: [
                                  ...fanSliceList.map((e) => FanSliceWidget(
                                    callback: callback,
                                    fanSlice: e,
                                    controller: controller,
                                  ))
                                ]
                            )
                        )
                    );
                  }
              )
          ));
    });
  }

  void _hideOverlay() async {
    if (overlayEntry != null) {
      Future.delayed(Duration(milliseconds: widget.animationDuration)).then((_) {
        try {
          overlayEntry.remove();
        } catch(_) {}
      });
    }
  }

  void _showOverlay(BuildContext context) async {
    overlayState = Overlay.of(context);
    overlayEntry = genEntry(context);
    overlayState!.insert(overlayEntry);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        width: 2*widget.buttonRadius,
        height: 2*widget.buttonRadius,
        duration: const Duration(seconds: 2),
        curve: Curves.easeIn,
        child: Material(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            color: color,
            child: InkWell(
              customBorder: const CircleBorder(),
              focusColor: color,
              onLongPress: () {
                _showOverlay(context);
              },
              onTap: () {
                ///overlayEntry!.remove();
              },
            )
        )
    );
  }
}
