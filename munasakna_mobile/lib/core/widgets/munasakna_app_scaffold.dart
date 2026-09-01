import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/munasakna_theme.dart';
import 'development_mode_banner.dart';
import 'manasikuna_visual_identity.dart';
import 'munasakna_bottom_nav.dart';

class MunasaknaAppScaffold extends StatelessWidget {
  const MunasaknaAppScaffold({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.showBack = true,
    this.floatingActionButton,
    this.bottomNavIndex = 2,
    this.showBottomNav = true,
    this.headerIcon,
    this.showPageBanner = true,
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;
  final bool showBack;
  final Widget? floatingActionButton;
  final int bottomNavIndex;
  final bool showBottomNav;
  final IconData? headerIcon;
  final bool showPageBanner;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      extendBody: false,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: MunasaknaTheme.sacredGradient(scheme),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ManasikunaKaabaMark(size: 32, compact: true),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.w900, color: Colors.white),
              ),
            ),
          ],
        ),
        actions: actions,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: showBack && context.canPop()
            ? IconButton(
                onPressed: context.pop,
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              )
            : null,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
              height: 1,
              color: MunasaknaTheme.kiswahGold.withValues(alpha: 0.34)),
        ),
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: showBottomNav
          ? MunasaknaBottomNav(selectedIndex: bottomNavIndex)
          : null,
      body: ManasikunaBackground(
        child: SafeArea(
          top: false,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(16, 14, 16, showBottomNav ? 24 : 28),
            children: [
              if (showPageBanner) ...[
                ManasikunaPageBanner(
                  title: title,
                  icon: headerIcon ?? Icons.explore_rounded,
                ),
                const SizedBox(height: 12),
                const DevelopmentModeBanner(compact: true),
                const SizedBox(height: 14),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}
