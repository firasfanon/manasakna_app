import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class MiqatPage extends StatelessWidget {
  const MiqatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'المواقيت الشرعية',
      headerIcon: Icons.flag_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const InfoSectionCard(
            title: 'الميقات بداية الدخول في النسك',
            subtitle: 'يربط هذا القسم بين الزمان والمكان والنية ومحظورات الإحرام.',
            icon: Icons.flag_outlined,
            trailing: MunasaknaStatusChip(label: 'شرعي', icon: Icons.verified_outlined),
            children: [
              Text('لا يتجاوز من أراد الحج أو العمرة الميقات باتجاه مكة إلا وهو محرم. الصياغات هنا إرشادية وتحتاج اعتماد اللجنة الشرعية قبل النشر الرسمي.'),
            ],
          ),
          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'المواقيت الزمانية',
            icon: Icons.calendar_month_outlined,
            children: [
              for (final item in _timeMiqat) _MiqatLine(title: item.$1, value: item.$2),
            ],
          ),
          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'المواقيت المكانية',
            icon: Icons.map_outlined,
            children: [
              for (final item in _placeMiqat) _MiqatLine(title: item.$1, value: item.$2),
            ],
          ),
          const SizedBox(height: 12),
          const _MiqatStagePanel(),
          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'إجراءات مرتبطة',
            icon: Icons.touch_app_outlined,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: () => context.push(MunasaknaRoutes.hajjType),
                    icon: const Icon(Icons.fact_check_outlined),
                    label: const Text('نوع الحج والنية'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.push(MunasaknaRoutes.rituals),
                    icon: const Icon(Icons.menu_book_outlined),
                    label: const Text('محظورات الإحرام'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.push(MunasaknaRoutes.hajjAssistant),
                    icon: const Icon(Icons.record_voice_over_outlined),
                    label: const Text('اسأل المساعد'),
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

class _MiqatLine extends StatelessWidget {
  const _MiqatLine({required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.055),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.place_outlined, color: MunasaknaTheme.deepHaramGreen, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text(value, style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45, color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiqatStagePanel extends StatelessWidget {
  const _MiqatStagePanel();

  @override
  Widget build(BuildContext context) {
    return InfoSectionCard(
      title: 'قبل الميقات، عنده، وبعده',
      icon: Icons.timeline_outlined,
      children: [
        for (final stage in _miqatStages) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: stage.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(stage.icon, color: stage.color, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stage.title, style: const TextStyle(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 3),
                    Text(stage.message, style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45)),
                  ],
                ),
              ),
            ],
          ),
          if (stage != _miqatStages.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _MiqatStage {
  const _MiqatStage(this.title, this.message, this.icon, this.color);
  final String title;
  final String message;
  final IconData icon;
  final Color color;
}

const _miqatStages = [
  _MiqatStage('قبل الميقات', 'استعد بالإحرام، راجع نوع النسك، واقرأ محظورات الإحرام قبل بدء النية.', Icons.pending_actions_outlined, MunasaknaTheme.kiswahGold),
  _MiqatStage('عند الميقات أو محاذاته', 'انْوِ الدخول في النسك وابدأ التلبية وفق نوع الحج المعتمد.', Icons.flag_circle_outlined, MunasaknaTheme.deepHaramGreen),
  _MiqatStage('بعد الميقات', 'أنت الآن محرم؛ أكثر من التلبية، وتجنب المحظورات، واسأل عند الحالات الخاصة.', Icons.verified_outlined, MunasaknaTheme.haramGreen),
];

const _timeMiqat = [
  ('أشهر الحج', 'شوال، ذو القعدة، وذو الحجة بحسب التفصيل الفقهي المعتمد.'),
  ('8 ذو الحجة', 'يوم التروية: التوجه إلى منى والإحرام بالحج للمتمتع.'),
  ('9 ذو الحجة', 'يوم عرفة: الوقوف بعرفة، وهو ركن الحج الأعظم.'),
  ('10 ذو الحجة', 'يوم النحر: الرمي، الهدي لمن عليه، الحلق أو التقصير، وطواف الإفاضة.'),
  ('11-13 ذو الحجة', 'أيام التشريق: المبيت بمنى ورمي الجمرات حسب التعجل أو التأخر.'),
];

const _placeMiqat = [
  ('ذو الحليفة / أبيار علي', 'لأهل المدينة ومن مر بطريقهم.'),
  ('الجحفة / رابغ', 'لأهل الشام ومصر والمغرب ومن مر بطريقهم.'),
  ('قرن المنازل / السيل الكبير', 'لأهل نجد ومن مر بطريقهم.'),
  ('يلملم', 'لأهل اليمن ومن مر بطريقهم.'),
  ('ذات عرق', 'لأهل العراق ومن مر بطريقهم.'),
  ('من كان داخل المواقيت', 'يحرم من مكانه، وأهل مكة يحرمون للحج من مكة وللعمرة من الحل.'),
];
