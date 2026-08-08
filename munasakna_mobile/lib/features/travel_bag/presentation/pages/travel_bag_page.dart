import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';


class TravelBagPage extends StatelessWidget {
  const TravelBagPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'حقيبتي للحج',
      headerIcon: Icons.luggage_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const InfoSectionCard(
            title: 'حقيبة خفيفة ومنظمة',
            subtitle: 'قائمة عملية غير طبية وغير إلزامية، تساعد الحاج على تقليل النسيان والازدحام.',
            icon: Icons.luggage_outlined,
            trailing: MunasaknaStatusChip(label: 'قبل السفر', icon: Icons.flight_takeoff_outlined),
            children: [
              Text('هذه الصفحة لا تستبدل تعليمات الشركة أو الجهات الصحية، لكنها تجمع أهم العناصر التي يتكرر احتياج الحاج لها.'),
            ],
          ),
          const SizedBox(height: 12),
          for (final section in _bagSections) ...[
            _BagSectionCard(section: section),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _BagSectionCard extends StatelessWidget {
  const _BagSectionCard({required this.section});
  final _BagSection section;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: scheme.surface, borderRadius: BorderRadius.circular(26), border: Border.all(color: section.color.withValues(alpha: 0.22))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: section.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(18)), child: Icon(section.icon, color: section.color)),
          const SizedBox(width: 10),
          Expanded(child: Text(section.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900))),
        ]),
        const SizedBox(height: 10),
        for (final item in section.items)
          Padding(padding: const EdgeInsets.only(bottom: 7), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.check_circle_outline, size: 18, color: section.color), const SizedBox(width: 8), Expanded(child: Text(item))])),
      ]),
    );
  }
}

class _BagSection {
  const _BagSection({required this.title, required this.items, required this.icon, required this.color});
  final String title;
  final List<String> items;
  final IconData icon;
  final Color color;
}

const _bagSections = [
  _BagSection(title: 'وثائق وهوية', items: ['جواز السفر والتصريح حسب تعليمات الجهة المنظمة.', 'نسخة ورقية/رقمية من بيانات السكن والمجموعة.', 'أرقام المشرف والطوارئ محفوظة خارج الهاتف أيضًا.'], icon: Icons.badge_outlined, color: MunasaknaTheme.deepHaramGreen),
  _BagSection(title: 'صحة وسلامة', items: ['أدوية شخصية كافية مع وصفها.', 'عبوة ماء صغيرة عند التنقل حسب التنظيم.', 'كمامة أو مستلزمات وقاية عند الحاجة وتعليمات الجهات الصحية.'], icon: Icons.health_and_safety_outlined, color: MunasaknaTheme.roseAlert),
  _BagSection(title: 'ميداني وتنقل', items: ['حقيبة خفيفة للمشاعر.', 'شاحن متنقل وكيبل مناسب.', 'مظلة أو غطاء واقٍ من الشمس حسب التعليمات.'], icon: Icons.directions_walk_outlined, color: MunasaknaTheme.kiswahGold),
  _BagSection(title: 'إرشاد وطمأنينة', items: ['قراءة دليل الإحرام قبل الميقات.', 'حفظ موقع السكن والمخيم ونقطة التجمع.', 'مراجعة الأسئلة الشائعة قبل كل مرحلة.'], icon: Icons.menu_book_outlined, color: MunasaknaTheme.zamzamBlue),
];
