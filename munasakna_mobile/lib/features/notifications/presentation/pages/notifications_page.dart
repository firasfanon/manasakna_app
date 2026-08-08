import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final Set<String> _enabled = _localReminders.map((item) => item.id).toSet();

  @override
  Widget build(BuildContext context) {
    final enabledCount = _enabled.length;
    return MunasaknaAppScaffold(
      title: 'الإشعارات والتنبيهات',
      headerIcon: Icons.notifications_active_outlined,
      bottomNavIndex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoSectionCard(
            title: 'مركز التنبيهات المحلي',
            subtitle: 'تنبيهات إرشادية مبنية على مصفوفة الحج v6. لا تُرسل إشعارات خارج الجهاز في هذه المرحلة.',
            icon: Icons.notifications_active_outlined,
            trailing: MunasaknaStatusChip(label: '$enabledCount مفعل', icon: Icons.check_circle_outline),
            children: [
              LinearProgressIndicator(value: enabledCount / _localReminders.length),
              const SizedBox(height: 10),
              const Text('لاحقًا، عند الربط مع نسك، ستُضبط المواعيد حسب برنامج الشركة والتفويج الفعلي. حاليًا هذه تنبيهات تعليمية/تجريبية.'),
            ],
          ),
          const SizedBox(height: 12),
          for (final group in _groupedReminders.entries) ...[
            InfoSectionCard(
              title: group.key,
              icon: _groupIcon(group.key),
              children: [
                for (final reminder in group.value)
                  _ReminderTile(
                    reminder: reminder,
                    enabled: _enabled.contains(reminder.id),
                    onChanged: (value) {
                      setState(() {
                        if (value) {
                          _enabled.add(reminder.id);
                        } else {
                          _enabled.remove(reminder.id);
                        }
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          InfoSectionCard(
            title: 'إجراء سريع',
            subtitle: 'انتقل إلى المساعد لطرح سؤال عن تنبيه أو مرحلة.',
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
                    label: const Text('أسئلة المرحلة'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _groupIcon(String group) {
    return switch (group) {
      'قبل السفر' => Icons.flight_takeoff_outlined,
      'الإحرام والميقات' => Icons.flag_outlined,
      'أيام الحج' => Icons.calendar_month_outlined,
      'السلامة والطوارئ' => Icons.health_and_safety_outlined,
      _ => Icons.notifications_outlined,
    };
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({required this.reminder, required this.enabled, required this.onChanged});

  final _LocalReminder reminder;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = reminder.isCritical ? scheme.error : scheme.primary;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)),
                child: Icon(reminder.icon, color: color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(reminder.title, style: const TextStyle(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 3),
                    Text(reminder.timeLabel, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Switch(value: enabled, onChanged: onChanged),
            ],
          ),
          const SizedBox(height: 8),
          Text(reminder.message, style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45)),
          if (reminder.isCritical) ...[
            const SizedBox(height: 8),
            const MunasaknaStatusChip(label: 'تنبيه مهم', icon: Icons.priority_high_rounded, color: MunasaknaTheme.roseAlert),
          ],
        ],
      ),
    );
  }
}

class _LocalReminder {
  const _LocalReminder({required this.id, required this.group, required this.title, required this.timeLabel, required this.message, required this.icon, this.isCritical = false});

  final String id;
  final String group;
  final String title;
  final String timeLabel;
  final String message;
  final IconData icon;
  final bool isCritical;
}

const _localReminders = [
  _LocalReminder(id: 'docs', group: 'قبل السفر', title: 'راجع الوثائق والجواز', timeLabel: 'قبل السفر', message: 'تأكد من الجواز، التصريح، بطاقة الحملة، وأرقام التواصل قبل التوجه إلى نقطة التجمع.', icon: Icons.description_outlined),
  _LocalReminder(id: 'health', group: 'قبل السفر', title: 'جهّز الأدوية والمعلومات الصحية', timeLabel: 'قبل السفر', message: 'احمل أدويتك الأساسية واكتب معلوماتك الصحية المهمة في مكان واضح.', icon: Icons.medication_outlined),
  _LocalReminder(id: 'miqat', group: 'الإحرام والميقات', title: 'استعد للميقات', timeLabel: 'قبل الميقات', message: 'حدد نوع النسك، راجع النية التعليمية، وتذكر محظورات الإحرام قبل الوصول إلى الميقات.', icon: Icons.flag_outlined, isCritical: true),
  _LocalReminder(id: 'ihram', group: 'الإحرام والميقات', title: 'أنت الآن محرم', timeLabel: 'بعد الإحرام', message: 'أكثر من التلبية، وابتعد عن محظورات الإحرام، واسأل اللجنة الشرعية عند وجود حالة خاصة.', icon: Icons.mosque_outlined),
  _LocalReminder(id: 'arafah', group: 'أيام الحج', title: 'يوم عرفة', timeLabel: '9 ذو الحجة', message: 'الوقوف بعرفة ركن الحج الأعظم؛ الزم مجموعتك وأكثر من الدعاء والذكر حتى وقت النفرة.', icon: Icons.landscape_outlined, isCritical: true),
  _LocalReminder(id: 'muzdalifah', group: 'أيام الحج', title: 'مزدلفة', timeLabel: 'ليلة 10 ذو الحجة', message: 'اتبع التفويج، استرح قدر المستطاع، وجهز نفسك لرمي جمرة العقبة يوم النحر.', icon: Icons.nightlight_outlined),
  _LocalReminder(id: 'jamarat', group: 'أيام الحج', title: 'رمي الجمرات', timeLabel: 'أيام التشريق', message: 'التزم بوقت التفويج، لا تذهب منفردًا، وتجنب المزاحمة حفاظًا على السلامة.', icon: Icons.route_outlined),
  _LocalReminder(id: 'lost', group: 'السلامة والطوارئ', title: 'عند الضياع عن المجموعة', timeLabel: 'في أي وقت', message: 'ابق في مكان آمن، افتح موقعي الحالي، واتصل بالمشرف أو رقم الطوارئ.', icon: Icons.emergency_share_outlined, isCritical: true),
];

Map<String, List<_LocalReminder>> get _groupedReminders {
  final grouped = <String, List<_LocalReminder>>{};
  for (final reminder in _localReminders) {
    grouped.putIfAbsent(reminder.group, () => []).add(reminder);
  }
  return grouped;
}
