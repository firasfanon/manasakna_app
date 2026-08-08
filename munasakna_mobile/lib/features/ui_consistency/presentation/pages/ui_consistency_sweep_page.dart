import 'package:flutter/material.dart';

import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/beta_batch_widgets.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../beta_readiness/data/beta_batches_05_11_registry.dart';

class UiConsistencySweepPage extends StatelessWidget {
  const UiConsistencySweepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'توحيد الواجهة',
      headerIcon: Icons.dashboard_customize_outlined,
      bottomNavIndex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BetaBatchSummaryCard(
            title: 'Batch 05 — UI Consistency & Internal Pages Polish',
            subtitle: 'دفعة تثبيت بصرية للتأكد من أن الصفحات الداخلية تتبع نفس الهوية: بطاقات موحدة، أزرار واضحة، نصوص مناسبة لكبار السن، وفصل صريح بين الإرشاد الشرعي والإداري والصحي.',
            icon: Icons.dashboard_customize_outlined,
            status: 'جاهز لبيتـا',
            color: MunasaknaTheme.haramGreen,
          ),
          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'قائمة المسح البصري',
            subtitle: 'هذه القائمة تصبح مرجعًا لأي صفحة جديدة قبل إغلاقها.',
            icon: Icons.fact_check_outlined,
            children: [
              for (final item in BetaBatches0511Registry.uiChecklist) ...[
                BetaChecklistTile(
                  title: item.title,
                  description: item.description,
                  status: item.status,
                  owner: item.owner,
                  closed: item.isClosed,
                  color: item.needsScholarApproval
                      ? MunasaknaTheme.roseAlert
                      : item.needsNusuk
                          ? MunasaknaTheme.zamzamBlue
                          : MunasaknaTheme.haramGreen,
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
          const SizedBox(height: 12),
          const InfoSectionCard(
            title: 'معيار الصفحة الداخلية',
            subtitle: 'أي صفحة في مناسكنا يجب أن تُقرأ كمهمة واضحة للحاج، لا كلوحة معلومات مكتظة.',
            icon: Icons.view_agenda_outlined,
            children: [
              BetaBulletList(
                items: [
                  'العنوان يجيب: أين أنا؟ وما المرحلة التي أخدمها؟',
                  'أول بطاقة تشرح ماذا يفعل الحاج الآن أو لماذا هذه الصفحة مهمة.',
                  'كل إجراء حساس يملك إحالة واضحة: لجنة شرعية، مرشد، مشرف، صحة، أو طوارئ.',
                  'لا تعرض الصفحة بيانات حقيقية في وضع التطوير؛ يظهر دائمًا أنها محلية/تجريبية.',
                  'تجنّب الجداول الثقيلة داخل الهاتف؛ استخدم بطاقات قصيرة مع chips للحالة.',
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const InfoSectionCard(
            title: 'نقاط polish المتبقية قبل Beta داخلية',
            icon: Icons.auto_fix_high_outlined,
            children: [
              BetaBulletList(
                icon: Icons.pending_actions_outlined,
                items: [
                  'اختبار الصفحات على عرض هاتف صغير وشاشة Web متوسطة.',
                  'توحيد النصوص الطويلة داخل صفحات المحتوى الشرعي لتكون قابلة للمراجعة والاعتماد.',
                  'تحويل أي زر يؤدي إلى ميزة مستقبلية إلى زر واضح بأنه قيد التحضير.',
                  'ربط كل صفحة ذات بيانات تشغيلية بوسم: بيانات محلية الآن / تحتاج نسك لاحقًا.',
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
