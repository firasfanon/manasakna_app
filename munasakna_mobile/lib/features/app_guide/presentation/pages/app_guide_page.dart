import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';


class AppGuidePage extends StatelessWidget {
  const AppGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'دليل التطبيق الشامل',
      headerIcon: Icons.menu_book_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const InfoSectionCard(
            title: 'مرجع استخدام مناسكنا',
            subtitle: 'دليل مبسط لكل مرحلة من مراحل التطبيق، مبني على مصفوفة الحج v6، ويعمل حاليًا محليًا بلا تسجيل دخول.',
            icon: Icons.auto_stories_outlined,
            trailing: MunasaknaStatusChip(label: 'مرجع أساسي', icon: Icons.verified_outlined),
            children: [
              Text('هذا الدليل يشرح كيف يستخدم الحاج التطبيق قبل السفر، وعند الميقات، وفي مكة والمشاعر، وبعد العودة. التحديثات التطويرية القادمة يجب أن تضيف أثرها إلى الدليل الشامل داخل مجلد docs.'),
            ],
          ),
          const SizedBox(height: 12),
          for (final phase in _guidePhases) ...[
            _GuidePhaseCard(phase: phase),
            const SizedBox(height: 12),
          ],
          InfoSectionCard(
            title: 'انتقال سريع بين الأدلة',
            icon: Icons.open_in_new_outlined,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(onPressed: () => context.push(MunasaknaRoutes.phaseNavigator), icon: const Icon(Icons.hub_outlined), label: const Text('مركز المراحل')),
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.hajjMatrix), icon: const Icon(Icons.account_tree_outlined), label: const Text('المصفوفة')),
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.hajjAssistant), icon: const Icon(Icons.smart_toy_outlined), label: const Text('المساعد')),
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.nusukReadiness), icon: const Icon(Icons.cloud_sync_outlined), label: const Text('جاهزية نسك')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GuidePhaseCard extends StatelessWidget {
  const _GuidePhaseCard({required this.phase});
  final _GuidePhase phase;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: phase.color.withValues(alpha: 0.22)),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(width: 50, height: 50, decoration: BoxDecoration(color: phase.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(18)), child: Icon(phase.icon, color: phase.color)),
              const SizedBox(width: 10),
              Expanded(child: Text(phase.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900))),
              MunasaknaStatusChip(label: phase.label, icon: Icons.layers_outlined, color: phase.color),
            ],
          ),
          const SizedBox(height: 10),
          Text(phase.description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55, color: scheme.onSurfaceVariant)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final item in phase.modules)
                Chip(
                  avatar: Icon(item.icon, size: 18),
                  label: Text(item.title),
                  side: BorderSide(color: phase.color.withValues(alpha: 0.25)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GuidePhase {
  const _GuidePhase({required this.title, required this.label, required this.description, required this.icon, required this.color, required this.modules});
  final String title;
  final String label;
  final String description;
  final IconData icon;
  final Color color;
  final List<_GuideModule> modules;
}

class _GuideModule {
  const _GuideModule(this.title, this.icon);
  final String title;
  final IconData icon;
}

const _guidePhases = [
  _GuidePhase(title: 'قبل السفر', label: 'تهيئة', description: 'يستخدم الحاج قائمة الجاهزية، محفظة الوثائق، نوع الحج والنية، والمكتبة دون إنترنت قبل الانتقال إلى الميقات.', icon: Icons.flight_takeoff_outlined, color: MunasaknaTheme.haramGreen, modules: [_GuideModule('قائمة الجاهزية', Icons.checklist_rtl_outlined), _GuideModule('محفظة الوثائق', Icons.folder_copy_outlined), _GuideModule('نوع الحج', Icons.fact_check_outlined), _GuideModule('المكتبة', Icons.offline_pin_outlined)]),
  _GuidePhase(title: 'الميقات والإحرام', label: 'بداية النسك', description: 'تظهر المواقيت الشرعية، النية التعليمية، محظورات الإحرام، والتنبيهات الصوتية الآمنة عند اقتراب مرحلة الإحرام.', icon: Icons.flag_outlined, color: MunasaknaTheme.kiswahGold, modules: [_GuideModule('المواقيت', Icons.flag_outlined), _GuideModule('محظورات الإحرام', Icons.warning_amber_outlined), _GuideModule('المساعد', Icons.record_voice_over_outlined)]),
  _GuidePhase(title: 'مكة والمشاعر', label: 'أثناء الحج', description: 'يستخدم الحاج رحلتي، رفيق اليوم، الدليل المكاني، الصحة والسلامة، ومركز الطوارئ أثناء أداء المناسك.', icon: Icons.mosque_outlined, color: MunasaknaTheme.deepHaramGreen, modules: [_GuideModule('رحلتي', Icons.route_outlined), _GuideModule('رفيق اليوم', Icons.today_outlined), _GuideModule('الدليل المكاني', Icons.map_outlined), _GuideModule('الطوارئ', Icons.emergency_outlined)]),
  _GuidePhase(title: 'بعد العودة', label: 'إغلاق الرحلة', description: 'تنتقل التجربة إلى الاستبيان والشكاوى والمتابعة الصحية وسجل الرحلة، تمهيدًا للتحسين داخل نسك لاحقًا.', icon: Icons.volunteer_activism_outlined, color: MunasaknaTheme.zamzamBlue, modules: [_GuideModule('استبيان', Icons.fact_check_outlined), _GuideModule('شكوى', Icons.forum_outlined), _GuideModule('ما بعد الحج', Icons.history_edu_outlined)]),
];
