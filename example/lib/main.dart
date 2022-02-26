import 'package:flutter/material.dart';
import 'package:wheel_colorpicker/wheel_colorpicker.dart';

void main() {
  ///debugRepaintRainbowEnabled = true;
  runApp(const WheelColorPickerDemo());
}

class WheelColorPickerDemo extends StatefulWidget {
  const WheelColorPickerDemo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WheelColorPickerDemoState();
  }
}

class WheelColorPickerDemoState extends State<WheelColorPickerDemo> {
  Color color2 = Colors.redAccent;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Wheel Colorpicker Demo'),
          ),
          body: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[200],
              child: Stack(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            width: 800,
                            height: 800,
                            color: Colors.grey[300],
                            child: WheelColorPicker(
                              onSelect: (Color color) {
                                print(color.toString());
                              },
                              key: const GlobalObjectKey("wheel_color_picker"),
                              defaultColor: Colors.blueAccent,
                              animationConfig: fanLikeAnimationConfig,
                              colors: defaultAvailableColors,
                              maxItemCount: 7,
                              buttonSize: 40,
                              pieceHeight: 25,
                              innerRadius: 80,
                            )
                        )
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                              color: color2,
                              width: 8,
                            ),
                          ),
                          child: WheelColorPicker(
                            onSelect: (Color color) {
                              setState(() {
                                color2 = color;
                              });
                            },
                            key: const GlobalObjectKey("wheel_color_picker_2"),
                            defaultColor: color2,
                            animationConfig: sunRayLikeAnimationConfig,
                            colors: simpleColors,
                            maxItemCount: 10,
                            buttonSize: 50,
                            pieceHeight: 15,
                            innerRadius: 100,
                          ),
                        )
                    )
                  ]
              )
          )
      ),
    );
  }

}

