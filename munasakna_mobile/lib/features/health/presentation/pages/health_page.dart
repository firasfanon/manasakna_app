import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class HealthPage extends StatelessWidget {
  const HealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'الصحة والسلامة',
      headerIcon: Icons.health_and_safety_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const InfoSectionCard(
            title: 'دليل الصحة أثناء الحج',
            subtitle: 'إرشادات عامة لا تغني عن الطبيب أو الفريق الصحي، وتظهر لاحقًا حسب العمر والحالة الصحية.',
            icon: Icons.health_and_safety_outlined,
            trailing: MunasaknaStatusChip(label: 'سلامة', icon: Icons.shield_outlined),
            children: [
              Text('الحج رحلة بدنية وروحية. حافظ على الماء، الأدوية، الراحة، واتباع التفويج، ولا تتردد في طلب المساعدة.'),
            ],
          ),
          const SizedBox(height: 12),
          for (final card in _healthCards) ...[
            _HealthCard(card: card),
            const SizedBox(height: 10),
          ],
          InfoSectionCard(
            title: 'طلب مساعدة سريع',
            icon: Icons.emergency_outlined,
            children: [
              const Text('اطلب المساعدة فورًا عند الدوخة الشديدة، ضيق النفس، ألم الصدر، الإغماء، الإصابة، أو فقدان أحد أفراد المجموعة.'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(onPressed: () => context.push(MunasaknaRoutes.emergency), icon: const Icon(Icons.emergency_share_outlined), label: const Text('الطوارئ')),
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.currentLocation), icon: const Icon(Icons.my_location_outlined), label: const Text('موقعي')),
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.contacts), icon: const Icon(Icons.contact_phone_outlined), label: const Text('الأرقام')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HealthCard extends StatelessWidget {
  const _HealthCard({required this.card});
  final _HealthCardData card;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = card.critical ? scheme.error : scheme.primary;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.065),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(18)),
                child: Icon(card.icon, color: color),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(card.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900))),
              if (card.critical) const MunasaknaStatusChip(label: 'مهم', icon: Icons.priority_high_rounded, color: MunasaknaTheme.roseAlert),
            ],
          ),
          const SizedBox(height: 10),
          for (final tip in card.tips)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_rounded, color: color, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(tip)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _HealthCardData {
  const _HealthCardData({required this.title, required this.icon, required this.tips, this.critical = false});
  final String title;
  final IconData icon;
  final List<String> tips;
  final bool critical;
}

const _healthCards = [
  _HealthCardData(title: 'الحرارة والإجهاد', icon: Icons.wb_sunny_outlined, critical: true, tips: ['اشرب الماء بانتظام ولا تنتظر العطش.', 'تجنب الشمس المباشرة قدر الإمكان.', 'توقف في مكان آمن عند الدوخة أو الإرهاق.']),
  _HealthCardData(title: 'الأدوية والأمراض المزمنة', icon: Icons.medication_outlined, tips: ['احمل أدويتك بكمية كافية.', 'احتفظ بقائمة أسماء الأدوية والجرعات.', 'أخبر مرافقك أو مشرفك بحالتك عند الحاجة.']),
  _HealthCardData(title: 'كبار السن وذوو الإعاقة', icon: Icons.accessible_forward_outlined, tips: ['لا يتحرك الحاج منفردًا في الزحام.', 'استخدم أوقات التفويج المخصصة.', 'اطلب مساعدة ميدانية مبكرًا ولا تنتظر تفاقم التعب.']),
  _HealthCardData(title: 'الزحام والجمرات', icon: Icons.groups_outlined, critical: true, tips: ['التزم بالتفويج ولا تعاكس اتجاه الحركة.', 'ابتعد عن نقاط التدافع.', 'استخدم صفحة الطوارئ عند الانفصال عن المجموعة.']),
];
