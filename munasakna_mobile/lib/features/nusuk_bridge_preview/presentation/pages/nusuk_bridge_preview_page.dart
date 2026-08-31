import 'package:flutter/material.dart';

import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/beta_batch_widgets.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';
import '../../data/nusuk_bridge_preview_registry.dart';
import '../../domain/models/nusuk_bridge_preview_models.dart';

class NusukBridgePreviewPage extends StatelessWidget {
  const NusukBridgePreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'معاينة جسر نسك',
      headerIcon: Icons.preview_outlined,
      bottomNavIndex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BetaBatchSummaryCard(
            title: 'Nusuk Bridge Preview Batch 01',
            subtitle: 'معاينة عملية لعقود الربط المستقبلية بين مناسكنا ونسك دون تسجيل دخول ودون اتصال حقيقي بالسيرفر. الهدف هو تثبيت DTO والحقول وسلوك الفشل الآمن قبل بناء قاعدة البيانات والـ API.',
            icon: Icons.account_tree_outlined,
            status: 'Preview / No Login',
            color: MunasaknaTheme.zamzamBlue,
          ),
          const SizedBox(height: 12),
          const InfoSectionCard(
            title: 'قواعد المعاينة',
            subtitle: 'هذه الصفحة ليست ربطًا حقيقيًا، بل عقد تشغيل قابل للمراجعة مع نسك.',
            icon: Icons.rule_outlined,
            children: [
              BetaBulletList(
                items: [
                  'لا تفعيل لتسجيل الدخول في هذه الدفعة.',
                  'لا إرسال أو قراءة من Supabase أو أي سيرفر خارجي.',
                  'كل Payload ظاهر هنا تجريبي ومقنّع ومخصص للمراجعة فقط.',
                  'أي كتابة للشكاوى أو الاستبيانات تبقى مؤجلة حتى المصادقة وRLS وسجل التدقيق.',
                  'المساعد والدليل والمصفوفة يبقون محليين ويعملون حتى عند عدم توفر نسك.',
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _PreviewMetricsRow(),
          const SizedBox(height: 12),
          for (final endpoint in NusukBridgePreviewRegistry.endpoints) ...[
            _EndpointPreviewCard(endpoint: endpoint),
            const SizedBox(height: 12),
          ],
          InfoSectionCard(
            title: 'بوابات قبل الربط الحقيقي',
            subtitle: 'لا ننتقل من المعاينة إلى الاتصال إلا بعد إغلاق هذه البوابات.',
            icon: Icons.verified_user_outlined,
            children: [
              for (final gate in NusukBridgePreviewRegistry.gates) ...[
                _GateTile(gate: gate),
                const SizedBox(height: 8),
              ],
            ],
          ),
          const SizedBox(height: 12),
          const InfoSectionCard(
            title: 'مخرجات الدفعة إلى نسك',
            subtitle: 'ما يجب أن يراجعه فريق نسك قبل البناء الفعلي.',
            icon: Icons.outbox_outlined,
            children: [
              BetaBulletList(
                items: [
                  'اعتماد أسماء المسارات أو تحويلها إلى RPC رسمية حسب سياسة المنصة.',
                  'اعتماد الحقول المطلوبة لكل عقد ووسم الحقول الحساسة.',
                  'تحديد سياسة Session/Auth لاحقًا دون كسر وضع الضيف الحالي.',
                  'تعريف أخطاء موحدة: غير مصادق، غير مصرح، لا توجد بيانات، موسم مغلق، خدمة غير متاحة.',
                  'إعادة هذه العقود إلى مناسكنا كـ DTO نهائي قبل تفعيل Remote Repository.',
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewMetricsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ready = NusukBridgePreviewRegistry.endpoints.where((endpoint) => endpoint.status == NusukPreviewEndpointStatus.readyForApi).length;
    final gated = NusukBridgePreviewRegistry.endpoints.length - ready;
    final cards = [
      _MetricCard(
        title: 'العقود',
        value: '${NusukBridgePreviewRegistry.endpoints.length}',
        subtitle: 'قراءة وكتابة مؤجلة',
        icon: Icons.schema_outlined,
        color: MunasaknaTheme.haramGreen,
      ),
      _MetricCard(
        title: 'جاهز للمراجعة',
        value: '$ready',
        subtitle: 'يمكن تحويله إلى API',
        icon: Icons.check_circle_outline,
        color: MunasaknaTheme.zamzamBlue,
      ),
      _MetricCard(
        title: 'بوابات حماية',
        value: '$gated',
        subtitle: 'مصادقة/RLS/خصوصية',
        icon: Icons.lock_outline,
        color: MunasaknaTheme.kiswahGold,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 720) {
          return Column(
            children: [
              for (final card in cards) ...[card, const SizedBox(height: 10)],
            ],
          );
        }
        return Row(
          children: [
            for (final card in cards) ...[
              Expanded(child: card),
              if (card != cards.last) const SizedBox(width: 10),
            ],
          ],
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 2),
                Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, color: color)),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EndpointPreviewCard extends StatelessWidget {
  const _EndpointPreviewCard({required this.endpoint});

  final NusukPreviewEndpoint endpoint;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InfoSectionCard(
      title: endpoint.titleAr,
      subtitle: endpoint.purposeAr,
      icon: Icons.api_outlined,
      trailing: MunasaknaStatusChip(label: endpoint.status.labelAr, icon: Icons.info_outline),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            MunasaknaStatusChip(label: endpoint.method, icon: Icons.sync_alt_outlined),
            MunasaknaStatusChip(label: endpoint.path, icon: Icons.link_outlined),
          ],
        ),
        const SizedBox(height: 12),
        Text('الشاشات المستهلكة', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final screen in endpoint.screenConsumersAr) MunasaknaStatusChip(label: screen, icon: Icons.phone_android_outlined),
          ],
        ),
        const SizedBox(height: 12),
        Text('الحقول المطلوبة', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        for (final field in endpoint.fields) ...[
          _FieldTile(field: field),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 8),
        Text('Payload تجريبي', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.55)),
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              endpoint.samplePayloadLines.join('\n'),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'monospace', height: 1.45),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text('قواعد القبول', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        BetaBulletList(items: endpoint.acceptanceRulesAr, icon: Icons.verified_outlined),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: MunasaknaTheme.kiswahGold.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            'سلوك الفشل الآمن: ${endpoint.failureFallbackAr}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w800, height: 1.45),
          ),
        ),
      ],
    );
  }
}

