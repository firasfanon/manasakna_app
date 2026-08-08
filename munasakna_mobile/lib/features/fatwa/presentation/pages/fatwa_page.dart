import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class FatwaPage extends StatelessWidget {
  const FatwaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'اللجنة الشرعية',
      headerIcon: Icons.gavel_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const InfoSectionCard(
            title: 'منهجية اللجنة الشرعية',
            subtitle: 'المساعد لا يفتي. المسائل الحساسة تُحال إلى الجهة المختصة.',
            icon: Icons.gavel_outlined,
            trailing: MunasaknaStatusChip(label: 'حاكم شرعي', icon: Icons.verified_outlined, color: MunasaknaTheme.kiswahGold),
            children: [
              Text('تعرض هذه الصفحة أسئلة حساسة يجب أن تُراجع قبل النشر الرسمي. في النسخة الحالية تُستخدم كدليل توجيهي وليس كفتوى نهائية.'),
            ],
          ),
          const SizedBox(height: 12),
          for (final group in _fatwaGroups) ...[
            InfoSectionCard(
              title: group.title,
              subtitle: group.subtitle,
              icon: group.icon,
              children: [
                for (final question in group.questions)
                  _SensitiveQuestionTile(question: question),
              ],
            ),
            const SizedBox(height: 12),
          ],
          InfoSectionCard(
            title: 'اسأل بطريقة آمنة',
            icon: Icons.record_voice_over_outlined,
            children: [
              const Text('يمكنك سؤال المساعد عن المرحلة، وسيجيب من المصفوفة والأسئلة المعتمدة فقط، أو يوجهك للجنة الشرعية عند الحساسية.'),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => context.push(MunasaknaRoutes.hajjAssistant),
                icon: const Icon(Icons.smart_toy_outlined),
                label: const Text('فتح المساعد'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SensitiveQuestionTile extends StatelessWidget {
  const _SensitiveQuestionTile({required this.question});
  final _Question question;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: question.critical ? scheme.error.withValues(alpha: 0.07) : scheme.primary.withValues(alpha: 0.055),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: (question.critical ? scheme.error : scheme.primary).withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(question.critical ? Icons.priority_high_rounded : Icons.help_outline, color: question.critical ? scheme.error : scheme.primary),
              const SizedBox(width: 8),
              Expanded(child: Text(question.text, style: const TextStyle(fontWeight: FontWeight.w900))),
            ],
          ),
          const SizedBox(height: 8),
          Text(question.answer, style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            const MunasaknaStatusChip(label: 'يحتاج اعتماد', icon: Icons.verified_user_outlined),
            if (question.critical) const MunasaknaStatusChip(label: 'حساس', icon: Icons.warning_amber_rounded, color: MunasaknaTheme.roseAlert),
          ]),
        ],
      ),
    );
  }
}

class _Question {
  const _Question(this.text, this.answer, {this.critical = false});
  final String text;
  final String answer;
  final bool critical;
}

class _FatwaGroup {
  const _FatwaGroup({required this.title, required this.subtitle, required this.icon, required this.questions});
  final String title;
  final String subtitle;
  final IconData icon;
  final List<_Question> questions;
}

const _fatwaGroups = [
  _FatwaGroup(title: 'الإحرام والمحظورات', subtitle: 'أسئلة تتغير أحكامها حسب العمد والنسيان والعذر', icon: Icons.flag_outlined, questions: [
    _Question('ماذا أفعل إذا ارتكبت محظورًا من محظورات الإحرام؟', 'يختلف الحكم حسب الفعل والعمد والنسيان والعذر؛ راجع اللجنة الشرعية أو المرشد المعتمد.', critical: true),
    _Question('هل يجوز تجاوز الميقات بلا إحرام؟', 'هذه مسألة حساسة مرتبطة بالنية والقدرة والرجوع للميقات أو الجبران؛ يلزم سؤال الجهة الشرعية.', critical: true),
  ]),
  _FatwaGroup(title: 'الطواف والسعي', subtitle: 'الشك في الأشواط أو العذر أثناء الطواف', icon: Icons.change_circle_outlined, questions: [
    _Question('ماذا أفعل إذا شككت في عدد أشواط الطواف أو السعي؟', 'لا يجيب التطبيق بحكم نهائي في هذه الحالة. اسأل المرشد فورًا مع بيان حالتك ووقت الشك.', critical: true),
    _Question('هل يلزم دعاء محدد لكل شوط؟', 'لا يلزم دعاء خاص لكل شوط، ويدعو الحاج بما تيسر من الخير، مع بقاء الصياغة النهائية لاعتماد اللجنة.'),
  ]),
  _FatwaGroup(title: 'عرفة ومزدلفة والرمي', subtitle: 'أركان وواجبات ومواطن زحام', icon: Icons.landscape_outlined, questions: [
    _Question('هل يجوز مغادرة عرفة قبل الغروب؟', 'هذه مسألة حساسة زمنيًا وشرعيًا وتنظيميًا؛ اتبع تعليمات الحملة والفتوى المعتمدة.', critical: true),
    _Question('هل يجوز التوكيل في الرمي؟', 'التوكيل له ضوابط مرتبطة بالعجز أو المرض أو الخوف؛ لا يعتمد التطبيق حكمًا عامًا دون اللجنة الشرعية.', critical: true),
  ]),
  _FatwaGroup(title: 'أحكام النساء', subtitle: 'أسئلة تحتاج مرشدة أو لجنة شرعية عند الحالات الخاصة', icon: Icons.female_outlined, questions: [
    _Question('ماذا تفعل المرأة إذا جاءها عذرها قبل الطواف؟', 'هذه مسألة مهمة تتأثر بالوقت والبرنامج والحالة؛ تراجع المرشدة أو اللجنة الشرعية فورًا.', critical: true),
    _Question('هل للمرأة لباس إحرام خاص؟', 'ليس للمرأة لباس إحرام خاص كالرجل، بل تلبس لباسًا ساترًا محتشمًا غير متبرج، مع اعتماد الصياغة النهائية شرعيًا.'),
  ]),
];
