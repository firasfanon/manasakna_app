import 'package:flutter/material.dart';

import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/manasikuna_visual_identity.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../hajj_matrix/domain/models/hajj_matrix_models.dart';
import '../../data/hajj_faq_matrix_v2.dart';
import '../../domain/models/hajj_faq_models.dart';

class ContextualFaqPage extends StatefulWidget {
  const ContextualFaqPage({super.key});

  @override
  State<ContextualFaqPage> createState() => _ContextualFaqPageState();
}

class _ContextualFaqPageState extends State<ContextualFaqPage> {
  HajjFaqPhase? _selectedPhase;
  HajjType? _selectedType;
  HajjGenderScope? _selectedGender;

  @override
  Widget build(BuildContext context) {
    final items = hajjFaqMatrixV2.where((item) {
      final phaseMatches = _selectedPhase == null || item.phase == _selectedPhase;
      final typeMatches = _selectedType == null || item.appliesToType(_selectedType!);
      final genderMatches = _selectedGender == null || item.genderScope == HajjGenderScope.all || item.genderScope == _selectedGender;
      return phaseMatches && typeMatches && genderMatches;
    }).toList(growable: false);

    return MunasaknaAppScaffold(
      title: 'أسئلة الحج حسب المرحلة',
      bottomNavIndex: 0,
      headerIcon: Icons.quiz_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FaqHero(total: items.length),
          const SizedBox(height: 14),
          _PhaseFilter(selected: _selectedPhase, onChanged: (phase) => setState(() => _selectedPhase = phase)),
          const SizedBox(height: 12),
          _ScopeFilter(
            selectedType: _selectedType,
            selectedGender: _selectedGender,
            onTypeChanged: (value) => setState(() => _selectedType = value),
            onGenderChanged: (value) => setState(() => _selectedGender = value),
          ),
          const SizedBox(height: 16),
          ManasikunaSectionTitle(
            title: 'الأسئلة المتوقعة',
            subtitle: 'مرتبة حسب الزمان والمكان ونوع الحج والجنس عند الحاجة',
            icon: Icons.question_answer_rounded,
            trailing: Text('${items.length}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
          ),
          const SizedBox(height: 10),
          for (final item in items) ...[
            _FaqCard(item: item),
            const SizedBox(height: 10),
          ],
          if (items.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('لا توجد أسئلة مطابقة لهذه الفلاتر حاليًا.'),
              ),
            ),
        ],
      ),
    );
  }
}

