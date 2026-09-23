import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:munasakna_mobile/features/journey/presentation/pages/journey_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'preferredRitualPath': 'hajj',
    });
  });

  testWidgets('traveler can switch explicitly from Hajj to Umrah',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: JourneyPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('مراحل رحلة الحاج'),
      350,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('مراحل رحلة الحاج'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('العمرة'),
      -350,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('العمرة'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('مراحل رحلة المعتمر'),
      350,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('مراحل رحلة المعتمر'), findsOneWidget);
  });

  testWidgets('traveler can return to government Hajj mode', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'preferredRitualPath': 'umrah',
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: JourneyPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('مراحل رحلة المعتمر'),
      350,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('مراحل رحلة المعتمر'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('الحج'),
      -350,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('الحج'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('مراحل رحلة الحاج'),
      350,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('مراحل رحلة الحاج'), findsOneWidget);
  });
}
