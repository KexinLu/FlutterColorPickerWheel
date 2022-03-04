import 'package:flutter/material.dart';

class WheelInkButton extends StatelessWidget {
  const WheelInkButton({
    Key? key,
    required this.buttonSize,
    required this.layerLink,
    required this.color,
    required this.onLongPress,
    required this.onTap
  }) : super(key: key);

  final double buttonSize;
  final LayerLink layerLink;
  final Color color;
  final void Function() onLongPress;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
        child: AnimatedContainer(
            width: buttonSize,
            height: buttonSize,
            duration: const Duration(seconds: 2),
            curve: Curves.easeIn,
            child: CompositedTransformTarget(
                link: layerLink,
                child: Material(
                    shape: const CircleBorder(),
                    color: color,
                    child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          focusColor: color,
                          onLongPress: onLongPress,
                          onTap: onTap,
                        )
                    )
                )
            )
        )
    );
  }
}
