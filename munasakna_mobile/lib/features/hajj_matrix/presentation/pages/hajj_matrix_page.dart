import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/manasikuna_visual_identity.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../data/hajj_ritual_matrix_v6.dart';
import '../../domain/models/hajj_matrix_models.dart';

class HajjMatrixPage extends StatefulWidget {
  const HajjMatrixPage({super.key});

  @override
  State<HajjMatrixPage> createState() => _HajjMatrixPageState();
}

class _HajjMatrixPageState extends State<HajjMatrixPage> {
  HajjType _selectedType = HajjType.tamattu;
  HajjMatrixLayer? _selectedLayer;

  @override
  Widget build(BuildContext context) {
    final stages = hajjRitualMatrixV6.where((stage) {
      final typeMatches = stage.appliesToType(_selectedType);
      final layerMatches = _selectedLayer == null || stage.layers.contains(_selectedLayer);
      return typeMatches && layerMatches;
    }).toList(growable: false);

    return MunasaknaAppScaffold(
      title: 'مصفوفة الحج v6',
      bottomNavIndex: 0,
      headerIcon: Icons.account_tree_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MatrixHero(totalStages: stages.length),
          const SizedBox(height: 14),
          _HajjTypeSelector(selectedType: _selectedType, onChanged: (value) => setState(() => _selectedType = value)),
          const SizedBox(height: 14),
          _LayerFilter(selectedLayer: _selectedLayer, onChanged: (value) => setState(() => _selectedLayer = value)),
          const SizedBox(height: 16),
          ManasikunaSectionTitle(
            title: 'مراحل المصفوفة',
            subtitle: 'مصنفة حسب الشرع، الزمن، المكان، الإدارة، الصحة، التعليم، والتطبيق',
            icon: Icons.view_timeline_rounded,
            trailing: Text('${stages.length}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
          ),
          const SizedBox(height: 10),
          for (final stage in stages) ...[
            _StageV6Card(stage: stage),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 8),
          const _MiqatsSection(),
          const SizedBox(height: 14),
          const _IhramProhibitionsSection(),
          const SizedBox(height: 14),
          _ActionBridgeCard(
            title: 'الدليل الإرشادي للطبقات',
            subtitle: 'افتح واجهات مبسطة لكل طبقة من الطبقات السبع.',
            icon: Icons.layers_rounded,
            route: MunasaknaRoutes.layerGuide,
          ),
          const SizedBox(height: 10),
          _ActionBridgeCard(
            title: 'مصفوفة الأسئلة السياقية',
            subtitle: 'أسئلة الحج المتكررة حسب الزمان والمكان ونوع الحج والجنس.',
            icon: Icons.quiz_rounded,
            route: MunasaknaRoutes.hajjFaq,
          ),
          const SizedBox(height: 10),
          _ActionBridgeCard(
            title: 'المساعد الذكي البسيط',
            subtitle: 'اسأل سؤالًا سريعًا عن الإحرام، عرفة، الجمرات، السلامة أو الشكاوى.',
            icon: Icons.smart_toy_rounded,
            route: MunasaknaRoutes.hajjAssistant,
          ),
        ],
      ),
    );
  }
}

class _MatrixHero extends StatelessWidget {
  const _MatrixHero({required this.totalStages});

  final int totalStages;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: MunasaknaTheme.sacredGradient(scheme),
        border: Border.all(color: MunasaknaTheme.kiswahGold.withValues(alpha: 0.45)),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hajj Ritual Matrix v6', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text('مصفوفة متعددة الأبعاد لبناء تجربة مناسكنا.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.86))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              ManasikunaPill(label: 'شرعي', icon: Icons.gavel_rounded),
              ManasikunaPill(label: 'زمني', icon: Icons.calendar_month_rounded),
              ManasikunaPill(label: 'مكاني', icon: Icons.map_rounded),
              ManasikunaPill(label: 'صحة وسلامة', icon: Icons.health_and_safety_rounded),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'تعرض هذه الشاشة ${totalStages} مرحلة للحج، وكل مرحلة تحمل حكمها، حساسيتها، حاجتها لبيانات نسك أو الموقع، والإجراء المناسب داخل التطبيق.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.92), height: 1.55),
          ),
        ],
      ),
    );
  }
}

