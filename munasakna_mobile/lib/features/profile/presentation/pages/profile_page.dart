import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/manasikuna_visual_identity.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';
import '../../../nusuk_data/presentation/providers/nusuk_providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(pilgrimProfileProvider);
    return MunasaknaAppScaffold(
      title: 'بياناتي',
      headerIcon: Icons.badge_outlined,
      child: profile.when(
        data: (data) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _PilgrimHero(
              name: data.fullNameAr,
              status: data.statusLabelAr,
              applicationNo: data.applicationNo,
            ),
            const SizedBox(height: 12),
            InfoSectionCard(
              title: 'البيانات الشخصية',
              subtitle: 'بيانات تجريبية محلية إلى حين الربط مع نظام نسك.',
              icon: Icons.person_outline,
              trailing: const MunasaknaStatusChip(label: 'محلي', icon: Icons.offline_pin_outlined),
              children: [
                _InfoRow(label: 'الاسم', value: data.fullNameAr, icon: Icons.person_outline),
                _InfoRow(label: 'رقم الهوية', value: data.nationalId, icon: Icons.credit_card_outlined),
                _InfoRow(label: 'رقم الطلب', value: data.applicationNo, icon: Icons.confirmation_number_outlined),
                _InfoRow(label: 'الهاتف', value: data.phone, icon: Icons.phone_outlined),
              ],
            ),
            const SizedBox(height: 12),
            InfoSectionCard(
              title: 'بيانات الرحلة',
              icon: Icons.travel_explore_outlined,
              children: [
                _InfoRow(label: 'الشركة', value: data.companyNameAr, icon: Icons.business_outlined),
                _InfoRow(label: 'المجموعة', value: data.groupNameAr, icon: Icons.groups_outlined),
                const _InfoRow(label: 'نوع النسك', value: 'تمتع - تجريبي', icon: Icons.explore_outlined),
                const _InfoRow(label: 'المرحلة الحالية', value: 'الصحة والتطعيم', icon: Icons.timeline_outlined),
              ],
            ),
            const SizedBox(height: 12),
            InfoSectionCard(
              title: 'إجراءات سريعة',
              icon: Icons.touch_app_outlined,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      onPressed: () => context.push(MunasaknaRoutes.updateProfile),
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('تحديث بياناتي'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => context.push(MunasaknaRoutes.digitalCard),
                      icon: const Icon(Icons.qr_code_2_outlined),
                      label: const Text('بطاقتي الرقمية'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => context.push(MunasaknaRoutes.journey),
                      icon: const Icon(Icons.route_outlined),
                      label: const Text('رحلتي'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Text('تعذر تحميل البيانات: $error'),
      ),
    );
  }
}

class _PilgrimHero extends StatelessWidget {
  const _PilgrimHero({required this.name, required this.status, required this.applicationNo});

  final String name;
  final String status;
  final String applicationNo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: MunasaknaTheme.sacredGradient(Theme.of(context).colorScheme),
        border: Border.all(color: MunasaknaTheme.kiswahGold.withValues(alpha: 0.44)),
      ),
      child: Row(
        children: [
          const ManasikunaKaabaMark(size: 62),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                const SizedBox(height: 5),
                Text('رقم الطلب: $applicationNo', style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    MunasaknaStatusChip(label: status, icon: Icons.verified_outlined, color: MunasaknaTheme.kiswahGold),
                    const MunasaknaStatusChip(label: 'وضع تطوير', icon: Icons.construction_outlined),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.055),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.11)),
      ),
      child: Row(
        children: [
          Icon(icon, color: scheme.primary, size: 22),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900))),
          const SizedBox(width: 10),
          Flexible(
            child: Text(value, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
