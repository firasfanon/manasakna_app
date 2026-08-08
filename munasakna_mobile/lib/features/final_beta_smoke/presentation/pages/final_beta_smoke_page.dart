import 'package:flutter/material.dart';

import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/beta_batch_widgets.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';
import '../../../beta_readiness/data/beta_batches_05_11_registry.dart';

class FinalBetaSmokePage extends StatelessWidget {
  const FinalBetaSmokePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'دخان بيتا النهائي',
      headerIcon: Icons.check_circle_outline,
      bottomNavIndex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BetaBatchSummaryCard(
            title: 'Batch 11 — Final Beta Smoke & Handoff',
            subtitle: 'بوابة الإغلاق النهائية قبل اعتماد Beta داخلية: اختبارات، تنقل، محتوى حساس، خصوصية، وتوريث واضح للدفعة التالية.',
            icon: Icons.check_circle_outline,
            status: 'Handoff Ready',
            color: MunasaknaTheme.haramGreen,
          ),
          const SizedBox(height: 12),
          for (final gate in BetaBatches0511Registry.finalSmokeGates) ...[
            InfoSectionCard(
              title: gate.title,
              subtitle: gate.closeRule,
              icon: Icons.verified_outlined,
              trailing: const MunasaknaStatusChip(label: 'Smoke gate', icon: Icons.rule_outlined),
              children: [
                BetaBulletList(items: gate.checks),
                const SizedBox(height: 8),
                Text(
                  'مانع الإغلاق: ${gate.blockerIf}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: MunasaknaTheme.roseAlert,
                        fontWeight: FontWeight.w900,
                        height: 1.45,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          const InfoSectionCard(
            title: 'أوامر الإغلاق المقترحة',
            icon: Icons.terminal_outlined,
            children: [
              SelectableText('flutter clean\\nflutter pub get\\nflutter test\\nflutter run -d chrome'),
              SizedBox(height: 10),
              Text('بعد نجاحها: تُعتمد النسخة كبوابة Beta داخلية مستقرة، مع تحديث الدليل الشامل وSESSION_HANDOFF.'),
            ],
          ),
        ],
      ),
    );
  }
}
