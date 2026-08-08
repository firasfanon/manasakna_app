import 'package:flutter/material.dart';

import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/beta_batch_widgets.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class NusukIntegrationHandoffPage extends StatelessWidget {
  const NusukIntegrationHandoffPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'تقرير نسك للتكامل',
      headerIcon: Icons.cloud_sync_outlined,
      bottomNavIndex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BetaBatchSummaryCard(
            title: 'تقرير مناسكنا إلى نسك',
            subtitle: 'ملخص تنفيذي بما يحتويه التطبيق، وما يحتاجه من نسك للانضمام الرسمي، وما يجب أن يجهزه نسك حتى يتكامل التطبيق مع المنصة دون Legacy ودون تفعيل تسجيل دخول قبل الجاهزية.',
            icon: Icons.integration_instructions_outlined,
            status: 'Nusuk Handoff',
            color: MunasaknaTheme.zamzamBlue,
          ),
          const SizedBox(height: 12),
          const InfoSectionCard(
            title: 'محتويات التطبيق الحالية',
            icon: Icons.apps_outlined,
            children: [
              BetaBulletList(
                items: [
                  'واجهة رئيسية وخدمات مرئية متوافقة مع الهوية المعتمدة.',
                  'رحلتي، رفيق اليوم، مصفوفة الحج v6، المواقيت، نوع الحج والنية، محظورات الإحرام، والدليل المكاني.',
                  'مساعد صوتي ونصي آمن مبني على المصفوفة وFAQ فقط، مع TTS وSpeech-to-Text.',
                  'صفحات تشغيلية: بياناتي، الوثائق، المجموعة والمشرف، السكن والنقل، الشكاوى، الاستبيان، الإشعارات، البطاقة الرقمية.',
                  'بوابات Beta Readiness، تدقيق UX، مخاطر الجودة، اعتماد المحتوى، جاهزية المنصات، وMock Bridge مع نسك.',
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in _requirements) ...[
            InfoSectionCard(
              title: item.title,
              subtitle: item.subtitle,
              icon: item.icon,
              trailing: MunasaknaStatusChip(label: item.owner, icon: Icons.account_tree_outlined),
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    MunasaknaStatusChip(label: item.priority, icon: Icons.priority_high_outlined),
                    MunasaknaStatusChip(label: item.status, icon: Icons.pending_actions_outlined),
                  ],
                ),
                const SizedBox(height: 10),
                BetaBulletList(items: item.items),
              ],
            ),
            const SizedBox(height: 12),
          ],
          const InfoSectionCard(
            title: 'قرار الانضمام المقترح',
            icon: Icons.rule_outlined,
            children: [
              Text('لا ينضم مناسكنا إلى نسك تشغيليًا إلا بعد تجهيز عقود API/RPC، نموذج الهوية، سياسات الخصوصية، اعتماد المحتوى، وتجربة بيتا داخلية ناجحة. حتى ذلك الوقت يبقى التطبيق في Guest/Development Mode مع بيانات محلية تجريبية فقط.'),
            ],
          ),
        ],
      ),
    );
  }
}

class _RequirementItem {
  const _RequirementItem({
    required this.title,
    required this.subtitle,
    required this.owner,
    required this.priority,
    required this.status,
    required this.icon,
    required this.items,
  });

  final String title;
  final String subtitle;
  final String owner;
  final String priority;
  final String status;
  final IconData icon;
  final List<String> items;
}

const _requirements = [
  _RequirementItem(
    title: 'ما يطلبه مناسكنا من نسك',
    subtitle: 'بيانات تشغيلية رسمية بدل البيانات المحلية التجريبية.',
    owner: 'Nusuk → App',
    priority: 'حرج',
    status: 'غير مفعل',
    icon: Icons.download_for_offline_outlined,
    items: [
      'ملف الحاج: الاسم، الهوية، رقم الطلب، الشركة، المجموعة، المشرف، حالة البرنامج.',
      'حالة الرحلة: المرحلة الحالية، الخطوة التالية، نسب الجاهزية، قيود التفويج، المواعيد.',
      'الوثائق: حالة الجواز، التطعيمات، التصريح، الملاحظات، دون كشف ملفات حساسة إلا بتصريح.',
      'الشكاوى والاستبيانات: إنشاء، متابعة، حالات، تصنيف، مرفقات عند الاعتماد.',
      'الإشعارات: تنبيهات رسمية، تعليمات عاجلة، تحديثات الشركة والمرشد.',
    ],
  ),
  _RequirementItem(
    title: 'ما يطلبه نسك من مناسكنا',
    subtitle: 'التزام التطبيق بعقود المنصة وحماية البيانات.',
    owner: 'App → Nusuk',
    priority: 'حرج',
    status: 'جاهز تصميميًا',
    icon: Icons.upload_file_outlined,
    items: [
      'عدم إرسال بيانات مجهولة أو غير مصنفة؛ كل طلب يجب أن يحمل context: موسم، مرحلة، خدمة، مستخدم.',
      'احترام RLS/RBAC وترك الصلاحيات السيادية داخل نسك والمنصة.',
      'إرسال الشكاوى والاستبيانات بصيغ DTO مستقرة وقابلة للتدقيق.',
      'عدم تضمين بيانات حساسة داخل QR؛ استخدام رمز موقّع أو معرف مؤقت فقط.',
      'تسجيل أحداث مهمة لاحقًا: فتح بطاقة، إرسال شكوى، مشاركة موقع، تشغيل مساعد صوتي عند الحاجة.',
    ],
  ),
  _RequirementItem(
    title: 'ما يجب على نسك تجهيزه قبل التكامل',
    subtitle: 'سيرفر، سياسات، مصادر بيانات، واعتماد محتوى.',
    owner: 'Nusuk Core',
    priority: 'عالٍ',
    status: 'مطلوب',
    icon: Icons.settings_suggest_outlined,
    items: [
      'Schema/API لمواسم الحج والبرامج والشركات والمجموعات والمشرفين والحجاج.',
      'واجهات آمنة لقراءة بيانات الحاج وتحديث ما يسمح بتحديثه فقط.',
      'قوائم مرجعية للشكاوى والاستبيانات والمراحل والمواقع ونقاط التجمع.',
      'صفحة إدارة المحتوى الشرعي والإرشادي مع حالة اعتماد اللجنة الشرعية.',
      'سياسة خصوصية وموافقة صريحة للموقع والميكروفون والإشعارات والوثائق.',
    ],
  ),
  _RequirementItem(
    title: 'ما يجب على مناسكنا تجهيزه قبل التكامل',
    subtitle: 'طبقة بيانات، feature flags، وسلوك فشل آمن.',
    owner: 'App Core',
    priority: 'عالٍ',
    status: 'جزئي',
    icon: Icons.app_settings_alt_outlined,
    items: [
      'تحويل Mock Repository إلى Local/Remote Repository مع Feature Flag واضح.',
      'إبقاء Guest Mode متاحًا للفحص والتدريب دون بيانات حقيقية.',
      'إضافة حالات Loading/Empty/Error لكل صفحة مرتبطة بنسك.',
      'إضافة fallback عند انقطاع الشبكة وعدم تعطيل الدليل والمصفوفة والمساعد المحلي.',
      'تثبيت اختبارات لعقود DTO قبل ربط السيرفر الحقيقي.',
    ],
  ),
];
