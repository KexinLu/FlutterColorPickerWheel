import 'dart:math';
import 'package:wheel_colorpicker/models/models.dart';

import 'package:flutter/material.dart';
import 'package:wheel_colorpicker/wheel_colorpicker.dart';

void main() => runApp(const WheelColorPickerDemo());

class WheelColorPickerDemo extends StatelessWidget {
  const WheelColorPickerDemo({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Wheel Colorpicker Demo'),
          ),
          body: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[200],
              child: const Center(
                  child: WheelColorPicker(
                    animationDuration: 1400,
                    defaultColor: Colors.blueAccent,
                    colors: defaultAvailableColors,
                    maxItemCount: 7,
                    buttonRadius: 50,
                    pieceHeight: 40,
                    innerRadius: 200,
                  )
              )
          ),
        ),
      );
    }
}

