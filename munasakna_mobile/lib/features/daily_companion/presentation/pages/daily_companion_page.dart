import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class DailyCompanionPage extends StatelessWidget {
  const DailyCompanionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'رفيق اليوم',
      headerIcon: Icons.today_outlined,
      bottomNavIndex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const InfoSectionCard(
            title: 'ماذا أفعل الآن؟',
            subtitle: 'خطة يومية تربط المناسك بالتنبيهات الصحية والميدانية. البيانات محلية إلى حين الربط مع نسك.',
            icon: Icons.today_outlined,
            trailing: MunasaknaStatusChip(label: 'يومي', icon: Icons.schedule_outlined),
            children: [
              Text('يعرض هذا الرفيق أعمال الحاج حسب اليوم والمكان، مع تحديد ما هو شرعي أو إداري أو صحي أو ميداني.'),
            ],
          ),
          const SizedBox(height: 12),
          for (final day in _dailyPlan) ...[
            _DailyCompanionCard(day: day),
            const SizedBox(height: 12),
          ],
          InfoSectionCard(
            title: 'مساعدة حسب المرحلة',
            icon: Icons.smart_toy_outlined,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: () => context.push(MunasaknaRoutes.hajjAssistant),
                    icon: const Icon(Icons.record_voice_over_outlined),
                    label: const Text('اسأل المساعد'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.push(MunasaknaRoutes.hajjFaq),
                    icon: const Icon(Icons.quiz_outlined),
                    label: const Text('أسئلة هذه المرحلة'),
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

class _DailyCompanionCard extends StatelessWidget {
  const _DailyCompanionCard({required this.day});
  final _DailyPlan day;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = day.critical ? scheme.error : scheme.primary;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: color.withValues(alpha: 0.20)),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.052), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(18)),
                child: Icon(day.icon, color: color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(day.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 3),
                    Text(day.place, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                  ],
                ),
              ),
              if (day.critical) const MunasaknaStatusChip(label: 'حرج', icon: Icons.priority_high_rounded, color: MunasaknaTheme.roseAlert),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Badge(text: day.layer),
              _Badge(text: day.importance),
              _Badge(text: day.timeWindow),
            ],
          ),
          const SizedBox(height: 12),
          for (final action in day.actions)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_outline, color: color, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(action)),
                ],
              ),
            ),
          if (day.warning != null) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scheme.error.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: scheme.error.withValues(alpha: 0.18)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded, color: scheme.error, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(day.warning!, style: const TextStyle(fontWeight: FontWeight.w700))),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: MunasaknaTheme.kiswahGold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w900)),
    );
  }
}

class _DailyPlan {
  const _DailyPlan({required this.title, required this.place, required this.timeWindow, required this.layer, required this.importance, required this.actions, required this.icon, this.warning, this.critical = false});
  final String title;
  final String place;
  final String timeWindow;
  final String layer;
  final String importance;
  final List<String> actions;
  final IconData icon;
  final String? warning;
  final bool critical;
}

const _dailyPlan = [
  _DailyPlan(title: 'قبل السفر', place: 'الوطن / الشركة / المديرية', timeWindow: 'قبل الحج', layer: 'إداري وصحي', importance: 'إجراء', icon: Icons.flight_takeoff_outlined, actions: ['تأكد من الجواز والوثائق والتطعيمات.', 'احمل الأدوية والمعلومات الصحية.', 'راجع نوع الحج والبرنامج ونقطة التجمع.']),
  _DailyPlan(title: 'الميقات والإحرام', place: 'الميقات أو محاذاته', timeWindow: 'قبل مكة', layer: 'شرعي', importance: 'ركن/واجب', icon: Icons.flag_outlined, critical: true, actions: ['حدد نوع النسك.', 'انوِ الدخول في النسك وابدأ التلبية.', 'التزم بمحظورات الإحرام بعد النية.'], warning: 'تجاوز الميقات بلا إحرام لمن أراد النسك مسألة تحتاج سؤال المرشد أو اللجنة.'),
  _DailyPlan(title: 'يوم عرفة', place: 'عرفة', timeWindow: '9 ذو الحجة', layer: 'شرعي وميداني', importance: 'ركن', icon: Icons.landscape_outlined, critical: true, actions: ['الزم موقع حملتك.', 'أكثر من الدعاء والذكر.', 'لا تنفرد عن المجموعة وحافظ على الماء.'], warning: 'الوقوف بعرفة ركن الحج الأعظم.'),
  _DailyPlan(title: 'يوم النحر', place: 'منى / مكة', timeWindow: '10 ذو الحجة', layer: 'شرعي وميداني', importance: 'واجب/ركن', icon: Icons.celebration_outlined, actions: ['رمي جمرة العقبة حسب التفويج.', 'الهدي لمن عليه هدي.', 'الحلق أو التقصير ثم طواف الإفاضة والسعي لمن عليه سعي.']),
  _DailyPlan(title: 'أيام التشريق', place: 'منى والجمرات', timeWindow: '11-13 ذو الحجة', layer: 'شرعي وسلامة', importance: 'واجب', icon: Icons.route_outlined, actions: ['رمي الجمرات الثلاث بالترتيب حسب التفويج.', 'اختر التعجل أو التأخر مع حملتك.', 'لا تذهب منفردًا في الزحام.']),
  _DailyPlan(title: 'طواف الوداع والعودة', place: 'مكة / الوطن', timeWindow: 'قبل المغادرة وبعدها', layer: 'شرعي وإداري', importance: 'واجب/إجراء', icon: Icons.home_work_outlined, actions: ['نسق طواف الوداع مع الحملة قبل المغادرة.', 'بعد العودة أكمل الاستبيان وسجل الملاحظات.', 'احتفظ بسجل الرحلة وتعليماتها.']),
];
