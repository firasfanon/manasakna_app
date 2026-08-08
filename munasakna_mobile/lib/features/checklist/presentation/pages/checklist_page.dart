import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/manasikuna_visual_identity.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final Set<String> _checked = {};
  String _filter = 'all';

  int get _totalCount => _visibleSections.fold(0, (sum, section) => sum + section.items.length);
  int get _checkedVisibleCount => _visibleSections.fold(0, (sum, section) => sum + section.items.where(_checked.contains).length);

  List<_ChecklistSection> get _visibleSections => _filter == 'all' ? _sections : _sections.where((section) => section.phase == _filter).toList();

  @override
  Widget build(BuildContext context) {
    final progress = _totalCount == 0 ? 0.0 : _checkedVisibleCount / _totalCount;
    return MunasaknaAppScaffold(
      title: 'قائمة الجاهزية',
      headerIcon: Icons.checklist_rtl_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoSectionCard(
            title: 'مؤشر الجاهزية',
            subtitle: 'قائمة محلية مرتبة حسب الزمان والمكان لتقليل النسيان أثناء الرحلة.',
            icon: Icons.checklist_rtl_outlined,
            trailing: MunasaknaStatusChip(label: '${(progress * 100).round()}%', icon: Icons.track_changes_outlined),
            children: [
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 10),
              Text('تم إنجاز $_checkedVisibleCount من $_totalCount عناصر في هذا النطاق', textAlign: TextAlign.center),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _FilterChip(label: 'الكل', value: 'all', selected: _filter == 'all', onTap: () => setState(() => _filter = 'all')),
                  _FilterChip(label: 'قبل السفر', value: 'before', selected: _filter == 'before', onTap: () => setState(() => _filter = 'before')),
                  _FilterChip(label: 'المشاعر', value: 'ritual', selected: _filter == 'ritual', onTap: () => setState(() => _filter = 'ritual')),
                  _FilterChip(label: 'السلامة', value: 'safety', selected: _filter == 'safety', onTap: () => setState(() => _filter = 'safety')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final section in _visibleSections) ...[
            InfoSectionCard(
              title: section.title,
              subtitle: section.subtitle,
              icon: section.icon,
              children: [
                for (final item in section.items)
                  CheckboxListTile.adaptive(
                    value: _checked.contains(item),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _checked.add(item);
                        } else {
                          _checked.remove(item);
                        }
                      });
                    },
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          InfoSectionCard(
            title: 'روابط مساعدة',
            icon: Icons.touch_app_outlined,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.health), icon: const Icon(Icons.health_and_safety_outlined), label: const Text('الصحة')),
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.contacts), icon: const Icon(Icons.contact_phone_outlined), label: const Text('الأرقام')),
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.hajjAssistant), icon: const Icon(Icons.smart_toy_outlined), label: const Text('اسأل المساعد')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const ManasikunaSectionTitle(title: 'تذكير', subtitle: 'القائمة تنظيمية، ولا تغني عن تعليمات الشركة والمرشد.', icon: Icons.info_outline),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.value, required this.selected, required this.onTap});
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ChoiceChip(label: Text(label), selected: selected, onSelected: (_) => onTap());
}

class _ChecklistSection {
  const _ChecklistSection({required this.phase, required this.title, required this.subtitle, required this.icon, required this.items});
  final String phase;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> items;
}

const _sections = [
  _ChecklistSection(phase: 'before', title: 'الوثائق', subtitle: 'قبل السفر ونقطة التجمع', icon: Icons.description_outlined, items: ['جواز السفر', 'تصريح السفر أو التأشيرة', 'بطاقة الحملة أو رقم المجموعة', 'نسخة رقمية من الوثائق المهمة', 'أرقام المشرف والمرشد والطوارئ']),
  _ChecklistSection(phase: 'before', title: 'الحقيبة الخفيفة', subtitle: 'ما يحتاجه الحاج دون إرهاق', icon: Icons.luggage_outlined, items: ['ملابس مناسبة وخفيفة', 'أدوية شخصية كافية', 'شاحن وبطارية متنقلة', 'حذاء مريح', 'معقم وكمامات عند الحاجة', 'زجاجة ماء صغيرة']),
  _ChecklistSection(phase: 'ritual', title: 'قبل الإحرام والميقات', subtitle: 'من مصفوفة الحج v6', icon: Icons.flag_outlined, items: ['معرفة نوع النسك', 'مراجعة النية التعليمية', 'مراجعة محظورات الإحرام', 'لبس الإحرام للرجال في الوقت المناسب', 'بدء التلبية بعد النية']),
  _ChecklistSection(phase: 'ritual', title: 'أيام المشاعر', subtitle: 'منى، عرفة، مزدلفة، الجمرات', icon: Icons.route_outlined, items: ['حفظ موقع المخيم', 'اتباع وقت التفويج', 'عدم الذهاب منفردًا للجمرات', 'الاحتفاظ بالماء والأدوية', 'استخدام أرقام الطوارئ عند الحاجة']),
  _ChecklistSection(phase: 'safety', title: 'السلامة والصحة', subtitle: 'إرشادات عامة لا تغني عن الفريق الصحي', icon: Icons.health_and_safety_outlined, items: ['إبلاغ المرافق بحالتك الصحية', 'تجنب الشمس الطويلة', 'التوقف عند الدوخة أو التعب', 'عدم مشاركة بيانات حساسة', 'استخدام موقعي الحالي عند الضياع']),
];
