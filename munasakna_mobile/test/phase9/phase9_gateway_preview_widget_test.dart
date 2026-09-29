import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:munasakna_mobile/phase9_preview_main.dart';

void main() {
  testWidgets('Phase 9 preview renders safe cross-plane Umrah projection',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const Phase9PreviewApp());
    await tester.pumpAndSettle();

    expect(find.text('Phase 9 — تكامل دون دمج السلطات'), findsOneWidget);
    expect(find.text('رحلة العمرة'), findsWidgets);
    expect(
      find.text('Cross-plane projection: فعال تجريبيًا'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
