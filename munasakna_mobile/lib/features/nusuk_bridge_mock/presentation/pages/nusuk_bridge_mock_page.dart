import 'package:flutter/material.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/beta_batch_widgets.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';
import '../../../beta_readiness/data/beta_batches_05_11_registry.dart';

class NusukBridgeMockPage extends StatelessWidget {
  const NusukBridgeMockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'طبقة نسك الوهمية',
      headerIcon: Icons.cloud_sync_outlined,
      bottomNavIndex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BetaBatchSummaryCard(
            title: 'Batch 08 — Nusuk Bridge Mock Layer',
            subtitle: 'تحضير الربط المستقبلي مع نسك دون تفعيل تسجيل الدخول أو إرسال بيانات. كل شيء يبقى محليًا/تجريبيًا في مرحلة بيتا الداخلية.',
            icon: Icons.cloud_sync_outlined,
            status: 'Guest / Mock',
            color: MunasaknaTheme.deepHaramGreen,
          ),
          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'عقود Mock الحالية',
            subtitle: 'هذه العقود تمنع إعادة الهندسة عند الانتقال إلى السيرفر.',
            icon: Icons.schema_outlined,
            children: [
              for (final contract in BetaBatches0511Registry.nusukMockContracts) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: MunasaknaTheme.zamzamBlue.withValues(alpha: 0.20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(contract.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                          ),
                          MunasaknaStatusChip(label: contract.readyState, icon: Icons.info_outline),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('المصدر المحلي: ${contract.localSource}'),
                      const SizedBox(height: 4),
                      Text('المسار المستقبلي: ${contract.futureEndpoint}'),
                      const SizedBox(height: 8),
                      BetaBulletList(items: contract.fields, icon: Icons.data_object_outlined),
                      const SizedBox(height: 8),
                      Text('قاعدة الخصوصية: ${contract.privacyRule}', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
          const SizedBox(height: 12),
          const InfoSectionCard(
            title: 'سياسة عدم التفعيل الآن',
            icon: Icons.lock_outline,
            children: [
              BetaBulletList(
                items: [
                  'لا تسجيل دخول في التطوير الحالي.',
                  'لا اتصال Supabase/Server من التطبيق لهذه الخدمات الآن.',
                  'لا رفع وثائق أو مرفقات قبل Storage/RLS.',
                  'لا QR يحتوي بيانات حساسة.',
                  'كل صفحة تشغيلية تعرض أنها بيانات محلية/تجريبية إلى حين الربط.',
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const BetaRouteTile(
            title: 'جاهزية نسك الحالية',
            subtitle: 'صفحة التحضير السابقة لعقود الربط.',
            icon: Icons.cloud_queue_outlined,
            route: MunasaknaRoutes.nusukReadiness,
            color: MunasaknaTheme.zamzamBlue,
          ),
        ],
      ),
    );
  }
}
