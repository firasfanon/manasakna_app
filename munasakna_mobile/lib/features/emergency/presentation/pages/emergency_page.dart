import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'الطوارئ',
      headerIcon: Icons.emergency_share_outlined,
      bottomNavIndex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoSectionCard(
            title: 'مساعدة سريعة',
            subtitle: 'بطاقة محلية للتصرف السريع عند الضياع، التعب، أو الحاجة للمساعدة.',
            icon: Icons.emergency_share_outlined,
            trailing: const MunasaknaStatusChip(label: 'بدون اتصال', icon: Icons.offline_pin_outlined, color: MunasaknaTheme.roseAlert),
            children: [
              _EmergencyAction(icon: Icons.my_location_outlined, title: 'تحديد موقعي', subtitle: 'اعرض الإحداثيات وانسخها يدويًا للمشرف أو الطوارئ.', onTap: () => context.push(MunasaknaRoutes.currentLocation)),
              _EmergencyAction(icon: Icons.contact_phone_outlined, title: 'أرقام ضرورية', subtitle: 'افتح صفحة الهواتف المهمة والمشرفين.', onTap: () => context.push(MunasaknaRoutes.contacts)),
              _EmergencyAction(icon: Icons.health_and_safety_outlined, title: 'إرشادات صحية', subtitle: 'راجع خطوات التعامل مع التعب والحرارة والزحام.', onTap: () => context.push(MunasaknaRoutes.health)),
              _EmergencyAction(icon: Icons.support_agent_outlined, title: 'تسجيل ملاحظة', subtitle: 'جهّز شكوى أو ملاحظة برقم مرجعي محلي.', onTap: () => context.push(MunasaknaRoutes.complaints)),
            ],
          ),
          const SizedBox(height: 12),
          const InfoSectionCard(
            title: 'خطة تصرف عند الضياع',
            icon: Icons.signpost_outlined,
            children: [
              _EmergencyStep(number: '1', text: 'توقف في مكان آمن ولا تتحرك عشوائيًا.'),
              _EmergencyStep(number: '2', text: 'افتح موقعي الحالي وانسخ الإحداثيات.'),
              _EmergencyStep(number: '3', text: 'اتصل بالمشرف أو أقرب نقطة إرشاد.'),
              _EmergencyStep(number: '4', text: 'لا تشارك رقم الهوية أو بيانات حساسة مع غير الجهات الموثوقة.'),
            ],
          ),
          const SizedBox(height: 12),
          const InfoSectionCard(
            title: 'حالات تستدعي تدخلًا فوريًا',
            icon: Icons.warning_amber_outlined,
            children: [
              Text('ضيق النفس، ألم الصدر، إغماء، إصابة، فقدان مريض أو كبير سن، أو ضياع في منطقة زحام شديد.'),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmergencyAction extends StatelessWidget {
  const _EmergencyAction({required this.icon, required this.title, required this.subtitle, required this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.error.withValues(alpha: 0.16)),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.error),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_left_rounded),
        onTap: onTap,
      ),
    );
  }
}

class _EmergencyStep extends StatelessWidget {
  const _EmergencyStep({required this.number, required this.text});
  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 15, backgroundColor: Theme.of(context).colorScheme.primary, child: Text(number, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900))),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }
}
