import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../domain/badge_tier.dart';
import 'badge_medal.dart';

class BadgeTierCard extends StatelessWidget {
  const BadgeTierCard({super.key, required this.tier, required this.count});

  final BadgeTier tier;

  /// How many times this badge has been earned.
  final int count;

  @override
  Widget build(BuildContext context) {
    final locked = count == 0;
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BadgeMedal(tier: tier, locked: locked),
          const SizedBox(height: 12),
          Text(
            tier.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: locked ? palette.muted : palette.ink,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            locked ? tier.description : 'Earned ×$count',
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              color: locked ? palette.muted : palette.leaf,
              fontSize: 12,
              fontWeight: locked ? FontWeight.w400 : FontWeight.w700,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
