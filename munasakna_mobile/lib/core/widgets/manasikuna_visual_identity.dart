import 'package:flutter/material.dart';

import '../../app/theme/munasakna_theme.dart';

class ManasikunaBackground extends StatelessWidget {
  const ManasikunaBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  MunasaknaTheme.darkBackground,
                  MunasaknaTheme.darkBackground,
                  MunasaknaTheme.deepHaramGreen.withValues(alpha: 0.42),
                ]
              : [
                  MunasaknaTheme.ihramIvory,
                  const Color(0xFFFFFBF2),
                  MunasaknaTheme.desertSand.withValues(alpha: 0.34),
                  scheme.primaryContainer.withValues(alpha: 0.18),
                ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          PositionedDirectional(
            top: -92,
            end: -72,
            child: IgnorePointer(
              child: _SoftCircle(size: 216, color: scheme.secondary.withValues(alpha: isDark ? 0.10 : 0.18)),
            ),
          ),
          PositionedDirectional(
            top: 180,
            start: -112,
            child: IgnorePointer(
              child: _SoftCircle(size: 224, color: scheme.primary.withValues(alpha: isDark ? 0.12 : 0.10)),
            ),
          ),
          PositionedDirectional(
            bottom: -125,
            end: -118,
            child: IgnorePointer(
              child: _SoftCircle(size: 266, color: scheme.tertiary.withValues(alpha: isDark ? 0.10 : 0.08)),
            ),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

class ManasikunaKaabaMark extends StatelessWidget {
  const ManasikunaKaabaMark({super.key, this.size = 56, this.compact = false});

  final double size;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size * 0.32),
              gradient: const LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors: [
                  MunasaknaTheme.kaabaBlack,
                  MunasaknaTheme.deepHaramGreen,
                ],
              ),
              border: Border.all(color: MunasaknaTheme.kiswahGold.withValues(alpha: 0.70), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.22),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
          ),
          Positioned(
            top: size * 0.30,
            left: size * 0.14,
            right: size * 0.14,
            child: Container(
              height: compact ? 3 : 4,
              decoration: BoxDecoration(
                color: MunasaknaTheme.kiswahGold,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Icon(Icons.mosque_rounded, color: Colors.white.withValues(alpha: 0.94), size: size * 0.42),
        ],
      ),
    );
  }
}

class ManasikunaPageBanner extends StatelessWidget {
  const ManasikunaPageBanner({
    super.key,
    required this.title,
    this.subtitle = 'تطبيق الحاج والمعتمر',
    this.icon = Icons.explore_rounded,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: MunasaknaTheme.sacredGradient(scheme),
        border: Border.all(color: MunasaknaTheme.kiswahGold.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          const ManasikunaKaabaMark(size: 48, compact: true),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.84),
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: MunasaknaTheme.kiswahGold.withValues(alpha: 0.35)),
            ),
            child: Icon(icon, color: MunasaknaTheme.kiswahGold, size: 22),
          ),
        ],
      ),
    );
  }
}

class ManasikunaSectionTitle extends StatelessWidget {
  const ManasikunaSectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors: [
                  scheme.primary.withValues(alpha: 0.16),
                  MunasaknaTheme.kiswahGold.withValues(alpha: 0.22),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: MunasaknaTheme.kiswahGold.withValues(alpha: 0.28)),
            ),
            child: Icon(icon, color: scheme.primary, size: 21),
          ),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class ManasikunaPill extends StatelessWidget {
  const ManasikunaPill({
    super.key,
    required this.label,
    required this.icon,
    this.isAlert = false,
    this.color,
  });

  final String label;
  final IconData icon;
  final bool isAlert;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final effectiveColor = color ?? (isAlert ? scheme.error : scheme.secondary);
    final foreground = color == null ? Colors.white : effectiveColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color == null ? Colors.white.withValues(alpha: 0.14) : effectiveColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: effectiveColor.withValues(alpha: 0.36)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: foreground, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: foreground, fontWeight: FontWeight.w800, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class ManasikunaProgressLine extends StatelessWidget {
  const ManasikunaProgressLine({
    super.key,
    required this.value,
    required this.label,
    required this.trailingLabel,
  });

  final double value;
  final String label;
  final String trailingLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w800)),
            ),
            Text(
              trailingLabel,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 9,
            value: value.clamp(0.0, 1.0).toDouble(),
            backgroundColor: scheme.surfaceContainerHighest,
            color: scheme.secondary,
          ),
        ),
      ],
    );
  }
}

class _SoftCircle extends StatelessWidget {
  const _SoftCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
