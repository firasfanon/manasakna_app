import 'package:flutter/material.dart';

import '../../../../core/utils/local_reference.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final Map<String, int> _ratings = {
    'الشركة': 5,
    'السكن': 5,
    'النقل': 5,
    'الإرشاد': 5,
    'الصحة والسلامة': 5,
    'التفويج': 5,
  };
  final _notesController = TextEditingController();
  String _stage = 'after_return';
  String? _reference;

  double get _average => _ratings.values.reduce((a, b) => a + b) / _ratings.length;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    final reference = makeLocalReference('MNK-SRV');
    setState(() => _reference = reference);
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم تجهيز الاستبيان محليًا: $reference')));
  }

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'استبيان الحج',
      headerIcon: Icons.fact_check_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoSectionCard(
            title: 'تقييم تجربة الحج',
            subtitle: 'التقييم محلي الآن، ولاحقًا يُرسل إلى نسك حسب سياسة الموسم.',
            icon: Icons.fact_check_outlined,
            trailing: MunasaknaStatusChip(label: _average.toStringAsFixed(1), icon: Icons.star_rounded),
            children: [
              LinearProgressIndicator(value: _average / 5),
              const SizedBox(height: 10),
              const Text('قيّم كل محور من 1 إلى 5. الأسئلة منظمة حسب الخدمات الأساسية للحاج.'),
            ],
          ),
          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'مرحلة التقييم',
            icon: Icons.timeline_outlined,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _StageChip(label: 'بعد السكن', value: 'housing', selected: _stage == 'housing', onTap: () => setState(() => _stage = 'housing')),
                  _StageChip(label: 'بعد النقل', value: 'transport', selected: _stage == 'transport', onTap: () => setState(() => _stage = 'transport')),
                  _StageChip(label: 'بعد العودة', value: 'after_return', selected: _stage == 'after_return', onTap: () => setState(() => _stage = 'after_return')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'محاور التقييم',
            icon: Icons.rate_review_outlined,
            children: [
              for (final item in _ratings.entries)
                _SurveyQuestion(title: item.key, value: item.value, onChanged: (value) => setState(() => _ratings[item.key] = value)),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'ملاحظات إضافية', prefixIcon: Icon(Icons.notes_outlined)),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(onPressed: _submit, icon: const Icon(Icons.check_outlined), label: const Text('تجهيز الاستبيان')),
            ],
          ),
          if (_reference != null) ...[
            const SizedBox(height: 12),
            InfoSectionCard(title: 'رقم الاستبيان', icon: Icons.numbers_outlined, children: [SelectableText(_reference!, textAlign: TextAlign.center)]),
          ],
        ],
      ),
    );
  }
}

class _StageChip extends StatelessWidget {
  const _StageChip({required this.label, required this.value, required this.selected, required this.onTap});
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ChoiceChip(label: Text(label), selected: selected, onSelected: (_) => onTap());
}

class _SurveyQuestion extends StatelessWidget {
  const _SurveyQuestion({required this.title, required this.value, required this.onChanged});

  final String title;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w900))),
              MunasaknaStatusChip(label: '$value/5', icon: Icons.star_rounded),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var index = 1; index <= 5; index++)
                ChoiceChip(label: Text('$index'), selected: value == index, onSelected: (_) => onChanged(index)),
            ],
          ),
        ],
      ),
    );
  }
}