class _HajjTypeSelector extends StatelessWidget {
  const _HajjTypeSelector({required this.selectedType, required this.onChanged});

  final HajjType selectedType;
  final ValueChanged<HajjType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ManasikunaSectionTitle(title: 'نوع الحج والنية', subtitle: 'اختيار النوع يغيّر مراحل الرحلة', icon: Icons.route_rounded),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final info in hajjTypeInfos)
                  ChoiceChip(
                    selected: selectedType == info.type,
                    label: Text(info.title),
                    onSelected: (_) => onChanged(info.type),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _SelectedTypeDetails(info: hajjTypeInfos.firstWhere((item) => item.type == selectedType)),
          ],
        ),
      ),
    );
  }
}

class _SelectedTypeDetails extends StatelessWidget {
  const _SelectedTypeDetails({required this.info});

  final HajjTypeInfo info;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.36),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(info.intention, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900, color: scheme.primary)),
          const SizedBox(height: 7),
          Text(info.summary, style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45)),
          const SizedBox(height: 8),
          Text(info.appBehavior, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.45)),
        ],
      ),
    );
  }
}

class _LayerFilter extends StatelessWidget {
  const _LayerFilter({required this.selectedLayer, required this.onChanged});

  final HajjMatrixLayer? selectedLayer;
  final ValueChanged<HajjMatrixLayer?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ManasikunaSectionTitle(title: 'الطبقات السبع', subtitle: 'فلترة المصفوفة حسب زاوية العمل', icon: Icons.layers_rounded),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(selected: selectedLayer == null, label: const Text('الكل'), onSelected: (_) => onChanged(null)),
                for (final layer in HajjMatrixLayer.values)
                  ChoiceChip(
                    selected: selectedLayer == layer,
                    avatar: Icon(_layerIcon(layer), size: 18),
                    label: Text(_layerLabel(layer)),
                    onSelected: (_) => onChanged(layer),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StageV6Card extends StatelessWidget {
  const _StageV6Card({required this.stage});

  final HajjRitualStageV6 stage;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final sensitivityColor = _sensitivityColor(scheme, stage.sensitivity);
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: sensitivityColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: sensitivityColor.withValues(alpha: 0.24)),
                  ),
                  child: Icon(_importanceIcon(stage.importance), color: sensitivityColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stage.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      Text('${stage.timeLabel} • ${stage.locationLabel}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(stage.summary, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: [
                _MiniTag(label: _importanceLabel(stage.importance), icon: _importanceIcon(stage.importance), color: sensitivityColor),
                _MiniTag(label: _sensitivityLabel(stage.sensitivity), icon: Icons.warning_amber_rounded, color: sensitivityColor),
                if (stage.requiresNusukData) _MiniTag(label: 'بيانات نسك', icon: Icons.storage_rounded, color: scheme.tertiary),
                if (stage.requiresLocation) _MiniTag(label: 'موقع جغرافي', icon: Icons.location_on_rounded, color: scheme.primary),
                if (stage.needsShariaApproval) _MiniTag(label: 'اعتماد شرعي', icon: Icons.verified_rounded, color: MunasaknaTheme.kiswahGold),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final layer in stage.layers) _LayerTag(layer: layer),
              ],
            ),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              title: const Text('ماذا يفعل الحاج؟', style: TextStyle(fontWeight: FontWeight.w900)),
              children: [
                for (final action in stage.actions) _BulletLine(text: action),
                if (stage.warnings.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  for (final warning in stage.warnings) _BulletLine(text: warning, alert: true),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiqatsSection extends StatelessWidget {
  const _MiqatsSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ManasikunaSectionTitle(title: 'المواقيت الشرعية', subtitle: 'زمانية ومكانية، وتتحول لاحقًا إلى تنبيهات ذكية', icon: Icons.explore_rounded),
            const SizedBox(height: 12),
            _BulletLine(text: 'المواقيت الزمانية: شوال، ذو القعدة، وذو الحجة بحسب التفصيل الشرعي المعتمد.'),
            _BulletLine(text: 'أيام الحج العملية: 8 التروية، 9 عرفة، 10 النحر، 11-13 التشريق.'),
            const SizedBox(height: 8),
            for (final miqat in spatialMiqats.take(5))
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _CompactInfoLine(title: miqat.name, subtitle: '${miqat.forWhom} — ${miqat.appHint}'),
              ),
          ],
        ),
      ),
    );
  }
}

