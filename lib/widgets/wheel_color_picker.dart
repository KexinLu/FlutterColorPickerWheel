import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wheel_color_picker/flow_delegates/flow_delegates.dart';
import 'package:wheel_color_picker/models/animation_config.dart';
import 'package:wheel_color_picker/models/fan_piece.dart';
import 'package:wheel_color_picker/models/fan_slice.dart';
import 'package:wheel_color_picker/utils/math_util.dart';
import 'package:wheel_color_picker/wheel_color_picker.dart';

extension GlobalKeyEx on GlobalKey {
  Offset get globalTopLeft {
    final RenderBox box = currentContext?.findRenderObject() as RenderBox;
    final Size size = box.size;
    return box.localToGlobal(
      size.topLeft(Offset.zero)
    );
  }
  Size get size {
    final RenderBox box = currentContext?.findRenderObject() as RenderBox;
    return box.size;
  }
}

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

  /// color picking button's size
  final double buttonSize;

  /// height of each fan piece
  final double pieceHeight;

  /// default button color
  final Color defaultColor;

  /// count of FanPieces in the tallest slice
  final int maxItemCount;

  final FanAnimationConfig animationConfig;

  final void Function(Color) onSelect;

  /// {@macro wheel_color_picker}
  const WheelColorPicker({
    Key? key,
    this.animationConfig = const FanAnimationConfig(),
    required this.onSelect,
    required this.defaultColor,
    required this.innerRadius,
    required this.maxItemCount,
    required this.pieceHeight,
    required this.buttonSize,
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
  final _key = GlobalKey<WheelColorPickerState>();

  /// animation controller controlling opening animation
  late AnimationController controller;

  /// center of this wheel
  late Offset center;

  /// rotation animation, other animations are handled individually by each slice
  /// rotation is cancelled for now
  /// also see [FanSliceWidget]
  late Animation<double> animation;

  /// current color of the button
  late Color color;

  /// List of fan pieces generated on initialization with respect to colors
  List<FanSlice> fanSliceList = [];

  late Widget overlayContent;

  late double maxRadius;

  OverlayEntry? overlayEntry;

  /// angle offset value notifier, initialized with 0 rotation
  /// when user pan on the wheel, rotate the wheel with angle
  /// ValueNotifier is used to reduce the amount of repaint
  ValueNotifier<double> angleOffsetNotifier = ValueNotifier(0);

  void increaseAngleOffset(double move) {
    /// rotate the wheel
    angleOffsetNotifier.value += move;
  }

  /// initialize the list of fan items
  void _initFanSliceList() {
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
    /// center needs to be established when initializing state
    /// center is with respect to the overlay container, not the parent container
    maxRadius = widget.innerRadius + widget.maxItemCount * widget.pieceHeight;
    center  = Offset(maxRadius, maxRadius);

    /// populate fan slices (with respect to list of colors)
    _initFanSliceList();

    color = widget.defaultColor;
    /// we can only build the fan pieces after the main button is built.
    /// Reason being we need the button's center Offset(global)
    WidgetsBinding.instance?.addPostFrameCallback(
            (_) => postBuild()
    );

    /// create the animation controller for all animation
    /// this widget only uses one animation controller
    controller = AnimationController(
      duration: Duration(milliseconds: widget.animationConfig.animationDurationInMillisecond),
      vsync: this,
    );

    /// --this is for a slight rotation when expanding the wheel--
    /// !rotation is cancelled for now;
    Tween<double> tween = ConstantTween(0);
    animation = tween.animate(controller);
  }

  /// [FanPieceWidget] onClick will call this function
  void callback (FanPiece fanPiece) {
    /// change the color of current button
    setState(() {
      color = fanPiece.color;
    });

    widget.onSelect(fanPiece.color);

    /// closing animation
    controller.reverse();

    /// hide the overlay
    _hideOverlay();
  }

  void postBuild() {
    _genEntryContent();
  }

  void _genEntryContent() {
    final Offset topLeft = GlobalKeyEx(_key).globalTopLeft;

    overlayContent = Positioned(
        top: topLeft.dy - maxRadius + widget.buttonSize/2,
        left: topLeft.dx - maxRadius + widget.buttonSize/2,
        child: GestureDetector(
            onPanUpdate: (d) {
              final newR = MathUtil.getRadians(center: center, point: d.localPosition);
              final oldR = MathUtil.getRadians(
                  center: center,
                  point: Offset( d.localPosition.dx - d.delta.dx,d.localPosition.dy - d.delta.dy));
              increaseAngleOffset(newR - oldR);
            },
            onTap: () {
              _hideOverlay();
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
                          child: RepaintBoundary(
                              child: Flow(
                                  delegate: FanFlowDelegation(
                                      center: center,
                                      animation: animation
                                  ),
                                  children: [
                                    ...fanSliceList.map(
                                            (e) => FanSliceWidget(
                                          fanAnimationConfig: widget.animationConfig,
                                          callback: callback,
                                          fanSlice: e,
                                          controller: controller,
                                        )
                                    )
                                  ]
                              )
                          )
                      )
                  );
                }
            )
        )
    );
  }

  void _hideOverlay() async {
      Future.delayed(Duration(milliseconds: widget.animationConfig.animationDurationInMillisecond)).then((_) {
          if (overlayEntry != null) {
            overlayEntry!.remove();
            overlayEntry = null;
          }
      });
  }

  void _showOverlay(BuildContext context) async {
    if (overlayEntry == null) {
      final OverlayState? overlayState = Overlay.of(context);
      overlayEntry = OverlayEntry(builder: (_) => overlayContent);
      overlayState!.insert(overlayEntry!);
      controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: RepaintBoundary(
            child: AnimatedContainer(
                key: _key,
                width: widget.buttonSize,
                height: widget.buttonSize,
                duration: const Duration(seconds: 2),
                curve: Curves.easeIn,
                child: Material(
                    shape: const CircleBorder(),
                    color: color,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      focusColor: color,
                      onLongPress: () {
                        _showOverlay(context);
                      },
                      onTap: () {
                        if (overlayEntry != null) {
                          overlayEntry!.remove();
                          overlayEntry = null;
                        }
                      },
                    )
                )
            )
        )
    );
  }
}
