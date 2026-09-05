import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:munasakna_mobile/app/munasakna_app.dart';
import 'package:munasakna_mobile/app/router/munasakna_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets(
    'assistant survives repeated navigation lifecycle without Flutter exception',
    (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MunasaknaApp()));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      final router = GoRouter.of(
        tester.element(find.text('مناسكنا').first),
      );

      for (var cycle = 0; cycle < 3; cycle++) {
        router.go(MunasaknaRoutes.hajjAssistant);
        await tester.pumpAndSettle(const Duration(milliseconds: 500));
        expect(
          find.text('المساعد الصوتي الذكي'),
          findsAtLeastNWidgets(1),
        );

        router.go(MunasaknaRoutes.home);
        await tester.pumpAndSettle(const Duration(milliseconds: 500));
        expect(find.text('رحلتي 1448'), findsOneWidget);

        router.go(MunasaknaRoutes.rituals);
        await tester.pumpAndSettle(const Duration(milliseconds: 500));
        expect(find.textContaining('المناسك'), findsWidgets);

        router.go(MunasaknaRoutes.hajjAssistant);
        await tester.pumpAndSettle(const Duration(milliseconds: 500));
        expect(
          find.text('المساعد الصوتي الذكي'),
          findsAtLeastNWidgets(1),
        );
      }

      expect(tester.takeException(), isNull);
    },
  );
}
