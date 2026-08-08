import 'package:flutter/material.dart';

import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/beta_readiness_widgets.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class BetaClosureChecklistPage extends StatelessWidget {
  const BetaClosureChecklistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MunasaknaAppScaffold(
      title: 'قائمة إغلاق بيتا',
      headerIcon: Icons.assignment_turned_in_outlined,
      bottomNavIndex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoSectionCard(
            title: 'Beta Readiness Batch 04',
            subtitle: 'قائمة إغلاق داخلية قبل اعتبار النسخة جاهزة لاختبار بيتا منظم.',
            icon: Icons.flag_circle_outlined,
            trailing: const MunasaknaStatusChip(label: 'v2.8.6', icon: Icons.new_releases_outlined),
            children: const [
              Text(
                'هذه الصفحة لا تفعّل تسجيل الدخول ولا تتصل بالسيرفر. هدفها ضبط بوابات الإغلاق: الاختبارات، المحتوى، الخصوصية، الصوت، قابلية الوصول، والاستعداد لربط نسك لاحقًا.',
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final cards = const [
                BetaReadinessMetricCard(
                  title: 'حالة الإغلاق',
                  value: 'قيد التحضير',
                  subtitle: 'لا تُعد النسخة Beta قبل إغلاق البوابات الحرجة.',
                  icon: Icons.pending_actions_outlined,
                  color: MunasaknaTheme.kiswahGold,
                ),
                BetaReadinessMetricCard(
                  title: 'الاختبارات',
                  value: '5 اختبارات أساس',
                  subtitle: 'يجب إعادة تشغيل flutter test بعد كل دفعة.',
                  icon: Icons.science_outlined,
                  color: MunasaknaTheme.zamzamBlue,
                ),
                BetaReadinessMetricCard(
                  title: 'المحتوى',
                  value: 'اعتماد مطلوب',
                  subtitle: 'المحتوى الشرعي الحساس يحتاج مراجعة اللجنة.',
                  icon: Icons.verified_user_outlined,
                  color: MunasaknaTheme.haramGreen,
                ),
              ];
              if (constraints.maxWidth < 720) {
                return Column(
                  children: [
                    for (final card in cards) ...[card, const SizedBox(height: 10)],
                  ],
                );
              }
              return Row(
                children: [
                  for (final card in cards) ...[
                    Expanded(child: card),
                    if (card != cards.last) const SizedBox(width: 10),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          const BetaReadinessChecklistCard(
            title: 'بوابات لا تغلق تلقائيًا',
            subtitle: 'هذه العناصر تحتاج قرارًا يدويًا من فريق المشروع قبل الانتقال لبيتا داخلية.',
            icon: Icons.rule_outlined,
            color: MunasaknaTheme.haramGreen,
            status: 'يدوي',
            items: [
              'اعتماد مصفوفة الحج v6 والأسئلة الحساسة من اللجنة الشرعية قبل النشر العام.',
              'اعتماد سياسة الخصوصية قبل تفعيل الموقع أو الوثائق أو البطاقة الرقمية الحقيقية.',
              'تشغيل الاختبارات على Chrome وAndroid فعلي، ثم تجربة iOS عند توفر macOS/Xcode.',
              'إبقاء وضع الضيف بلا تسجيل دخول إلى حين جاهزية عقود نسك وقاعدة البيانات.',
            ],
          ),
          const SizedBox(height: 12),
          BetaReadinessChecklistCard(
            title: 'قائمة إغلاق تجربة المستخدم',
            subtitle: 'تثبيت الواجهات الداخلية قبل إضافة ميزات جديدة كبيرة.',
            icon: Icons.touch_app_outlined,
            color: scheme.primary,
            items: const [
              'كل صفحة تعرض عنوانًا واضحًا، وصفًا مختصرًا، وإجراءً عمليًا للحاج.',
              'النصوص الطويلة مقسمة إلى بطاقات؛ لا توجد شاشة واحدة مكتظة بالمعلومات.',
              'الأزرار المهمة كبيرة وواضحة ومناسبة لكبار السن.',
              'المساعد الصوتي ظاهر من الصفحة الرئيسية والخدمات وشريط التنقل السفلي.',
              'الصفحات الحساسة لا تعطي حكمًا نهائيًا بل توجه إلى اللجنة الشرعية أو المرشد.',
            ],
          ),
          const SizedBox(height: 12),
          const BetaReadinessChecklistCard(
            title: 'قائمة إغلاق تقنية',
            subtitle: 'عناصر فنية يجب عدم تجاوزها عند كل baseline جديد.',
            icon: Icons.integration_instructions_outlined,
            color: MunasaknaTheme.zamzamBlue,
            status: 'إلزامي',
            items: [
              'تحديث docs/MANASIKUNA_COMPREHENSIVE_SYSTEM_GUIDE.md في كل دفعة.',
              'عدم إضافة تسجيل دخول أو مفاتيح API حقيقية في هذه المرحلة.',
              'عدم ربط أي Legacy أو ASP؛ الربط المستقبلي فقط عبر نسك داخل PalWakf.',
              'الحفاظ على Riverpod الحديث وعدم إدخال legacy.dart في الدفعات الجديدة.',
              'تسليم baseline كامل مضغوط، وليس patch منفصلًا فقط.',
            ],
          ),
          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'قرار الإغلاق المقترح',
            subtitle: 'التوصية الحالية قبل المتابعة.',
            icon: Icons.recommend_outlined,
            children: [
              Text(
                'توصية Batch 04: نستمر في التطوير كـ Alpha مستقر متقدم، ونبدأ اختبارات Beta داخلية فقط بعد إغلاق محتوى اللجنة الشرعية، اختبار الصوت على جهاز حقيقي، وتثبيت سيناريوهات الرحلة الأساسية.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
