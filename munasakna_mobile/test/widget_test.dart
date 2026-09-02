import 'package:flutter/widgets.dart' show Scrollable;
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

  testWidgets('manasikuna visual home renders the adopted reference interface',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MunasaknaApp()));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    expect(find.text('مناسكنا'), findsAtLeastNWidgets(1));
    expect(find.text('الركن الخامس من أركان الإسلام'), findsOneWidget);
    expect(find.text('لبيك اللهم لبيك'), findsOneWidget);
    expect(find.text('رحلتي 1448'), findsOneWidget);
    expect(find.text('رحلتي'), findsAtLeastNWidgets(1));

    await tester.scrollUntilVisible(
      find.text('خدمات سريعة'),
      350,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('خدمات سريعة'), findsOneWidget);
    expect(find.text('دليل المناسك'), findsWidgets);
    expect(find.text('البطاقة الرقمية'), findsWidgets);
    expect(find.text('موقعي الحالي'), findsWidgets);

    await tester.scrollUntilVisible(
      find.text('وضع التطوير: بلا تسجيل دخول'),
      350,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('وضع التطوير: بلا تسجيل دخول'), findsOneWidget);
  });

  testWidgets('primary journey entry opens standalone 1448 activation product',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MunasaknaApp()));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    await tester.tap(find.text('رحلتي 1448'));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    expect(find.text('فعّل رحلتك 1448'), findsOneWidget);
    expect(find.textContaining('لا تتصل بنسك'), findsOneWidget);
    expect(find.text('استخدام رمز تجريبي'), findsOneWidget);
  });

  testWidgets('legacy journey route remains reachable for compatibility',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MunasaknaApp()));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    final context = tester.element(find.text('رحلتي 1448').first);
    context.go(MunasaknaRoutes.journey);
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    expect(
      find.text('رحلة إيمانية\nتنظيم دقيق... وطمأنينة تامة'),
      findsOneWidget,
    );
    expect(find.text('حالة رحلتك'), findsOneWidget);
    expect(find.text('65%'), findsOneWidget);
    expect(find.text('المرحلة الحالية'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('مراحل رحلة الحاج'),
      350,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('مراحل رحلة الحاج'), findsOneWidget);
    expect(find.text('الجواز والوثائق'), findsOneWidget);
    expect(find.text('الصحة والتطعيم'), findsOneWidget);
  });

  testWidgets('services reference page renders visual service list',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MunasaknaApp()));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    await tester.tap(find.text('المزيد'));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    expect(find.text('الخدمات'), findsOneWidget);
    expect(find.text('ابحث عن خدمة...'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('اللجنة الشرعية والفتاوى'),
      350,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('اللجنة الشرعية والفتاوى'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('الشكاوى والاقتراحات'),
      350,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('الشكاوى والاقتراحات'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('الإشعارات والتنبيهات'),
      350,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('الإشعارات والتنبيهات'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('الإعدادات'),
      350,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('الإعدادات'), findsOneWidget);
  });

  testWidgets(
      'hajj matrix and contextual faq pages remain reachable from services',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MunasaknaApp()));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    await tester.tap(find.text('المناسك'));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    expect(find.textContaining('المناسك'), findsWidgets);
  });

  testWidgets('assistant voice page renders web android ios tts support',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MunasaknaApp()));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    await tester.tap(find.text('المساعد'));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    expect(find.text('المساعد الصوتي الذكي'), findsAtLeastNWidgets(1));
    expect(find.textContaining('الويب وأندرويد وآيفون'), findsOneWidget);
    expect(
      find.textContaining('مساعد مناسكنا الإرشادي'),
      findsAtLeastNWidgets(1),
    );
    expect(find.text('اسأل بالصوت'), findsOneWidget);
    expect(find.textContaining('إرسال السؤال تلقائيًا'), findsOneWidget);
  });
}
