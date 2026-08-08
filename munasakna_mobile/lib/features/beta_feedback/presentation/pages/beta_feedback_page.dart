import 'package:flutter/material.dart';

import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class BetaFeedbackPage extends StatelessWidget {
  const BetaFeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'سجل ملاحظات بيتا',
      headerIcon: Icons.feedback_outlined,
      bottomNavIndex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoSectionCard(
            title: 'منهجية استقبال الملاحظات',
            subtitle: 'تجميع ملاحظات بيتا محليًا ومنهجيًا قبل أي ربط رسمي مع نسك.',
            icon: Icons.feedback_outlined,
            trailing: const MunasaknaStatusChip(label: 'داخلي', icon: Icons.lock_outline),
            children: [
              Text(
                'لا تُرسل هذه الصفحة أي بيانات إلى السيرفر. الغرض منها الآن توحيد طريقة التفكير في الملاحظة: ما الصفحة؟ ما المرحلة؟ هل الخلل في الواجهة، المحتوى، الصوت، الموقع، الخصوصية، أم عقد نسك؟',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _FeedbackCategoryGrid(categories: _categories),
          const SizedBox(height: 12),
          _SeverityPanel(levels: _severityLevels),
          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'عينات ملاحظات جاهزة للتجربة',
            subtitle: 'نماذج تساعد فريق التطوير على اختبار التصنيف قبل فتح الكتابة الفعلية إلى نسك.',
            icon: Icons.assignment_outlined,
            children: [
              for (final sample in _sampleFeedback) ...[
                _SampleFeedbackCard(sample: sample),
                if (sample != _sampleFeedback.last) const SizedBox(height: 10),
              ],
            ],
          ),
          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'قواعد الإغلاق',
            subtitle: 'لا تُغلق الملاحظة حتى يكون لها قرار واضح.',
            icon: Icons.rule_folder_outlined,
            children: const [
              Text('• ملاحظة المحتوى الشرعي تُحوّل للاعتماد الشرعي ولا تُحل بتعديل عشوائي.'),
              SizedBox(height: 8),
              Text('• ملاحظة الصوت تُختبر على الويب وأندرويد أولًا، ثم iOS عند توفر بيئة Xcode.'),
              SizedBox(height: 8),
              Text('• ملاحظة الخصوصية أو الموقع لا تُغلق إلا بعد صياغة نص موافقة واضح.'),
              SizedBox(height: 8),
              Text('• ملاحظة نسك تُربط بعقد بيانات محدد ولا تُفعل قبل المصادقة وسجل التدقيق.'),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeedbackCategoryGrid extends StatelessWidget {
  const _FeedbackCategoryGrid({required this.categories});

  final List<_FeedbackCategory> categories;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 720;
        final children = [
          for (final category in categories)
            _FeedbackCategoryCard(category: category),
        ];
        if (!isWide) {
          return Column(
            children: [
              for (final child in children) ...[child, if (child != children.last) const SizedBox(height: 10)],
            ],
          );
        }
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final child in children) SizedBox(width: (constraints.maxWidth - 10) / 2, child: child),
          ],
        );
      },
    );
  }
}

class _FeedbackCategoryCard extends StatelessWidget {
  const _FeedbackCategoryCard({required this.category});

