import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class AccessibilitySupportPage extends StatelessWidget {
  const AccessibilitySupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'دعم كبار السن والمرضى',
      headerIcon: Icons.accessible_forward_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const InfoSectionCard(
            title: 'إرشاد سلامة لا يغني عن الطبيب أو المشرف',
            subtitle: 'تجربة موجهة لكبار السن والمرضى وذوي الحاجة الخاصة، مع أزرار مساعدة واضحة.',
            icon: Icons.health_and_safety_outlined,
            trailing: MunasaknaStatusChip(label: 'سلامة', icon: Icons.favorite_outline),
            children: [
              Text('المعلومات عامة وميدانية، ولا تقدم تشخيصًا طبيًا أو فتوى شرعية. عند الحالة الخاصة تُحال للجهة المختصة.'),
            ],
          ),
          const SizedBox(height: 12),
          for (final plan in _supportPlans) ...[
            _SupportPlanCard(plan: plan),
            const SizedBox(height: 12),
          ],
          InfoSectionCard(
            title: 'زر مساعدة سريع',
            icon: Icons.sos_outlined,
            children: [
              const Text('عند التعب الشديد أو الضياع أو الانفصال عن المجموعة، افتح موقعي الحالي ثم اتصل بالمشرف أو الطوارئ.'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(onPressed: () => context.push(MunasaknaRoutes.emergency), icon: const Icon(Icons.emergency_share_outlined), label: const Text('الطوارئ')),
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.currentLocation), icon: const Icon(Icons.my_location_outlined), label: const Text('موقعي الحالي')),
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.contacts), icon: const Icon(Icons.call_outlined), label: const Text('اتصال')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SupportPlanCard extends StatelessWidget {
  const _SupportPlanCard({required this.plan});
  final _SupportPlan plan;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: plan.color.withValues(alpha: 0.22)),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.05), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Container(width: 52, height: 52, decoration: BoxDecoration(color: plan.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(18)), child: Icon(plan.icon, color: plan.color)),
          const SizedBox(width: 10),
          Expanded(child: Text(plan.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900))),
          MunasaknaStatusChip(label: plan.priority, icon: Icons.priority_high_outlined, color: plan.color),
        ]),
        const SizedBox(height: 12),
        Text(plan.summary, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55)),
        const SizedBox(height: 12),
        for (final step in plan.steps)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.check_circle_outline, color: plan.color, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(step)),
            ]),
          ),
      ]),
    );
  }
}

class _SupportPlan {
  const _SupportPlan({required this.title, required this.priority, required this.summary, required this.steps, required this.icon, required this.color});
  final String title;
  final String priority;
  final String summary;
  final List<String> steps;
  final IconData icon;
  final Color color;
}

const _supportPlans = [
  _SupportPlan(title: 'كبير السن', priority: 'مهم', summary: 'تظهر له تعليمات مختصرة وأزرار أكبر وتنبيهات عدم الانفراد في الزحام.', steps: ['استخدم مرافقة المجموعة دائمًا.', 'جهّز بطاقة تعريف ورقم المشرف.', 'لا تذهب للجمرات أو الحرم منفردًا عند الزحام.'], icon: Icons.elderly_outlined, color: MunasaknaTheme.haramGreen),
  _SupportPlan(title: 'مريض أو يتناول أدوية', priority: 'حساس', summary: 'لا تحفظ هذه النسخة ملاحظات صحية شخصية؛ عند الحاجة شارك المعلومة مباشرة مع الطبيب أو المشرف المختص.', steps: ['احمل الأدوية بكمية كافية.', 'أخبر المرافق أو المشرف بمعلومة صحية مهمة.', 'عند التعب الشديد توقف واطلب مساعدة.'], icon: Icons.medication_outlined, color: MunasaknaTheme.roseAlert),
  _SupportPlan(title: 'ذوو الإعاقة أو الحركة المحدودة', priority: 'ميداني', summary: 'يحتاج الحاج إلى مسارات ميسرة وتنسيق خاص مع الحملة والمشرف.', steps: ['حدد حاجتك قبل التفويج.', 'استخدم خدمة الطوارئ والموقع عند الانفصال.', 'لا تعتمد على تقدير شخصي في الزحام الشديد.'], icon: Icons.accessible_forward_outlined, color: MunasaknaTheme.zamzamBlue),
  _SupportPlan(title: 'من يخاف الزحام أو الضياع', priority: 'وقائي', summary: 'يركز التطبيق على نقاط التجمع، مشاركة الموقع، والاتصال بالمشرف عند الحاجة.', steps: ['احفظ نقطة اللقاء.', 'شارك موقعك عند الحاجة فقط.', 'ابق في مكان آمن ولا تتحرك عشوائيًا.'], icon: Icons.psychology_alt_outlined, color: MunasaknaTheme.kiswahGold),
];
