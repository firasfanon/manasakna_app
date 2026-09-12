import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class OfflineLibraryPage extends StatelessWidget {
  const OfflineLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'المكتبة دون إنترنت',
      headerIcon: Icons.offline_pin_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const InfoSectionCard(
            title: 'محتوى يعمل عند ضعف الشبكة',
            subtitle: 'محتوى نصي وصوتي مختصر للاستخدام عند ضعف الشبكة.',
            icon: Icons.offline_pin_outlined,
            trailing: MunasaknaStatusChip(
                label: 'محلي', icon: Icons.phone_android_outlined),
            children: [
              Text(
                  'تتوفر المواد المحفوظة داخل التطبيق دون الحاجة لاتصال مستمر، ويُضاف المحتوى المعتمد عند توفره.'),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in _libraryItems) ...[
            _OfflineItemCard(item: item),
            const SizedBox(height: 12),
          ],
          InfoSectionCard(
            title: 'مصادر المحتوى',
            icon: Icons.verified_user_outlined,
            children: [
              const Text(
                  'المحتوى الشرعي والإداري والصحي يُعرض بعد مراجعته من الجهة المختصة.'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                      onPressed: () => context.push(MunasaknaRoutes.rituals),
                      icon: const Icon(Icons.layers_outlined),
                      label: const Text('دليل المناسك')),
                  OutlinedButton.icon(
                      onPressed: () => context.push(MunasaknaRoutes.hajjFaq),
                      icon: const Icon(Icons.account_tree_outlined),
                      label: const Text('الأسئلة الشائعة')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OfflineItemCard extends StatelessWidget {
  const _OfflineItemCard({required this.item});
  final _OfflineItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: item.color.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.052),
              blurRadius: 15,
              offset: const Offset(0, 8))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18)),
              child: Icon(item.icon, color: item.color)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(item.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant, height: 1.45)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final tag in item.tags)
                    Chip(label: Text(tag), visualDensity: VisualDensity.compact)
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OfflineItem {
  const _OfflineItem(
      {required this.title,
      required this.description,
      required this.tags,
      required this.icon,
      required this.color});
  final String title;
  final String description;
  final List<String> tags;
  final IconData icon;
  final Color color;
}

const _libraryItems = [
  _OfflineItem(
      title: 'دليل المناسك المختصر',
      description:
          'خطوات الحج الأساسية حسب النوع والمرحلة، بصياغة سهلة لكبار السن.',
      tags: ['شرعي', 'إرشادي', 'نصي'],
      icon: Icons.menu_book_outlined,
      color: MunasaknaTheme.deepHaramGreen),
  _OfflineItem(
      title: 'تنبيهات السلامة',
      description: 'محتوى صحي وميداني عن الحرارة والزحام والأدوية والطوارئ.',
      tags: ['صحي', 'ميداني', 'محلي'],
      icon: Icons.health_and_safety_outlined,
      color: MunasaknaTheme.roseAlert),
  _OfflineItem(
      title: 'أسئلة شائعة حسب المرحلة',
      description: 'أسئلة شائعة تظهر دون إنترنت حسب المرحلة.',
      tags: ['الأسئلة الشائعة', 'مرحلي', 'آمن'],
      icon: Icons.quiz_outlined,
      color: MunasaknaTheme.kiswahGold),
  _OfflineItem(
      title: 'رسائل صوتية قصيرة',
      description: 'رسائل صوتية قصيرة للتذكير والتنبيه، لا للإفتاء.',
      tags: ['صوت', 'تذكير', 'صوتي'],
      icon: Icons.record_voice_over_outlined,
      color: MunasaknaTheme.haramGreen),
];
