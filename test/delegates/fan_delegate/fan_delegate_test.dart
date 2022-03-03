import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheel_color_picker/flow_delegates/fan_delegate.dart';

void main() {
  group("Testing FanDelegate", () {
    testWidgets("Testing FanDelegate widget", (WidgetTester tester) async {
      GlobalKey target = GlobalKey();
      await tester.pumpWidget(
          TestComponent(
            degree: 200,
            key: target,
          )
      );
      Finder widget = find.byKey(target).first;
      await expectLater(
          widget,
          matchesGoldenFile('snapshots/fan_delegate_rendering.png')
      );

      TestComponentState widgetState = tester.state(find.byKey(target));

      widgetState.controller.duration = const Duration(milliseconds: 1500);
      widgetState.controller.forward(from: 0.0);
      await tester.pumpAndSettle();
      await expectLater(
          widget,
          matchesGoldenFile('snapshots/fan_delegate_rendering_done.png')
      );
    });
  });
}

class TestComponent extends StatefulWidget {
  final double degree;
  const TestComponent({
    Key? key,
    required this.degree,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TestComponentState();
  }
}

class TestComponentState extends State<TestComponent> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    controller = AnimationController(vsync: this);
    animation = Tween<double>(begin: 0, end: widget.degree).animate(controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey,
        width: 500,
        height: 500,
        child: Center(
            child: Flow(
              delegate: FanFlowDelegation(center: const Offset(200,200), animation: animation),
              children: [
                Center(child: Container(width: 100, height: 200, color: Colors.red))
              ],
            )
        )
    );
  }
}
