import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../tracker/domain/habit_mode.dart';
import '../../../tracker/domain/habit_tracker.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({super.key, required this.tracker, required this.onTap});

  final HabitTracker tracker;
  final VoidCallback onTap;

  bool get _isQuit => tracker.mode == HabitMode.quitHabit;

  String _subtitle(DateTime now) {
    final mode = _isQuit ? 'Quit' : 'Build';
    if (tracker.isCompleted) return '$mode · Completed';
    if (tracker.hasEnded(now)) return '$mode · Ended';
    return '$mode · Day ${tracker.currentDay(now)} of ${tracker.totalDays}';
  }

  Widget _status(DateTime now, AppPalette palette) {
    if (tracker.isCompleted) {
      return const Icon(Icons.emoji_events_rounded, color: AppColors.amber);
    }
    if (!tracker.isActive(now)) {
      return Icon(Icons.chevron_right_rounded, color: palette.muted);
    }
    if (tracker.isCheckedIn(now)) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: palette.sage,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'LOGGED TODAY',
          style: TextStyle(
            color: palette.muted,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.lime,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'CHECK IN',
        style: TextStyle(
          color: AppColors.ink,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final palette = context.palette;
    final icon = _isQuit ? Icons.block_rounded : Icons.trending_up_rounded;
    final iconBackground = _isQuit ? palette.inkSurface : palette.leafSoft;
    final iconColor = _isQuit ? AppColors.lime : palette.leaf;
    final barColor = _isQuit ? palette.emphasis : AppColors.success;

    return Material(
      color: palette.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: palette.border),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: iconBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tracker.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: palette.ink,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _subtitle(now),
                          style: TextStyle(color: palette.muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _status(now, palette),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: tracker.progress,
                  minHeight: 6,
                  color: barColor,
                  backgroundColor: palette.sage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
