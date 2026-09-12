import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:munasakna_mobile/app/router/munasakna_routes.dart';
import 'package:munasakna_mobile/features/contacts/presentation/pages/contacts_page.dart';
import 'package:munasakna_mobile/features/home/presentation/pages/munasakna_home_page.dart';
import 'package:munasakna_mobile/features/journey/presentation/pages/journey_page.dart';
import 'package:munasakna_mobile/features/services/presentation/pages/services_page.dart';

Future<void> pumpPage(
  WidgetTester tester, {
  required String path,
  required Widget page,
  double textScale = 1.0,
  bool provider = false,
}) async {
  final router = GoRouter(
    routes: [GoRoute(path: path, builder: (_, __) => page)],
    initialLocation: path,
  );

  Widget app = MaterialApp.router(
    debugShowCheckedModeBanner: false,
    routerConfig: router,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(textScale),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
    ),
  );

  if (provider) app = ProviderScope(child: app);

  await tester.pumpWidget(app);
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 700));
}

void expectNoFlutterError(WidgetTester tester, String checkpoint) {
  final error = tester.takeException();
  expect(error, isNull, reason: '$checkpoint - $error');
}

void main() {
  testWidgets('home remains usable at 360 and 200 percent text scale',
      (tester) async {
    tester.view.physicalSize = const Size(360, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpPage(
      tester,
      path: MunasaknaRoutes.home,
      page: const MunasaknaHomePage(),
      textScale: 2,
      provider: true,
    );

    expect(find.text('رحلتي 1448'), findsOneWidget);
    expectNoFlutterError(tester, 'home-200');
  });

  testWidgets('journey remains usable at 360 and 200 percent text scale',
      (tester) async {
    tester.view.physicalSize = const Size(360, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpPage(
      tester,
      path: MunasaknaRoutes.journey,
      page: const JourneyPage(),
      textScale: 2,
      provider: true,
    );

    expect(find.text('حالة رحلتك'), findsOneWidget);
    expectNoFlutterError(tester, 'journey-200');
  });

  testWidgets('services remains usable at 360 and 200 percent text scale',
      (tester) async {
    tester.view.physicalSize = const Size(360, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpPage(
      tester,
      path: MunasaknaRoutes.services,
      page: const ServicesPage(),
      textScale: 2,
    );

    expect(find.text('الخدمات'), findsOneWidget);
    expectNoFlutterError(tester, 'services-200');
  });

  testWidgets('contacts remain usable at 360 default text scale',
      (tester) async {
    tester.view.physicalSize = const Size(360, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpPage(
      tester,
      path: MunasaknaRoutes.contacts,
      page: const ContactsPage(),
    );

    expect(find.text('هواتف ضرورية'), findsAtLeastNWidgets(1));
    expectNoFlutterError(tester, 'contacts-360');
  });

  test('public contacts contain no fake callable numbers', () {
    final source = File(
      'lib/features/contacts/presentation/pages/contacts_page.dart',
    ).readAsStringSync();

    expect(source.contains('+966 000'), isFalse);
    expect(source.contains('تجريبي - لا يتصل الآن'), isFalse);
    expect(source.contains('أرقام تجريبية'), isFalse);
  });

  test('offline library exposes pilgrim copy not implementation copy', () {
    final source = File(
      'lib/features/offline_library/presentation/pages/'
      'offline_library_page.dart',
    ).readAsStringSync();

    for (final forbidden in const [
      'FAQ',
      'بحاجة اعتماد',
      'تجهيز مبكر',
      'إدارة الاعتماد لاحقًا',
      'مستقبلي',
      'MunasaknaRoutes.layerGuide',
      'MunasaknaRoutes.hajjMatrix',
    ]) {
      expect(source.contains(forbidden), isFalse, reason: forbidden);
    }
  });

  test('fatwa surface exposes user guidance not editorial governance copy', () {
    final source = File(
      'lib/features/fatwa/presentation/pages/fatwa_page.dart',
    ).readAsStringSync();

    for (final forbidden in const [
      'قبل النشر الرسمي',
      'في النسخة الحالية',
      'يحتاج اعتماد',
      'المصفوفة',
      'اعتماد الصياغة النهائية',
    ]) {
      expect(source.contains(forbidden), isFalse, reason: forbidden);
    }
  });

  test('assistant response sources hide internal version terminology', () {
    final source = File(
      'lib/features/hajj_assistant/domain/services/'
      'simple_hajj_assistant_service.dart',
    ).readAsStringSync();

    for (final forbidden in const [
      'Hajj Ritual Matrix v6',
      'مصفوفة الحج v6',
      'FAQ v2',
      'سياسة المساعد المحلي',
      'تذكير ذكي تجريبي',
      'في وضع التطوير',
    ]) {
      expect(source.contains(forbidden), isFalse, reason: forbidden);
    }
  });
}
