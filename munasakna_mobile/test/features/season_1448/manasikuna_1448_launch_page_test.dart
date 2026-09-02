import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:munasakna_mobile/features/season_1448/data/manasikuna_1448_synthetic_source.dart';
import 'package:munasakna_mobile/features/season_1448/presentation/pages/manasikuna_1448_launch_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('activation view is truthful and activates synthetic journey',
      (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('season1448-truthful-mode-banner')),
      findsOneWidget,
    );
    expect(find.textContaining('لا اتصال بنسك'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey<String>('season1448-fill-demo-token')),
    );
    await tester.pump();

    final field = tester.widget<TextField>(
      find.byKey(const ValueKey<String>('season1448-token-field')),
    );
    expect(
      field.controller?.text,
      Manasikuna1448SyntheticSource.demoToken,
    );

    await tester.tap(
      find.byKey(const ValueKey<String>('season1448-activate-button')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('season1448-active')),
      findsOneWidget,
    );
    expect(find.text('حاج تجريبي 1448'), findsOneWidget);
    expect(find.text('حملة الرفيق 1448 التجريبية'), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('season1448-operational-grid')),
      findsOneWidget,
    );
  });

  testWidgets('1448 launch page remains overflow-free at target widths',
      (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey<String>('season1448-fill-demo-token')),
    );
    await tester.pump();
    await tester.tap(
      find.byKey(const ValueKey<String>('season1448-activate-button')),
    );
    await tester.pumpAndSettle();

    for (final width in <double>[360, 768, 1280, 1440]) {
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1;
      await tester.pumpAndSettle();

      expect(
        tester.takeException(),
        isNull,
        reason: 'unexpected Flutter exception at width=$width',
      );
      expect(
        find.byKey(const ValueKey<String>('season1448-active')),
        findsOneWidget,
      );
    }

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}

Widget _app() {
  return const ProviderScope(
    child: MaterialApp(
      home: Manasikuna1448LaunchPage(),
    ),
  );
}
