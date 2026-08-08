import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/munasakna_environment.dart';
import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/development_mode_banner.dart';
import '../../../../core/widgets/munasakna_bottom_nav.dart';

class MunasaknaHomePage extends StatelessWidget {
  const MunasaknaHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const MunasaknaBottomNav(selectedIndex: 2),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFCF5),
              Color(0xFFFDF8EE),
              Color(0xFFFBF4E7),
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 112),
            children: [
              _HomeTopBar(onProfile: () => context.push(MunasaknaRoutes.profile)),
              const SizedBox(height: 10),
              const _HeroKaabaPanel(),
              const SizedBox(height: 18),
              _JourneyShortcutCard(onTap: () => context.push(MunasaknaRoutes.journey)),
              const SizedBox(height: 20),
              const _HomeSectionTitle(title: 'خدمات سريعة'),
              const SizedBox(height: 12),
              const _QuickServicesGrid(),
              const SizedBox(height: 18),
              const _DevelopmentCompactCard(),
              const SizedBox(height: 12),
              const _QuranInspirationCard(),
              const SizedBox(height: 10),
              const Text(
                'خدمات الحج والعمرة',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 1, height: 0.01, color: Colors.transparent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeTopBar extends StatelessWidget {
  const _HomeTopBar({required this.onProfile});

  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        _RoundIconButton(icon: Icons.notifications_rounded, onTap: () => context.push(MunasaknaRoutes.hajjFaq)),
        const Spacer(),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              MunasaknaEnvironment.appNameAr,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: MunasaknaTheme.deepHaramGreen,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              'الركن الخامس من أركان الإسلام',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.58),
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
        const Spacer(),
        _RoundIconButton(icon: Icons.person_rounded, onTap: onProfile),
      ],
    );
  }
}

