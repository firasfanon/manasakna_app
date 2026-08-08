import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/manasikuna_visual_identity.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../data/hajj_ritual_matrix_v6.dart';
import '../../domain/models/hajj_matrix_models.dart';

class LayeredGuidePage extends StatelessWidget {
  const LayeredGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'الدليل الإرشادي',
      bottomNavIndex: 0,
      headerIcon: Icons.layers_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _GuideHero(),
          const SizedBox(height: 14),
          const ManasikunaSectionTitle(
            title: 'واجهات سهلة لكل طبقة',
            subtitle: 'كل طبقة تقود الحاج إلى إجراء واضح بدل النص الطويل',
            icon: Icons.dashboard_customize_rounded,
          ),
          const SizedBox(height: 10),
          for (final layer in hajjGuideLayers) ...[
            _LayerGuideCard(layer: layer),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 4),
          _AssistantBridge(),
        ],
      ),
    );
  }
}

class _GuideHero extends StatelessWidget {
  const _GuideHero();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: MunasaknaTheme.sacredGradient(scheme),
        border: Border.all(color: MunasaknaTheme.kiswahGold.withValues(alpha: 0.42)),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const ManasikunaKaabaMark(size: 58),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'الدليل الإرشادي متعدد الطبقات',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'واجهة مرشدة لتبسيط الحج للحاج: شرعًا، زمنًا، مكانًا، إداريًا، صحيًا، تعليميًا، وتقنيًا.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.92), height: 1.55),
          ),
          const SizedBox(height: 14),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ManasikunaPill(label: 'كبار السن', icon: Icons.elderly_rounded),
              ManasikunaPill(label: 'أزرار واضحة', icon: Icons.touch_app_rounded),
              ManasikunaPill(label: 'مساعد بسيط', icon: Icons.smart_toy_rounded),
            ],
          ),
        ],
      ),
    );
  }
}

class _LayerGuideCard extends StatelessWidget {
  const _LayerGuideCard({required this.layer});

  final HajjGuideLayer layer;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = _layerColor(scheme, layer.layer);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(color: color.withValues(alpha: 0.24)),
                  ),
                  child: Icon(_layerIcon(layer.layer), color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(layer.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      Text(layer.summary, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.45)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(layer.interfaceTitle, style: TextStyle(fontWeight: FontWeight.w900, color: color)),
                  const SizedBox(height: 4),
                  Text(layer.interfaceDescription, style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: [for (final item in layer.items) Chip(label: Text(item))],
            ),
          ],
        ),
      ),
    );
  }
}

class _AssistantBridge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(MunasaknaRoutes.hajjAssistant),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(Icons.smart_toy_rounded, color: scheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('اسأل المساعد الذكي البسيط', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 3),
                    Text('مساعد محلي تجريبي يجيب من مصفوفة الحج v6 ولا يتصل بأي خدمة خارجية.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.35)),
                  ],
                ),
              ),
              Icon(Icons.chevron_left_rounded, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

IconData _layerIcon(HajjMatrixLayer layer) {
  switch (layer) {
    case HajjMatrixLayer.sharia:
      return Icons.gavel_rounded;
    case HajjMatrixLayer.time:
      return Icons.schedule_rounded;
    case HajjMatrixLayer.place:
      return Icons.map_rounded;
    case HajjMatrixLayer.administrative:
      return Icons.assignment_rounded;
    case HajjMatrixLayer.healthSafety:
      return Icons.health_and_safety_rounded;
    case HajjMatrixLayer.education:
      return Icons.menu_book_rounded;
    case HajjMatrixLayer.technical:
      return Icons.touch_app_rounded;
  }
}

Color _layerColor(ColorScheme scheme, HajjMatrixLayer layer) {
  switch (layer) {
    case HajjMatrixLayer.sharia:
      return scheme.primary;
    case HajjMatrixLayer.time:
      return MunasaknaTheme.kiswahGold;
    case HajjMatrixLayer.place:
      return scheme.tertiary;
    case HajjMatrixLayer.administrative:
      return const Color(0xFF7C3AED);
    case HajjMatrixLayer.healthSafety:
      return const Color(0xFF059669);
    case HajjMatrixLayer.education:
      return const Color(0xFFB45309);
    case HajjMatrixLayer.technical:
      return const Color(0xFF2563EB);
  }
}