class _FaqHero extends StatelessWidget {
  const _FaqHero({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: MunasaknaTheme.sacredGradient(scheme),
        border: Border.all(color: MunasaknaTheme.kiswahGold.withValues(alpha: 0.42)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ManasikunaKaabaMark(size: 60),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('FAQ Matrix v2', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(
                  'أسئلة لا تظهر عشوائيًا؛ بل بحسب المرحلة والمكان ونوع الحج والجنس، مع إجابات معتدلة وإحالة المسائل الحساسة للجنة الشرعية.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.88), height: 1.5),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ManasikunaPill(label: '$total سؤال', icon: Icons.fact_check_rounded),
                    const ManasikunaPill(label: 'زمان ومكان', icon: Icons.place_rounded),
                    const ManasikunaPill(label: 'إجابات وسطية', icon: Icons.balance_rounded),
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

class _PhaseFilter extends StatelessWidget {
  const _PhaseFilter({required this.selected, required this.onChanged});

  final HajjFaqPhase? selected;
  final ValueChanged<HajjFaqPhase?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ManasikunaSectionTitle(title: 'المرحلة الزمانية/المكانية', subtitle: 'اختر أين ومتى يظهر السؤال', icon: Icons.timeline_rounded),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(selected: selected == null, label: const Text('الكل'), onSelected: (_) => onChanged(null)),
                for (final phase in HajjFaqPhase.values)
                  ChoiceChip(selected: selected == phase, label: Text(_phaseLabel(phase)), onSelected: (_) => onChanged(phase)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScopeFilter extends StatelessWidget {
  const _ScopeFilter({
    required this.selectedType,
    required this.selectedGender,
    required this.onTypeChanged,
    required this.onGenderChanged,
  });

  final HajjType? selectedType;
  final HajjGenderScope? selectedGender;
  final ValueChanged<HajjType?> onTypeChanged;
  final ValueChanged<HajjGenderScope?> onGenderChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ManasikunaSectionTitle(title: 'تخصيص السؤال', subtitle: 'حسب نوع الحج والجنس عند الحاجة', icon: Icons.tune_rounded),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(selected: selectedType == null, label: const Text('كل الأنواع'), onSelected: (_) => onTypeChanged(null)),
                ChoiceChip(selected: selectedType == HajjType.tamattu, label: const Text('تمتع'), onSelected: (_) => onTypeChanged(HajjType.tamattu)),
                ChoiceChip(selected: selectedType == HajjType.qiran, label: const Text('قران'), onSelected: (_) => onTypeChanged(HajjType.qiran)),
                ChoiceChip(selected: selectedType == HajjType.ifrad, label: const Text('إفراد'), onSelected: (_) => onTypeChanged(HajjType.ifrad)),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(selected: selectedGender == null, label: const Text('الجميع'), onSelected: (_) => onGenderChanged(null)),
                ChoiceChip(selected: selectedGender == HajjGenderScope.male, label: const Text('ذكر'), onSelected: (_) => onGenderChanged(HajjGenderScope.male)),
                ChoiceChip(selected: selectedGender == HajjGenderScope.female, label: const Text('أنثى'), onSelected: (_) => onGenderChanged(HajjGenderScope.female)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({required this.item});

  final HajjFaqItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = _priorityColor(scheme, item.priority);
    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.24)),
            ),
            child: Icon(_categoryIcon(item.category), color: color),
          ),
          title: Text(item.question, style: const TextStyle(fontWeight: FontWeight.w900)),
          subtitle: Text('${item.timeWindow} • ${item.placeContext}', maxLines: 2, overflow: TextOverflow.ellipsis),
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(item.answer, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55)),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: [
                _FaqTag(label: _categoryLabel(item.category), icon: _categoryIcon(item.category), color: scheme.primary),
                _FaqTag(label: _priorityLabel(item.priority), icon: Icons.priority_high_rounded, color: color),
                _FaqTag(label: item.appActionLabel, icon: Icons.touch_app_rounded, color: scheme.tertiary),
                if (item.genderScope != HajjGenderScope.all) _FaqTag(label: _genderLabel(item.genderScope), icon: Icons.person_rounded, color: scheme.primary),
                if (item.needsScholarApproval) _FaqTag(label: 'اعتماد شرعي', icon: Icons.verified_rounded, color: MunasaknaTheme.kiswahGold),
                if (item.answerStyle == HajjFaqAnswerStyle.referToScholar) _FaqTag(label: 'إحالة للجنة', icon: Icons.gavel_rounded, color: scheme.error),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqTag extends StatelessWidget {
  const _FaqTag({required this.label, required this.icon, required this.color});

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

String _phaseLabel(HajjFaqPhase phase) {
  switch (phase) {
    case HajjFaqPhase.beforeTravel:
      return 'قبل السفر';
    case HajjFaqPhase.beforeMiqat:
      return 'قبل الميقات';
    case HajjFaqPhase.ihram:
      return 'الإحرام';
    case HajjFaqPhase.makkah:
      return 'مكة';
    case HajjFaqPhase.minaTarwiyah:
      return 'منى/التروية';
    case HajjFaqPhase.arafah:
      return 'عرفة';
    case HajjFaqPhase.muzdalifah:
      return 'مزدلفة';
    case HajjFaqPhase.nahr:
      return 'يوم النحر';
    case HajjFaqPhase.tashreeq:
      return 'التشريق';
    case HajjFaqPhase.farewell:
      return 'الوداع';
    case HajjFaqPhase.afterReturn:
      return 'بعد العودة';
    case HajjFaqPhase.urgent:
      return 'عاجل';
  }
}

String _categoryLabel(HajjFaqCategory category) {
  switch (category) {
    case HajjFaqCategory.sharia:
      return 'شرعي';
    case HajjFaqCategory.administrative:
      return 'إداري';
    case HajjFaqCategory.health:
      return 'صحي';
    case HajjFaqCategory.field:
      return 'ميداني';
    case HajjFaqCategory.education:
      return 'تعليمي';
    case HajjFaqCategory.technical:
      return 'تطبيقي';
  }
}

IconData _categoryIcon(HajjFaqCategory category) {
  switch (category) {
    case HajjFaqCategory.sharia:
      return Icons.gavel_rounded;
    case HajjFaqCategory.administrative:
      return Icons.assignment_rounded;
    case HajjFaqCategory.health:
      return Icons.health_and_safety_rounded;
    case HajjFaqCategory.field:
      return Icons.place_rounded;
    case HajjFaqCategory.education:
      return Icons.menu_book_rounded;
    case HajjFaqCategory.technical:
      return Icons.touch_app_rounded;
  }
}

String _priorityLabel(HajjFaqPriority priority) {
  switch (priority) {
    case HajjFaqPriority.normal:
      return 'عادي';
    case HajjFaqPriority.important:
      return 'مهم';
    case HajjFaqPriority.critical:
      return 'حرج';
  }
}

Color _priorityColor(ColorScheme scheme, HajjFaqPriority priority) {
  switch (priority) {
    case HajjFaqPriority.normal:
      return scheme.primary;
    case HajjFaqPriority.important:
      return MunasaknaTheme.kiswahGold;
    case HajjFaqPriority.critical:
      return scheme.error;
  }
}

String _genderLabel(HajjGenderScope scope) {
  switch (scope) {
    case HajjGenderScope.all:
      return 'الجميع';
    case HajjGenderScope.male:
      return 'ذكر';
    case HajjGenderScope.female:
      return 'أنثى';
  }
}
