import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/munasakna_routes.dart';
import '../../app/theme/munasakna_theme.dart';

class MunasaknaBottomNav extends StatelessWidget {
  const MunasaknaBottomNav({
    super.key,
    this.selectedIndex = 2,
  });

  final int selectedIndex;

  static const List<_NavDestination> _destinations = [
    _NavDestination(
      'المناسك',
      Icons.explore_rounded,
      Icons.explore_outlined,
      MunasaknaRoutes.rituals,
    ),
    _NavDestination(
      'رحلتي',
      Icons.route_rounded,
      Icons.route_outlined,
      MunasaknaRoutes.season1448Launch,
    ),
    _NavDestination(
      'الرئيسية',
      Icons.home_rounded,
      Icons.home_outlined,
      MunasaknaRoutes.home,
    ),
    _NavDestination(
      'المساعد',
      Icons.record_voice_over_rounded,
      Icons.record_voice_over_outlined,
      MunasaknaRoutes.hajjAssistant,
    ),
    _NavDestination(
      'المزيد',
      Icons.more_horiz_rounded,
      Icons.more_horiz,
      MunasaknaRoutes.services,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final safeIndex = selectedIndex < 0 || selectedIndex >= _destinations.length
        ? 2
        : selectedIndex;
    final scheme = Theme.of(context).colorScheme;
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final isWide = viewportWidth >= 900;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWide ? 760 : double.infinity,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isWide ? 0 : 18),
              child: Container(
                key: const ValueKey<String>('munasakna-bottom-nav-surface'),
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: scheme.surface.withValues(alpha: 0.96),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: scheme.outlineVariant.withValues(alpha: 0.32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: scheme.shadow.withValues(alpha: 0.11),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    for (var index = 0; index < _destinations.length; index++)
                      Expanded(
                        child: _BottomNavItem(
                          destination: _destinations[index],
                          selected: index == safeIndex,
                          onTap: () => _goIfNeeded(
                            context,
                            _destinations[index].route,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void _goIfNeeded(BuildContext context, String route) {
    final currentRoute = GoRouterState.of(context).uri.path;
    if (currentRoute == route) return;
    context.go(route);
  }
}

class _BottomNavItem extends StatefulWidget {
  const _BottomNavItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final _NavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_BottomNavItem> createState() => _BottomNavItemState();
}

class _BottomNavItemState extends State<_BottomNavItem> {
  late final FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(
      debugLabel: 'bottom-nav-${widget.destination.label}',
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selectedColor = MunasaknaTheme.deepHaramGreen;

    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.destination.label,
      hint: 'الانتقال إلى ${widget.destination.label}',
      onTap: widget.onTap,
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: ValueKey<String>('bottom-nav-${widget.destination.route}'),
          focusNode: _focusNode,
          onFocusChange: (focused) {
            if (_hasFocus == focused) return;
            setState(() => _hasFocus = focused);
          },
          focusColor: selectedColor.withValues(alpha: 0.12),
          hoverColor: selectedColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(24),
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: widget.selected ? selectedColor : Colors.transparent,
              borderRadius: BorderRadius.circular(
                widget.selected ? 24 : 18,
              ),
              border: Border.all(
                color: _hasFocus
                    ? (widget.selected
                        ? MunasaknaTheme.kiswahGold
                        : scheme.primary)
                    : Colors.transparent,
                width: _hasFocus ? 3 : 1,
              ),
              boxShadow: widget.selected
                  ? [
                      BoxShadow(
                        color: selectedColor.withValues(alpha: 0.26),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.selected
                      ? widget.destination.selectedIcon
                      : widget.destination.icon,
                  color: widget.selected
                      ? Colors.white
                      : scheme.onSurface.withValues(alpha: 0.72),
                  size: widget.selected ? 25 : 22,
                ),
                const SizedBox(height: 3),
                Text(
                  widget.destination.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: widget.selected
                        ? Colors.white
                        : scheme.onSurface.withValues(alpha: 0.74),
                    fontSize: 10.5,
                    height: 1.05,
                    fontWeight:
                        widget.selected ? FontWeight.w900 : FontWeight.w700,
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

class _NavDestination {
  const _NavDestination(
    this.label,
    this.selectedIcon,
    this.icon,
    this.route,
  );

  final String label;
  final IconData selectedIcon;
  final IconData icon;
  final String route;
}
