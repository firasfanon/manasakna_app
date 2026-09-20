import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:munasakna_mobile/features/journey_contract/domain/journey_context.dart';
import 'package:munasakna_mobile/features/unified_journey/data/phase8_journey_catalog.dart';
import 'package:munasakna_mobile/features/unified_journey/domain/unified_journey_resolution.dart';
import 'package:munasakna_mobile/features/unified_journey/presentation/unified_journey_switcher.dart';

Future<UnifiedJourneyResolution> buildResolution({
  JourneyType? preferredType = JourneyType.hajj,
  JourneyFreshness umrahFreshness = JourneyFreshness.fresh,
}) async {
  final contexts = await LocalPhase8JourneyCatalog(
    umrahFreshness: umrahFreshness,
  ).loadEligibleJourneys();
  return const UnifiedJourneyResolver().resolve(
    contexts,
    preferredType: preferredType,
  );
}

Widget appFor(
  UnifiedJourneyResolution resolution, {
  ValueChanged<JourneyType>? onSelect,
  double textScale = 1,
}) {
  return MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: UnifiedJourneySwitcherView(
              resolution: resolution,
              onSelect: onSelect ?? (_) {},
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('switcher distinguishes government Hajj from company Umrah',
      (tester) async {
    final resolution = await buildResolution();
    await tester.pumpWidget(appFor(resolution));
    await tester.pumpAndSettle();

    expect(find.text('الحج'), findsOneWidget);
    expect(find.text('العمرة'), findsOneWidget);
    expect(find.text('معلومة رسمية من الجهة الحكومية'), findsOneWidget);
    expect(
      find.textContaining('المعلومات الرسمية المرتبطة بالحج'),
      findsOneWidget,
    );
  });

  testWidgets('switcher changes journey only through explicit traveler action',
      (tester) async {
    final resolution = await buildResolution();
    JourneyType? selected;

    await tester.pumpWidget(
      appFor(
        resolution,
        onSelect: (value) => selected = value,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('العمرة'));
    await tester.pump();

    expect(selected, JourneyType.umrah);
  });

  testWidgets('offline snapshot language is explicit', (tester) async {
    final resolution = await buildResolution(
      preferredType: JourneyType.umrah,
      umrahFreshness: JourneyFreshness.offlineSnapshot,
    );

    await tester.pumpWidget(appFor(resolution));
    await tester.pumpAndSettle();

    expect(find.textContaining('نسخة محفوظة للعمل دون اتصال'), findsOneWidget);
    expect(
      find.textContaining('ليست حالة حج رسمية'),
      findsOneWidget,
    );
  });

  testWidgets('ambiguous multiple journeys prompt explicit selection',
      (tester) async {
    final resolution = await buildResolution(preferredType: null);

    await tester.pumpWidget(appFor(resolution));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('تعذر تحديد رحلة واحدة دون غموض'),
      findsOneWidget,
    );
  });

  testWidgets('RTL narrow viewport has no render overflow', (tester) async {
    tester.view.physicalSize = const Size(360, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final resolution = await buildResolution(
      preferredType: JourneyType.umrah,
    );

    await tester.pumpWidget(appFor(resolution));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('رحلاتي'), findsOneWidget);
  });

  testWidgets('200 percent text scale remains usable', (tester) async {
    tester.view.physicalSize = const Size(360, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final resolution = await buildResolution();

    await tester.pumpWidget(appFor(resolution, textScale: 2));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('معلومة رسمية من الجهة الحكومية'), findsOneWidget);
  });
}
