import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/badge_tier.dart';

class RewardsSummaryCard extends StatelessWidget {
  const RewardsSummaryCard({
    super.key,
    required this.earnedCount,
    required this.unlockedTiers,
  });

  final int earnedCount;
  final int unlockedTiers;

  String get _headline {
    if (earnedCount == 0) return 'Your trophy shelf\nis waiting.';
    final noun = earnedCount == 1 ? 'badge' : 'badges';
    return '$earnedCount $noun earned.\nKeep it going!';
  }

  String get _subtitle => earnedCount == 0
      ? 'Finish any habit goal to unlock your first badge.'
      : '$unlockedTiers of ${BadgeTier.values.length} badge types unlocked.';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: context.palette.inkSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'YOUR REWARDS',
                  style: TextStyle(
                    color: Color(0xFFB9D4C8),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  _headline,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _subtitle,
                  style: const TextStyle(
                    color: Color(0xFFD1DED8),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.lime,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: AppColors.ink,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}
