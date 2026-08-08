import 'package:flutter/material.dart';

import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/beta_batch_widgets.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';
import '../../../beta_readiness/data/beta_batches_05_11_registry.dart';

class PlatformReadinessPage extends StatelessWidget {
  const PlatformReadinessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'جاهزية المنصات',
      headerIcon: Icons.devices_outlined,
      bottomNavIndex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BetaBatchSummaryCard(
            title: 'Batch 10 — Web/PWA + Android/iOS Readiness',
            subtitle: 'تحضير مسارات التشغيل والبناء لكل منصة. التطبيق ما زال بيتا داخلية ولا يُنشر رسميًا قبل الخصوصية والاختبارات والأيقونات والاعتماد.',
            icon: Icons.devices_outlined,
            status: 'Platform checklist',
            color: MunasaknaTheme.zamzamBlue,
          ),
          const SizedBox(height: 12),
          for (final item in BetaBatches0511Registry.platformReadiness) ...[
            InfoSectionCard(
              title: item.platform,
              subtitle: item.releaseNote,
              icon: Icons.devices_other_outlined,
              trailing: const MunasaknaStatusChip(label: 'تحقق محلي', icon: Icons.terminal_outlined),
              children: [
                Text('أمر الاختبار/البناء:', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                SelectableText(item.testCommand),
                const SizedBox(height: 12),
                Text('منجز:', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                BetaBulletList(items: item.done),
                const SizedBox(height: 8),
                Text('متبقٍ:', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                BetaBulletList(items: item.pending, icon: Icons.pending_actions_outlined),
              ],
            ),
            const SizedBox(height: 12),
          ],
          const InfoSectionCard(
            title: 'ملاحظات الإطلاق',
            icon: Icons.storefront_outlined,
            children: [
              BetaBulletList(
                items: [
                  'Android يمكن بناؤه من Windows، أما iOS فيحتاج macOS/Xcode.',
                  'PWA يحتاج manifest وأيقونات واسم عرض وسياسة كاش قبل إتاحة التثبيت.',
                  'الميكروفون والموقع يحتاجان نصوص أذونات واضحة وسهلة للمستخدم.',
                  'لا تشغيل صوت تلقائي على الويب؛ استخدم زر استمع.',
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
