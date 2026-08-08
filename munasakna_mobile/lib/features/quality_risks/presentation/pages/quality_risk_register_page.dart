import 'package:flutter/material.dart';

import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/beta_readiness_widgets.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class QualityRiskRegisterPage extends StatelessWidget {
  const QualityRiskRegisterPage({super.key});

  static const _risks = [
    _RiskItem(
      title: 'إجابة شرعية غير معتمدة',
      owner: 'اللجنة الشرعية',
      level: 'حرج',
      mitigation: 'وسم المسائل الحساسة وتوجيه الحاج للمرشد أو اللجنة بدل الجواب النهائي.',
    ),
    _RiskItem(
      title: 'فشل الصوت على جهاز محدد',
      owner: 'فريق التطبيق',
      level: 'مهم',
      mitigation: 'إبقاء النص والكتابة اليدوية دائمًا كبديل عن TTS/STT.',
    ),
    _RiskItem(
      title: 'التباس بين بيانات تجريبية وحقيقية',
      owner: 'نسك / المنصة',
      level: 'مهم',
      mitigation: 'إبقاء Banner وضع التطوير بلا تسجيل دخول حتى تفعيل الربط الرسمي.',
    ),
    _RiskItem(
      title: 'ازدحام الشاشة بالمعلومات',
      owner: 'UX',
      level: 'متوسط',
      mitigation: 'تقسيم المحتوى حسب مرحلة الحاج: ماذا أفعل الآن؟ التفاصيل تظهر عند الطلب.',
    ),
    _RiskItem(
      title: 'تفعيل موقع أو وثائق بلا سياسة خصوصية نهائية',
      owner: 'المنصة',
      level: 'حرج',
      mitigation: 'عدم رفع بيانات حساسة أو مشاركة موقع تلقائي قبل اعتماد الخصوصية وRLS/RBAC.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MunasaknaAppScaffold(
      title: 'سجل مخاطر الجودة',
      headerIcon: Icons.health_and_safety_outlined,
      bottomNavIndex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoSectionCard(
            title: 'Quality Risk Register',
            subtitle: 'سجل مخاطر حي لمرحلة Beta Readiness.',
            icon: Icons.shield_outlined,
            trailing: const MunasaknaStatusChip(label: 'مستمر', icon: Icons.update_outlined),
            children: const [
              Text(
                'الغرض من السجل هو منع تكرار الأخطاء أثناء الدفعات الكبيرة: كل خطر له مالك، مستوى، وتخفيف واضح داخل التطبيق أو في إجراءات التطوير.',
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final cards = const [
                BetaReadinessMetricCard(
                  title: 'مخاطر حرجة',
                  value: '2',
                  subtitle: 'المحتوى الشرعي والخصوصية.',
                  icon: Icons.warning_amber_rounded,
                  color: MunasaknaTheme.roseAlert,
                ),
                BetaReadinessMetricCard(
                  title: 'مخاطر مهمة',
                  value: '2',
                  subtitle: 'الصوت والتمييز بين التجريبي والحقيقي.',
                  icon: Icons.priority_high_outlined,
                  color: MunasaknaTheme.kiswahGold,
                ),
                BetaReadinessMetricCard(
                  title: 'مخاطر UX',
                  value: '1',
                  subtitle: 'كثافة المعلومات داخل الصفحات.',
                  icon: Icons.design_services_outlined,
                  color: MunasaknaTheme.zamzamBlue,
                ),
              ];
              if (constraints.maxWidth < 720) {
                return Column(children: [for (final card in cards) ...[card, const SizedBox(height: 10)]]);
              }
              return Row(children: [for (final card in cards) ...[Expanded(child: card), if (card != cards.last) const SizedBox(width: 10)]]);
            },
          ),
          const SizedBox(height: 12),
          for (final risk in _risks) ...[
            _RiskCard(risk: risk),
            const SizedBox(height: 10),
          ],
          InfoSectionCard(
            title: 'قاعدة الإغلاق',
            subtitle: 'لا يُغلق الخطر الحرج بنص عام فقط.',
            icon: Icons.lock_reset_outlined,
            children: [
              Text(
                'إغلاق أي خطر حرج يحتاج دليل تحقق: اختبار ناجح، اعتماد محتوى، أو سياسة مكتوبة. المخاطر التي تمس الفتوى أو البيانات الشخصية لا تُرحّل للنشر العام.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant, height: 1.55),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RiskItem {
  const _RiskItem({required this.title, required this.owner, required this.level, required this.mitigation});

  final String title;
  final String owner;
  final String level;
  final String mitigation;
}

class _RiskCard extends StatelessWidget {
  const _RiskCard({required this.risk});

  final _RiskItem risk;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = switch (risk.level) {
      'حرج' => MunasaknaTheme.roseAlert,
      'مهم' => MunasaknaTheme.kiswahGold,
      _ => scheme.primary,
    };
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: scheme.surface,
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.report_problem_outlined, color: color),
              const SizedBox(width: 8),
              Expanded(child: Text(risk.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900))),
              MunasaknaStatusChip(label: risk.level, icon: Icons.speed_outlined, color: color),
            ],
          ),
          const SizedBox(height: 8),
          Text('المالك: ${risk.owner}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(risk.mitigation, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55)),
        ],
      ),
    );
  }
}
