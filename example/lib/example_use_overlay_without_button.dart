import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/monokai.dart';
import 'package:wheel_color_picker/wheel_color_picker.dart';

class ExampleUseOverlayOnly extends StatefulWidget {
  const ExampleUseOverlayOnly({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ExampleUseOverlayOnlyState();
  }
}

const codeSample = '''
!!! Note: If you want to attach overly to some element, you need to use OverlayLink
See WheelColorPicker class for detail

class ExampleUseOverlayOnlyState extends State<ExampleUseOverlayOnly> with SingleTickerProviderStateMixin {
  Color color = Colors.redAccent;
  late Widget overlayContent;
  late AnimationController controller;
  OverlayEntry? _overlayEntry;
  bool isOpen = false;

  @override
  void dispose() {
      if (isOpen && _overlayEntry != null) {
          _overlayEntry!.remove();
          _overlayEntry = null;
      }
      super.dispose();
  }

  void _showOverlay() async {
      if (!isOpen) {
          isOpen = true;
          controller.forward();
          OverlayState? overlayState = Overlay.of(context);
          _overlayEntry = OverlayEntry(builder: (context) => overlayContent);
          overlayState?.insert(_overlayEntry!);
      }
  }

  void _hideOverlay() async {
      if (isOpen) {
          isOpen = false;
          controller.reverse();
          Future.delayed(const Duration(milliseconds: 500)).then((_) {
              if (_overlayEntry != null) {
                  _overlayEntry!.remove();
                  _overlayEntry = null;
              }
          });
      }
  }

  @override
  void initState() {
      super.initState();
      controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
      overlayContent = WheelOverlayEntryContent(
          animationController: controller,
          animationConfig: sunRayLikeAnimationConfig,
          colors: simpleColors,
          innerRadius: 10,
          hideOverlay: _hideOverlay,
          onSelect: (Color selectedColor) {
              _hideOverlay();
              setState(() {
                  color = selectedColor;
              });
          },
          pieceHeight: 30,
      );
  }
  
  @override
  Widget build (BuildContext context) {
      return Container(
          child: MaterialButton(
              color: Colors.blueAccent,
              textColor: Colors.white,
              child: const Text("Click to Open"),
              onPressed: _showOverlay,
          )
      )
  }
}
''';

class ExampleUseOverlayOnlyState extends State<ExampleUseOverlayOnly> with SingleTickerProviderStateMixin {
  Color color = Colors.redAccent;
  late Widget overlayContent;
  late AnimationController controller;
  OverlayEntry? _overlayEntry;
  bool isOpen = false;

  @override
  void dispose() {
    if (isOpen && _overlayEntry != null) {
        _overlayEntry!.remove();
        _overlayEntry = null;
    }
    super.dispose();
  }

  void _showOverlay() async {
    if (!isOpen) {
      isOpen = true;
      controller.forward();
      OverlayState? overlayState = Overlay.of(context);
      _overlayEntry = OverlayEntry(builder: (context) => overlayContent);
      overlayState?.insert(_overlayEntry!);
    }
  }

  void _hideOverlay() async {
    if (isOpen) {
      isOpen = false;
      controller.reverse();
      Future.delayed(const Duration(milliseconds: 500)).then((_) {
        if (_overlayEntry != null) {
          _overlayEntry!.remove();
          _overlayEntry = null;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    overlayContent = WheelOverlayEntryContent(
      animationController: controller,
      animationConfig: sunRayLikeAnimationConfig,
      colors: simpleColors,
      innerRadius: 200,
      pieceHeight: 20,
      pieceBorderSize: 5,
      hideOverlay: _hideOverlay,
      onSelect: (Color selectedColor) {
        _hideOverlay();
        setState(() {
          color = selectedColor;
        });
      },
    );
  }

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
                            )
                        ),
                        const Expanded(flex:2, child: SizedBox()),
                        Expanded(flex:2,
                            child: MaterialButton(
                              color: Colors.blueAccent,
                              textColor: Colors.white,
                              child: const Text("Click to Open"),
                              onPressed: _showOverlay,
                            )
                        ),
                        const Expanded(
                            flex:8,
                            child: Align(
                                alignment: Alignment.topCenter,
                                child: SizedBox(
                                    height: 500,
                                    width: 500,
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
          padding: const EdgeInsets.all(15),
          textStyle: const TextStyle(
            fontSize: 9,
            height: 1.2,
            fontFamily: 'RaleWay',
            letterSpacing: 0.5,
            wordSpacing: 3,
          ),
        )
      ],
    );
  }
}