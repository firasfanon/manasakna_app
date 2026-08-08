import 'package:flutter/material.dart';

import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/beta_batch_widgets.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class BetaContentUxAuditPage extends StatelessWidget {
  const BetaContentUxAuditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'تدقيق المحتوى والواجهة',
      headerIcon: Icons.rate_review_outlined,
      bottomNavIndex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BetaBatchSummaryCard(
            title: 'Beta Content & UX Audit',
            subtitle: 'مراجعة صفحة بصفحة قبل أي ربط حقيقي مع نسك أو بناء APK تجريبي. التدقيق يثبت ما هو جاهز، وما يحتاج اعتمادًا شرعيًا، وما يحتاج بيانات من نسك، وما يجب اختباره على الهاتف والويب.',
            icon: Icons.fact_check_outlined,
            status: 'Audit Baseline',
            color: MunasaknaTheme.haramGreen,
          ),
          const SizedBox(height: 12),
          const InfoSectionCard(
            title: 'منهجية التدقيق',
            subtitle: 'كل صفحة لا تُراجع كواجهة فقط، بل كجزء من رحلة الحاج حسب الزمن والمكان والحساسية.',
            icon: Icons.account_tree_outlined,
            children: [
              BetaBulletList(
                items: [
                  'تحديد طبقة الصفحة: شرعية، زمنية، مكانية، إدارية، صحية، تعليمية، تقنية.',
                  'تحديد المخاطر: فتوى، خصوصية، موقع، صوت، ازدحام، بيانات شخصية.',
                  'تحديد مصدر البيانات: محلي تجريبي الآن، أو نسك لاحقًا، أو اعتماد شرعي/إداري.',
                  'فحص قابلية الاستخدام لكبار السن: حجم الخط، وضوح الزر، قلة النص، تجنب الازدحام.',
                  'فحص الويب والموبايل: عدم وجود overflow، وضوح scroll، صلاحية الصوت والميكروفون.',
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in _auditItems) ...[
            InfoSectionCard(
              title: item.title,
              subtitle: item.scope,
              icon: item.icon,
              trailing: MunasaknaStatusChip(label: item.status, icon: Icons.verified_outlined),
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    MunasaknaStatusChip(label: item.layer, icon: Icons.layers_outlined),
                    MunasaknaStatusChip(label: item.risk, icon: Icons.warning_amber_outlined),
                    MunasaknaStatusChip(label: item.nusukNeed, icon: Icons.cloud_sync_outlined),
                  ],
                ),
                const SizedBox(height: 10),
                BetaBulletList(items: item.actions),
              ],
            ),
            const SizedBox(height: 12),
          ],
          const InfoSectionCard(
            title: 'قرار التدقيق الحالي',
            icon: Icons.rule_folder_outlined,
            children: [
              Text('النسخة v290 مستقرة اختباريًا، وتنتقل الآن إلى تدقيق محتوى وUX داخلي. لا يتم تفعيل تسجيل الدخول، ولا يتم استخدام بيانات حقيقية، ولا يبدأ الربط مع نسك قبل إغلاق قائمة المتطلبات في تقرير نسك.'),
            ],
          ),
        ],
      ),
    );
  }
}

class _AuditItem {
  const _AuditItem({
    required this.title,
    required this.scope,
    required this.layer,
    required this.risk,
    required this.nusukNeed,
    required this.status,
    required this.icon,
    required this.actions,
  });

  final String title;
  final String scope;
  final String layer;
  final String risk;
  final String nusukNeed;
  final String status;
  final IconData icon;
  final List<String> actions;
}

const _auditItems = [
  _AuditItem(
    title: 'الرئيسية والخدمات',
    scope: 'بوابة دخول الحاج إلى رحلته والخدمات السريعة.',
    layer: 'UX / تقنية',
    risk: 'منخفض',
    nusukNeed: 'لا يحتاج الآن',
    status: 'جاهز للتدقيق البصري',
    icon: Icons.home_outlined,
    actions: [
      'تثبيت ترتيب الخدمات الأعلى أهمية: رحلتي، رفيق اليوم، نوع الحج، المواقيت، المساعد.',
      'التأكد من أن كل بطاقة تفتح صفحة عاملة ولا تنقل إلى نموذج غير مكتمل.',
      'تقليل النصوص الطويلة في البطاقات لصالح عبارات مباشرة لكبار السن.',
    ],
  ),
  _AuditItem(
    title: 'رحلتي ومصفوفة الحج',
    scope: 'الخط الزمني الشرعي والزمني والميداني للحاج.',
    layer: 'شرعية / زمنية',
    risk: 'مرتفع شرعيًا',
    nusukNeed: 'حالة الرحلة لاحقًا',
    status: 'يتطلب اعتمادًا شرعيًا',
    icon: Icons.route_outlined,
    actions: [
      'وسم أركان الحج والواجبات بوضوح دون تشدد أو تساهل.',
      'إظهار الاختلاف حسب تمتع/قران/إفراد عند توفر اختيار المستخدم.',
      'تجهيز ربط لاحق مع حالة الرحلة من نسك بدل النسب التجريبية.',
    ],
  ),
  _AuditItem(
    title: 'المساعد والأسئلة',
    scope: 'إجابات صوتية ونصية من المصفوفة وFAQ فقط.',
    layer: 'تعليمية / صوت',
    risk: 'مرتفع بسبب الفتوى',
    nusukNeed: 'لا يحتاج في مرحلة الضيف',
    status: 'آمن بشروط',
    icon: Icons.record_voice_over_outlined,
    actions: [
      'الإبقاء على قاعدة: لا فتوى ولا تخمين ولا إجابة خارج المصفوفة.',
      'إحالة الأسئلة الحساسة للجنة الشرعية أو المرشد.',
      'فحص TTS وSpeech-to-Text على Chrome وAndroid وجهاز iOS لاحقًا.',
    ],
  ),
  _AuditItem(
    title: 'الصحة والسلامة والطوارئ',
    scope: 'دعم كبار السن والمرضى والضياع والزحام.',
    layer: 'صحية / ميدانية',
    risk: 'مرتفع ميدانيًا',
    nusukNeed: 'مشرف وطوارئ لاحقًا',
    status: 'يحتاج اختبارًا ميدانيًا',
    icon: Icons.health_and_safety_outlined,
    actions: [
      'تأكيد أن النصوص الصحية إرشادية وليست تشخيصًا طبيًا.',
      'تجهيز أزرار اتصال وموقع عند الربط الحقيقي.',
      'فحص قابلية الاستخدام عند التوتر أو ضعف الشبكة.',
    ],
  ),
  _AuditItem(
    title: 'الشكاوى والاستبيانات والوثائق',
    scope: 'خدمات تشغيلية تحتاج نسك قبل الإنتاج.',
    layer: 'إدارية / بيانات',
    risk: 'خصوصية',
    nusukNeed: 'أساسي',
    status: 'واجهة جاهزة وربط مؤجل',
    icon: Icons.assignment_outlined,
    actions: [
      'منع رفع ملفات حقيقية في وضع التطوير.',
      'تجهيز حقول الشكاوى والاستبيان لتطابق عقود نسك.',
      'إبقاء QR محليًا بصريًا فقط إلى حين اعتماد آلية التوقيع الآمن.',
    ],
  ),
];
