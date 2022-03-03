import 'package:flutter/material.dart';
import 'package:wheel_color_picker/models/layerlink_config.dart';
import 'package:wheel_color_picker/models/models.dart';
import 'package:wheel_color_picker/wheel_color_picker.dart';

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

class WheelColorPickerDemoState extends State<WheelColorPickerDemo> with SingleTickerProviderStateMixin {
  Color color2 = Colors.redAccent;
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Wheel Color Picker Demo'),
            ),
            body: NotificationListener<ScrollEndNotification>(
                onNotification: (notification) {
                  return true;
                },
                child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 20,
                    children: [
                      Container(
                          width: 200,
                          height: 200,
                          color: Colors.grey[300],
                          child: WheelColorPicker(
                            onSelect: (Color color) {
                              print(color.toString());
                            },
                            key: const GlobalObjectKey("wheel_color_picker"),
                            defaultColor: Colors.blueAccent,
                            animationConfig: fanLikeAnimationConfig,
                            colorList: defaultAvailableColors,
                            buttonSize: 40,
                            pieceHeight: 25,
                            innerRadius: 80,
                          )
                      ),
                      Container(
                        width: 200,
                        height: 200,
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
                          onTap: (color) {
                          },
                          animationConfig: sunRayLikeAnimationConfig,
                          stickToButton: true,
                          colorList: simpleColors,
                          behaviour: ButtonBehaviour.clickToOpen,
                          buttonSize: 50,
                          pieceHeight: 15,
                          innerRadius: 100,
                        ),
                      ),
                      Container(
                          width: 200,
                          height: 200,
                          color: Colors.grey[300],
                          child: WheelColorPicker(
                            onSelect: (Color color) {
                              print(color.toString());
                            },
                            key: const GlobalObjectKey("wheel_color_picker_3"),
                            defaultColor: Colors.blueAccent,
                            animationConfig: fanLikeAnimationConfig,
                            colorList: defaultAvailableColors,
                            buttonSize: 40,
                            pieceHeight: 25,
                            innerRadius: 80,
                          )
                      ),
                      Container(
                          width: 200,
                          height: 200,
                          color: Colors.grey[300],
                          child: WheelColorPicker(
                            onSelect: (Color color) {
                              print(color.toString());
                            },
                            key: const GlobalObjectKey("wheel_color_picker_4"),
                            stickToButton: false,
                            defaultColor: Colors.blueAccent,
                            colorList: defaultAvailableColors,
                            fanPieceBorderSize: 10,
                            animationConfig: fanLikeAnimationConfig,
                            buttonSize: 40,
                            pieceHeight: 45,
                            innerRadius: 100,
                          )
                      ),
                      WheelOverlayEntryContent(
                        alignment: Alignment.center,
                        layerLinkConfig: const LayerLinkConfig(
                          enabled: false,
                        ),
                        onSelect: (Color color) {
                          print(color.toString());
                        },
                        key: const GlobalObjectKey("wheel_overlay_entry"),
                        animationConfig: fanLikeAnimationConfig,
                        colors: [[Colors.red, Colors.redAccent], [Colors.green, Colors.greenAccent]],
                        pieceHeight: 25,
                        animationController: controller,
                      ),
                    ]
                )
            )
    ),
    );
  }
}

