import 'package:flutter/material.dart';

import '../../../../app/config/munasakna_environment.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MunasaknaAppScaffold(
      title: 'الخصوصية',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoSectionCard(
            title: 'وضع التطبيق',
            subtitle: 'مناسكنا يعمل حاليًا محليًا على الجهاز ضمن مرحلة التطوير بلا تسجيل دخول.',
            icon: Icons.privacy_tip_outlined,
            trailing: MunasaknaStatusChip(label: 'Data Not Collected', icon: Icons.verified_user_outlined),
            children: [
              Text('لا يحتوي التطبيق على تسجيل دخول أو حسابات مستخدمين أو قاعدة بيانات خارجية.'),
              SizedBox(height: 8),
              Text('لا يرسل التطبيق بيانات شخصية إلى خوادم خارجية في هذه النسخة.'),
              SizedBox(height: 8),
              Text('يُطلب إذن الموقع فقط عند الضغط على خدمة موقعي الحالي، ويُعرض الموقع داخل الجهاز.'),
            ],
          ),
          SizedBox(height: 12),
          InfoSectionCard(
            title: 'بيانات النشر',
            icon: Icons.app_settings_alt_outlined,
            children: [
              SelectableText('Bundle / Package: ${MunasaknaEnvironment.packageId}'),
              SizedBox(height: 8),
              Text('إجابة الخصوصية المقترحة للمتاجر: لا يتم جمع البيانات، مع الإفصاح عن إذن الموقع كإذن اختياري داخل الجهاز.'),
            ],
          ),
        ],
      ),
    );
  }
}
