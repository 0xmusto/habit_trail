import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.rewardCount,
    required this.onRewardsTap,
    required this.onThemeTap,
  });

  final int rewardCount;
  final VoidCallback onRewardsTap;
  final VoidCallback onThemeTap;

  static const _weekdays = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  ];
  static const _months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];

  String _todayLabel() {
    final today = DateTime.now();
    return '${_weekdays[today.weekday - 1]}, ${_months[today.month - 1]} ${today.day}';
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _todayLabel(),
                style: TextStyle(
                  color: palette.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Make today\ncount.',
                style: TextStyle(
                  color: palette.ink,
                  fontSize: 34,
                  height: 1.08,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        Semantics(
          button: true,
          label: isDark ? 'Switch to light mode' : 'Switch to dark mode',
          child: GestureDetector(
            onTap: onThemeTap,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: palette.sage,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: palette.ink,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Semantics(
          button: true,
          label: 'Rewards, $rewardCount earned',
          child: GestureDetector(
            onTap: onRewardsTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.lime,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: AppColors.ink,
                  ),
                ),
                if (rewardCount > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: palette.inkSurface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: palette.canvas, width: 2),
                      ),
                      child: Text(
                        '$rewardCount',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
