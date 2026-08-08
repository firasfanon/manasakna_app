import 'package:flutter/material.dart';

import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class PrayerTimesPage extends StatelessWidget {
  const PrayerTimesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'مواقيت الصلاة',
      headerIcon: Icons.access_time_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const InfoSectionCard(
            title: 'مواقيت تجريبية',
            subtitle: 'تعرض المواقيت محليًا الآن. لاحقًا تُربط بالموقع والمشاعر حسب السياسة المعتمدة.',
            icon: Icons.access_time_outlined,
            trailing: MunasaknaStatusChip(label: 'محلي', icon: Icons.schedule_outlined),
            children: [Text('استخدم هذه الصفحة لتنظيم اليوم، مع الالتزام بتعليمات التفويج والحملة في أوقات المناسك.')],
          ),
          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'مواقيت اليوم',
            icon: Icons.mosque_outlined,
            children: [
              for (final item in _times) _PrayerTimeTile(item: item),
            ],
          ),
          const SizedBox(height: 12),
          const InfoSectionCard(
            title: 'تنبيهات مرتبطة بالمناسك',
            icon: Icons.notifications_active_outlined,
            children: [
              Text('في يوم عرفة ومزدلفة وأيام التشريق قد تختلف أولوية الحركة والتنظيم، لذلك يعرض التطبيق المواقيت كتذكير لا كبديل عن توجيهات المرشد.'),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrayerTimeTile extends StatelessWidget {
  const _PrayerTimeTile({required this.item});
  final _PrayerTime item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: item.highlight ? MunasaknaTheme.kiswahGold.withValues(alpha: 0.13) : scheme.primary.withValues(alpha: 0.055),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: (item.highlight ? MunasaknaTheme.kiswahGold : scheme.primary).withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Icon(item.icon, color: item.highlight ? MunasaknaTheme.kiswahGold : scheme.primary),
          const SizedBox(width: 10),
          Expanded(child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w900))),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(item.time, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}

class _PrayerTime {
  const _PrayerTime(this.name, this.time, this.icon, {this.highlight = false});
  final String name;
  final String time;
  final IconData icon;
  final bool highlight;
}

const _times = [
  _PrayerTime('الفجر', '05:10', Icons.nights_stay_outlined),
  _PrayerTime('الشروق', '06:35', Icons.wb_sunny_outlined),
  _PrayerTime('الظهر', '12:42', Icons.light_mode_outlined, highlight: true),
  _PrayerTime('العصر', '16:05', Icons.wb_sunny_outlined),
  _PrayerTime('المغرب', '19:22', Icons.nights_stay_outlined),
  _PrayerTime('العشاء', '20:45', Icons.dark_mode_outlined),
];
