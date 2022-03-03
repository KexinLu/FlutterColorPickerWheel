import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheel_color_picker/widgets/wheel_overlay_entry_content.dart';

const snapshotPath = 'snapshots';

void main() {
  List<List<Color>> colorsList = const [
    [Colors.red, Colors.lightGreenAccent, Colors.green],
    [Colors.black, Colors.lightBlue, Colors.amberAccent],
    [Colors.purple, Colors.deepPurpleAccent, Colors.purpleAccent]
  ];
  testWidgets(
    "Testing WheelOverlayEntry rendering",
        (WidgetTester tester) async {
      final GlobalKey target = GlobalKey();
      AnimationController controller = AnimationController(vsync: tester);
      await tester.pumpWidget(
          WheelOverlayEntryContent(
            debugMode: true,
            key: target,
            colors: colorsList,
            onSelect: (_) {},
            pieceHeight: 50,
            animationController: controller,
          )
      );
      await expectLater(
          find.byKey(target).first,
          matchesGoldenFile('$snapshotPath/can_render/render.png')
      );
    },
  );

  testWidgets(
    "Testing WheelOverlayEntry rendering with innerRadius",
        (WidgetTester tester) async {
      final GlobalKey target = GlobalKey();
      AnimationController controller = AnimationController(vsync: tester);
      await tester.pumpWidget(
          WheelOverlayEntryContent(
            key: target,
            colors: colorsList,
            debugMode: true,
            onSelect: (_) {},
            pieceHeight: 50,
            animationController: controller,
            innerRadius: 100,
          )
      );
      await expectLater(
          find.byKey(target).first,
          matchesGoldenFile('snapshots/can_render_inner_radius/render.png')
      );
    },
  );

  testWidgets(
    "Testing WheelOverlayEntry rendering with padding",
        (WidgetTester tester) async {
      final GlobalKey target = GlobalKey();
      AnimationController controller = AnimationController(vsync: tester);
      await tester.pumpWidget(
          WheelOverlayEntryContent(
            key: target,
            debugMode: true,
            colors: colorsList,
            onSelect: (_) {},
            pieceHeight: 50,
            animationController: controller,
            innerRadius: 100,
            padding: 80,
          )
      );
      await expectLater(
          find.byKey(target).first,
          matchesGoldenFile('snapshots/can_have_padding/render.png')
      );
    },
  );

  testWidgets(
    "Testing WheelOverlayEntry can drag to rotate - right",
        (WidgetTester tester) async {
      final GlobalKey target = GlobalKey();
      AnimationController controller = AnimationController(
          vsync: tester,
          duration: const Duration(milliseconds: 500)
      );
      await tester.pumpWidget(
          WheelOverlayEntryContent(
              key: target,
              debugMode: true,
              colors: colorsList,
              onSelect: (_) {},
              pieceHeight: 50,
              animationController: controller,
              innerRadius: 100,
              padding: 80
          )
      );
      controller.forward();
      await tester.pumpAndSettle();
      await expectLater(
          find.byKey(target).first,
          matchesGoldenFile('snapshots/right_rotate/before_rotate.png')
      );

      Offset start = const Offset( 500, 50, );
      Offset end = const Offset( 500, 200, );
      await tester.dragFrom(start, end);
      await tester.pumpAndSettle();
      await expectLater(
          find.byKey(target).first,
          matchesGoldenFile('snapshots/right_rotate/after_rotate.png')
      );

      await tester.dragFrom(const Offset(500, 200), const Offset(500, 150));
      await tester.pumpAndSettle();
      await expectLater(
          find.byKey(target).first,
          matchesGoldenFile('snapshots/right_rotate/after_rotate_reverse.png')
      );
    },
  );

  testWidgets(
    "Testing WheelOverlayEntry can drag to rotate - left",
        (WidgetTester tester) async {
      final GlobalKey target = GlobalKey();
      AnimationController controller = AnimationController(
          vsync: tester,
          duration: const Duration(milliseconds: 500)
      );
      await tester.pumpWidget(
          WheelOverlayEntryContent(
              key: target,
              debugMode: true,
              colors: colorsList,
              onSelect: (_) {},
              pieceHeight: 50,
              animationController: controller,
              innerRadius: 100,
              padding: 80
          )
      );
      controller.forward();
      await tester.pumpAndSettle();
      await expectLater(
          find.byKey(target).first,
          matchesGoldenFile('snapshots/left_rotate/wheel_overlay_entry_content_before_rotate.png')
      );

      Offset start = const Offset( 200, 50, );
      Offset end = const Offset( 200, 200, );
      await tester.dragFrom(start, end);
      await tester.pumpAndSettle();
      await expectLater(
          find.byKey(target).first,
          matchesGoldenFile('snapshots/left_rotate/wheel_overlay_entry_content_after_rotate.png')
      );

      await tester.dragFrom(const Offset(200, 200), const Offset(200, 150));
      await tester.pumpAndSettle();
      await expectLater(
          find.byKey(target).first,
          matchesGoldenFile('snapshots/left_rotate/after_rotate_reverse.png')
      );
    },
  );
}