class _FieldTile extends StatelessWidget {
  const _FieldTile({required this.field});

  final NusukPreviewField field;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(field.labelAr, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
              ),
              MunasaknaStatusChip(label: field.required ? 'إلزامي' : 'اختياري', icon: field.required ? Icons.star_outline : Icons.radio_button_unchecked),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              MunasaknaStatusChip(label: field.name, icon: Icons.data_object_outlined),
              MunasaknaStatusChip(label: field.typeHint, icon: Icons.code_outlined),
              MunasaknaStatusChip(label: field.sourceAr, icon: Icons.source_outlined),
              MunasaknaStatusChip(label: field.privacyLevel.labelAr, icon: Icons.privacy_tip_outlined),
            ],
          ),
          if (field.notesAr != null) ...[
            const SizedBox(height: 8),
            Text(field.notesAr!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.45)),
          ],
        ],
      ),
    );
  }
}

class _GateTile extends StatelessWidget {
  const _GateTile({required this.gate});

  final NusukPreviewGate gate;

  @override
  Widget build(BuildContext context) {
    final color = gate.done ? MunasaknaTheme.haramGreen : MunasaknaTheme.kiswahGold;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(gate.done ? Icons.check_circle_outline : Icons.pending_actions_outlined, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(gate.titleAr, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(gate.descriptionAr, style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    MunasaknaStatusChip(label: gate.ownerAr, icon: Icons.person_outline),
                    MunasaknaStatusChip(label: gate.statusAr, icon: Icons.info_outline),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
