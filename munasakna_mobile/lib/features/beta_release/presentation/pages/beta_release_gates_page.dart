import 'package:flutter/material.dart';

import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class BetaReleaseGatesPage extends StatelessWidget {
  const BetaReleaseGatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final completed = _releaseGates.where((gate) => gate.status == _GateStatus.complete).length;
    final blocked = _releaseGates.where((gate) => gate.status == _GateStatus.blocked).length;
    final pending = _releaseGates.length - completed - blocked;
    return MunasaknaAppScaffold(
      title: 'بوابات الإطلاق الداخلي',
      headerIcon: Icons.rule_folder_outlined,
      bottomNavIndex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoSectionCard(
            title: 'Release Gates — قبل Beta الداخلية',
            subtitle: 'هذه ليست صفحة نشر رسمي، بل سجل بوابات يمنع الانتقال العشوائي من Alpha مستقر إلى Beta داخلية.',
            icon: Icons.rule_folder_outlined,
            trailing: const MunasaknaStatusChip(label: 'حاكم', icon: Icons.verified_user_outlined),
            children: [
              Text(
                'لا نفعّل تسجيل الدخول، ولا نكتب إلى نسك، ولا ننشر محتوى شرعي حساس قبل إغلاق البوابات المطلوبة. البوابات تقرأ حالة النظام الحالي وتوضح ما هو مكتمل وما هو مؤجل.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  MunasaknaStatusChip(label: '$completed مكتملة', icon: Icons.check_circle_outline, color: MunasaknaTheme.haramGreen),
                  MunasaknaStatusChip(label: '$pending قيد المراجعة', icon: Icons.pending_actions_outlined, color: MunasaknaTheme.kiswahGold),
                  MunasaknaStatusChip(label: '$blocked مؤجلة/محجوبة', icon: Icons.lock_clock_outlined, color: Theme.of(context).colorScheme.error),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final gate in _releaseGates) ...[
            _ReleaseGateCard(gate: gate),
            const SizedBox(height: 12),
          ],
          InfoSectionCard(
            title: 'قرار الانتقال المقترح',
            subtitle: 'الحالة الحالية بعد Batch 03.',
            icon: Icons.rocket_launch_outlined,
            children: const [
              Text('التطبيق مناسب لاختبار Beta داخلي محدود، بشرط إبقاء البيانات محلية وعدم تفعيل المصادقة أو الكتابة إلى نسك.'),
              SizedBox(height: 8),
              Text('الإطلاق الرسمي للجمهور يبقى مؤجلًا حتى اعتماد المحتوى الشرعي، الربط الآمن مع نسك، وسياسة الخصوصية النهائية.'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReleaseGateCard extends StatelessWidget {
  const _ReleaseGateCard({required this.gate});

  final _ReleaseGate gate;

  @override
  Widget build(BuildContext context) {
    final color = switch (gate.status) {
      _GateStatus.complete => MunasaknaTheme.haramGreen,
      _GateStatus.pending => MunasaknaTheme.kiswahGold,
      _GateStatus.blocked => Theme.of(context).colorScheme.error,
    };
    final label = switch (gate.status) {
      _GateStatus.complete => 'مكتملة',
      _GateStatus.pending => 'قيد المراجعة',
      _GateStatus.blocked => 'مؤجلة',
    };
    final icon = switch (gate.status) {
      _GateStatus.complete => Icons.check_circle_outline,
      _GateStatus.pending => Icons.pending_actions_outlined,
      _GateStatus.blocked => Icons.lock_clock_outlined,
    };
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: scheme.surface,
        border: Border.all(color: color.withValues(alpha: 0.20)),
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
                  color: color.withValues(alpha: 0.10),
                ),
                child: Icon(gate.icon, color: color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(gate.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(gate.description, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.45)),
                  ],
                ),
              ),
              MunasaknaStatusChip(label: label, icon: icon, color: color),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: color.withValues(alpha: 0.06),
            ),
            child: Text(gate.nextAction, style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

enum _GateStatus { complete, pending, blocked }

class _ReleaseGate {
  const _ReleaseGate({
    required this.title,
    required this.description,
    required this.nextAction,
    required this.status,
    required this.icon,
  });

  final String title;
  final String description;
  final String nextAction;
  final _GateStatus status;
  final IconData icon;
}

const _releaseGates = [
  _ReleaseGate(
    title: 'استقرار الاختبارات',
    description: 'Baseline v282 أظهر All tests passed، وكل دفعة لاحقة يجب أن تعيد الاختبار قبل الاعتماد.',
    nextAction: 'بعد هذه الدفعة: تشغيل flutter test محليًا وإغلاق أي خطأ موضعيًا فقط.',
    status: _GateStatus.complete,
    icon: Icons.checklist_rtl_outlined,
  ),
  _ReleaseGate(
    title: 'وضع الضيف بلا تسجيل دخول',
    description: 'التطبيق يعمل في التطوير دون مصادقة حتى جاهزية قاعدة بيانات نسك ومتطلبات السيرفر.',
    nextAction: 'يُمنع إدخال شاشة تسجيل دخول في هذه المرحلة إلا كتصميم مؤجل غير مفعّل.',
    status: _GateStatus.complete,
    icon: Icons.no_accounts_outlined,
  ),
  _ReleaseGate(
    title: 'اعتماد المحتوى الشرعي',
    description: 'مصفوفة الحج وFAQ والمساعد تحتاج مراجعة اللجنة الشرعية قبل النشر للجمهور.',
    nextAction: 'تصدير قائمة المسائل الحساسة وتجهيزها للاعتماد الشرعي.',
    status: _GateStatus.pending,
    icon: Icons.gavel_outlined,
  ),
  _ReleaseGate(
    title: 'الصوت والمساعد',
    description: 'TTS وSpeech-to-Text جاهزان مبدئيًا، لكن يحتاجان اختبارًا على أجهزة حقيقية ومتصفحات مختلفة.',
    nextAction: 'تنفيذ سيناريو صوت على Chrome/Android، وتأجيل iOS لحين توفر macOS/Xcode.',
    status: _GateStatus.pending,
    icon: Icons.record_voice_over_outlined,
  ),
  _ReleaseGate(
    title: 'الخصوصية والموقع والوثائق',
    description: 'الموقع والبطاقة الرقمية والوثائق تحتاج سياسة خصوصية ونصوص موافقة قبل الربط.',
    nextAction: 'مراجعة صفحات الخصوصية والطوارئ والبطاقة الرقمية قبل أي كتابة للسيرفر.',
    status: _GateStatus.pending,
    icon: Icons.privacy_tip_outlined,
  ),
  _ReleaseGate(
    title: 'ربط نسك',
    description: 'العقود جاهزة تصميميًا، لكن لا يوجد ربط فعلي ولا مصادقة ولا RLS حتى الآن.',
    nextAction: 'يبقى الربط محجوبًا حتى تجهيز قاعدة البيانات، Edge/API، سياسات RLS، وسجل التدقيق.',
    status: _GateStatus.blocked,
    icon: Icons.cloud_sync_outlined,
  ),
  _ReleaseGate(
    title: 'الإطلاق للمتاجر',
    description: 'النشر الرسمي يحتاج أيقونات نهائية، سياسة خصوصية، اعتماد المحتوى، وحسابات المطور.',
    nextAction: 'يبقى مؤجلًا بعد Beta داخلية وتجارب ميدانية محدودة.',
    status: _GateStatus.blocked,
    icon: Icons.storefront_outlined,
  ),
];
