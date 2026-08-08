import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class HajjSchedulePage extends StatelessWidget {
  const HajjSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'تقويم الحج',
      headerIcon: Icons.event_note_outlined,
      bottomNavIndex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const InfoSectionCard(
            title: 'تقويم زمني لا يخلط بين النسك والإجراء',
            subtitle: 'يرتب التطبيق أعمال الحاج قبل السفر وأثناء الحج وبعد العودة حسب المواقيت الشرعية ومراحل التفويج.',
            icon: Icons.calendar_month_outlined,
            trailing: MunasaknaStatusChip(label: 'زمني', icon: Icons.schedule_outlined),
            children: [
              Text('هذه النسخة محلية للتطوير. عند الربط مع نسك تُستبدل التواريخ العامة بمواعيد السفر، التفويج، السكن، والنقل الخاصة بالحاج.'),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in _scheduleItems) ...[
            _ScheduleCard(item: item),
            const SizedBox(height: 12),
          ],
          InfoSectionCard(
            title: 'ماذا يتغير عند الربط مع نسك؟',
            icon: Icons.cloud_sync_outlined,
            children: [
              _Bullet('تتحول المراحل العامة إلى مواعيد فعلية حسب شركة الحاج ومجموعته.'),
              _Bullet('تظهر تنبيهات قبل التفويج والحافلة والمخيم وطواف الإفاضة والوداع.'),
              _Bullet('تبقى الأحكام الشرعية من المصفوفة، بينما تأتي المواعيد الإدارية من نسك.'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: null,
                    icon: Icon(Icons.lock_clock_outlined),
                    label: Text('ربط نسك لاحقًا'),
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

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({required this.item});
  final _ScheduleItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = item.critical ? scheme.error : item.color;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: color.withValues(alpha: 0.22)),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.055), blurRadius: 16, offset: const Offset(0, 9))],
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
                child: Icon(item.icon, color: color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 3),
                    Text(item.timeLabel, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              MunasaknaStatusChip(label: item.layer, icon: Icons.layers_outlined, color: color),
            ],
          ),
          const SizedBox(height: 12),
          Text(item.summary, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55)),
          const SizedBox(height: 12),
          for (final action in item.actions) _Bullet(action, color: color),
          if (item.warning != null) ...[
            const SizedBox(height: 10),
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
                  Icon(Icons.warning_amber_rounded, color: scheme.error, size: 19),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item.warning!, style: const TextStyle(fontWeight: FontWeight.w800))),
                ],
              ),
            ),
          ],
          if (item.route != null) ...[
            const SizedBox(height: 12),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: OutlinedButton.icon(
                onPressed: () => context.push(item.route!),
                icon: const Icon(Icons.open_in_new_outlined),
                label: const Text('افتح المرحلة'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text, {this.color});
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final base = color ?? Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: base, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _ScheduleItem {
  const _ScheduleItem({required this.title, required this.timeLabel, required this.layer, required this.summary, required this.actions, required this.icon, required this.color, this.warning, this.critical = false, this.route});
  final String title;
  final String timeLabel;
  final String layer;
  final String summary;
  final List<String> actions;
  final IconData icon;
  final Color color;
  final String? warning;
  final bool critical;
  final String? route;
}

const _scheduleItems = [
  _ScheduleItem(title: 'الاستعداد قبل السفر', timeLabel: 'قبل الحج بأيام أو أسابيع', layer: 'إداري/صحي', summary: 'مرحلة تجهيز الجواز والوثائق والتطعيمات والأدوية ومعرفة البرنامج ونقطة التجمع.', actions: ['راجع محفظة الوثائق.', 'تأكد من أرقام المشرف والطوارئ.', 'افتح قائمة الجاهزية قبل المغادرة.'], icon: Icons.flight_takeoff_outlined, color: MunasaknaTheme.zamzamBlue, route: MunasaknaRoutes.documentsWallet),
  _ScheduleItem(title: 'الميقات والإحرام', timeLabel: 'عند الميقات أو محاذاته', layer: 'شرعي', summary: 'يدخل الحاج في النسك حسب نوع الحج، ويبدأ التلبية ويلتزم بمحظورات الإحرام.', actions: ['حدد نوع الحج والنية التعليمية.', 'راجع محظورات الإحرام.', 'لا تتجاوز الميقات لمن أراد النسك إلا بإحرام.'], icon: Icons.flag_outlined, color: MunasaknaTheme.haramGreen, warning: 'المسائل التفصيلية تُحال إلى اللجنة الشرعية أو المرشد المعتمد.', critical: true, route: MunasaknaRoutes.miqat),
  _ScheduleItem(title: 'منى وعرفة ومزدلفة', timeLabel: '8 و9 وليلة 10 ذو الحجة', layer: 'شرعي/ميداني', summary: 'أيام الانتقال الكبرى: منى للتروية، عرفة للركن الأعظم، ومزدلفة للاستعداد ليوم النحر.', actions: ['التزم بالمجموعة والتفويج.', 'اشرب الماء وتجنب الانفراد.', 'استخدم رفيق اليوم لمعرفة ماذا تفعل الآن.'], icon: Icons.route_outlined, color: MunasaknaTheme.roseAlert, warning: 'الوقوف بعرفة ركن الحج الأعظم.', critical: true, route: MunasaknaRoutes.dailyCompanion),
  _ScheduleItem(title: 'يوم النحر وأيام التشريق', timeLabel: '10 إلى 13 ذو الحجة', layer: 'شرعي/سلامة', summary: 'الرمي والهدي والحلق أو التقصير وطواف الإفاضة ثم رمي أيام التشريق والتعجل أو التأخر.', actions: ['اتبع وقت التفويج للجمرات.', 'لا تزاحم ولا تذهب منفردًا.', 'افتح الدليل المكاني عند الحاجة.'], icon: Icons.celebration_outlined, color: MunasaknaTheme.kiswahGold, route: MunasaknaRoutes.fieldGuide),
  _ScheduleItem(title: 'الوداع والعودة', timeLabel: 'قبل مغادرة مكة وبعد العودة', layer: 'شرعي/إداري', summary: 'يؤدي الحاج طواف الوداع قبل مغادرة مكة، ثم يكمل التقييم والشكاوى والملاحظات بعد العودة.', actions: ['نسق طواف الوداع مع حملتك.', 'أكمل الاستبيان بعد العودة.', 'احتفظ بسجل الرحلة والتعليمات.'], icon: Icons.home_work_outlined, color: MunasaknaTheme.deepHaramGreen, route: MunasaknaRoutes.postHajj),
];
