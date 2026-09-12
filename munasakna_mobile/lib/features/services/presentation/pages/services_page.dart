import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/munasakna_bottom_nav.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final visibleServices = query.isEmpty
        ? _visualServices
        : _visualServices
            .where((service) =>
                service.title.toLowerCase().contains(query) ||
                service.subtitle.toLowerCase().contains(query))
            .toList(growable: false);

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
              _ServicesTopBar(
                onBack: () => context.canPop()
                    ? context.pop()
                    : context.go(MunasaknaRoutes.home),
              ),
              const SizedBox(height: 18),
              _SearchBox(onChanged: (value) => setState(() => _query = value)),
              const SizedBox(height: 18),
              if (visibleServices.isEmpty)
                const _EmptySearchResult()
              else
                for (final service in visibleServices) ...[
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
        SizedBox(
          width: 48,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: BackButton(
              onPressed: onBack,
              color: MunasaknaTheme.deepHaramGreen,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'الخدمات',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: MunasaknaTheme.deepHaramGreen,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ),
        const SizedBox(width: 56),
      ],
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEDE6D8)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 18,
              offset: const Offset(0, 10)),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: const InputDecoration(
          hintText: 'ابحث عن خدمة...',
          prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF9AA49E)),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}

class _EmptySearchResult extends StatelessWidget {
  const _EmptySearchResult();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFEDE6D8)),
        ),
        child: Text(
          'لا توجد خدمة مطابقة لبحثك.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6F7973),
                fontWeight: FontWeight.w700,
              ),
        ),
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
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.052),
                  blurRadius: 18,
                  offset: const Offset(0, 9)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: service.gold
                        ? MunasaknaTheme.kiswahGold
                        : MunasaknaTheme.haramGreen,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: (service.gold
                                ? MunasaknaTheme.kiswahGold
                                : MunasaknaTheme.haramGreen)
                            .withValues(alpha: 0.24),
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
                      Text(service.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: MunasaknaTheme.deepHaramGreen,
                                  fontWeight: FontWeight.w900)),
                      const SizedBox(height: 5),
                      Text(service.subtitle,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: const Color(0xFF6F7973),
                                  height: 1.35,
                                  fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_left_rounded,
                    color: Color(0xFF8F9B95)),
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

