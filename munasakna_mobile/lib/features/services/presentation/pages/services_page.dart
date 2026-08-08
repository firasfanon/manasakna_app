import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/munasakna_bottom_nav.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const MunasaknaBottomNav(selectedIndex: 4),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFCF5), Color(0xFFFDF8EE), Color(0xFFFBF4E7)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 112),
            children: [
              _ServicesTopBar(onBack: () => context.canPop() ? context.pop() : context.go(MunasaknaRoutes.home)),
              const SizedBox(height: 18),
              const _SearchBox(),
              const SizedBox(height: 18),
              for (final service in _visualServices) ...[
                _ServiceListTile(service: service),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 4),
              const _FooterKaabaPanel(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServicesTopBar extends StatelessWidget {
  const _ServicesTopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_forward_rounded, color: MunasaknaTheme.deepHaramGreen, size: 28),
          tooltip: 'عودة',
        ),
        const Spacer(),
        Text(
          'الخدمات',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: MunasaknaTheme.deepHaramGreen,
                fontWeight: FontWeight.w900,
              ),
        ),
        const Spacer(),
        const SizedBox(width: 48),
      ],
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEDE6D8)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 18, offset: const Offset(0, 10))],
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: Color(0xFF9AA49E)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'ابحث عن خدمة...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF9AA49E), fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceListTile extends StatelessWidget {
  const _ServiceListTile({required this.service});

  final _VisualService service;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(service.route),
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFEDE6D8)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.052), blurRadius: 18, offset: const Offset(0, 9))],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: service.gold ? MunasaknaTheme.kiswahGold : MunasaknaTheme.haramGreen,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: (service.gold ? MunasaknaTheme.kiswahGold : MunasaknaTheme.haramGreen).withValues(alpha: 0.24),
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(service.icon, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: MunasaknaTheme.deepHaramGreen, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        service.subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF6F7973), height: 1.35, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_left_rounded, color: Color(0xFF8F9B95)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterKaabaPanel extends StatelessWidget {
  const _FooterKaabaPanel();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/services_footer_kaaba.png',
            height: 176,
            width: double.infinity,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
          PositionedDirectional(
            start: 26,
            top: 30,
            child: Text(
              'نَفْقَهُ الْمَنَاسِكَ',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: MunasaknaTheme.deepHaramGreen,
                    fontWeight: FontWeight.w900,
                    shadows: [const Shadow(color: Colors.white, blurRadius: 10)],
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

const _visualServices = [
  _VisualService('رفيق اليوم', 'خطة يومية: ماذا أفعل الآن حسب اليوم والمكان', Icons.today_rounded, MunasaknaRoutes.dailyCompanion, gold: true),
  _VisualService('نوع الحج والنية', 'تمتع أو قران أو إفراد مع أثر كل اختيار على رحلتك', Icons.fact_check_rounded, MunasaknaRoutes.hajjType),
  _VisualService('المواقيت الشرعية', 'المواقيت الزمانية والمكانية وتنبيه الإحرام', Icons.flag_rounded, MunasaknaRoutes.miqat, gold: true),
  _VisualService('الدليل المكاني', 'مكة ومنى وعرفة ومزدلفة والجمرات بإرشاد ميداني', Icons.map_rounded, MunasaknaRoutes.fieldGuide),
  _VisualService('المكتبة دون إنترنت', 'محتوى آمن ومختصر عند ضعف الشبكة', Icons.offline_pin_rounded, MunasaknaRoutes.offlineLibrary, gold: true),
  _VisualService('تقويم الحج', 'مراحل زمنية من قبل السفر حتى ما بعد العودة', Icons.event_note_rounded, MunasaknaRoutes.hajjSchedule),
  _VisualService('محفظة الوثائق', 'جواز وتطعيمات وتصريح وبيانات طوارئ بشكل محلي', Icons.folder_copy_rounded, MunasaknaRoutes.documentsWallet, gold: true),
  _VisualService('مجموعتي والمشرف', 'المشرف والمرشد ونقاط التجمع عند الربط مع نسك', Icons.groups_2_rounded, MunasaknaRoutes.groupSupervisor),
  _VisualService('السكن والنقل', 'الفندق والمخيم والحافلة والتفويج', Icons.hotel_rounded, MunasaknaRoutes.accommodationTransport, gold: true),
  _VisualService('دعم كبار السن والمرضى', 'إرشادات سلامة وأزرار مساعدة للحالات الخاصة', Icons.accessible_forward_rounded, MunasaknaRoutes.accessibilitySupport),
  _VisualService('ما بعد الحج', 'استبيان وملاحظات ومتابعة صحية وسجل الرحلة', Icons.volunteer_activism_rounded, MunasaknaRoutes.postHajj, gold: true),
  _VisualService('توحيد الواجهة', 'مسح بصري للصفحات الداخلية قبل بيتا', Icons.dashboard_customize_rounded, MunasaknaRoutes.uiConsistencySweep, gold: true),
  _VisualService('أمان المساعد والصوت', 'لا فتوى ولا هلوسة مع fallback للصوت', Icons.record_voice_over_rounded, MunasaknaRoutes.assistantSafetyHardening),
  _VisualService('توسيع الأسئلة', 'FAQ حسب الزمان والمكان والجمهور', Icons.quiz_rounded, MunasaknaRoutes.faqExpansionApproval, gold: true),
  _VisualService('نسك التجريبي', 'Mock bridge دون تسجيل أو اتصال فعلي', Icons.cloud_sync_rounded, MunasaknaRoutes.nusukBridgeMock),
  _VisualService('تذكيرات المراحل', 'تنبيهات محلية حسب المرحلة والميقات', Icons.notifications_active_rounded, MunasaknaRoutes.stageReminders, gold: true),
  _VisualService('جاهزية المنصات', 'فحص Web وAndroid وiOS قبل بيتا', Icons.devices_rounded, MunasaknaRoutes.platformReadiness),
  _VisualService('دخان بيتا النهائي', 'بوابة smoke وتوريث قبل الاعتماد', Icons.check_circle_rounded, MunasaknaRoutes.finalBetaSmoke, gold: true),
  _VisualService('دليل المناسك', 'تعرف على المناسك خطوة بخطوة بالصور والفيديو', Icons.menu_book_rounded, MunasaknaRoutes.rituals),
  _VisualService('اللجنة الشرعية والفتاوى', 'أسئلتك الشرعية وإجابات موثوقة من أهل العلم', Icons.stars_rounded, MunasaknaRoutes.fatwa, gold: true),
  _VisualService('الشكاوى والاقتراحات', 'نستمع لك لتحسين خدماتنا على مدار الرحلة', Icons.forum_rounded, MunasaknaRoutes.complaints),
  _VisualService('الاستبيانات', 'شاركنا رأيك لتطوير تجربتك في خدمة ضيوف الرحمن', Icons.assignment_rounded, MunasaknaRoutes.survey, gold: true),
  _VisualService('الهواتف الضرورية', 'أرقام مهمة تهمك أثناء الرحلة', Icons.call_rounded, MunasaknaRoutes.contacts),
  _VisualService('مواقيت الصلاة', 'مواقيت الصلاة في مكة والمشاعر مع تنبيه الأذان', Icons.mosque_rounded, MunasaknaRoutes.prayerTimes, gold: true),
  _VisualService('موقعي الحالي', 'اعرف موقعك الحالي في مكة والمشاعر', Icons.location_on_rounded, MunasaknaRoutes.currentLocation),
  _VisualService('البطاقة الرقمية', 'بطاقتك التعريفية لرحلة الحج (QR)', Icons.qr_code_2_rounded, MunasaknaRoutes.digitalCard, gold: true),
  _VisualService('المساعد الصوتي الذكي', 'يسأل ويجيب ويذكّر وينبه بالصوت دون فتوى أو تخمين', Icons.record_voice_over_rounded, MunasaknaRoutes.hajjAssistant, gold: true),
  _VisualService('الإشعارات والتنبيهات', 'تنبيهات مهمة لمجريات رحلتك حسب المرحلة', Icons.notifications_rounded, MunasaknaRoutes.notifications),
  _VisualService('جاهزية بيتا', 'تثبيت تجربة المستخدم وتحضير عقود نسك', Icons.workspace_premium_rounded, MunasaknaRoutes.betaReadiness, gold: true),
  _VisualService('تشغيل بيتا الداخلي', 'اختبار الرحلة دون تسجيل دخول أو بيانات حقيقية', Icons.rocket_launch_rounded, MunasaknaRoutes.betaPilot),
  _VisualService('سجل ملاحظات بيتا', 'تصنيف الملاحظات والأخطاء قبل الإغلاق', Icons.feedback_rounded, MunasaknaRoutes.betaFeedback, gold: true),
  _VisualService('بوابات الإطلاق الداخلي', 'اختبارات وخصوصية واعتماد وربط نسك', Icons.rule_folder_rounded, MunasaknaRoutes.releaseGates),
  _VisualService('تدقيق المحتوى والواجهة', 'مراجعة صفحة بصفحة قبل الربط أو APK التجريبي', Icons.rate_review_rounded, MunasaknaRoutes.betaContentUxAudit, gold: true),
  _VisualService('تقرير نسك للتكامل', 'ما يحتاجه التطبيق من نسك وما يحتاجه نسك من التطبيق', Icons.integration_instructions_rounded, MunasaknaRoutes.nusukIntegrationHandoff),
  _VisualService('الإعدادات', 'اللغة والمظهر ووضع التطوير', Icons.tune_rounded, MunasaknaRoutes.settings, gold: true),
];

class _VisualService {
  const _VisualService(this.title, this.subtitle, this.icon, this.route, {this.gold = false});

  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final bool gold;
}
