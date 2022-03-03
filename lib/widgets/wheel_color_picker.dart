import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wheel_color_picker/flow_delegates/flow_delegates.dart';
import 'package:wheel_color_picker/models/animation_config.dart';
import 'package:wheel_color_picker/models/button_behaviour.dart';
import 'package:wheel_color_picker/models/fan_slice.dart';
import 'package:wheel_color_picker/models/layerlink_config.dart';
import 'package:wheel_color_picker/wheel_color_picker.dart';
import 'package:wheel_color_picker/widgets/ink_button.dart';

/// {@template wheel_color_picker}
///     A button which you can click to pop out an overlay containing a wheel
///     of color pieces.
/// {@endtemplate}
class WheelColorPicker extends StatefulWidget {
  /// List of slice of colors you want to show
  /// The inner list represents a slice of colors
  final List<List<Color>> colorList;

  /// when considering this wheel as a donut shaped widget,
  /// inner radius of the wheel
  final double innerRadius;

  /// color picking button's size
  final double buttonSize;

  /// Imagine the wheel as a donut shaped cake,
  /// One can cut it into multiple slices,
  /// Then, if we cut one slice into equal height pieces, each piece would share
  /// the same height.
  /// Height of each fan piece
  final double pieceHeight;

  /// default button color
  final Color defaultColor;

  /// see [FanAnimationConfig] for detail
  /// animationConfig determines the animation behaviour of this widget
  final FanAnimationConfig animationConfig;

  /// callback function which gets invoked when one color is picked
  final void Function(Color) onSelect;

  /// [stickToButton] will cause the overlay to center at the [WheelInkButton]
  final bool stickToButton;

  /// see [ButtonBehaviour], [ButtonBehaviour.longPressToOpen]
  /// [ButtonBehaviour.clickToOpen]
  final ButtonBehaviour? behaviour;

  final void Function(Color)? onTap;

  final bool debugMode;

  final double fanPieceBorderSize;

  /// {@macro wheel_color_picker}
  const WheelColorPicker({
    Key? key,
    this.animationConfig = const FanAnimationConfig(),
    required this.onSelect,
    required this.defaultColor,
    required this.innerRadius,
    required this.pieceHeight,
    required this.buttonSize,
    this.onTap,
    this.behaviour = ButtonBehaviour.longPressToOpen,
    this.stickToButton = true,
    this.colorList = defaultAvailableColors,
    this.fanPieceBorderSize = 0,
    this.debugMode = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WheelColorPickerState();
  }
}

/// {@macro wheel_color_picker}
class WheelColorPickerState extends State<WheelColorPicker> with TickerProviderStateMixin, WidgetsBindingObserver {
  final _key = GlobalKey();
  final layerLink = LayerLink();

  /// Animation controller of the the component,
  /// it's responsible to trigger animations in [FanFlowDelegation]
  /// and [FanSliceDelegate].
  late AnimationController _controller;

  /// current color of the button
  late Color color;

  /// List of fan pieces generated on initialization with respect to colors
  List<FanSlice> fanSliceList = [];

  /// Overlay content is generated post build
  /// The reason for this is because we need the trigger button's location information
  /// in-order to determine the center position for our wheel
  /// Also this saves unnecessary computation
  late Widget overlayContent;

  /// When the overlay is shown, isOpen is true
  /// We can technically only rely on overlayEntry to determine if the
  /// overlay is shown; however, we want to show the animation of fan slices
  /// disappearing, thus the removal of overlayEntry is a future.
  /// Thus to prevent user from double tapping another color before the
  /// overlay disappears, we have to check isOpen.
  bool isOpen = false;

  /// current overlayEntry
  /// to remove the overlay, we can do overlayEntry.remove()
  /// which will remove its self from [OverlayState]
  /// The content of the overlayEntry is generated
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();
    color = widget.defaultColor;
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.animationConfig.animationDurationInMillisecond),
      vsync: this,
    );
    /// we calculate overlay entry content once
    /// each time when we are showing the overlay, we are just putting the same
    /// content into a new [OverlayEntry], and push the [OverlayEntry] into the
    /// [OverlayState]
    _genOverlayEntryContent();
  }

  @override
  void dispose() async {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
    _controller.dispose();
    super.dispose();
  }

  void _genOverlayEntryContent() {
    LayerLinkConfig layerLinkConfig = const LayerLinkConfig();
    if (widget.stickToButton) {
      layerLinkConfig = LayerLinkConfig(
        enabled: true,
        layerLink: layerLink,
        buttonRadius: widget.buttonSize / 2,
      );
    }
    overlayContent = Positioned(
        child: WheelOverlayEntryContent(
            animationConfig: widget.animationConfig,
            animationController: _controller,
            colors: widget.colorList,
            innerRadius: widget.innerRadius,
            layerLinkConfig: layerLinkConfig,
            pieceBorderSize: widget.fanPieceBorderSize,
            hideOverlay: _hideOverlay,
            onSelect: (Color selectedColor) {
              /// isOpen is necessary to prevent user from selecting another fan
              /// piece after the color callback has been invoked
              if (isOpen) {
                /// onSelect is passed in, the caller can decide what to do with the color
                widget.onSelect(selectedColor);

                setState(() {
                  /// change the button's color
                  color = selectedColor;
                });

                /// reverse the open animation
                _controller.reverse();

                /// hide the overlay, with a delay to wait for animation to finish
                _hideOverlay();
              }
            },
            pieceHeight: widget.pieceHeight
        )
    );
  }

  /// hide the overlay entry
  void _hideOverlay() async {
    isOpen = false;
    _controller.reverse();
    return Future.delayed(Duration(milliseconds: widget.animationConfig.animationDurationInMillisecond)).then((_) {
      if (overlayEntry != null) {
        overlayEntry!.remove();
        overlayEntry = null;
      }
    });
  }

  /// create and display the overlay entry
  void _showOverlay(BuildContext context) async {
    if (isOpen==false && overlayEntry == null) {
      isOpen = true;
      final OverlayState? overlayState = Overlay.of(context);
      overlayEntry = OverlayEntry(builder: (_) => overlayContent);
      overlayState!.insert(overlayEntry!);
      _controller.forward();
    }
  }

  void _onLongPress() {
    if (!isOpen) {
      _showOverlay(context);
    } else if (overlayEntry != null) {
      _hideOverlay();
    }
  }

  void _onTap() {
    if (widget.behaviour == ButtonBehaviour.clickToOpen && !isOpen) {
      _showOverlay(context);
    } else if (overlayEntry != null && widget.behaviour != ButtonBehaviour.clickToOpen) {
      _hideOverlay();
    }
    if (widget.onTap != null) {
      widget.onTap!(color);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        key: _key,
        alignment: Alignment.center,
        child: WheelInkButton(
          color: color,
          onLongPress: _onLongPress,
          onTap: _onTap,
          layerLink: layerLink,
          buttonSize: widget.buttonSize,
        )
    );
  }
}
