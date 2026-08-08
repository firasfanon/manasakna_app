import 'package:flutter/material.dart';

import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';
import '../../../beta_readiness/data/beta_page_audit_registry.dart';
import '../../../beta_readiness/domain/models/beta_page_audit.dart';

class BetaTestScenariosPage extends StatelessWidget {
  const BetaTestScenariosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scenarios = BetaReadinessRegistry.scenarios;
    return MunasaknaAppScaffold(
      title: 'سيناريوهات اختبار بيتا',
      headerIcon: Icons.science_outlined,
      bottomNavIndex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoSectionCard(
            title: 'اختبار الرحلة لا الشاشة فقط',
            subtitle: 'الهدف اختبار استخدام الحاج للتطبيق في زمان ومكان وحالة محددة.',
            icon: Icons.bug_report_outlined,
            trailing: MunasaknaStatusChip(label: '${scenarios.length} سيناريو', icon: Icons.playlist_add_check_outlined),
            children: [
              Text(
                'تستخدم هذه السيناريوهات كقائمة قبول داخلية قبل Beta. لا تفترض وجود تسجيل دخول، وتراعي اختلاف الويب وأندرويد وآيفون والصوت والموقع.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final scenario in scenarios) ...[
            _ScenarioCard(scenario: scenario),
            const SizedBox(height: 12),
          ],
          InfoSectionCard(
            title: 'معيار نجاح الدفعة',
            subtitle: 'كل سيناريو يجب أن ينجح دون شاشة حمراء أو طلب تسجيل دخول أو إجابة غير معتمدة.',
            icon: Icons.verified_outlined,
            children: const [
              Text('السيناريوهات الحرجة تُختبر أولًا على Android ثم Web، وتُراجع لاحقًا على iOS عند توفر بيئة macOS/Xcode.'),
              SizedBox(height: 8),
              Text('أي فشل في الصوت أو الميكروفون يجب أن يترك الكتابة اليدوية متاحة دائمًا.'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  const _ScenarioCard({required this.scenario});

  final BetaTestScenario scenario;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isCritical = scenario.priorityAr == 'حرج';
    final color = isCritical ? scheme.error : scheme.primary;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: scheme.surface,
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(isCritical ? Icons.priority_high_rounded : Icons.task_alt_outlined, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(scenario.titleAr, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
              ),
              MunasaknaStatusChip(label: scenario.priorityAr, icon: Icons.flag_outlined, color: color),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              MunasaknaStatusChip(label: scenario.personaAr, icon: Icons.person_outline, color: MunasaknaTheme.haramGreen),
              MunasaknaStatusChip(label: scenario.stageAr, icon: Icons.timeline_outlined, color: MunasaknaTheme.zamzamBlue),
              for (final platform in scenario.platformsAr)
                MunasaknaStatusChip(label: platform, icon: Icons.devices_outlined, color: MunasaknaTheme.kiswahGold),
            ],
          ),
          const SizedBox(height: 12),
          Text('خطوات الاختبار', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          for (var i = 0; i < scenario.stepsAr.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 11, backgroundColor: scheme.primary.withValues(alpha: 0.12), child: Text('${i + 1}', style: TextStyle(fontSize: 11, color: scheme.primary, fontWeight: FontWeight.w900))),
                  const SizedBox(width: 8),
                  Expanded(child: Text(scenario.stepsAr[i], style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45))),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: scheme.primary.withValues(alpha: 0.07),
            ),
            child: Text('النتيجة المتوقعة: ${scenario.expectedResultAr}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
