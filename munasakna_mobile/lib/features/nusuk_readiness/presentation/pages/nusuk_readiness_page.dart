import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';


class NusukReadinessPage extends StatelessWidget {
  const NusukReadinessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'جاهزية الربط مع نسك',
      headerIcon: Icons.cloud_sync_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const InfoSectionCard(
            title: 'التطبيق محلي الآن، والربط لاحقًا عبر نسك فقط',
            subtitle: 'لا تسجيل دخول ولا قاعدة بيانات خارجية في مرحلة التطوير الحالية. هذه الصفحة تضبط ما سيُربط مستقبلًا.',
            icon: Icons.cloud_done_outlined,
            trailing: MunasaknaStatusChip(label: 'مستقبلي', icon: Icons.timeline_outlined),
            children: [
              Text('عند جاهزية قاعدة بيانات نسك، يتم تفعيل المصادقة والقراءة والكتابة تدريجيًا دون ربط بأي نظام قديم أو ASP.'),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in _readinessItems) ...[
            _ReadinessCard(item: item),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _ReadinessCard extends StatelessWidget {
  const _ReadinessCard({required this.item});
  final _ReadinessItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: scheme.surface, borderRadius: BorderRadius.circular(26), border: Border.all(color: item.color.withValues(alpha: 0.22))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: item.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(18)), child: Icon(item.icon, color: item.color)),
          const SizedBox(width: 10),
          Expanded(child: Text(item.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900))),
          MunasaknaStatusChip(label: item.status, icon: Icons.check_circle_outline, color: item.color),
        ]),
        const SizedBox(height: 10),
        Text(item.description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55, color: scheme.onSurfaceVariant)),
        const SizedBox(height: 10),
        for (final task in item.tasks)
          Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.arrow_left_rounded, color: item.color), Expanded(child: Text(task))])),
      ]),
    );
  }
}

class _ReadinessItem {
  const _ReadinessItem({required this.title, required this.status, required this.description, required this.tasks, required this.icon, required this.color});
  final String title;
  final String status;
  final String description;
  final List<String> tasks;
  final IconData icon;
  final Color color;
}

const _readinessItems = [
  _ReadinessItem(title: 'المصادقة المستقبلية', status: 'مؤجلة', description: 'تبقى تجربة التطوير بلا تسجيل دخول إلى حين اكتمال متطلبات السيرفر.', tasks: ['تفعيل OTP/هوية لاحقًا.', 'ربط ملف الحاج ببيانات نسك.', 'تحديد وضع الضيف ووضع المستخدم المسجل.'], icon: Icons.login_outlined, color: MunasaknaTheme.haramGreen),
  _ReadinessItem(title: 'مصادر البيانات', status: 'جاهزية DTO', description: 'الصفحات مبنية الآن على بيانات محلية، وتحتاج لاحقًا DTOs وRepositories رسمية.', tasks: ['بيانات الحاج.', 'الوثائق والجواز والتطعيمات.', 'الشركة والمجموعة والسكن والنقل.', 'الشكاوى والاستبيانات.'], icon: Icons.storage_outlined, color: MunasaknaTheme.zamzamBlue),
  _ReadinessItem(title: 'الأمان والخصوصية', status: 'إلزامي', description: 'الربط يجب أن يحترم أقل قدر من البيانات، وموافقة المستخدم على الموقع والصوت.', tasks: ['QR بلا بيانات حساسة.', 'الموقع عند الطلب فقط.', 'تخزين المرفقات في مسارات محمية.', 'سجل تدقيق للتحديثات الحساسة.'], icon: Icons.privacy_tip_outlined, color: MunasaknaTheme.roseAlert),
  _ReadinessItem(title: 'التشغيل الميداني', status: 'لاحقًا', description: 'تحتاج بعض الوظائف إلى وضع اتصال ضعيف ومزامنة لاحقة عند عودة الشبكة.', tasks: ['تخزين محلي مؤقت.', 'طوابير مزامنة.', 'رسائل خطأ مفهومة للحاج.', 'أولوية للطوارئ والموقع.'], icon: Icons.sync_outlined, color: MunasaknaTheme.kiswahGold),
];
