import 'package:flutter/material.dart';

import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'هواتف ضرورية',
      headerIcon: Icons.contact_phone_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const InfoSectionCard(
            title: 'دليل تواصل محلي',
            subtitle: 'أرقام تجريبية/تصنيفية إلى حين الربط ببيانات نسك والشركة والمجموعة.',
            icon: Icons.contact_phone_outlined,
            trailing: MunasaknaStatusChip(label: 'قابل للربط', icon: Icons.link_outlined),
            children: [
              Text('لاحقًا ستظهر أرقام المشرف والمرشد والشركة حسب ملف الحاج، بدون عرض بيانات غير لازمة.'),
            ],
          ),
          const SizedBox(height: 12),
          for (final group in _contactGroups) ...[
            InfoSectionCard(
              title: group.title,
              subtitle: group.subtitle,
              icon: group.icon,
              children: [
                for (final contact in group.contacts) _ContactTile(contact: contact),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.contact});
  final _Contact contact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.055),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Icon(contact.icon, color: scheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contact.title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text(contact.subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SelectableText(contact.value, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _ContactGroup {
  const _ContactGroup({required this.title, required this.subtitle, required this.icon, required this.contacts});
  final String title;
  final String subtitle;
  final IconData icon;
  final List<_Contact> contacts;
}

class _Contact {
  const _Contact({required this.title, required this.subtitle, required this.value, required this.icon});
  final String title;
  final String subtitle;
  final String value;
  final IconData icon;
}

const _contactGroups = [
  _ContactGroup(title: 'المشرفون', subtitle: 'تظهر لاحقًا حسب الشركة والمجموعة', icon: Icons.groups_outlined, contacts: [
    _Contact(title: 'مشرف المجموعة', subtitle: 'تجريبي - لا يتصل الآن', value: '+966 000 000 000', icon: Icons.supervisor_account_outlined),
    _Contact(title: 'مرشد المناسك', subtitle: 'للاستفسار الإرشادي العام', value: '+966 000 000 001', icon: Icons.menu_book_outlined),
  ]),
  _ContactGroup(title: 'الدعم والطوارئ', subtitle: 'تصنيف أولي للمساعدة السريعة', icon: Icons.emergency_share_outlined, contacts: [
    _Contact(title: 'طوارئ صحية', subtitle: 'اتبع التعليمات الرسمية في موقعك', value: '997', icon: Icons.health_and_safety_outlined),
    _Contact(title: 'دعم ميداني', subtitle: 'عند الضياع أو الانفصال عن المجموعة', value: '+966 000 000 002', icon: Icons.support_agent_outlined),
  ]),
  _ContactGroup(title: 'جهات إرشادية', subtitle: 'توجيه للمختص لا للفتوى من التطبيق', icon: Icons.gavel_outlined, contacts: [
    _Contact(title: 'اللجنة الشرعية', subtitle: 'للمسائل الحساسة والتفصيلية', value: 'داخل نسك لاحقًا', icon: Icons.gavel_outlined),
    _Contact(title: 'الدعم التقني', subtitle: 'للأخطاء داخل التطبيق', value: 'داخل التطبيق لاحقًا', icon: Icons.bug_report_outlined),
  ]),
];