class _IhramProhibitionsSection extends StatelessWidget {
  const _IhramProhibitionsSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ManasikunaSectionTitle(title: 'محظورات الإحرام', subtitle: 'تعرض حسب الجنس والحالة في نسخة الربط لاحقًا', icon: Icons.do_not_disturb_on_rounded),
            const SizedBox(height: 12),
            for (final group in ihramProhibitionGroups) ...[
              Text(group.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: [for (final item in group.items) Chip(label: Text(item))],
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionBridgeCard extends StatelessWidget {
  const _ActionBridgeCard({required this.title, required this.subtitle, required this.icon, required this.route});

  final String title;
  final String subtitle;
  final IconData icon;
  final String route;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(route),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: scheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 3),
                    Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.35)),
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

class _MiniTag extends StatelessWidget {
  const _MiniTag({required this.label, required this.icon, required this.color});

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }
}

class _LayerTag extends StatelessWidget {
  const _LayerTag({required this.layer});

  final HajjMatrixLayer layer;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: scheme.secondary.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_layerIcon(layer), size: 15, color: scheme.primary),
          const SizedBox(width: 5),
          Text(_layerLabel(layer), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.text, this.alert = false});

  final String text;
  final bool alert;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(alert ? Icons.warning_amber_rounded : Icons.check_circle_rounded, size: 18, color: alert ? scheme.error : scheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45))),
        ],
      ),
    );
  }
}

class _CompactInfoLine extends StatelessWidget {
  const _CompactInfoLine({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.35)),
        ],
      ),
    );
  }
}

String _layerLabel(HajjMatrixLayer layer) {
  switch (layer) {
    case HajjMatrixLayer.sharia:
      return 'شرعية';
    case HajjMatrixLayer.time:
      return 'زمنية';
    case HajjMatrixLayer.place:
      return 'مكانية';
    case HajjMatrixLayer.administrative:
      return 'إدارية';
    case HajjMatrixLayer.healthSafety:
      return 'صحة وسلامة';
    case HajjMatrixLayer.education:
      return 'تعليمية';
    case HajjMatrixLayer.technical:
      return 'تطبيقية';
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

String _importanceLabel(HajjImportance importance) {
  switch (importance) {
    case HajjImportance.rukn:
      return 'ركن';
    case HajjImportance.wajib:
      return 'واجب';
    case HajjImportance.sunnah:
      return 'سنة';
    case HajjImportance.guidance:
      return 'إرشاد';
    case HajjImportance.procedure:
      return 'إجراء';
  }
}

IconData _importanceIcon(HajjImportance importance) {
  switch (importance) {
    case HajjImportance.rukn:
      return Icons.verified_rounded;
    case HajjImportance.wajib:
      return Icons.task_alt_rounded;
    case HajjImportance.sunnah:
      return Icons.auto_awesome_rounded;
    case HajjImportance.guidance:
      return Icons.lightbulb_rounded;
    case HajjImportance.procedure:
      return Icons.assignment_turned_in_rounded;
  }
}

String _sensitivityLabel(HajjSensitivity sensitivity) {
  switch (sensitivity) {
    case HajjSensitivity.normal:
      return 'عادي';
    case HajjSensitivity.important:
      return 'مهم';
    case HajjSensitivity.critical:
      return 'حرج';
  }
}

Color _sensitivityColor(ColorScheme scheme, HajjSensitivity sensitivity) {
  switch (sensitivity) {
    case HajjSensitivity.normal:
      return scheme.primary;
    case HajjSensitivity.important:
      return MunasaknaTheme.kiswahGold;
    case HajjSensitivity.critical:
      return scheme.error;
  }
}
