import 'package:flutter/material.dart';

import '../../app/config/munasakna_environment.dart';
import '../../app/theme/munasakna_theme.dart';

class DevelopmentModeBanner extends StatelessWidget {
  const DevelopmentModeBanner({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (!MunasaknaEnvironment.developmentMode) {
      return const SizedBox.shrink();
    }

    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: MunasaknaEnvironment.developmentModeLabelAr,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: MunasaknaTheme.kiswahGold.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(compact ? 18 : 22),
          border: Border.all(color: MunasaknaTheme.kiswahGold.withValues(alpha: 0.36)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 14, vertical: compact ? 10 : 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: compact ? 34 : 40,
                height: compact ? 34 : 40,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.construction_rounded, color: scheme.primary, size: compact ? 19 : 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      MunasaknaEnvironment.developmentModeLabelAr,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    if (!compact) ...[
                      const SizedBox(height: 3),
                      Text(
                        MunasaknaEnvironment.developmentModeDescriptionAr,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                              height: 1.35,
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
