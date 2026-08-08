import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/manasikuna_visual_identity.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class DigitalCardPage extends StatelessWidget {
  const DigitalCardPage({super.key});

  static const String _qrData = 'MUNASAKNA|LOCAL|SAFE_TOKEN|1447|DEMO-0001';

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'بطاقتي الرقمية',
      headerIcon: Icons.qr_code_2_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoSectionCard(
            title: 'بطاقة الحاج الرقمية',
            subtitle: 'رمز محلي تجريبي لا يكشف رقم هوية أو هاتف، ولا يحتاج اتصالًا بالإنترنت.',
            icon: Icons.qr_code_2_outlined,
            trailing: const MunasaknaStatusChip(label: 'QR آمن', icon: Icons.verified_outlined),
            children: [
              _DigitalCard(qrData: _qrData),
            ],
          ),
          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'ما الذي يظهر للموظف لاحقًا؟',
            icon: Icons.visibility_outlined,
            children: const [
              _DataScopeTile(title: 'مسموح', text: 'اسم مختصر، رقم حاج/طلب، الشركة، المجموعة، وحالة تحقق عامة.'),
              _DataScopeTile(title: 'غير مسموح', text: 'رقم الهوية، الهاتف، الملاحظات الصحية، أو أي بيانات حساسة داخل QR.'),
              _DataScopeTile(title: 'مستقبليًا', text: 'رمز موقّع ومحدود الصلاحية يصدر من نسك، وليس نصًا ثابتًا داخل التطبيق.'),
            ],
          ),
          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'إجراءات مرتبطة',
            icon: Icons.touch_app_outlined,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(onPressed: () => context.push(MunasaknaRoutes.profile), icon: const Icon(Icons.badge_outlined), label: const Text('بياناتي')),
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.journey), icon: const Icon(Icons.route_outlined), label: const Text('رحلتي')),
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.privacy), icon: const Icon(Icons.privacy_tip_outlined), label: const Text('الخصوصية')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DigitalCard extends StatelessWidget {
  const _DigitalCard({required this.qrData});
  final String qrData;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.14)),
      ),
      child: Column(
        children: [
          const ManasikunaKaabaMark(size: 58),
          const SizedBox(height: 10),
          Text('مناسكنا - بطاقة محلية', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
            child: QrImageView(data: qrData, version: QrVersions.auto, size: 225, backgroundColor: Colors.white),
          ),
          const SizedBox(height: 14),
          SelectableText('MUNASAKNA-DEMO-1447-0001', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text('رمز تعريفي تجريبي فقط', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _DataScopeTile extends StatelessWidget {
  const _DataScopeTile({required this.title, required this.text});
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 2),
                Text(text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
