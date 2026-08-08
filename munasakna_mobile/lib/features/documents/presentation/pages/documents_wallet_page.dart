import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class DocumentsWalletPage extends StatelessWidget {
  const DocumentsWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'محفظة الوثائق',
      headerIcon: Icons.folder_copy_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const InfoSectionCard(
            title: 'محفظة محلية مؤقتة للوثائق',
            subtitle: 'تجميع ما يحتاجه الحاج قبل الربط مع نسك: الجواز، التطعيمات، التصاريح، بيانات الطوارئ والوصول.',
            icon: Icons.folder_copy_outlined,
            trailing: MunasaknaStatusChip(label: 'محلي', icon: Icons.phone_android_outlined),
            children: [
              Text('لا يتم رفع أي وثائق حاليًا. هذه الصفحة تجهّز تجربة المستخدم وتحدد الحقول التي ستربط لاحقًا مع السيرفر.'),
            ],
          ),
          const SizedBox(height: 12),
          _ReadinessSummary(completed: 4, total: _documents.length),
          const SizedBox(height: 12),
          for (final document in _documents) ...[
            _DocumentTile(document: document),
            const SizedBox(height: 10),
          ],
          InfoSectionCard(
            title: 'إجراءات سريعة',
            icon: Icons.bolt_outlined,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(onPressed: () => context.push(MunasaknaRoutes.checklist), icon: const Icon(Icons.checklist_rtl_outlined), label: const Text('قائمة الجاهزية')),
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.profile), icon: const Icon(Icons.badge_outlined), label: const Text('بياناتي')),
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.health), icon: const Icon(Icons.health_and_safety_outlined), label: const Text('الصحة والسلامة')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReadinessSummary extends StatelessWidget {
  const _ReadinessSummary({required this.completed, required this.total});
  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final value = completed / total;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: MunasaknaTheme.goldMistGradient(scheme),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: MunasaknaTheme.kiswahGold.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_outlined, color: MunasaknaTheme.deepHaramGreen),
              const SizedBox(width: 8),
              Expanded(child: Text('جاهزية الوثائق', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900))),
              Text('$completed / $total', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, color: scheme.primary)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(borderRadius: BorderRadius.circular(999), child: LinearProgressIndicator(value: value, minHeight: 10)),
          const SizedBox(height: 8),
          Text('البيانات تجريبية إلى حين تجهيز قاعدة بيانات نسك وسياسات رفع الملفات.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({required this.document});
  final _PilgrimDocument document;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = switch (document.status) {
      _DocumentStatus.ready => scheme.primary,
      _DocumentStatus.review => MunasaknaTheme.kiswahGold,
      _DocumentStatus.missing => scheme.error,
    };
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: color.withValues(alpha: 0.11), borderRadius: BorderRadius.circular(17)), child: Icon(document.icon, color: color)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(document.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(document.note, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          MunasaknaStatusChip(label: document.label, icon: document.statusIcon, color: color),
        ],
      ),
    );
  }
}

enum _DocumentStatus { ready, review, missing }

class _PilgrimDocument {
  const _PilgrimDocument({required this.title, required this.note, required this.icon, required this.status});
  final String title;
  final String note;
  final IconData icon;
  final _DocumentStatus status;

  String get label => switch (status) {
        _DocumentStatus.ready => 'جاهز',
        _DocumentStatus.review => 'مراجعة',
        _DocumentStatus.missing => 'ناقص',
      };

  IconData get statusIcon => switch (status) {
        _DocumentStatus.ready => Icons.check_circle_outline,
        _DocumentStatus.review => Icons.pending_actions_outlined,
        _DocumentStatus.missing => Icons.error_outline,
      };
}

const _documents = [
  _PilgrimDocument(title: 'جواز السفر', note: 'يتحقق منه لاحقًا من خلال نظام نسك حسب الموسم وشروط السفر.', icon: Icons.article_outlined, status: _DocumentStatus.ready),
  _PilgrimDocument(title: 'شهادة التطعيم', note: 'تظهر حالة التطعيمات المطلوبة من الجهة المختصة عند الربط الرسمي.', icon: Icons.vaccines_outlined, status: _DocumentStatus.review),
  _PilgrimDocument(title: 'تصريح الحج', note: 'مرجع التصريح والبرنامج سيأتي من نسك وليس من التطبيق المحلي.', icon: Icons.verified_user_outlined, status: _DocumentStatus.ready),
  _PilgrimDocument(title: 'بيانات الطوارئ', note: 'رقم قريب أو مرافق وملاحظات صحية مهمة يمكن تجهيزها الآن محليًا.', icon: Icons.contact_emergency_outlined, status: _DocumentStatus.ready),
  _PilgrimDocument(title: 'إثبات السكن/المخيم', note: 'سيظهر عند اعتماد السكن والمخيم من نظام نسك.', icon: Icons.hotel_outlined, status: _DocumentStatus.missing),
  _PilgrimDocument(title: 'تذكرة السفر/الحافلة', note: 'سترتبط بمواعيد التفويج والنقل لاحقًا.', icon: Icons.confirmation_number_outlined, status: _DocumentStatus.missing),
];
