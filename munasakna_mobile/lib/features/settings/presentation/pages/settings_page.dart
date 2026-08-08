import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../domain/models/munasakna_app_settings.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsControllerProvider);
    final settings = settingsAsync.value ?? MunasaknaAppSettings.defaults;
    final controller = ref.read(appSettingsControllerProvider.notifier);

    return MunasaknaAppScaffold(
      title: 'الإعدادات',
      bottomNavIndex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SettingsHeader(settings: settings),
          const SizedBox(height: 14),
          _SettingsSection(
            title: 'المظهر',
            icon: Icons.palette_rounded,
            children: [
              _SegmentedChoice<ThemeMode>(
                label: 'وضع التطبيق',
                value: settings.themeMode,
                choices: const [
                  _Choice(ThemeMode.system, 'تلقائي', Icons.phone_android_rounded),
                  _Choice(ThemeMode.light, 'فاتح', Icons.light_mode_rounded),
                  _Choice(ThemeMode.dark, 'داكن', Icons.dark_mode_rounded),
                ],
                onChanged: controller.setThemeMode,
              ),
              const SizedBox(height: 14),
              _SegmentedChoice<String>(
                label: 'اللغة',
                value: settings.languageCode,
                choices: const [
                  _Choice('ar', 'العربية', Icons.translate_rounded),
                  _Choice('en', 'English', Icons.language_rounded),
                ],
                onChanged: controller.setLanguageCode,
              ),
              const SizedBox(height: 14),
              _FontScaleTile(
                value: settings.textScale,
                onChanged: controller.setTextScale,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SettingsSection(
            title: 'خدمات الحج والعمرة',
            icon: Icons.explore_rounded,
            children: [
              _SegmentedChoice<String>(
                label: 'المسار المفضل',
                value: settings.preferredRitualPath,
                choices: const [
                  _Choice('hajj', 'الحج', Icons.hiking_rounded),
                  _Choice('umrah', 'العمرة', Icons.mosque_rounded),
                ],
                onChanged: controller.setPreferredRitualPath,
              ),
              const SizedBox(height: 14),
              TextFormField(
                initialValue: settings.groupLabel,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'اسم المجموعة أو الحملة',
                  prefixIcon: Icon(Icons.groups_rounded),
                ),
                onChanged: controller.setGroupLabel,
              ),
              const SizedBox(height: 8),
              _MobileSwitchTile(
                value: settings.enableHajjMode,
                onChanged: controller.setHajjMode,
                icon: Icons.fact_check_rounded,
                title: 'بطاقات الجاهزية',
                subtitle: 'إظهار بطاقة الجاهزية على الشاشة الرئيسية.',
              ),
              _MobileSwitchTile(
                value: settings.enableLocationHints,
                onChanged: controller.setLocationHints,
                icon: Icons.my_location_rounded,
                title: 'تلميحات الموقع',
                subtitle: 'شرح مبسّط عند استخدام خدمة موقعي الحالي.',
              ),
              _MobileSwitchTile(
                value: settings.showPrivacyBanner,
                onChanged: controller.setPrivacyBanner,
                icon: Icons.privacy_tip_rounded,
                title: 'تذكير الخصوصية',
                subtitle: 'إظهار تنبيه بأن التطبيق يعمل محليًا.',
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SettingsSection(
            title: 'إدارة التطبيق',
            icon: Icons.admin_panel_settings_rounded,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.restore_rounded),
                title: const Text('استعادة الإعدادات الافتراضية'),
                subtitle: const Text('يعيد المظهر واللغة وخيارات الخدمات إلى الوضع الأولي.'),
                trailing: const Icon(Icons.chevron_left_rounded),
                onTap: () => _confirmReset(context, controller),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, AppSettingsController controller) async {
    final confirm = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('إعادة ضبط الإعدادات؟', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              const Text('سيتم إرجاع إعدادات التطبيق إلى الوضع الافتراضي. لا توجد حسابات أو بيانات خارجية مرتبطة بهذا الإجراء.'),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(true),
                icon: const Icon(Icons.restore_rounded),
                label: const Text('إعادة الضبط'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('إلغاء'),
              ),
            ],
          ),
        ),
      ),
    );
    if (confirm == true) {
      await controller.reset();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت استعادة الإعدادات الافتراضية')));
      }
    }
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader({required this.settings});

  final MunasaknaAppSettings settings;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.primaryContainer.withValues(alpha: 0.55),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(Icons.tune_rounded, color: scheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('لوحة إعدادات موبايل', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  Text(
                    'المسار: ${settings.preferredRitualPath == 'umrah' ? 'العمرة' : 'الحج'} • اللغة: ${settings.languageCode == 'ar' ? 'العربية' : 'English'}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.icon, required this.children});

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, color: scheme.primary),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _SegmentedChoice<T> extends StatelessWidget {
  const _SegmentedChoice({
    required this.label,
    required this.value,
    required this.choices,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<_Choice<T>> choices;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final choice in choices)
              ChoiceChip(
                selected: value == choice.value,
                avatar: Icon(choice.icon, size: 18),
                label: Text(choice.label),
                onSelected: (_) => onChanged(choice.value),
              ),
          ],
        ),
      ],
    );
  }
}

class _FontScaleTile extends StatelessWidget {
  const _FontScaleTile({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(Icons.format_size_rounded),
            const SizedBox(width: 8),
            Expanded(child: Text('حجم الخط', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900))),
            Text('${(value * 100).round()}%'),
          ],
        ),
        Slider(
          value: value,
          min: 0.90,
          max: 1.25,
          divisions: 7,
          label: '${(value * 100).round()}%',
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _MobileSwitchTile extends StatelessWidget {
  const _MobileSwitchTile({
    required this.value,
    required this.onChanged,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      secondary: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(subtitle),
    );
  }
}

class _Choice<T> {
  const _Choice(this.value, this.label, this.icon);

  final T value;
  final String label;
  final IconData icon;
}
