import 'package:flutter/material.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/beta_batch_widgets.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';
import '../../../beta_readiness/data/beta_batches_05_11_registry.dart';

class FaqExpansionApprovalPage extends StatelessWidget {
  const FaqExpansionApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'توسيع الأسئلة',
      headerIcon: Icons.quiz_outlined,
      bottomNavIndex: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BetaBatchSummaryCard(
            title: 'Batch 07 — FAQ Expansion & Scholar Approval Queue',
            subtitle: 'توسيع مصفوفة الأسئلة حسب الزمان والمكان والجنس ونوع الحج، مع وسم كل سؤال حساس قبل نشره داخل التطبيق أو ربطه بالمساعد.',
            icon: Icons.quiz_outlined,
            status: 'FAQ v2+',
            color: MunasaknaTheme.kiswahGold,
          ),
          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'أسئلة متوسعة مقترحة',
            subtitle: 'كل سؤال هنا مرتبط بمرحلة ومكان وجمهور وإجراء داخل التطبيق.',
            icon: Icons.question_answer_outlined,
            children: [
              for (final topic in BetaBatches0511Registry.expandedFaqTopics) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: (topic.needsScholarApproval ? MunasaknaTheme.roseAlert : MunasaknaTheme.haramGreen).withValues(alpha: 0.22),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          MunasaknaStatusChip(label: topic.phase, icon: Icons.event_outlined),
                          MunasaknaStatusChip(label: topic.place, icon: Icons.place_outlined),
                          MunasaknaStatusChip(label: topic.audience, icon: Icons.groups_outlined),
                          if (topic.needsScholarApproval)
                            const MunasaknaStatusChip(label: 'اعتماد شرعي', icon: Icons.verified_user_outlined),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(topic.question, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 6),
                      Text(topic.safeAnswer, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55)),
                      const SizedBox(height: 8),
                      Text('إجراء التطبيق: ${topic.action}', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
          const SizedBox(height: 12),
          const InfoSectionCard(
            title: 'قواعد التوسع',
            icon: Icons.rule_outlined,
            children: [
              BetaBulletList(
                items: [
                  'لا نضيف سؤالًا بلا phase/place/audience/action.',
                  'أسئلة النساء والتحلل والتوكيل وترك الواجبات تُوسم دائمًا للاعتماد.',
                  'الإجابة الوسطية تعرض قاعدة عامة ولا تدخل في خلاف فقهي إلا إذا اعتمدته اللجنة.',
                  'المساعد لا يجيب من السؤال الجديد حتى ينتقل من مسودة إلى معتمد أو إرشادي آمن.',
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const BetaRouteTile(
            title: 'فتح أسئلة الحج الحالية',
            subtitle: 'مصفوفة FAQ الحالية حسب الزمان والمكان.',
            icon: Icons.quiz_outlined,
            route: MunasaknaRoutes.hajjFaq,
            color: MunasaknaTheme.kiswahGold,
          ),
        ],
      ),
    );
  }
}