// Pilgrim-facing surface only. Engineering/beta/governance routes remain in
// the router for controlled internal workflows but are not advertised here.
const _visualServices = [
  _VisualService('رفيق اليوم', 'ماذا أفعل الآن حسب اليوم والمكان',
      Icons.today_rounded, MunasaknaRoutes.dailyCompanion,
      gold: true),
  _VisualService('رحلتي', 'الجاهزية والمراحل والخطوة التالية',
      Icons.route_rounded, MunasaknaRoutes.journey),
  _VisualService('مركز المراحل', 'الزمان والمكان والإجراء المناسب',
      Icons.event_note_rounded, MunasaknaRoutes.phaseNavigator,
      gold: true),
  _VisualService('نوع الحج والنية', 'تمتع أو قران أو إفراد وأثر الاختيار',
      Icons.fact_check_rounded, MunasaknaRoutes.hajjType),
  _VisualService('المواقيت الشرعية', 'المواقيت الزمانية والمكانية والإحرام',
      Icons.flag_rounded, MunasaknaRoutes.miqat,
      gold: true),
  _VisualService('دليل المناسك', 'الحج والعمرة خطوة بخطوة',
      Icons.menu_book_rounded, MunasaknaRoutes.rituals),
  _VisualService('أسئلة الحج', 'إرشاد حسب السياق مع حدود واضحة',
      Icons.quiz_rounded, MunasaknaRoutes.hajjFaq,
      gold: true),
  _VisualService('اللجنة الشرعية والفتاوى', 'الرجوع للمحتوى الشرعي عند الحاجة',
      Icons.stars_rounded, MunasaknaRoutes.fatwa),
  _VisualService('تقويم الحج', 'مراحل زمنية قبل السفر وأثناءه وبعده',
      Icons.event_note_rounded, MunasaknaRoutes.hajjSchedule,
      gold: true),
  _VisualService('قائمة الجاهزية', 'الوثائق والصحة والحقيبة قبل الحركة',
      Icons.fact_check_rounded, MunasaknaRoutes.checklist),
  _VisualService('حقيبتي للحج', 'قائمة تجهيز عملية للسفر والمشاعر',
      Icons.luggage_rounded, MunasaknaRoutes.travelBag,
      gold: true),
  _VisualService('محفظة الوثائق', 'مراجع ووثائق محلية ضمن حدود الخصوصية',
      Icons.folder_copy_rounded, MunasaknaRoutes.documentsWallet),
  _VisualService(
      'مجموعتي والمشرف',
      'المشرف ونقاط التجمع عند توفر بيانات مصرح بها',
      Icons.groups_2_rounded,
      MunasaknaRoutes.groupSupervisor,
      gold: true),
  _VisualService('السكن والنقل', 'الفندق والمخيم والحافلة والتفويج',
      Icons.hotel_rounded, MunasaknaRoutes.accommodationTransport),
  _VisualService('الدليل المكاني', 'مكة ومنى وعرفة ومزدلفة والجمرات',
      Icons.map_rounded, MunasaknaRoutes.fieldGuide,
      gold: true),
  _VisualService('موقعي الحالي', 'الموقع عند الطلب وضمن حدود الخصوصية',
      Icons.location_on_rounded, MunasaknaRoutes.currentLocation),
  _VisualService('الصحة والسلامة', 'وقاية غير تشخيصية ومتى تطلب المساعدة',
      Icons.health_and_safety_rounded, MunasaknaRoutes.health,
      gold: true),
  _VisualService('الطوارئ', 'وصول سريع للمساعدة والأرقام المهمة',
      Icons.call_rounded, MunasaknaRoutes.emergency),
  _VisualService('دعم كبار السن والمرضى', 'إرشادات وأدوات للحالات الخاصة',
      Icons.accessible_forward_rounded, MunasaknaRoutes.accessibilitySupport,
      gold: true),
  _VisualService('المكتبة دون إنترنت', 'محتوى آمن عند ضعف الشبكة',
      Icons.offline_pin_rounded, MunasaknaRoutes.offlineLibrary),
  _VisualService('تذكيرات المراحل', 'تنبيهات محلية حسب المرحلة والميقات',
      Icons.notifications_active_rounded, MunasaknaRoutes.stageReminders,
      gold: true),
  _VisualService('الإشعارات والتنبيهات', 'تنبيهات محلية لمجريات الرحلة',
      Icons.notifications_rounded, MunasaknaRoutes.notifications),
  _VisualService('المساعد الصوتي الذكي', 'إرشاد وتذكير دون فتوى أو تخمين',
      Icons.record_voice_over_rounded, MunasaknaRoutes.hajjAssistant,
      gold: true),
  _VisualService('الهواتف الضرورية', 'أرقام مهمة أثناء الرحلة',
      Icons.call_rounded, MunasaknaRoutes.contacts),
  _VisualService('مواقيت الصلاة', 'تنظيم الصلاة أثناء الرحلة',
      Icons.mosque_rounded, MunasaknaRoutes.prayerTimes,
      gold: true),
  _VisualService('البطاقة الرقمية', 'بطاقة تعريفية محلية مع QR آمن',
      Icons.qr_code_2_rounded, MunasaknaRoutes.digitalCard),
  _VisualService('مواعظ وأحكام', 'محتوى إرشادي مختصر',
      Icons.auto_stories_rounded, MunasaknaRoutes.guidance,
      gold: true),
  _VisualService('الدليل الطبقي', 'شرعي وزمني ومكاني وصحي',
      Icons.layers_rounded, MunasaknaRoutes.layerGuide),
  _VisualService('دليل التطبيق الشامل', 'مرجع استخدام المزايا والمراحل',
      Icons.help_center_rounded, MunasaknaRoutes.appGuide,
      gold: true),
  _VisualService('روابط مفيدة', 'مصادر ومراجع عند الحاجة',
      Icons.language_rounded, MunasaknaRoutes.usefulLinks),
  _VisualService('الشكاوى والاقتراحات', 'الملاحظات التشغيلية والمتابعة',
      Icons.forum_rounded, MunasaknaRoutes.complaints,
      gold: true),
  _VisualService('الاستبيانات', 'تقييم تجربة الرحلة والخدمات',
      Icons.assignment_rounded, MunasaknaRoutes.survey),
  _VisualService('ما بعد الحج', 'متابعة وتقييم وسجل الرحلة بعد العودة',
      Icons.volunteer_activism_rounded, MunasaknaRoutes.postHajj,
      gold: true),
  _VisualService('الخصوصية', 'البيانات المحلية وحدود المشاركة',
      Icons.privacy_tip_rounded, MunasaknaRoutes.privacy),
  _VisualService('الإعدادات', 'اللغة والمظهر وإعدادات التطبيق',
      Icons.tune_rounded, MunasaknaRoutes.settings,
      gold: true),
];

class _VisualService {
  const _VisualService(this.title, this.subtitle, this.icon, this.route,
      {this.gold = false});

  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final bool gold;
}
