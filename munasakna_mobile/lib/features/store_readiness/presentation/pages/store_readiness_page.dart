import 'package:flutter/material.dart';

import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/beta_readiness_widgets.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class StoreReadinessPage extends StatelessWidget {
  const StoreReadinessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'جاهزية المتاجر والويب',
      headerIcon: Icons.storefront_outlined,
      bottomNavIndex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoSectionCard(
            title: 'خارطة جاهزية النشر',
            subtitle: 'تجهيز Android وiOS وWeb دون تنفيذ نشر فعلي الآن.',
            icon: Icons.publish_outlined,
            trailing: const MunasaknaStatusChip(label: 'تحضيري', icon: Icons.lock_clock_outlined),
            children: const [
              Text(
                'الصفحة تجمع متطلبات المتاجر والويب حتى لا تضيع أثناء التطوير. لا يتم رفع التطبيق للمتاجر قبل الاعتماد الشرعي، الخصوصية، وتجارب الأجهزة.',
              ),
            ],
          ),
          const SizedBox(height: 12),
          const BetaReadinessChecklistCard(
            title: 'Android',
            subtitle: 'جاهزية أولية لبناء APK وتجربة داخلية.',
            icon: Icons.android_outlined,
            color: MunasaknaTheme.haramGreen,
            status: 'مؤجل للنشر',
            items: [
              'تشغيل flutter build apk --release بعد نجاح الاختبارات.',
              'تجربة TTS وSpeech-to-Text على جهاز Android حقيقي.',
              'مراجعة أذونات الميكروفون والموقع قبل أي نشر.',
              'تحضير أيقونات المتجر ولقطات شاشة عربية واضحة لاحقًا.',
            ],
          ),
          const SizedBox(height: 12),
          const BetaReadinessChecklistCard(
            title: 'iPhone / iOS',
            subtitle: 'الكود مجهز مبدئيًا لكن البناء النهائي يتطلب macOS/Xcode.',
            icon: Icons.phone_iphone_outlined,
            color: MunasaknaTheme.zamzamBlue,
            status: 'ينتظر جهاز بناء',
            items: [
              'تأكيد أذونات الميكروفون والتعرف الصوتي داخل Info.plist.',
              'اختبار الأصوات العربية المتاحة على iOS.',
              'إعداد Bundle Identifier النهائي عند قرار النشر.',
              'تجربة الأداء على شاشة صغيرة وكبيرة قبل رفع TestFlight.',
            ],
          ),
          const SizedBox(height: 12),
          const BetaReadinessChecklistCard(
            title: 'Web',
            subtitle: 'تشغيل نسخة ويب تجريبية للحاسوب والاختبار الداخلي.',
            icon: Icons.web_asset_outlined,
            color: MunasaknaTheme.kiswahGold,
            status: 'تجريبي',
            items: [
              'تشغيل flutter run -d chrome للتحقق البصري.',
              'اختبار قيود المتصفح للصوت والميكروفون؛ غالبًا يتطلب ضغط المستخدم على زر استمع.',
              'تأكيد تجاوب الصفحة الرئيسية وصفحة الخدمات والمساعد على عرض الحاسوب.',
              'عدم تخزين بيانات حساسة في LocalStorage قبل سياسة خصوصية نهائية.',
            ],
          ),
          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'مواد النشر المقترحة',
            subtitle: 'لا تعتمد نهائيًا إلا بعد اعتماد الوزارة واللجنة الشرعية.',
            icon: Icons.article_outlined,
            children: const [
              _StoreItem(title: 'اسم التطبيق', value: 'مناسكنا'),
              _StoreItem(title: 'وصف قصير', value: 'رفيق الحاج والمعتمر للإرشاد، الرحلة، التنبيهات، والخدمات الميدانية.'),
              _StoreItem(title: 'وضع النسخة الحالية', value: 'تطوير / Beta داخلية، بلا تسجيل دخول وبلا بيانات حقيقية.'),
              _StoreItem(title: 'تنبيه شرعي', value: 'المساعد إرشادي ولا يصدر فتوى، ويرجع المسائل الحساسة للجنة الشرعية.'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StoreItem extends StatelessWidget {
  const _StoreItem({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: scheme.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '$title: ', style: const TextStyle(fontWeight: FontWeight.w900)),
                  TextSpan(text: value),
                ],
              ),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
