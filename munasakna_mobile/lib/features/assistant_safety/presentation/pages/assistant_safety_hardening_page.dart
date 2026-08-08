import 'package:flutter/material.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/beta_batch_widgets.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../beta_readiness/data/beta_batches_05_11_registry.dart';

class AssistantSafetyHardeningPage extends StatelessWidget {
  const AssistantSafetyHardeningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'أمان المساعد والصوت',
      headerIcon: Icons.record_voice_over_outlined,
      bottomNavIndex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BetaBatchSummaryCard(
            title: 'Batch 06 — Assistant Safety & Voice Hardening',
            subtitle: 'تقوية المساعد ليبقى إرشاديًا فقط: يذكّر، ينبه، يسأل، ويجيب من المصفوفة والأسئلة المعتمدة، ولا يفتي ولا يخمّن ولا يتجاوز حدود المعرفة.',
            icon: Icons.shield_outlined,
            status: 'لا فتوى / لا هلوسة',
            color: MunasaknaTheme.zamzamBlue,
          ),
          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'حواجز الأمان',
            subtitle: 'هذه الحواجز يجب أن تُختبر مع كل تطوير جديد للمساعد.',
            icon: Icons.security_outlined,
            children: [
              for (final rule in BetaBatches0511Registry.assistantGuardrails) ...[
                BetaChecklistTile(
                  title: rule.trigger,
                  description: '${rule.allowedAnswer}\nالإحالة: ${rule.referral}',
                  status: rule.severity,
                  owner: 'Assistant Policy',
                  color: rule.severity.contains('حرج') ? MunasaknaTheme.roseAlert : MunasaknaTheme.zamzamBlue,
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
          const SizedBox(height: 12),
          const InfoSectionCard(
            title: 'سياسة الصوت عبر المنصات',
            subtitle: 'الصوت مساعد للإرشاد لا بديل عن القراءة أو المرشد.',
            icon: Icons.volume_up_outlined,
            children: [
              BetaBulletList(
                items: [
                  'على الويب قد يحتاج المستخدم الضغط على زر استمع بسبب سياسات المتصفح.',
                  'إذا لم يعمل الميكروفون، تبقى الكتابة اليدوية متاحة دائمًا.',
                  'اختيار صوت ذكر/أنثى يعتمد لاحقًا على ملف المستخدم أو التفضيل، وليس مفعلًا كهوية شخصية الآن.',
                  'أي رد صوتي في المسائل الحساسة يجب أن يكون قصيرًا ويختم بتوجيه للجهة المختصة.',
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const InfoSectionCard(
            title: 'أوامر سريعة مقترحة',
            icon: Icons.keyboard_voice_outlined,
            children: [
              BetaBulletList(
                icon: Icons.question_answer_outlined,
                items: [
                  'ماذا أفعل الآن؟',
                  'أنا عند الميقات، ماذا أفعل؟',
                  'أنا في عرفة وأشعر بالتعب.',
                  'ضعت عن مجموعتي.',
                  'هل هذا السؤال يحتاج اللجنة الشرعية؟',
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const InfoSectionCard(
            title: 'الربط المباشر',
            subtitle: 'يمكن فتح صفحة المساعد الصوتي الحالية لاختبار الإدخال والقراءة.',
            icon: Icons.smart_toy_outlined,
            children: [
              BetaRouteTile(
                title: 'فتح المساعد الصوتي الذكي',
                subtitle: 'واجهة السؤال الصوتي/النصي والإجابات الآمنة.',
                icon: Icons.record_voice_over_outlined,
                route: MunasaknaRoutes.hajjAssistant,
                color: MunasaknaTheme.zamzamBlue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
