import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:munasakna_mobile/app/router/munasakna_routes.dart';
import 'package:munasakna_mobile/app/theme/munasakna_theme.dart';
import 'package:munasakna_mobile/core/widgets/munasakna_bottom_nav.dart';

double _contrastRatio(Color first, Color second) {
  final firstLuminance = first.computeLuminance();
  final secondLuminance = second.computeLuminance();
  final lighter =
      firstLuminance > secondLuminance ? firstLuminance : secondLuminance;
  final darker =
      firstLuminance > secondLuminance ? secondLuminance : firstLuminance;
  return (lighter + 0.05) / (darker + 0.05);
}

Border _focusedBorder(WidgetTester tester, Finder item) {
  final animated = find.descendant(
    of: item,
    matching: find.byType(AnimatedContainer),
  );
  expect(animated, findsOneWidget);

  final decoration =
      tester.widget<AnimatedContainer>(animated).decoration! as BoxDecoration;
  return decoration.border! as Border;
}

void main() {
  testWidgets(
    'bottom navigation preserves semantics tap action touch target and focus contrast',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final semantics = tester.ensureSemantics();
      final theme = MunasaknaTheme.light();

      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(
            bottomNavigationBar: MunasaknaBottomNav(selectedIndex: 2),
          ),
        ),
      );

      for (final label in const [
        'المناسك',
        'رحلتي',
        'الرئيسية',
        'المساعد',
        'المزيد',
      ]) {
        expect(find.bySemanticsLabel(label), findsOneWidget);
      }

      expect(
        tester.getSemantics(find.bySemanticsLabel('المساعد')),
        matchesSemantics(
          label: 'المساعد',
          hint: 'الانتقال إلى المساعد',
          isButton: true,
          hasSelectedState: true,
          hasTapAction: true,
        ),
      );

      final assistantItem = find.byKey(
        const ValueKey<String>(
          'bottom-nav-${MunasaknaRoutes.hajjAssistant}',
        ),
      );
      expect(assistantItem, findsOneWidget);

      final assistantSize = tester.getSize(assistantItem);
      expect(assistantSize.width, greaterThanOrEqualTo(48));
      expect(assistantSize.height, greaterThanOrEqualTo(48));

      final assistantInk = tester.widget<InkWell>(assistantItem);
      expect(assistantInk.focusNode, isNotNull);
      assistantInk.focusNode!.requestFocus();
      await tester.pumpAndSettle();

      final assistantBorder = _focusedBorder(tester, assistantItem);
      expect(assistantBorder.top.color, theme.colorScheme.primary);
      expect(assistantBorder.top.width, 3);
      expect(
        _contrastRatio(
          assistantBorder.top.color,
          theme.colorScheme.surface,
        ),
        greaterThanOrEqualTo(3),
      );

      final homeItem = find.byKey(
        const ValueKey<String>(
          'bottom-nav-${MunasaknaRoutes.home}',
        ),
      );
      expect(homeItem, findsOneWidget);

      final homeInk = tester.widget<InkWell>(homeItem);
      expect(homeInk.focusNode, isNotNull);
      homeInk.focusNode!.requestFocus();
      await tester.pumpAndSettle();

      final homeBorder = _focusedBorder(tester, homeItem);
      expect(homeBorder.top.color, MunasaknaTheme.kiswahGold);
      expect(homeBorder.top.width, 3);
      expect(
        _contrastRatio(
          homeBorder.top.color,
          MunasaknaTheme.deepHaramGreen,
        ),
        greaterThanOrEqualTo(3),
      );

      semantics.dispose();
    },
  );

  testWidgets(
    'bottom navigation remains usable at 200 percent text scale',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: MunasaknaTheme.light(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(2),
              ),
              child: child!,
            );
          },
          home: const Scaffold(
            bottomNavigationBar: MunasaknaBottomNav(selectedIndex: 2),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('الرئيسية'), findsOneWidget);
      expect(find.text('المساعد'), findsOneWidget);
    },
  );
}
