import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';


class PhaseNavigatorPage extends StatelessWidget {
  const PhaseNavigatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'مركز المراحل',
      headerIcon: Icons.hub_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const InfoSectionCard(
            title: 'كل مرحلة لها سؤالها وتنبيهها وخدمتها',
            subtitle: 'المركز يربط الزمان والمكان ونوع الحج بالإجراء المناسب داخل التطبيق.',
            icon: Icons.hub_outlined,
            trailing: MunasaknaStatusChip(label: 'زمني/مكاني', icon: Icons.schedule_outlined),
            children: [
              Text('هذه الصفحة تمهد لتحويل مصفوفة الحج إلى تجربة يومية: ماذا أفعل الآن؟ ماذا أسأل؟ أين أذهب؟ ومتى أطلب مساعدة؟'),
            ],
          ),
          const SizedBox(height: 12),
          for (final phase in _phases) ...[
            _PhaseActionCard(phase: phase),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _PhaseActionCard extends StatelessWidget {
  const _PhaseActionCard({required this.phase});
  final _PhaseAction phase;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: phase.color.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Container(width: 48, height: 48, decoration: BoxDecoration(color: phase.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(18)), child: Icon(phase.icon, color: phase.color)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(phase.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(phase.window, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
            ])),
            MunasaknaStatusChip(label: phase.priority, icon: Icons.priority_high_outlined, color: phase.color),
          ]),
          const SizedBox(height: 10),
          Text(phase.description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55)),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            FilledButton.icon(onPressed: () => context.push(phase.primaryRoute), icon: Icon(phase.primaryIcon), label: Text(phase.primaryAction)),
            OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.hajjFaq), icon: const Icon(Icons.quiz_outlined), label: const Text('أسئلة المرحلة')),
            OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.hajjAssistant), icon: const Icon(Icons.smart_toy_outlined), label: const Text('اسأل المساعد')),
          ]),
        ],
      ),
    );
  }
}

class _PhaseAction {
  const _PhaseAction({required this.title, required this.window, required this.priority, required this.description, required this.primaryAction, required this.primaryRoute, required this.primaryIcon, required this.icon, required this.color});
  final String title;
  final String window;
  final String priority;
  final String description;
  final String primaryAction;
  final String primaryRoute;
  final IconData primaryIcon;
  final IconData icon;
  final Color color;
}

const _phases = [
  _PhaseAction(title: 'قبل السفر', window: 'الوطن / المديرية / الشركة', priority: 'مهم', description: 'أغلق الوثائق والتطعيمات والأدوية وفهم نوع الحج قبل الانتقال إلى الميقات.', primaryAction: 'قائمة الجاهزية', primaryRoute: MunasaknaRoutes.checklist, primaryIcon: Icons.checklist_rtl_outlined, icon: Icons.flight_takeoff_outlined, color: MunasaknaTheme.haramGreen),
  _PhaseAction(title: 'الميقات والإحرام', window: 'قبل الميقات / عنده / بعده', priority: 'حساس', description: 'حدد نوع النسك، راجع النية التعليمية، ثم التزم بمحظورات الإحرام بعد الدخول في النسك.', primaryAction: 'المواقيت', primaryRoute: MunasaknaRoutes.miqat, primaryIcon: Icons.flag_outlined, icon: Icons.flag_circle_outlined, color: MunasaknaTheme.kiswahGold),
  _PhaseAction(title: 'مكة والطواف والسعي', window: 'الوصول إلى مكة', priority: 'مهم', description: 'اتبع التفويج، تجنب الزحام، وراجع دليل المناسك والأسئلة المتعلقة بالطواف والسعي.', primaryAction: 'دليل المناسك', primaryRoute: MunasaknaRoutes.rituals, primaryIcon: Icons.explore_outlined, icon: Icons.mosque_outlined, color: MunasaknaTheme.deepHaramGreen),
  _PhaseAction(title: 'عرفة ومزدلفة', window: '9 ذو الحجة وليلة 10', priority: 'حرج', description: 'يوم عرفة ركن الحج الأعظم، وبعده مرحلة مزدلفة؛ التطبيق يرفع التنبيهات ويقرب أدوات المساعدة.', primaryAction: 'رفيق اليوم', primaryRoute: MunasaknaRoutes.dailyCompanion, primaryIcon: Icons.today_outlined, icon: Icons.landscape_outlined, color: MunasaknaTheme.roseAlert),
  _PhaseAction(title: 'منى والجمرات', window: '10-13 ذو الحجة', priority: 'ميداني', description: 'الالتزام بالتفويج والسلامة أهم من السرعة. استخدم الدليل المكاني والطوارئ عند الحاجة.', primaryAction: 'الدليل المكاني', primaryRoute: MunasaknaRoutes.fieldGuide, primaryIcon: Icons.map_outlined, icon: Icons.route_outlined, color: MunasaknaTheme.zamzamBlue),
  _PhaseAction(title: 'العودة والتقييم', window: 'بعد طواف الوداع والعودة', priority: 'إداري', description: 'أغلق الرحلة بالاستبيان والملاحظات والمتابعة الصحية، ليتم تحسين الخدمات لاحقًا عبر نسك.', primaryAction: 'ما بعد الحج', primaryRoute: MunasaknaRoutes.postHajj, primaryIcon: Icons.volunteer_activism_outlined, icon: Icons.home_outlined, color: MunasaknaTheme.haramGreen),
];
