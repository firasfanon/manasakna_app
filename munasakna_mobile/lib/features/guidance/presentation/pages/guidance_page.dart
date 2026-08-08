import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/manasikuna_visual_identity.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class GuidancePage extends StatelessWidget {
  const GuidancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'مواعظ وأحكام',
      headerIcon: Icons.menu_book_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const InfoSectionCard(
            title: 'إرشاد معتدل للحاج',
            subtitle: 'محتوى توعوي مختصر مرتبط بالمرحلة، ولا يحل محل فتوى اللجنة الشرعية.',
            icon: Icons.menu_book_outlined,
            trailing: MunasaknaStatusChip(label: 'معتدل', icon: Icons.balance_outlined),
            children: [
              Text('يركز هذا الدليل على الطمأنينة، حسن الخلق، اتباع التعليمات، وتجنب التشدد أو التساهل في مواضع الأركان والواجبات.'),
            ],
          ),
          const SizedBox(height: 12),
          const ManasikunaSectionTitle(title: 'إرشادات حسب المرحلة', subtitle: 'تظهر لاحقًا ديناميكيًا حسب الزمان والمكان', icon: Icons.timeline_outlined),
          const SizedBox(height: 10),
          for (final item in _guidanceItems) ...[
            _GuidanceCard(item: item),
            const SizedBox(height: 10),
          ],
          InfoSectionCard(
            title: 'عند الشك',
            icon: Icons.help_outline,
            children: [
              const Text('إن تعلّق السؤال بترك ركن، ترك واجب، محظور إحرام، عذر صحي، أو حالة خاصة؛ فالأولى مراجعة اللجنة الشرعية أو المرشد المعتمد.'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(onPressed: () => context.push(MunasaknaRoutes.fatwa), icon: const Icon(Icons.gavel_outlined), label: const Text('اللجنة الشرعية')),
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.hajjAssistant), icon: const Icon(Icons.smart_toy_outlined), label: const Text('اسأل المساعد')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GuidanceCard extends StatelessWidget {
  const _GuidanceCard({required this.item});

  final _GuidanceItem item;

  @override
  Widget build(BuildContext context) {
    return InfoSectionCard(
      title: item.title,
      subtitle: item.phase,
      icon: item.icon,
      children: [
        Text(item.summary),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tag in item.tags) MunasaknaStatusChip(label: tag, icon: Icons.check_circle_outline),
          ],
        ),
      ],
    );
  }
}

class _GuidanceItem {
  const _GuidanceItem({required this.title, required this.phase, required this.summary, required this.icon, required this.tags});
  final String title;
  final String phase;
  final String summary;
  final IconData icon;
  final List<String> tags;
}

const _guidanceItems = [
  _GuidanceItem(title: 'قبل السفر', phase: 'استعداد وطمأنينة', summary: 'تعلم الأساسيات، راجع الوثائق، وخذ بالأسباب دون قلق. الحج رحلة إيمانية منظمة وليست اختبارًا للارتباك.', icon: Icons.flight_takeoff_outlined, tags: ['تعلم', 'تنظيم', 'نية صالحة']),
  _GuidanceItem(title: 'عند الإحرام', phase: 'الميقات والنية', summary: 'الإحرام نية دخول في النسك، ويبدأ بعدها الالتزام بالمحظورات والتلبية. الصيغ المعروضة للتعليم لا للحصر.', icon: Icons.flag_outlined, tags: ['نية', 'تلبية', 'محظورات']),
  _GuidanceItem(title: 'في عرفة', phase: 'ركن الحج الأعظم', summary: 'أكثر من الدعاء والذكر، والزم مجموعتك، ولا تجعل الانشغال بالتصوير أو القلق يطغى على روح اليوم.', icon: Icons.landscape_outlined, tags: ['دعاء', 'ذكر', 'سكينة']),
  _GuidanceItem(title: 'في الزحام', phase: 'سلامة ورفق', summary: 'الرفق بالحجاج من تمام العبادة. لا تزاحم، واتبع التفويج، وقدم السلامة عند التعب أو الخطر.', icon: Icons.groups_outlined, tags: ['رفق', 'سلامة', 'اتباع التعليمات']),
  _GuidanceItem(title: 'بعد العودة', phase: 'أثر الحج', summary: 'حافظ على أثر العبادة في الخلق والسلوك، وأكمل التقييم والملاحظات لتحسين خدمة الحجاج.', icon: Icons.home_outlined, tags: ['استمرار', 'تقييم', 'شكر']),
];
