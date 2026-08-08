import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class PostHajjPage extends StatelessWidget {
  const PostHajjPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'ما بعد الحج',
      headerIcon: Icons.volunteer_activism_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const InfoSectionCard(
            title: 'إغلاق الرحلة لا يعني انتهاء الأثر',
            subtitle: 'صفحة تجمع التقييم، الملاحظات، الشكاوى، المتابعة الصحية، وسجل الرحلة بعد العودة.',
            icon: Icons.volunteer_activism_outlined,
            trailing: MunasaknaStatusChip(label: 'بعد العودة', icon: Icons.home_outlined),
            children: [
              Text('هذه المرحلة إدارية وإرشادية، وتساعد نسك لاحقًا في تحسين الخدمات ومتابعة الملاحظات.'),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in _postHajjItems) ...[
            _PostHajjCard(item: item),
            const SizedBox(height: 12),
          ],
          InfoSectionCard(
            title: 'إجراءات ما بعد العودة',
            icon: Icons.task_alt_outlined,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(onPressed: () => context.push(MunasaknaRoutes.survey), icon: const Icon(Icons.fact_check_outlined), label: const Text('الاستبيان')),
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.complaints), icon: const Icon(Icons.forum_outlined), label: const Text('شكوى أو ملاحظة')),
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.health), icon: const Icon(Icons.health_and_safety_outlined), label: const Text('متابعة صحية')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PostHajjCard extends StatelessWidget {
  const _PostHajjCard({required this.item});
  final _PostHajjItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: item.color.withValues(alpha: 0.22)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 50, height: 50, decoration: BoxDecoration(color: item.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(18)), child: Icon(item.icon, color: item.color)),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 5),
          Text(item.description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5, color: scheme.onSurfaceVariant)),
        ])),
      ]),
    );
  }
}

class _PostHajjItem {
  const _PostHajjItem({required this.title, required this.description, required this.icon, required this.color});
  final String title;
  final String description;
  final IconData icon;
  final Color color;
}

const _postHajjItems = [
  _PostHajjItem(title: 'استبيان التجربة', description: 'يقيم الحاج الشركة والسكن والنقل والإرشاد والتنظيم والصحة والسلامة.', icon: Icons.fact_check_outlined, color: MunasaknaTheme.haramGreen),
  _PostHajjItem(title: 'إغلاق الشكاوى والملاحظات', description: 'تظهر الشكاوى المفتوحة وتوثق الردود والإجراءات عند الربط مع نسك.', icon: Icons.forum_outlined, color: MunasaknaTheme.kiswahGold),
  _PostHajjItem(title: 'متابعة صحية عامة', description: 'تذكير بمراجعة الجهة الصحية عند استمرار التعب أو ظهور أعراض مقلقة بعد العودة.', icon: Icons.health_and_safety_outlined, color: MunasaknaTheme.roseAlert),
  _PostHajjItem(title: 'سجل الرحلة', description: 'ملخص إنجاز المراحل والتنبيهات المهمة، مع إرشاد للحفاظ على أثر العبادة.', icon: Icons.history_edu_outlined, color: MunasaknaTheme.zamzamBlue),
];
