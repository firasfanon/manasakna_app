import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class BetaPilotPage extends StatelessWidget {
  const BetaPilotPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MunasaknaAppScaffold(
      title: 'تشغيل بيتا الداخلي',
      headerIcon: Icons.rocket_launch_outlined,
      bottomNavIndex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoSectionCard(
            title: 'Beta Readiness Batch 03',
            subtitle: 'مركز تشغيل تجريبي داخلي لا يستخدم بيانات حقيقية ولا يفعّل تسجيل الدخول.',
            icon: Icons.rocket_launch_outlined,
            trailing: const MunasaknaStatusChip(label: 'v2.8.5', icon: Icons.new_releases_outlined),
            children: [
              Text(
                'هذه الصفحة تضبط كيف نختبر مناسكنا كرحلة حج كاملة: من قبل السفر، إلى الميقات، ثم مكة والمشاعر، ثم ما بعد العودة. الهدف هو قياس الوضوح، السلامة، الصوت، ومطابقة الإجابات للمصفوفة، دون أي ربط فعلي مع نسك الآن.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55),
              ),
              const SizedBox(height: 12),
              const Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  MunasaknaStatusChip(label: 'بلا تسجيل دخول', icon: Icons.no_accounts_outlined),
                  MunasaknaStatusChip(label: 'بيانات تجريبية فقط', icon: Icons.science_outlined, color: MunasaknaTheme.zamzamBlue),
                  MunasaknaStatusChip(label: 'لا فتوى نهائية', icon: Icons.gavel_outlined, color: MunasaknaTheme.kiswahGold),
                  MunasaknaStatusChip(label: 'جاهز لاختبار داخلي', icon: Icons.verified_outlined, color: MunasaknaTheme.haramGreen),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _PilotSection(
            title: 'مجموعات الاختبار المقترحة',
            subtitle: 'نختبر تجربة التطبيق على أكثر من نمط مستخدم قبل ربط البيانات الرسمية.',
            icon: Icons.groups_3_outlined,
            color: scheme.primary,
            items: const [
              _PilotItem('ضيف بلا تسجيل دخول', 'يتصفح الخدمات، يسأل المساعد، ويفتح دليل المناسك دون أي حساب.'),
              _PilotItem('حاج متمتع', 'يراجع نوع الحج والنية، الإحرام، عمرة التمتع، ثم يوم التروية.'),
              _PilotItem('حاجة تسأل عن أحكام خاصة', 'تختبر توجيه المسائل الحساسة إلى اللجنة الشرعية دون فتوى من المساعد.'),
              _PilotItem('كبير سن أو مريض', 'يراجع الطوارئ، الأدوية، دعم الزحام، ومشاركة الموقع عند الحاجة.'),
              _PilotItem('تجربة ويب/أندرويد', 'تختبر قراءة الصوت، إدخال الميكروفون، والتنقل عبر شاشة كبيرة وصغيرة.'),
            ],
          ),
          const SizedBox(height: 12),
          _PilotSection(
            title: 'مسار تشغيل جلسة بيتا',
            subtitle: 'كل جلسة اختبار يجب أن تمر بمراحل موحدة كي لا تصبح الملاحظات عشوائية.',
            icon: Icons.timeline_outlined,
            color: MunasaknaTheme.haramGreen,
            items: const [
              _PilotItem('تهيئة', 'اختيار سيناريو واحد، منصة واحدة، وحالة حاج واحدة قبل بدء الاختبار.'),
              _PilotItem('تنفيذ', 'فتح الصفحات المحددة، استخدام المساعد، تجربة الصوت، وتسجيل الملاحظات.'),
              _PilotItem('تحقق', 'مطابقة الإجابة مع مصفوفة الحج v6 وFAQ v2 وعدم قبول أي جواب خارج المصدر.'),
              _PilotItem('تصنيف', 'تحديد هل الملاحظة UX أو محتوى أو صوت أو موقع أو عقد نسك أو أداء.'),
              _PilotItem('إغلاق', 'تحديد القرار: إصلاح الآن، اعتماد شرعي، مؤجل للربط، أو لا مشكلة.'),
            ],
          ),
          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'روابط متابعة التشغيل',
            subtitle: 'مداخل مباشرة للصفحات المرتبطة بجاهزية بيتا.',
            icon: Icons.hub_outlined,
            children: const [
              _PilotLink(title: 'سيناريوهات اختبار بيتا', subtitle: 'اختبر الرحلة لا الشاشة فقط.', icon: Icons.science_outlined, route: MunasaknaRoutes.betaTestScenarios),
              SizedBox(height: 10),
              _PilotLink(title: 'سجل ملاحظات بيتا', subtitle: 'صنف الأخطاء والملاحظات قبل الإغلاق.', icon: Icons.feedback_outlined, route: MunasaknaRoutes.betaFeedback),
              SizedBox(height: 10),
              _PilotLink(title: 'بوابات الإطلاق الداخلي', subtitle: 'لا ننتقل للربط أو النشر قبل إغلاق البوابات.', icon: Icons.rule_folder_outlined, route: MunasaknaRoutes.releaseGates),
            ],
          ),
        ],
      ),
    );
  }
}

class _PilotSection extends StatelessWidget {
  const _PilotSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.items,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<_PilotItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900))),
            ],
          ),
          const SizedBox(height: 6),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.45)),
          const SizedBox(height: 12),
          for (final item in items) ...[
            _PilotItemTile(item: item, color: color),
            if (item != items.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _PilotItem {
  const _PilotItem(this.title, this.description);
  final String title;
  final String description;
}

class _PilotItemTile extends StatelessWidget {
  const _PilotItemTile({required this.item, required this.color});
  final _PilotItem item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color.withValues(alpha: 0.06),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, size: 20, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text(item.description, style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PilotLink extends StatelessWidget {
  const _PilotLink({required this.title, required this.subtitle, required this.icon, required this.route});

  final String title;
  final String subtitle;
  final IconData icon;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => context.push(route),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.06),
            border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.14)),
          ),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 3),
                    Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.45)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Theme.of(context).colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
