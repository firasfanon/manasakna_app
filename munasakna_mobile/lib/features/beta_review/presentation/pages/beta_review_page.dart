import 'package:flutter/material.dart';

import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';
import '../../../beta_readiness/data/beta_page_audit_registry.dart';
import '../../../beta_readiness/domain/models/beta_page_audit.dart';

class BetaReviewPage extends StatelessWidget {
  const BetaReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final audits = BetaReadinessRegistry.pageAudits;
    final needsNusuk = audits.where((item) => item.needsNusukData).length;
    final needsScholar = audits.where((item) => item.needsScholarApproval).length;
    return MunasaknaAppScaffold(
      title: 'مراجعة الصفحات',
      headerIcon: Icons.fact_check_outlined,
      bottomNavIndex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoSectionCard(
            title: 'Beta Readiness Batch 02',
            subtitle: 'مراجعة وظيفية للصفحات الداخلية قبل الانتقال إلى Beta داخلية.',
            icon: Icons.rule_folder_outlined,
            trailing: const MunasaknaStatusChip(label: 'v2.8.4', icon: Icons.new_releases_outlined),
            children: [
              Text(
                'هذه الصفحة لا تضيف ربطًا فعليًا مع نسك، لكنها تثبت ما تحتاجه كل صفحة من بيانات واعتماد وخصوصية وسيناريو اختبار قبل التفعيل الرسمي.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  MunasaknaStatusChip(label: '${audits.length} صفحات مراجعة', icon: Icons.dashboard_customize_outlined),
                  MunasaknaStatusChip(label: '$needsNusuk تحتاج نسك', icon: Icons.cloud_sync_outlined, color: MunasaknaTheme.zamzamBlue),
                  MunasaknaStatusChip(label: '$needsScholar تحتاج اعتمادًا شرعيًا', icon: Icons.verified_outlined, color: MunasaknaTheme.kiswahGold),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in audits) ...[
            _PageAuditCard(item: item),
            const SizedBox(height: 12),
          ],
          InfoSectionCard(
            title: 'قاعدة الإغلاق قبل Beta',
            subtitle: 'لا تُغلق أي صفحة حساسة قبل تحديد مصدر البيانات، الاعتماد، وسيناريو الاختبار.',
            icon: Icons.lock_clock_outlined,
            children: const [
              Text('الصفحات الشرعية تحتاج اعتماد اللجنة الشرعية قبل النشر العام.'),
              SizedBox(height: 8),
              Text('الصفحات الإدارية التي تكتب بيانات إلى السيرفر تبقى محلية حتى تفعيل نسك والمصادقة.'),
              SizedBox(height: 8),
              Text('صفحات الموقع والصوت والوثائق تحتاج موافقة المستخدم وسياسة خصوصية واضحة.'),
            ],
          ),
        ],
      ),
    );
  }
}

class _PageAuditCard extends StatelessWidget {
  const _PageAuditCard({required this.item});

  final BetaPageAuditItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: scheme.surface,
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: scheme.primary.withValues(alpha: 0.11),
                ),
                child: Icon(item.icon, color: scheme.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.titleAr, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(item.layerAr, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                  ],
                ),
              ),
              MunasaknaStatusChip(label: item.statusAr, icon: Icons.verified_outlined),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              MunasaknaStatusChip(label: item.stageAr, icon: Icons.timeline_outlined, color: MunasaknaTheme.haramGreen),
              MunasaknaStatusChip(label: item.primaryUserAr, icon: Icons.person_outline, color: MunasaknaTheme.zamzamBlue),
              MunasaknaStatusChip(
                label: item.needsNusukData ? 'تحتاج بيانات نسك' : 'محلية الآن',
                icon: item.needsNusukData ? Icons.cloud_sync_outlined : Icons.phone_android_outlined,
                color: item.needsNusukData ? MunasaknaTheme.zamzamBlue : MunasaknaTheme.haramGreen,
              ),
              MunasaknaStatusChip(
                label: item.needsScholarApproval ? 'اعتماد شرعي' : 'لا تحتاج اعتمادًا شرعيًا',
                icon: item.needsScholarApproval ? Icons.gavel_outlined : Icons.check_circle_outline,
                color: item.needsScholarApproval ? MunasaknaTheme.kiswahGold : MunasaknaTheme.haramGreen,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _BulletGroup(title: 'المخاطر', items: item.risksAr, icon: Icons.warning_amber_outlined, color: scheme.error),
          const SizedBox(height: 10),
          _BulletGroup(title: 'خطوات الإغلاق', items: item.nextActionsAr, icon: Icons.task_alt_outlined, color: scheme.primary),
        ],
      ),
    );
  }
}

class _BulletGroup extends StatelessWidget {
  const _BulletGroup({required this.title, required this.items, required this.icon, required this.color});

  final String title;
  final List<String> items;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color.withValues(alpha: 0.07),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, size: 19, color: color),
              const SizedBox(width: 6),
              Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900, color: color)),
            ],
          ),
          const SizedBox(height: 8),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text('• $item', style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45)),
            ),
        ],
      ),
    );
  }
}
