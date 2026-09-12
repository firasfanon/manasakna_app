import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:munasakna_mobile/app/router/munasakna_routes.dart';
import 'package:munasakna_mobile/features/home/presentation/pages/munasakna_home_page.dart';
import 'package:munasakna_mobile/features/journey/presentation/pages/journey_page.dart';
import 'package:munasakna_mobile/features/nusuk_data/presentation/providers/nusuk_providers.dart';
import 'package:munasakna_mobile/features/services/presentation/pages/services_page.dart';

void main() {
  testWidgets('home notification icon opens notifications', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: MunasaknaRoutes.home,
          builder: (_, __) => const MunasaknaHomePage(),
        ),
        GoRoute(
          path: MunasaknaRoutes.notifications,
          builder: (_, __) =>
              const Scaffold(body: Text('NOTIFICATIONS_TARGET')),
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.notifications_rounded), findsOneWidget);
    await tester.tap(find.byIcon(Icons.notifications_rounded));
    await tester.pumpAndSettle();
    expect(find.text('NOTIFICATIONS_TARGET'), findsOneWidget);
  });

  testWidgets('services is pilgrim-only and searchable', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: MunasaknaRoutes.services,
          builder: (_, __) => const ServicesPage(),
        ),
      ],
      initialLocation: MunasaknaRoutes.services,
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    // ListView children outside the current viewport may not be built yet.
    // Verify the visible top of the list, then use the product search itself
    // to surface deeper services deterministically.
    expect(find.text('رفيق اليوم'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'الصحة');
    await tester.pumpAndSettle();
    expect(find.text('الصحة والسلامة'), findsOneWidget);
    expect(find.text('الطوارئ'), findsNothing);

    await tester.enterText(find.byType(TextField), 'الطوارئ');
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Text && widget.data == 'الطوارئ',
      ),
      findsOneWidget,
    );
    expect(find.text('الصحة والسلامة'), findsNothing);

    await tester.enterText(find.byType(TextField), 'خدمة غير موجودة');
    await tester.pumpAndSettle();
    expect(find.text('لا توجد خدمة مطابقة لبحثك.'), findsOneWidget);
  });

  testWidgets('journey uses repository-driven progress/readiness',
      (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: MunasaknaRoutes.journey,
          builder: (_, __) => const JourneyPage(),
        ),
      ],
      initialLocation: MunasaknaRoutes.journey,
    );
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );
    await tester.pumpAndSettle();

    expect(find.text('42%'), findsOneWidget);
    expect(find.text('جاهزية مبدئية'), findsOneWidget);
    expect(
      find.text('المرحلة الحالية: استكمال الجاهزية والوثائق'),
      findsOneWidget,
    );
    expect(find.textContaining('15 ذو القعدة'), findsNothing);
    expect(find.text('إكمال التطعيمات'), findsNothing);
  });

  testWidgets('journey errors hide raw provider exception', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: MunasaknaRoutes.journey,
          builder: (_, __) => const JourneyPage(),
        ),
      ],
      initialLocation: MunasaknaRoutes.journey,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          journeyOverviewProvider.overrideWith(
            (ref) async => throw Exception('SECRET_DIAGNOSTIC'),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('تعذر تحميل ملخص الرحلة الآن. حاول مرة أخرى لاحقًا.'),
      findsOneWidget,
    );
    expect(find.textContaining('SECRET_DIAGNOSTIC'), findsNothing);
  });

  test('public Services source excludes engineering-only routes', () {
    final source = File(
      'lib/features/services/presentation/pages/services_page.dart',
    ).readAsStringSync();
    const forbidden = [
      'uiConsistencySweep',
      'assistantSafetyHardening',
      'faqExpansionApproval',
      'nusukBridgeMock',
      'platformReadiness',
      'finalBetaSmoke',
      'betaReadiness',
      'betaPilot',
      'betaFeedback',
      'releaseGates',
      'betaContentUxAudit',
      'nusukIntegrationHandoff',
    ];
    for (final route in forbidden) {
      expect(source.contains('MunasaknaRoutes.$route'), isFalse);
    }
  });

  test('Journey source excludes known misleading hard-coded values', () {
    final source = File(
      'lib/features/journey/presentation/pages/journey_page.dart',
    ).readAsStringSync();
    expect(source.contains("final progress = 0.65;"), isFalse);
    expect(source.contains("Text('65%'"), isFalse);
    expect(source.contains("Text('جاهز'"), isFalse);
    expect(source.contains("title: 'إكمال التطعيمات'"), isFalse);
    expect(source.contains('15 ذو القعدة'), isFalse);
    expect(source.contains(r'$error'), isFalse);
  });
  test('public product source hides internal development banners', () {
    final home = File(
      'lib/features/home/presentation/pages/munasakna_home_page.dart',
    ).readAsStringSync();
    final scaffold = File(
      'lib/core/widgets/munasakna_app_scaffold.dart',
    ).readAsStringSync();

    expect(home.contains('DevelopmentModeBanner'), isFalse);
    expect(home.contains('وضع التطوير: بلا تسجيل دخول'), isFalse);
    expect(scaffold.contains('DevelopmentModeBanner'), isFalse);
  });

  test('public journey navigation excludes synthetic activation route', () {
    final home = File(
      'lib/features/home/presentation/pages/munasakna_home_page.dart',
    ).readAsStringSync();
    final bottomNav = File(
      'lib/core/widgets/munasakna_bottom_nav.dart',
    ).readAsStringSync();

    expect(home.contains('MunasaknaRoutes.season1448Launch'), isFalse);
    expect(bottomNav.contains('MunasaknaRoutes.season1448Launch'), isFalse);
    expect(home.contains('MunasaknaRoutes.journey'), isTrue);
    expect(bottomNav.contains('MunasaknaRoutes.journey'), isTrue);
  });

  test('assistant public copy hides internal implementation terminology', () {
    final source = File(
      'lib/features/hajj_assistant/presentation/pages/'
      'simple_hajj_assistant_page.dart',
    ).readAsStringSync();

    for (final forbidden in const [
      'مصفوفة الحج',
      'FAQ',
      'تجريبية محلية',
      'ضمن حدود المصفوفة',
    ]) {
      expect(source.contains(forbidden), isFalse);
    }

    expect(source.contains('لا أفتي ولا أخمّن'), isTrue);
  });

  test('services and journey use direction-aware back controls', () {
    final services = File(
      'lib/features/services/presentation/pages/services_page.dart',
    ).readAsStringSync();
    final journey = File(
      'lib/features/journey/presentation/pages/journey_page.dart',
    ).readAsStringSync();
    final scaffold = File(
      'lib/core/widgets/munasakna_app_scaffold.dart',
    ).readAsStringSync();

    expect(services.contains('BackButton('), isTrue);
    expect(journey.contains('BackButton('), isTrue);
    expect(scaffold.contains('BackButton('), isTrue);
    expect(services.contains('Icons.arrow_forward_rounded'), isFalse);
    expect(journey.contains('AlignmentDirectional.centerStart'), isTrue);
  });

  testWidgets('journey current and next stages remain readable at 360px',
      (tester) async {
    tester.view.physicalSize = const Size(360, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: MunasaknaRoutes.journey,
          builder: (_, __) => const JourneyPage(),
        ),
      ],
      initialLocation: MunasaknaRoutes.journey,
    );

    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      find.text('مراجعة الجواز، التطعيم، ونقطة التجمع'),
      findsOneWidget,
    );
    expect(find.textContaining('موعد السفر:'), findsOneWidget);
  });

  testWidgets('journey and services remain usable at 200 percent text scale',
      (tester) async {
    tester.view.physicalSize = const Size(360, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final servicesRouter = GoRouter(
      routes: [
        GoRoute(
          path: MunasaknaRoutes.services,
          builder: (_, __) => const ServicesPage(),
        ),
      ],
      initialLocation: MunasaknaRoutes.services,
    );

    await tester.pumpWidget(
      MaterialApp.router(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(2),
            ),
            child: child!,
          );
        },
        routerConfig: servicesRouter,
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('الخدمات'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    final journeyRouter = GoRouter(
      routes: [
        GoRoute(
          path: MunasaknaRoutes.journey,
          builder: (_, __) => const JourneyPage(),
        ),
      ],
      initialLocation: MunasaknaRoutes.journey,
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(2),
              ),
              child: child!,
            );
          },
          routerConfig: journeyRouter,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('حالة رحلتك'), findsOneWidget);
  });
}
