import 'package:flutter/cupertino.dart';

class LayerLinkConfig {
  final bool enabled;
  final double buttonRadius;
  final LayerLink? layerLink;

  const LayerLinkConfig({
    this.enabled = false,
    this.buttonRadius = 0,
    this.layerLink,
  });
}