  final _FeedbackCategory category;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: scheme.surface,
        border: Border.all(color: category.color.withValues(alpha: 0.20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(category.icon, color: category.color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(category.description, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SeverityPanel extends StatelessWidget {
  const _SeverityPanel({required this.levels});

  final List<_SeverityLevel> levels;

  @override
  Widget build(BuildContext context) {
    return InfoSectionCard(
      title: 'مستويات الأولوية',
      subtitle: 'تصنيف موحد يمنع تضخيم الملاحظات أو تجاهل الملاحظات الحرجة.',
      icon: Icons.priority_high_outlined,
      children: [
        for (final level in levels) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MunasaknaStatusChip(label: level.label, icon: level.icon, color: level.color),
              const SizedBox(width: 10),
              Expanded(child: Text(level.description, style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45))),
            ],
          ),
          if (level != levels.last) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _SampleFeedbackCard extends StatelessWidget {
  const _SampleFeedbackCard({required this.sample});

  final _SampleFeedback sample;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: sample.color.withValues(alpha: 0.06),
        border: Border.all(color: sample.color.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(sample.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900))),
              MunasaknaStatusChip(label: sample.category, icon: Icons.label_outline, color: sample.color),
            ],
          ),
          const SizedBox(height: 6),
          Text(sample.description, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.45)),
          const SizedBox(height: 8),
          Text('قرار الإغلاق: ${sample.closure}', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _FeedbackCategory {
  const _FeedbackCategory(this.title, this.description, this.icon, this.color);
  final String title;
  final String description;
  final IconData icon;
  final Color color;
}

class _SeverityLevel {
  const _SeverityLevel(this.label, this.description, this.icon, this.color);
  final String label;
  final String description;
  final IconData icon;
  final Color color;
}

class _SampleFeedback {
  const _SampleFeedback(this.title, this.description, this.category, this.closure, this.color);
  final String title;
  final String description;
  final String category;
  final String closure;
  final Color color;
}

const _categories = [
  _FeedbackCategory('تجربة المستخدم', 'وضوح الصفحة، حجم الخط، سهولة الوصول، وتسلسل الخطوات.', Icons.touch_app_outlined, MunasaknaTheme.haramGreen),
  _FeedbackCategory('المحتوى الشرعي', 'أي إجابة أو صياغة تحتاج مراجعة اللجنة الشرعية قبل النشر.', Icons.gavel_outlined, MunasaknaTheme.kiswahGold),
  _FeedbackCategory('الصوت والمساعد', 'الاستماع، القراءة، وضبط المساعد على المصفوفة دون فتوى.', Icons.record_voice_over_outlined, MunasaknaTheme.zamzamBlue),
  _FeedbackCategory('الموقع والسلامة', 'الإذن، مشاركة الموقع، الطوارئ، الزحام، وكبار السن.', Icons.health_and_safety_outlined, Color(0xFFB22222)),
  _FeedbackCategory('عقود نسك', 'أي حقل أو تدفق يحتاج بيانات من السيرفر لاحقًا.', Icons.cloud_sync_outlined, MunasaknaTheme.deepHaramGreen),
  _FeedbackCategory('الأداء والاستقرار', 'اختبارات، تنقل، عدم ظهور شاشات حمراء، وسلاسة الويب/الموبايل.', Icons.speed_outlined, Color(0xFF6D5E00)),
];

const _severityLevels = [
  _SeverityLevel('حرج', 'يمنع استخدام الصفحة أو قد يسبب توجيهًا غير آمن أو تسريبًا للخصوصية.', Icons.error_outline, Color(0xFFB22222)),
  _SeverityLevel('مهم', 'يؤثر على رحلة الحاج أو وضوح الإرشاد لكنه لا يوقف التطبيق بالكامل.', Icons.warning_amber_outlined, MunasaknaTheme.kiswahGold),
  _SeverityLevel('تحسين', 'تحسين بصري أو لغوي أو تنظيمي يمكن ترحيله لدفعة لاحقة.', Icons.tune_outlined, MunasaknaTheme.zamzamBlue),
  _SeverityLevel('مؤجل', 'مرتبط بقاعدة بيانات نسك أو اعتماد شرعي أو iOS/Xcode لاحقًا.', Icons.schedule_outlined, MunasaknaTheme.haramGreen),
];

const _sampleFeedback = [
  _SampleFeedback('النص طويل في بطاقة يوم عرفة', 'المستخدم يحتاج ملخصًا أسرع في الواجهة مع رابط للتفصيل.', 'UX', 'اختصار النص وإبقاء التفصيل داخل الدليل.', MunasaknaTheme.haramGreen),
  _SampleFeedback('سؤال عن ترك واجب', 'المساعد يجب أن يوجه للّجنة ولا يجيب بحكم تفصيلي.', 'شرعي', 'وسم السؤال حساس وإحالته للاعتماد الشرعي.', MunasaknaTheme.kiswahGold),
  _SampleFeedback('الميكروفون لا يعمل على متصفح معين', 'يجب عرض بديل الكتابة اليدوية ورسالة إذن الميكروفون.', 'صوت', 'تحسين رسالة fallback دون تعطيل الصفحة.', MunasaknaTheme.zamzamBlue),
];
