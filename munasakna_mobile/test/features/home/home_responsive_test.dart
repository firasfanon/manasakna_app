import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:munasakna_mobile/app/munasakna_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SliverGridDelegateWithFixedCrossAxisCount> _pumpHomeAtWidth(
  WidgetTester tester,
  double width,
) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 900);

  await tester.pumpWidget(const ProviderScope(child: MunasaknaApp()));
  await tester.pumpAndSettle(const Duration(milliseconds: 500));

  final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
  expect(scaffold.extendBody, isFalse);

  await tester.scrollUntilVisible(
    find.text('خدمات سريعة'),
    350,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();

  final gridFinder = find.byKey(const ValueKey<String>('quick-services-grid'));
  expect(gridFinder, findsOneWidget);

  final grid = tester.widget<GridView>(gridFinder);
  expect(
    grid.gridDelegate,
    isA<SliverGridDelegateWithFixedCrossAxisCount>(),
  );

  expect(tester.takeException(), isNull);

  return grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('home responsive contract at 360px', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final delegate = await _pumpHomeAtWidth(tester, 360);

    expect(delegate.crossAxisCount, 3);
    expect(delegate.childAspectRatio, closeTo(0.92, 0.001));

    final navSize = tester.getSize(
      find.byKey(const ValueKey<String>('munasakna-bottom-nav-surface')),
    );
    expect(navSize.width, lessThan(360));
  });

  testWidgets('home responsive contract at 768px', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final delegate = await _pumpHomeAtWidth(tester, 768);

    expect(delegate.crossAxisCount, 4);
    expect(delegate.childAspectRatio, closeTo(1.12, 0.001));

    final navSize = tester.getSize(
      find.byKey(const ValueKey<String>('munasakna-bottom-nav-surface')),
    );
    expect(navSize.width, closeTo(732, 1.0));
  });

  testWidgets('home responsive contract at 1280px', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final delegate = await _pumpHomeAtWidth(tester, 1280);

    expect(delegate.crossAxisCount, 6);
    expect(delegate.childAspectRatio, closeTo(1.35, 0.001));

    final navSize = tester.getSize(
      find.byKey(const ValueKey<String>('munasakna-bottom-nav-surface')),
    );
    expect(navSize.width, closeTo(760, 1.0));
  });

  testWidgets('home responsive contract at 1440px and nav does not cover body',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final delegate = await _pumpHomeAtWidth(tester, 1440);

    expect(delegate.crossAxisCount, 6);
    expect(delegate.childAspectRatio, closeTo(1.35, 0.001));

    final navFinder =
        find.byKey(const ValueKey<String>('munasakna-bottom-nav-surface'));
    final navSize = tester.getSize(navFinder);
    expect(navSize.width, closeTo(760, 1.0));

    await tester.scrollUntilVisible(
      find.text('وضع التطوير: بلا تسجيل دخول'),
      350,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    final navTop = tester.getTopLeft(navFinder).dy;
    final developmentTextBottom =
        tester.getBottomLeft(find.text('وضع التطوير: بلا تسجيل دخول')).dy;

    expect(developmentTextBottom, lessThan(navTop));
    expect(tester.takeException(), isNull);
  });
}
