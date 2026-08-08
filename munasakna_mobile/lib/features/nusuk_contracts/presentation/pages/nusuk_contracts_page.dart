import 'package:flutter/material.dart';

import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/beta_readiness_widgets.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';
import '../../../nusuk_data/domain/services/nusuk_bridge_contract.dart';

class NusukContractsPage extends StatelessWidget {
  const NusukContractsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final contracts = NusukBridgeContractPlan.contracts;
    return MunasaknaAppScaffold(
      title: 'عقود الربط مع نسك',
      headerIcon: Icons.cloud_sync_outlined,
      bottomNavIndex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoSectionCard(
            title: 'طبقة ربط مستقبلية دون تفعيل الدخول',
            subtitle: 'تجهيز DTO ومسارات قراءة/كتابة مؤجلة حتى تكتمل قاعدة نسك وسياسات الخصوصية.',
            icon: Icons.account_tree_outlined,
            trailing: const MunasaknaStatusChip(label: 'تصميم فقط', icon: Icons.lock_outline),
            children: [
              Text(
                'هذه الصفحة تحول عقود v283 إلى قائمة تنفيذ أوضح: ما يقرأه التطبيق، ما يكتبه لاحقًا، وما يجب حمايته قبل أي ربط فعلي.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55),
              ),
              const SizedBox(height: 12),
              const Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  MunasaknaStatusChip(label: 'لا تسجيل دخول الآن', icon: Icons.person_off_outlined),
                  MunasaknaStatusChip(label: 'لا Legacy', icon: Icons.block_outlined, color: MunasaknaTheme.roseAlert),
                  MunasaknaStatusChip(label: 'نسك فقط', icon: Icons.verified_user_outlined, color: MunasaknaTheme.haramGreen),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final contract in contracts) ...[
            NusukBridgeContractCard(
              title: contract.titleAr,
              description: '${contract.descriptionAr}\nالمسار المقترح: ${contract.endpointHint}',
              fields: contract.requiredFieldsAr,
              status: contract.modeLabelAr,
            ),
            const SizedBox(height: 10),
            _ContractRules(contractId: contract.id),
            const SizedBox(height: 12),
          ],
          InfoSectionCard(
            title: 'قواعد الحماية قبل الربط',
            subtitle: 'تظل هذه القواعد إلزامية عند الانتقال من البيانات المحلية إلى نسك.',
            icon: Icons.security_outlined,
            children: const [
              Text('QR لا يحمل بيانات حساسة؛ يحمل رمزًا أو معرفًا مؤقتًا فقط.'),
              SizedBox(height: 8),
              Text('الموقع لا يشارك إلا بعد ضغط واضح من المستخدم، ولا يعمل تلقائيًا في الخلفية.'),
              SizedBox(height: 8),
              Text('الشكاوى والوثائق والبيانات الصحية تحتاج مصادقة وسجل تدقيق قبل الإرسال.'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContractRules extends StatelessWidget {
  const _ContractRules({required this.contractId});

  final String contractId;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final rules = switch (contractId) {
      'pilgrim_profile' => ['قراءة فقط في أول ربط', 'إخفاء رقم الهوية جزئيًا', 'عدم تخزين بيانات حساسة في QR'],
      'journey_status' => ['تحديث دوري لا لحظي', 'تجاهل البيانات القديمة عند وصول تحديث أحدث', 'ربط المرحلة بالمصفوفة v6'],
      'field_contacts' => ['عرض أرقام حسب الموسم والمجموعة', 'تمييز الطوارئ عن الدعم العادي', 'الموقع بإذن المستخدم فقط'],
      'feedback_and_complaints' => ['كتابة مؤجلة لحين المصادقة', 'ربط الشكوى بالمرحلة والخدمة', 'سجل تدقيق وإشعارات متابعة'],
      _ => ['تحديد مصدر الحقيقة قبل التنفيذ'],
    };
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.50)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final rule in rules)
            MunasaknaStatusChip(label: rule, icon: Icons.rule_outlined, color: scheme.primary),
        ],
      ),
    );
  }
}
