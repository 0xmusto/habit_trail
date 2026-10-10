import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/habit_tracker.dart';

class TrackerStatsCard extends StatelessWidget {
  const TrackerStatsCard({super.key, required this.tracker, required this.now});

  final HabitTracker tracker;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final label = tracker.isCompleted
        ? 'COMPLETED'
        : tracker.hasEnded(now)
        ? 'PERIOD ENDED'
        : 'DAY ${tracker.currentDay(now)} OF ${tracker.totalDays}';
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.palette.inkSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFFB9D4C8),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Text(
                '${(tracker.progress * 100).round()}%',
                style: const TextStyle(
                  color: AppColors.lime,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: tracker.progress,
              minHeight: 7,
              color: AppColors.lime,
              backgroundColor: Colors.white.withValues(alpha: 0.14),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _Stat(
                label: tracker.mode.successStat,
                value: tracker.successCount,
              ),
              _Stat(label: tracker.mode.failStat, value: tracker.failedCount),
              _Stat(label: 'Streak', value: tracker.streak(now)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$value',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Color(0xFFB9D4C8), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
