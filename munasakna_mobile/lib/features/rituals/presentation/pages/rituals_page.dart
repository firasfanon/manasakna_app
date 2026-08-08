import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/manasikuna_visual_identity.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../settings/presentation/providers/settings_provider.dart';

class RitualsPage extends ConsumerWidget {
  const RitualsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsControllerProvider).value;
    final isUmrah = settings?.preferredRitualPath == 'umrah';
    final steps = isUmrah ? _umrahSteps : _hajjSteps;

    return MunasaknaAppScaffold(
      title: 'دليل المناسك',
      bottomNavIndex: 0,
      headerIcon: Icons.explore_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _RitualHero(isUmrah: isUmrah, stepsCount: steps.length),
          const SizedBox(height: 14),
          ManasikunaSectionTitle(
            title: isUmrah ? 'خطوات العمرة' : 'خطوات الحج',
            subtitle: 'عرض مختصر ومنظم يناسب الاستخدام أثناء الرحلة',
            icon: Icons.timeline_rounded,
          ),
          const SizedBox(height: 10),
          for (var index = 0; index < steps.length; index++)
            _RitualStepCard(number: index + 1, step: steps[index], isLast: index == steps.length - 1),
          const SizedBox(height: 12),
          const InfoSectionCard(
            title: 'تنبيه شرعي',
            icon: Icons.info_outline,
            children: [
              Text('المحتوى هنا للتذكير والتنظيم. عند الشك في حكم شرعي أو حالة خاصة استخدم صفحة اللجنة الشرعية أو اسأل مرشد الحملة.'),
            ],
          ),
        ],
      ),
    );
  }
}

class _RitualHero extends StatelessWidget {
  const _RitualHero({required this.isUmrah, required this.stepsCount});

  final bool isUmrah;
  final int stepsCount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: MunasaknaTheme.sacredGradient(scheme),
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          const ManasikunaKaabaMark(size: 62),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isUmrah ? 'مسار العمرة' : 'مسار الحج',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                Text(
                  '$stepsCount مراحل أساسية بتوجيهات مختصرة وسهلة القراءة.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.88), height: 1.45),
                ),
              ],
            ),
          ),
          Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white.withValues(alpha: 0.80)),
        ],
      ),
    );
  }
}

class _RitualStepCard extends StatelessWidget {
  const _RitualStepCard({required this.number, required this.step, required this.isLast});

  final int number;
  final _RitualStep step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: scheme.primary,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: scheme.secondary.withValues(alpha: 0.72), width: 1.2),
                ),
                child: Center(
                  child: Text('$number', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 72,
                  decoration: BoxDecoration(
                    color: scheme.secondary.withValues(alpha: 0.34),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Card(
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  title: Text(step.title, style: const TextStyle(fontWeight: FontWeight.w900)),
                  subtitle: Text(step.summary),
                  children: [
                    for (final item in step.details)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check_circle_rounded, size: 18, color: scheme.primary),
                            const SizedBox(width: 8),
                            Expanded(child: Text(item)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RitualStep {
  const _RitualStep(this.title, this.summary, this.details);
  final String title;
  final String summary;
  final List<String> details;
}

const _hajjSteps = [
  _RitualStep('الإحرام', 'النية ولبس الإحرام من الميقات.', ['تأكد من الوثائق والحقيبة قبل المغادرة.', 'حافظ على بطاقة الحملة وأرقام المشرفين.', 'اسأل المرشد عن النية المناسبة لنوع حجك.']),
  _RitualStep('مكة والطواف', 'الطواف والسعي حسب توجيه المرشد.', ['التزم بمسار المجموعة.', 'تجنب الزحام قدر الإمكان.', 'احتفظ بماء ودواء أساسي عند الحاجة.']),
  _RitualStep('منى وعرفة', 'الاستعداد لأيام المشاعر.', ['راجع وقت التحرك من الحملة.', 'احفظ موقع الخيمة أو التقطه من خدمة الموقع.', 'اهتم بالترطيب والراحة.']),
  _RitualStep('مزدلفة ومنى', 'المبيت والرمي وفق الجدول.', ['اتبع تعليمات التفويج.', 'لا تتحرك منفردًا عند الزحام.', 'استخدم أرقام الطوارئ عند الحاجة.']),
  _RitualStep('الختام والعودة', 'طواف الوداع وترتيبات السفر.', ['راجع الحقيبة والوثائق.', 'أكمل الاستبيان والملاحظات.', 'احتفظ بسجل الأدوية والمواعيد.']),
];

const _umrahSteps = [
  _RitualStep('الإحرام', 'النية من الميقات أو حسب مسار السفر.', ['راجع محظورات الإحرام.', 'احتفظ برقم المجموعة.', 'استخدم قائمة الجاهزية قبل الانطلاق.']),
  _RitualStep('الطواف', 'سبعة أشواط حول الكعبة.', ['التزم بالهدوء والرفق.', 'اتبع تعليمات التنظيم.', 'توقف عند التعب أو الحاجة الطبية.']),
  _RitualStep('السعي', 'بين الصفا والمروة.', ['ابدأ من الصفا.', 'احرص على البقاء مع المجموعة.', 'اشرب الماء عند الحاجة.']),
  _RitualStep('الحلق أو التقصير', 'إتمام النسك.', ['تأكد من إتمام الخطوات.', 'اسأل المرشد عند وجود لبس.', 'احفظ وقت العودة أو التجمع.']),
];
