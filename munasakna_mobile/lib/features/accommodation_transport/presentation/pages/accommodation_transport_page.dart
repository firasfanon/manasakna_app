import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class AccommodationTransportPage extends StatelessWidget {
  const AccommodationTransportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'السكن والنقل',
      headerIcon: Icons.hotel_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const InfoSectionCard(
            title: 'سكن ونقل ضمن برنامج الحاج',
            subtitle: 'تجربة محلية لعرض الفندق، المخيم، الحافلة، التفويج، ونقاط الانتقال قبل الربط مع نسك.',
            icon: Icons.hotel_outlined,
            trailing: MunasaknaStatusChip(label: 'تشغيلي', icon: Icons.directions_bus_outlined),
            children: [
              Text('لا تظهر بيانات حقيقية في وضع التطوير. لاحقًا ستأتي من برنامج الحاج وشركته ومجموعته داخل نسك.'),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in _logistics) ...[
            _LogisticsCard(item: item),
            const SizedBox(height: 12),
          ],
          InfoSectionCard(
            title: 'عند حدوث مشكلة',
            icon: Icons.report_problem_outlined,
            children: [
              const Text('إذا تعذّر الوصول للسكن أو الحافلة، لا تتحرك منفردًا. استخدم موقعي الحالي واتصل بالمشرف أو افتح شكوى مرتبطة بالمرحلة.'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(onPressed: () => context.push(MunasaknaRoutes.currentLocation), icon: const Icon(Icons.my_location_outlined), label: const Text('موقعي الحالي')),
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.groupSupervisor), icon: const Icon(Icons.groups_2_outlined), label: const Text('مجموعتي')),
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.complaints), icon: const Icon(Icons.forum_outlined), label: const Text('فتح شكوى')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LogisticsCard extends StatelessWidget {
  const _LogisticsCard({required this.item});
  final _LogisticsItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: item.color.withValues(alpha: 0.22)),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.05), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Container(width: 52, height: 52, decoration: BoxDecoration(color: item.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(18)), child: Icon(item.icon, color: item.color)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(item.phase, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w700)),
          ])),
          MunasaknaStatusChip(label: item.status, icon: Icons.info_outline, color: item.color),
        ]),
        const SizedBox(height: 12),
        Text(item.summary, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55)),
        const SizedBox(height: 12),
        for (final tip in item.tips)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.check_circle_outline, color: item.color, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(tip)),
            ]),
          ),
      ]),
    );
  }
}

class _LogisticsItem {
  const _LogisticsItem({required this.title, required this.phase, required this.status, required this.summary, required this.tips, required this.icon, required this.color});
  final String title;
  final String phase;
  final String status;
  final String summary;
  final List<String> tips;
  final IconData icon;
  final Color color;
}

const _logistics = [
  _LogisticsItem(title: 'السكن في مكة', phase: 'قبل المناسك وأثناء الطواف', status: 'لاحقًا', summary: 'يعرض اسم الفندق أو السكن، العنوان، رقم الغرفة، وتعليمات الوصول بعد الربط مع نسك.', tips: ['احفظ اسم السكن ونقطة العودة.', 'لا تغادر دون معرفة نقطة التجمع.', 'استخدم الهواتف الضرورية عند الحاجة.'], icon: Icons.apartment_outlined, color: MunasaknaTheme.deepHaramGreen),
  _LogisticsItem(title: 'مخيم منى', phase: '8 و11 و12 و13 ذو الحجة', status: 'ميداني', summary: 'يعرض المخيم والبوابة ومسار العودة من الجمرات، مع إرشادات عدم الانفراد في الزحام.', tips: ['احفظ رقم المخيم والبوابة.', 'اتبع المرشد عند الذهاب للجمرات.', 'لا تعاكس اتجاه الحركة.'], icon: Icons.holiday_village_outlined, color: MunasaknaTheme.haramGreen),
  _LogisticsItem(title: 'الحافلات والتفويج', phase: 'بين مكة والمشاعر', status: 'تنظيمي', summary: 'يعرض رقم الحافلة، توقيت التحرك، ونقطة التجمع عند توفر بيانات البرنامج.', tips: ['كن في نقطة التجمع قبل الموعد.', 'لا تصعد حافلة غير مجموعتك.', 'أبلغ المشرف عند التأخر أو الضياع.'], icon: Icons.directions_bus_outlined, color: MunasaknaTheme.zamzamBlue),
  _LogisticsItem(title: 'الانتقال إلى عرفة ومزدلفة', phase: '9 وليلة 10', status: 'حساس', summary: 'مرحلة حرجة في التنظيم؛ يفضل أن يبرز التطبيق التعليمات الخاصة بحافلة المجموعة ونقطة النزول.', tips: ['التزم بالمجموعة طوال الوقت.', 'جهز الماء والأدوية.', 'لا تنشغل بالبحث عن الحصى وسط الزحام.'], icon: Icons.route_outlined, color: MunasaknaTheme.roseAlert),
];
