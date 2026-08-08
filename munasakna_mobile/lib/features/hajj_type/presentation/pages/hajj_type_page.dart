import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class HajjTypePage extends StatelessWidget {
  const HajjTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'نوع الحج والنية',
      headerIcon: Icons.fact_check_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const InfoSectionCard(
            title: 'اختيار النسك يغيّر رحلتك',
            subtitle: 'هذه شاشة إرشادية محلية. لاحقًا سيُحفظ اختيار الحاج في نسك ويخصص له الجدول تلقائيًا.',
            icon: Icons.alt_route_outlined,
            trailing: MunasaknaStatusChip(label: 'v6', icon: Icons.verified_outlined),
            children: [
              Text('اختر نوع الحج مع المرشد أو وفق برنامج الشركة. النية محلها القلب، والصيغ هنا تعليمية فقط وليست فتوى نهائية.'),
            ],
          ),
          const SizedBox(height: 12),
          for (final type in _hajjTypes) ...[
            _HajjTypeCard(type: type),
            const SizedBox(height: 12),
          ],
          InfoSectionCard(
            title: 'ماذا يفعل التطبيق بعد الاختيار؟',
            icon: Icons.tune_outlined,
            children: [
              const _ActionLine('التمتع: تظهر عمرة التمتع، التحلل، إحرام الحج، والهدي.'),
              const _ActionLine('القران: يظهر إحرام واحد للحج والعمرة، ولا تظهر مرحلة التحلل من العمرة.'),
              const _ActionLine('الإفراد: تظهر أعمال الحج فقط، ولا يظهر هدي التمتع/القران كمرحلة مطلوبة.'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: () => context.push(MunasaknaRoutes.miqat),
                    icon: const Icon(Icons.flag_outlined),
                    label: const Text('المواقيت'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.push(MunasaknaRoutes.hajjFaq),
                    icon: const Icon(Icons.quiz_outlined),
                    label: const Text('أسئلة النوع'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HajjTypeCard extends StatelessWidget {
  const _HajjTypeCard({required this.type});

  final _HajjTypeData type;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = type.requiresHady ? MunasaknaTheme.kiswahGold : scheme.primary;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: color.withValues(alpha: 0.30)),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.055), blurRadius: 14, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(type.icon, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(type.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(type.description, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.45)),
                  ],
                ),
              ),
              if (type.requiresHady) const MunasaknaStatusChip(label: 'هدي', icon: Icons.workspace_premium_outlined),
            ],
          ),
          const SizedBox(height: 12),
          _IntentionBox(label: type.intention),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MiniFact(label: type.hasUmrah ? 'توجد عمرة' : 'لا توجد عمرة تمتع'),
              _MiniFact(label: type.hasTahallul ? 'تحلل قبل الحج' : 'لا تحلل قبل الحج'),
              _MiniFact(label: type.requiresHady ? 'عليه هدي' : 'لا هدي تمتع/قران'),
            ],
          ),
        ],
      ),
    );
  }
}

class _IntentionBox extends StatelessWidget {
  const _IntentionBox({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MunasaknaTheme.deepHaramGreen.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MunasaknaTheme.deepHaramGreen.withValues(alpha: 0.16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.record_voice_over_outlined, color: MunasaknaTheme.deepHaramGreen, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800, height: 1.5))),
        ],
      ),
    );
  }
}

class _MiniFact extends StatelessWidget {
  const _MiniFact({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      avatar: const Icon(Icons.check_circle_outline, size: 18),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _ActionLine extends StatelessWidget {
  const _ActionLine(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.arrow_circle_left_outlined, size: 19, color: MunasaknaTheme.deepHaramGreen),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _HajjTypeData {
  const _HajjTypeData({
    required this.title,
    required this.description,
    required this.intention,
    required this.icon,
    required this.hasUmrah,
    required this.hasTahallul,
    required this.requiresHady,
  });

  final String title;
  final String description;
  final String intention;
  final IconData icon;
  final bool hasUmrah;
  final bool hasTahallul;
  final bool requiresHady;
}

const _hajjTypes = [
  _HajjTypeData(
    title: 'حج التمتع',
    description: 'عمرة في أشهر الحج، ثم تحلل، ثم إحرام جديد للحج يوم التروية أو حسب البرنامج.',
    intention: 'عند الميقات: لبيك اللهم عمرة. ثم لاحقًا عند الحج: لبيك اللهم حجًا.',
    icon: Icons.restart_alt_rounded,
    hasUmrah: true,
    hasTahallul: true,
    requiresHady: true,
  ),
  _HajjTypeData(
    title: 'حج القران',
    description: 'حج وعمرة بإحرام واحد، ويبقى الحاج على إحرامه حتى يوم النحر.',
    intention: 'عند الميقات: لبيك اللهم عمرة وحجًا.',
    icon: Icons.link_rounded,
    hasUmrah: true,
    hasTahallul: false,
    requiresHady: true,
  ),
  _HajjTypeData(
    title: 'حج الإفراد',
    description: 'إحرام بالحج فقط دون عمرة تمتع، وتظهر له أعمال الحج الأساسية.',
    intention: 'عند الميقات: لبيك اللهم حجًا.',
    icon: Icons.looks_one_rounded,
    hasUmrah: false,
    hasTahallul: false,
    requiresHady: false,
  ),
];
