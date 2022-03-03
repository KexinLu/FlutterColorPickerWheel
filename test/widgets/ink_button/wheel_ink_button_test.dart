import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheel_color_picker/widgets/ink_button.dart';
import 'package:wheel_color_picker/widgets/wheel_overlay_entry_content.dart';

const snapshotPath = 'snapshots';

void main() {
  testWidgets(
    "Testing WheelInkButton",
        (WidgetTester tester) async {
      final GlobalKey target = GlobalKey();
      LayerLink ll = LayerLink();

      var longPressCalled = false;
      var tapCalled = false;

      await tester.pumpWidget(
          Container(
              height: 500,
              width: 500,
              color: Colors.grey,
              child: Center(
                  child: WheelInkButton(
                  key: target,
                  buttonSize: 50,
                  layerLink: ll,
                  color: Colors.greenAccent,
                  onLongPress: () {
                    longPressCalled = true;
                  },
                  onTap: () {
                    tapCalled = true;
                  }
              ))
          )
      );

      await expectLater(
          find.byKey(target).first,
          matchesGoldenFile('snapshots/render.png')
      );
      expect(longPressCalled, false);
      expect(tapCalled, false);

      await tester.longPress(find.byKey(target));
      await tester.pump();
      expect(longPressCalled, true);
      expect(tapCalled, false);

      await tester.tap(find.byKey(target));
      await tester.pump();
      expect(longPressCalled, true);
      expect(tapCalled, true);
    },
  );
}