class _HeroKaabaPanel extends StatelessWidget {
  const _HeroKaabaPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipPath(
          clipper: _HaramArchClipper(),
          child: Container(
            height: 255,
            decoration: BoxDecoration(
              border: Border.all(color: MunasaknaTheme.kiswahGold.withValues(alpha: 0.38), width: 1.1),
            ),
            foregroundDecoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.white.withValues(alpha: 0.08),
                  const Color(0xFFFFFCF5),
                ],
                stops: const [0.0, 0.62, 1.0],
              ),
            ),
            child: Image.asset(
              'assets/images/kaaba_home_hero.png',
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -10),
          child: Column(
            children: [
              Text(
                'لبيك اللهم لبيك',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: MunasaknaTheme.deepHaramGreen,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'تطبيقك الذكي لخدمة\nرحلة الحج خطوة بخطوة',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: MunasaknaTheme.deepHaramGreen.withValues(alpha: 0.86),
                      fontWeight: FontWeight.w700,
                      height: 1.55,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _JourneyShortcutCard extends StatelessWidget {
  const _JourneyShortcutCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [MunasaknaTheme.deepHaramGreen, MunasaknaTheme.haramGreen],
            ),
            boxShadow: [
              BoxShadow(
                color: MunasaknaTheme.deepHaramGreen.withValues(alpha: 0.24),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                SizedBox(
                  width: 86,
                  height: 86,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PositionedDirectional(
                        start: 4,
                        top: 8,
                        child: Icon(Icons.luggage_rounded, size: 72, color: MunasaknaTheme.warmGold.withValues(alpha: 0.95)),
                      ),
                      PositionedDirectional(
                        end: 2,
                        bottom: 4,
                        child: Container(
                          width: 48,
                          height: 58,
                          decoration: BoxDecoration(
                            color: MunasaknaTheme.deepHaramGreen,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: MunasaknaTheme.kiswahGold, width: 1.2),
                          ),
                          child: const Icon(Icons.mosque_rounded, color: MunasaknaTheme.kiswahGold, size: 22),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'رحلتي',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        'متابعة مراحل حجك بكل سهولة',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.88),
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.chevron_left_rounded, color: MunasaknaTheme.deepHaramGreen, size: 19),
                              const SizedBox(width: 4),
                              Text(
                                'عرض رحلتي',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      color: MunasaknaTheme.deepHaramGreen,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeSectionTitle extends StatelessWidget {
  const _HomeSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: MunasaknaTheme.deepHaramGreen,
            fontWeight: FontWeight.w900,
          ),
    );
  }
}

class _QuickServicesGrid extends StatelessWidget {
  const _QuickServicesGrid();

  static const _items = [
    _VisualQuickService('رفيق اليوم', Icons.today_rounded, MunasaknaRoutes.dailyCompanion),
    _VisualQuickService('نوع الحج', Icons.fact_check_rounded, MunasaknaRoutes.hajjType),
    _VisualQuickService('المواقيت', Icons.flag_rounded, MunasaknaRoutes.miqat),
    _VisualQuickService('تقويم الحج', Icons.event_note_rounded, MunasaknaRoutes.hajjSchedule),
    _VisualQuickService('الوثائق', Icons.folder_copy_rounded, MunasaknaRoutes.documentsWallet),
    _VisualQuickService('مجموعتي', Icons.groups_2_rounded, MunasaknaRoutes.groupSupervisor),
    _VisualQuickService('السكن والنقل', Icons.hotel_rounded, MunasaknaRoutes.accommodationTransport),
    _VisualQuickService('دليل المناسك', Icons.menu_book_rounded, MunasaknaRoutes.rituals),
    _VisualQuickService('مواقيت الصلاة', Icons.mosque_rounded, MunasaknaRoutes.prayerTimes),
    _VisualQuickService('البطاقة الرقمية', Icons.qr_code_2_rounded, MunasaknaRoutes.digitalCard),
    _VisualQuickService('موقعي الحالي', Icons.location_on_outlined, MunasaknaRoutes.currentLocation),
    _VisualQuickService('المساعد الصوتي', Icons.record_voice_over_rounded, MunasaknaRoutes.hajjAssistant),
    _VisualQuickService('الهواتف الضرورية', Icons.call_outlined, MunasaknaRoutes.contacts),
    _VisualQuickService('الإشعارات', Icons.notifications_none_rounded, MunasaknaRoutes.hajjFaq),
    _VisualQuickService('الفتاوى', Icons.help_outline_rounded, MunasaknaRoutes.fatwa),
    _VisualQuickService('الشكاوى', Icons.chat_bubble_outline_rounded, MunasaknaRoutes.complaints),
    _VisualQuickService('الاستبيانات', Icons.fact_check_outlined, MunasaknaRoutes.survey),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.92,
      ),
      itemBuilder: (context, index) => _QuickServiceCard(item: _items[index]),
    );
  }
}

class _QuickServiceCard extends StatelessWidget {
  const _QuickServiceCard({required this.item});

  final _VisualQuickService item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(item.route),
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFEDE6D8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.055),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: MunasaknaTheme.deepHaramGreen, size: 31),
                const SizedBox(height: 9),
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: MunasaknaTheme.deepHaramGreen,
                        fontWeight: FontWeight.w900,
                        height: 1.25,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DevelopmentCompactCard extends StatelessWidget {
  const _DevelopmentCompactCard();

  @override
  Widget build(BuildContext context) {
    return const DevelopmentModeBanner(compact: true);
  }
}

class _QuranInspirationCard extends StatelessWidget {
  const _QuranInspirationCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/home_quran_card.png',
            height: 175,
            width: double.infinity,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
          Container(
            height: 175,
            width: double.infinity,
            decoration: BoxDecoration(color: MunasaknaTheme.deepHaramGreen.withValues(alpha: 0.32)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Text(
              'إِنَّ الْحَجَّ أَشْهُرٌ مَّعْلُومَاتٌ\nفَمَن فَرَضَ فِيهِنَّ الْحَجَّ فَلَا رَفَثَ وَلَا فُسُوقَ\nوَلَا جِدَالَ فِي الْحَجِّ\n(سورة البقرة: 197)',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.8,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFEDE6D8)),
          ),
          child: Icon(icon, color: MunasaknaTheme.deepHaramGreen, size: 22),
        ),
      ),
    );
  }
}

class _HaramArchClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()..moveTo(0, size.height);
    path.lineTo(0, size.height * 0.30);
    path.cubicTo(size.width * 0.10, size.height * 0.18, size.width * 0.23, size.height * 0.18, size.width * 0.35, size.height * 0.29);
    path.cubicTo(size.width * 0.43, size.height * 0.36, size.width * 0.55, size.height * 0.36, size.width * 0.63, size.height * 0.25);
    path.cubicTo(size.width * 0.73, size.height * 0.12, size.width * 0.88, size.height * 0.15, size.width, size.height * 0.28);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _VisualQuickService {
  const _VisualQuickService(this.title, this.icon, this.route);

  final String title;
  final IconData icon;
  final String route;
}
