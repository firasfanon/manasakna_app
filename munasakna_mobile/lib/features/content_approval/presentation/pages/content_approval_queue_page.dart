import 'package:flutter/material.dart';

import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class ContentApprovalQueuePage extends StatelessWidget {
  const ContentApprovalQueuePage({super.key});

  static const _items = [
    _ApprovalItem(
      title: 'مصفوفة الحج v6',
      layer: 'شرعي / زمني / مكاني',
      status: 'اعتماد شرعي مطلوب',
      risk: 'حرج',
      notes: 'الأركان، الواجبات، التحلل، الرخص، والأسئلة الحساسة لا تنشر رسميًا قبل اعتماد اللجنة.',
    ),
    _ApprovalItem(
      title: 'FAQ حسب الزمان والمكان',
      layer: 'تعليمي / شرعي',
      status: 'مراجعة صياغة',
      risk: 'مهم',
      notes: 'الإجابات يجب أن تبقى وسطية، مختصرة، وتوجه للجهة المختصة عند التفصيل.',
    ),
    _ApprovalItem(
      title: 'إرشادات الصحة والسلامة',
      layer: 'صحي / ميداني',
      status: 'اعتماد جهة صحية لاحقًا',
      risk: 'مهم',
      notes: 'تبقى إرشادات عامة، ولا تتحول إلى تشخيص أو علاج.',
    ),
    _ApprovalItem(
      title: 'المساعد الصوتي',
      layer: 'تقني / معرفي',
      status: 'محدود بالمصفوفة',
      risk: 'حرج',
      notes: 'لا يجيب خارج مصادر المعرفة المحلية، ولا يصدر فتوى، ويعرض توجيهًا واضحًا للجنة الشرعية.',
    ),
    _ApprovalItem(
      title: 'الشكاوى والاستبيان',
      layer: 'إداري / تشغيلي',
      status: 'ينتظر نسك',
      risk: 'مهم',
      notes: 'النسخة الحالية محلية. الربط الحقيقي يحتاج سياسات تخزين وتدقيق وصلاحيات.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'طابور اعتماد المحتوى',
      headerIcon: Icons.verified_user_outlined,
      bottomNavIndex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoSectionCard(
            title: 'حوكمة المحتوى قبل بيتا',
            subtitle: 'تمييز ما يمكن عرضه إرشاديًا وما يحتاج اعتمادًا رسميًا قبل النشر.',
            icon: Icons.approval_outlined,
            trailing: const MunasaknaStatusChip(label: 'حاكم', icon: Icons.policy_outlined),
            children: const [
              Text(
                'هذه الصفحة تمنع الخلط بين المحتوى الإرشادي العام والمحتوى الشرعي الحساس. أي مسألة مؤثرة في صحة النسك أو التزام الحاج تُوسم لاعتماد اللجنة الشرعية.',
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in _items) ...[
            _ApprovalCard(item: item),
            const SizedBox(height: 10),
          ],
          InfoSectionCard(
            title: 'قاعدة جواب المساعد',
            subtitle: 'لا هلوسة ولا فتوى.',
            icon: Icons.smart_toy_outlined,
            children: const [
              Text(
                'إذا لم يجد المساعد جوابًا واضحًا في مصفوفة الحج أو FAQ، يعتذر ويوجه الحاج إلى المرشد أو اللجنة الشرعية أو الطوارئ حسب نوع المسألة.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ApprovalItem {
  const _ApprovalItem({
    required this.title,
    required this.layer,
    required this.status,
    required this.risk,
    required this.notes,
  });

  final String title;
  final String layer;
  final String status;
  final String risk;
  final String notes;
}

class _ApprovalCard extends StatelessWidget {
  const _ApprovalCard({required this.item});

  final _ApprovalItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isCritical = item.risk == 'حرج';
    final accent = isCritical ? MunasaknaTheme.roseAlert : scheme.primary;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: scheme.surface,
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(isCritical ? Icons.warning_amber_rounded : Icons.fact_check_outlined, color: accent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(item.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
              ),
              MunasaknaStatusChip(label: item.risk, icon: Icons.priority_high_outlined, color: accent),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text(item.layer), avatar: const Icon(Icons.layers_outlined, size: 18)),
              Chip(label: Text(item.status), avatar: const Icon(Icons.verified_outlined, size: 18)),
            ],
          ),
          const SizedBox(height: 8),
          Text(item.notes, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant, height: 1.55)),
        ],
      ),
    );
  }
}
