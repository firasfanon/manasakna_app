import 'package:flutter/material.dart';

import '../../../../core/utils/local_reference.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({super.key});

  @override
  State<ComplaintsPage> createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();
  String _type = 'housing';
  String _stage = 'before_travel';
  String _priority = 'normal';
  String? _lastReference;

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final reference = makeLocalReference('MNK-CMP');
    setState(() => _lastReference = reference);
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تجهيز الشكوى محليًا برقم مرجعي: $reference')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'شكاوى الحجاج',
      headerIcon: Icons.support_agent_outlined,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const InfoSectionCard(
              title: 'تقديم شكوى أو ملاحظة',
              subtitle: 'يتم تجهيز الطلب محليًا. لاحقًا سيرتبط بنظام نسك للمراجعة والتصنيف والرد.',
              icon: Icons.support_agent_outlined,
              trailing: MunasaknaStatusChip(label: 'محلي', icon: Icons.offline_pin_outlined),
              children: [
                Text('اختر المرحلة والخدمة بدقة حتى تصبح الشكوى قابلة للتوجيه عند الربط الرسمي.'),
              ],
            ),
            const SizedBox(height: 12),
            InfoSectionCard(
              title: 'تفاصيل الشكوى',
              icon: Icons.edit_note_outlined,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _stage,
                  decoration: const InputDecoration(labelText: 'المرحلة'),
                  items: const [
                    DropdownMenuItem(value: 'before_travel', child: Text('قبل السفر')),
                    DropdownMenuItem(value: 'makkah', child: Text('مكة')),
                    DropdownMenuItem(value: 'mina', child: Text('منى')),
                    DropdownMenuItem(value: 'arafah', child: Text('عرفة')),
                    DropdownMenuItem(value: 'muzdalifah', child: Text('مزدلفة')),
                    DropdownMenuItem(value: 'after_return', child: Text('بعد العودة')),
                  ],
                  onChanged: (value) => setState(() => _stage = value ?? _stage),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _type,
                  decoration: const InputDecoration(labelText: 'نوع الشكوى'),
                  items: const [
                    DropdownMenuItem(value: 'housing', child: Text('السكن')),
                    DropdownMenuItem(value: 'transport', child: Text('النقل')),
                    DropdownMenuItem(value: 'company', child: Text('الشركة')),
                    DropdownMenuItem(value: 'health', child: Text('الصحة')),
                    DropdownMenuItem(value: 'guidance', child: Text('الإرشاد')),
                    DropdownMenuItem(value: 'lost', child: Text('ضياع/مساعدة ميدانية')),
                    DropdownMenuItem(value: 'other', child: Text('أخرى')),
                  ],
                  onChanged: (value) => setState(() => _type = value ?? _type),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _priority,
                  decoration: const InputDecoration(labelText: 'الأولوية'),
                  items: const [
                    DropdownMenuItem(value: 'normal', child: Text('عادية')),
                    DropdownMenuItem(value: 'important', child: Text('مهمة')),
                    DropdownMenuItem(value: 'urgent', child: Text('عاجلة')),
                  ],
                  onChanged: (value) => setState(() => _priority = value ?? _priority),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'عنوان الشكوى', prefixIcon: Icon(Icons.title_outlined)),
                  validator: (value) => value == null || value.trim().length < 3 ? 'أدخل عنوانًا واضحًا' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _detailsController,
                  minLines: 4,
                  maxLines: 7,
                  decoration: const InputDecoration(labelText: 'تفاصيل الشكوى', prefixIcon: Icon(Icons.notes_outlined)),
                  validator: (value) => value == null || value.trim().length < 10 ? 'أدخل تفاصيل كافية' : null,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.send_outlined),
                  label: const Text('تجهيز الشكوى'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            InfoSectionCard(
              title: 'مسار المتابعة المتوقع',
              icon: Icons.timeline_outlined,
              children: const [
                _ComplaintStep(label: 'استلام محلي', active: true),
                _ComplaintStep(label: 'تصنيف في نسك لاحقًا'),
                _ComplaintStep(label: 'توجيه للجهة المختصة'),
                _ComplaintStep(label: 'رد وإغلاق'),
              ],
            ),
            if (_lastReference != null) ...[
              const SizedBox(height: 12),
              InfoSectionCard(
                title: 'آخر رقم مرجعي',
                icon: Icons.confirmation_number_outlined,
                children: [SelectableText(_lastReference!, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900))],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ComplaintStep extends StatelessWidget {
  const _ComplaintStep({required this.label, this.active = false});
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(active ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: active ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: TextStyle(fontWeight: active ? FontWeight.w900 : FontWeight.w700))),
        ],
      ),
    );
  }
}
