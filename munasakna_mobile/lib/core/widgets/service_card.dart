import 'package:flutter/material.dart';

import '../../app/theme/munasakna_theme.dart';

class MunasaknaServiceCard extends StatelessWidget {
  const MunasaknaServiceCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.subtitle,
    this.isImportant = false,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool isImportant;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accentColor = isImportant ? colorScheme.error : colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [
                colorScheme.surface,
                colorScheme.surface,
                MunasaknaTheme.kiswahGold.withValues(alpha: isImportant ? 0.09 : 0.06),
              ],
            ),
            border: Border.all(
              color: isImportant
                  ? colorScheme.error.withValues(alpha: 0.26)
                  : MunasaknaTheme.kiswahGold.withValues(alpha: 0.24),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.07),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              PositionedDirectional(
                top: -30,
                end: -30,
                child: _GlowCircle(size: 90, color: accentColor.withValues(alpha: 0.08)),
              ),
              PositionedDirectional(
                bottom: -20,
                start: -20,
                child: _GlowCircle(size: 68, color: colorScheme.secondary.withValues(alpha: 0.10)),
              ),
              PositionedDirectional(
                top: 0,
                start: 0,
                end: 0,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: isImportant ? colorScheme.error : MunasaknaTheme.kiswahGold,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: AlignmentDirectional.topStart,
                              end: AlignmentDirectional.bottomEnd,
                              colors: [
                                accentColor.withValues(alpha: 0.18),
                                MunasaknaTheme.kiswahGold.withValues(alpha: 0.16),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: MunasaknaTheme.kiswahGold.withValues(alpha: 0.28)),
                          ),
                          child: Icon(icon, size: 25, color: accentColor),
                        ),
                        const Spacer(),
                        if (isImportant)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                            decoration: BoxDecoration(
                              color: colorScheme.errorContainer.withValues(alpha: 0.70),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Icon(Icons.priority_high_rounded, size: 14, color: colorScheme.onErrorContainer),
                          )
                        else
                          Icon(Icons.auto_awesome_rounded, size: 17, color: MunasaknaTheme.kiswahGold.withValues(alpha: 0.95)),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            height: 1.23,
                          ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 5),
                      Text(
                        subtitle!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              height: 1.23,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size, required this.color});

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
