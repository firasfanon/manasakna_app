import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';


class KnowledgeGovernancePage extends StatelessWidget {
  const KnowledgeGovernancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'حوكمة المعرفة',
      headerIcon: Icons.verified_user_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const InfoSectionCard(
            title: 'لا فتوى ولا هلوسة',
            subtitle: 'المساعد والدليل يعتمدان على المصفوفة والأسئلة المعتمدة فقط، والمسائل الحساسة تُحال للجهة المختصة.',
            icon: Icons.shield_outlined,
            trailing: MunasaknaStatusChip(label: 'آمن', icon: Icons.lock_outline),
            children: [
              Text('هذه الصفحة توضح للحاج وللمطور كيف تُدار المعرفة داخل التطبيق: مصدر الإجابة، درجة الحساسية، الاعتماد الشرعي، والإحالة عند الحاجة.'),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in _governanceItems) ...[
            _GovernanceCard(item: item),
            const SizedBox(height: 12),
          ],
          InfoSectionCard(
            title: 'جهات الإحالة',
            icon: Icons.account_balance_outlined,
            children: const [
              Text('المسائل الشرعية التفصيلية: اللجنة الشرعية أو المرشد المعتمد.'),
              SizedBox(height: 6),
              Text('المسائل الصحية: الجهة الصحية أو الطوارئ.'),
              SizedBox(height: 6),
              Text('المسائل الإدارية: الشركة أو المشرف أو نظام نسك بعد الربط.'),
            ],
          ),
        ],
      ),
    );
  }
}

class _GovernanceCard extends StatelessWidget {
  const _GovernanceCard({required this.item});
  final _GovernanceItem item;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: scheme.surface, borderRadius: BorderRadius.circular(26), border: Border.all(color: item.color.withValues(alpha: 0.22))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 50, height: 50, decoration: BoxDecoration(color: item.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(18)), child: Icon(item.icon, color: item.color)),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(item.description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55, color: scheme.onSurfaceVariant)),
        ])),
      ]),
    );
  }
}

class _GovernanceItem {
  const _GovernanceItem({required this.title, required this.description, required this.icon, required this.color});
  final String title;
  final String description;
  final IconData icon;
  final Color color;
}

const _governanceItems = [
  _GovernanceItem(title: 'المصفوفة أولًا', description: 'كل إجابة إرشادية يجب أن تعود إلى Hajj Ritual Matrix v6 أو FAQ Matrix، ولا تُنشأ إجابات حرة في المسائل الشرعية.', icon: Icons.account_tree_outlined, color: MunasaknaTheme.deepHaramGreen),
  _GovernanceItem(title: 'وسم الحساسية', description: 'أي سؤال عن ترك ركن، ترك واجب، محظور إحرام، عذر النساء، أو التوكيل في الرمي يُوسم حساسًا ويحال للجهة المختصة.', icon: Icons.warning_amber_outlined, color: MunasaknaTheme.roseAlert),
  _GovernanceItem(title: 'فصل الشرعي عن الإداري', description: 'التطبيق يفرق بين حكم شرعي، إجراء شركة، تنبيه صحي، ومعلومة ميدانية؛ ولا يخلط بينها في الإجابة.', icon: Icons.category_outlined, color: MunasaknaTheme.kiswahGold),
  _GovernanceItem(title: 'تحديث موثق', description: 'كل تطوير جديد يجب أن يحدث الدليل الشامل وسجل النسخة حتى يبقى الملف المرجعي مصدر الحقيقة للمطورين.', icon: Icons.edit_note_outlined, color: MunasaknaTheme.zamzamBlue),
];
