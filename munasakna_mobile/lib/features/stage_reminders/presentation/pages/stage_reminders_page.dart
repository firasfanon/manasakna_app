import 'package:flutter/material.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/beta_batch_widgets.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';
import '../../../beta_readiness/data/beta_batches_05_11_registry.dart';

class StageRemindersPage extends StatelessWidget {
  const StageRemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'التذكيرات المرحلية',
      headerIcon: Icons.notifications_active_outlined,
      bottomNavIndex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BetaBatchSummaryCard(
            title: 'Batch 09 — Notifications & Stage Reminders',
            subtitle: 'خطة تذكيرات محلية حسب الزمان والمكان والمرحلة. لا يوجد Push server الآن؛ التنبيهات الشخصية تأتي لاحقًا بعد نسك والموافقة.',
            icon: Icons.notifications_active_outlined,
            status: 'Local Plan',
            color: MunasaknaTheme.roseAlert,
          ),
          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'خطة التذكيرات',
            subtitle: 'كل تذكير يحمل مرحلة ووقتًا ومكانًا وأولوية وإجراء تطبيق.',
            icon: Icons.event_available_outlined,
            children: [
              for (final reminder in BetaBatches0511Registry.stageReminderPlans) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: MunasaknaTheme.roseAlert.withValues(alpha: reminder.priority.contains('حرج') ? 0.38 : 0.18)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          MunasaknaStatusChip(label: reminder.phase, icon: Icons.flag_outlined),
                          MunasaknaStatusChip(label: reminder.priority, icon: Icons.priority_high_outlined),
                          MunasaknaStatusChip(label: reminder.voiceMode, icon: Icons.volume_up_outlined),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(reminder.reminder, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900, height: 1.45)),
                      const SizedBox(height: 8),
                      Text('الوقت: ${reminder.timeHint} — المكان: ${reminder.placeHint}'),
                      const SizedBox(height: 4),
                      Text('إجراء التطبيق: ${reminder.appAction}', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
          const SizedBox(height: 12),
          const InfoSectionCard(
            title: 'قواعد التفعيل لاحقًا',
            icon: Icons.settings_suggest_outlined,
            children: [
              BetaBulletList(
                items: [
                  'التذكيرات العامة يمكن أن تكون محلية Offline.',
                  'التذكيرات الشخصية حسب التفويج تحتاج بيانات نسك وموافقة المستخدم.',
                  'التذكير الصوتي لا يعمل تلقائيًا في الويب دون تفاعل المستخدم.',
                  'أي تنبيه شرعي حرج يفتح الدليل ولا يعطي فتوى تفصيلية.',
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const BetaRouteTile(
            title: 'فتح الإشعارات الحالية',
            subtitle: 'واجهة التنبيهات الموجودة داخل التطبيق.',
            icon: Icons.notifications_none_outlined,
            route: MunasaknaRoutes.notifications,
            color: MunasaknaTheme.roseAlert,
          ),
        ],
      ),
    );
  }
}
