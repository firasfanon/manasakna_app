import 'package:flutter/material.dart';

import '../../../../core/utils/local_reference.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController(text: '0590000000');
  final _addressController = TextEditingController(text: 'فلسطين');
  final _emergencyController = TextEditingController();
  final _healthNoteController = TextEditingController();
  String _priority = 'normal';
  String _updateReason = 'phone';
  String? _reference;

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    _emergencyController.dispose();
    _healthNoteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final reference = makeLocalReference('MNK-UPD');
    setState(() => _reference = reference);
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تجهيز طلب التحديث محليًا: $reference')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'تحديث بياناتي',
      headerIcon: Icons.manage_accounts_outlined,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const InfoSectionCard(
              title: 'تحديث محلي آمن',
              subtitle: 'هذه الشاشة تجهّز طلبًا محليًا فقط إلى حين ربط التطبيق بنظام نسك.',
              icon: Icons.privacy_tip_outlined,
              trailing: MunasaknaStatusChip(label: 'بدون إرسال', icon: Icons.offline_pin_outlined),
              children: [
                Text('عند الربط الرسمي لاحقًا، ستتحول هذه الطلبات إلى workflow مراجعة واعتماد داخل نسك دون كشف بيانات غير لازمة.'),
              ],
            ),
            const SizedBox(height: 12),
            InfoSectionCard(
              title: 'سبب التحديث',
              icon: Icons.fact_check_outlined,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ReasonChip(value: 'phone', label: 'هاتف', selected: _updateReason == 'phone', onTap: () => setState(() => _updateReason = 'phone')),
                    _ReasonChip(value: 'address', label: 'عنوان', selected: _updateReason == 'address', onTap: () => setState(() => _updateReason = 'address')),
                    _ReasonChip(value: 'health', label: 'صحة', selected: _updateReason == 'health', onTap: () => setState(() => _updateReason = 'health')),
                    _ReasonChip(value: 'emergency', label: 'طوارئ', selected: _updateReason == 'emergency', onTap: () => setState(() => _updateReason = 'emergency')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            InfoSectionCard(
              title: 'البيانات المطلوب تحديثها',
              icon: Icons.edit_note_outlined,
              children: [
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'رقم الهاتف', prefixIcon: Icon(Icons.phone_outlined)),
                  validator: (value) => value == null || value.trim().length < 8 ? 'أدخل رقم هاتف صحيح' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'العنوان', prefixIcon: Icon(Icons.home_outlined)),
                  validator: (value) => value == null || value.trim().isEmpty ? 'أدخل العنوان' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emergencyController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'هاتف الطوارئ', prefixIcon: Icon(Icons.emergency_share_outlined)),
                  validator: (value) => value == null || value.trim().length < 8 ? 'أدخل هاتف الطوارئ' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _healthNoteController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(labelText: 'ملاحظة صحية أو احتياج خاص', prefixIcon: Icon(Icons.health_and_safety_outlined)),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _priority,
                  decoration: const InputDecoration(labelText: 'أولوية المراجعة'),
                  items: const [
                    DropdownMenuItem(value: 'normal', child: Text('عادي')),
                    DropdownMenuItem(value: 'important', child: Text('مهم')),
                    DropdownMenuItem(value: 'urgent', child: Text('عاجل ميداني')),
                  ],
                  onChanged: (value) => setState(() => _priority = value ?? _priority),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('تجهيز طلب التحديث'),
                ),
              ],
            ),
            if (_reference != null) ...[
              const SizedBox(height: 12),
              InfoSectionCard(
                title: 'رقم طلب التحديث',
                subtitle: 'احتفظ بهذا الرقم التجريبي لحين الربط مع نسك.',
                icon: Icons.receipt_long_outlined,
                children: [SelectableText(_reference!, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900))],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReasonChip extends StatelessWidget {
  const _ReasonChip({required this.value, required this.label, required this.selected, required this.onTap});

  final String value;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      avatar: selected ? const Icon(Icons.check_rounded, size: 18) : null,
    );
  }
}
