import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/monokai.dart';
import 'package:flutter_color_picker_wheel/models/button_behaviour.dart';
import 'package:flutter_color_picker_wheel/flutter_color_picker_wheel.dart';

class ExampleDetachedWithGap extends StatefulWidget {
  const ExampleDetachedWithGap({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ExampleDetachedWithGapState();
  }
}

const codeSample = '''
WheelColorPicker(
    onSelect: (Color newColor) {
        setState(() {
            color = newColor;
        });
    },
    key: const GlobalObjectKey("flutter_color_picker_wheel_example1"),
    defaultColor: color,
    animationConfig: sunRayLikeAnimationConfig,                   
    colorList: simpleColors,                                     
    fanPieceBorderSize: 8,                      <-----------------
    stickToButton: false,                       <-----------------
    behaviour: ButtonBehaviour.clickToOpen,
    buttonSize: 40,
    pieceHeight: 25,
    innerRadius: 80,
)
''';

class ExampleDetachedWithGapState extends State<ExampleDetachedWithGap> {
  Color color = Colors.redAccent;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: true,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      crossAxisCount: 2,
      children: [
        Container(
            color: Colors.grey[300],
            child:
                Container(
                  padding: const EdgeInsets.all(150),
                  child: Column(
                      children:[
                        Expanded(
                            flex:12,
                            child: Container(
                                height: 500,
                                width: 500,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(45),
                                    border: Border.all(
                                        width: 15,
                                        color: color
                                    )
                                ),
                                child: WheelColorPicker(
                                  onSelect: (Color newColor) {
                                    setState(() {
                                      color = newColor;
                                    });
                                  },
                                  key: const GlobalObjectKey("flutter_color_picker_wheel_example_overlay_gap"),
                                  defaultColor: color,
                                  animationConfig: sunRayLikeAnimationConfig,
                                  behaviour: ButtonBehaviour.clickToOpen,
                                  stickToButton: false,
                                  fanPieceBorderSize: 25,
                                  colorList: simpleColors,
                                  buttonSize: 80,
                                  pieceHeight: 30,
                                  innerRadius: 80,
                                )
                            )
                        ),
                        const Expanded(flex:1, child: SizedBox()),
                        Expanded(
                            flex:8,
                            child: Align(
                                alignment: Alignment.topCenter,
                                child: SizedBox(
                                    height: 500,
                                    width: 500,
                                    child: RichText(
                                        text: const TextSpan(
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.indigo,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(text: 'Tap to open \n'),
                                              TextSpan(text: 'Drag to rotate \n'),
                                              TextSpan(text: '\n'),
                                              TextSpan(text: 'Full screen overlay \n'),
                                              TextSpan(text: 'Click dimmer to close')
                                            ]
                                        )
                                    )
                                )
                            )
                        ),
                      ]

                  )

                )
        ),
        HighlightView(
          codeSample,
          language: 'dart',
          theme: monokaiTheme,
          padding: const EdgeInsets.all(55),
          textStyle: const TextStyle(
            height: 1.5,
            fontFamily: 'RaleWay',
            letterSpacing: 0.5,
            wordSpacing: 3,
          ),
        )
      ],
    );
  }
}