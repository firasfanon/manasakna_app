import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class UsefulLinksPage extends StatelessWidget {
  const UsefulLinksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'روابط مفيدة',
      headerIcon: Icons.language_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const InfoSectionCard(
            title: 'مكتبة روابط محلية',
            subtitle: 'لا تفتح روابط خارجية فعليًا الآن. هذه تصنيفات جاهزة للربط الرسمي لاحقًا.',
            icon: Icons.language_outlined,
            trailing: MunasaknaStatusChip(label: 'قيد الربط', icon: Icons.link_outlined),
            children: [
              Text('الهدف ترتيب المصادر الرسمية والإرشادية قبل ربطها من لوحة نسك أو قاعدة البيانات.')
            ],
          ),
          const SizedBox(height: 12),
          for (final group in _linkGroups) ...[
            InfoSectionCard(
              title: group.title,
              subtitle: group.subtitle,
              icon: group.icon,
              children: [
                for (final link in group.links) _UsefulLinkTile(link: link),
              ],
            ),
            const SizedBox(height: 12),
          ],
          InfoSectionCard(
            title: 'بدائل داخل التطبيق',
            icon: Icons.apps_outlined,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.hajjFaq), icon: const Icon(Icons.quiz_outlined), label: const Text('أسئلة الحج')),
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.layerGuide), icon: const Icon(Icons.layers_outlined), label: const Text('الدليل الطبقي')),
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.hajjMatrix), icon: const Icon(Icons.account_tree_outlined), label: const Text('المصفوفة')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UsefulLinkTile extends StatelessWidget {
  const _UsefulLinkTile({required this.link});
  final _UsefulLink link;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.055),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Icon(link.icon, color: scheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(link.title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text(link.description, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const MunasaknaStatusChip(label: 'لاحقًا', icon: Icons.schedule_outlined),
        ],
      ),
    );
  }
}

class _LinkGroup {
  const _LinkGroup({required this.title, required this.subtitle, required this.icon, required this.links});
  final String title;
  final String subtitle;
  final IconData icon;
  final List<_UsefulLink> links;
}

class _UsefulLink {
  const _UsefulLink({required this.title, required this.description, required this.icon});
  final String title;
  final String description;
  final IconData icon;
}

const _linkGroups = [
  _LinkGroup(title: 'مصادر رسمية', subtitle: 'تُدار لاحقًا من نسك', icon: Icons.verified_outlined, links: [
    _UsefulLink(title: 'تعليمات الموسم', description: 'تعليمات الحج الرسمية حسب الموسم والبرنامج.', icon: Icons.article_outlined),
    _UsefulLink(title: 'إعلانات الشركات', description: 'بيانات الشركة والمجموعة ومواعيد التفويج.', icon: Icons.business_outlined),
  ]),
  _LinkGroup(title: 'إرشاد الحاج', subtitle: 'محتوى تعليمي لا يحل محل اللجنة الشرعية', icon: Icons.menu_book_outlined, links: [
    _UsefulLink(title: 'دليل المناسك', description: 'شرح منظم للمناسك حسب الزمان والمكان.', icon: Icons.explore_outlined),
    _UsefulLink(title: 'محظورات الإحرام', description: 'قائمة تعليمية قبل وبعد الميقات.', icon: Icons.flag_outlined),
  ]),
  _LinkGroup(title: 'سلامة وميدان', subtitle: 'أدوات عملية عند الحاجة', icon: Icons.health_and_safety_outlined, links: [
    _UsefulLink(title: 'خطة الطوارئ', description: 'ما الذي تفعله عند الضياع أو التعب.', icon: Icons.emergency_share_outlined),
    _UsefulLink(title: 'موقعي الحالي', description: 'عرض الإحداثيات عند الطلب فقط.', icon: Icons.my_location_outlined),
  ]),
];
