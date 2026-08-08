import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class FieldGuidePage extends StatelessWidget {
  const FieldGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'الدليل المكاني',
      headerIcon: Icons.map_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const InfoSectionCard(
            title: 'خريطة إرشادية دون تتبع دائم',
            subtitle: 'لا نشارك موقع الحاج إلا بإذن واضح. هذه الصفحة تمهيد للخرائط الحقيقية لاحقًا.',
            icon: Icons.map_outlined,
            trailing: MunasaknaStatusChip(label: 'ميداني', icon: Icons.place_outlined),
            children: [
              Text('يعرض الدليل أهم الأماكن التي يحتاجها الحاج، وما يجب أن يعرفه في كل مكان، مع توجيه سريع للموقع والطوارئ.'),
            ],
          ),
          const SizedBox(height: 12),
          for (final place in _places) ...[
            _PlaceGuideCard(place: place),
            const SizedBox(height: 12),
          ],
          InfoSectionCard(
            title: 'أزرار ميدانية سريعة',
            icon: Icons.touch_app_outlined,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(onPressed: () => context.push(MunasaknaRoutes.currentLocation), icon: const Icon(Icons.my_location_outlined), label: const Text('موقعي الحالي')),
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.contacts), icon: const Icon(Icons.call_outlined), label: const Text('هواتف ضرورية')),
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.emergency), icon: const Icon(Icons.emergency_outlined), label: const Text('الطوارئ')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlaceGuideCard extends StatelessWidget {
  const _PlaceGuideCard({required this.place});
  final _PlaceGuide place;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: place.color.withValues(alpha: 0.22)),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.052), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(width: 50, height: 50, decoration: BoxDecoration(color: place.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(18)), child: Icon(place.icon, color: place.color)),
              const SizedBox(width: 10),
              Expanded(child: Text(place.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900))),
              MunasaknaStatusChip(label: place.phase, icon: Icons.schedule_outlined, color: place.color),
            ],
          ),
          const SizedBox(height: 10),
          Text(place.description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55)),
          const SizedBox(height: 12),
          for (final item in place.tips)
            Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_outline, color: place.color, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PlaceGuide {
  const _PlaceGuide({required this.title, required this.phase, required this.description, required this.tips, required this.icon, required this.color});
  final String title;
  final String phase;
  final String description;
  final List<String> tips;
  final IconData icon;
  final Color color;
}

const _places = [
  _PlaceGuide(title: 'مكة والمسجد الحرام', phase: 'الطواف', description: 'مركز الطواف والسعي وطواف الإفاضة والوداع. الالتزام بتعليمات التفويج يقلل الزحام.', tips: ['احفظ نقطة اللقاء بعد الطواف.', 'لا تزاحم عند الحجر الأسود.', 'اتبع مسار المجموعة عند السعي.'], icon: Icons.mosque_outlined, color: MunasaknaTheme.deepHaramGreen),
  _PlaceGuide(title: 'منى', phase: 'التروية والتشريق', description: 'مخيمات الحجاج وموقع رمي الجمرات. من أكثر المناطق حاجة للالتزام بالمجموعة.', tips: ['احفظ رقم المخيم والبوابة.', 'لا تتحرك منفردًا في الليل أو الزحام.', 'استخدم الهواتف الضرورية عند الضياع.'], icon: Icons.holiday_village_outlined, color: MunasaknaTheme.haramGreen),
  _PlaceGuide(title: 'عرفة', phase: '9 ذو الحجة', description: 'موضع الوقوف بعرفة، وهو ركن الحج الأعظم. التطبيق يبرز هذه المرحلة كمرحلة حرجة.', tips: ['الزم موقع حملتك.', 'اشرب الماء ولا تتعرض للشمس طويلًا.', 'أكثر من الدعاء والذكر.'], icon: Icons.landscape_outlined, color: MunasaknaTheme.roseAlert),
  _PlaceGuide(title: 'مزدلفة', phase: 'ليلة 10', description: 'مرحلة انتقالية بعد عرفة وقبل يوم النحر، وفيها الراحة والذكر والاستعداد للرمي.', tips: ['اتبع التفويج ولا تبحث عن الحصى وسط الزحام.', 'استرح قدر المستطاع.', 'جهز نفسك ليوم النحر.'], icon: Icons.nightlight_outlined, color: MunasaknaTheme.kiswahGold),
  _PlaceGuide(title: 'الجمرات', phase: '11-13', description: 'من أكثر المواقع ازدحامًا. لا يظهر التطبيق الرمي كسباق بل كواجب مرتبط بالسلامة والتفويج.', tips: ['التزم بوقت التفويج.', 'لا تعاكس اتجاه الحركة.', 'إذا تعبت اطلب المساعدة فورًا.'], icon: Icons.route_outlined, color: MunasaknaTheme.deepHaramGreen),
];
