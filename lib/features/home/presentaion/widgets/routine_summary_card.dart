import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';

class RoutineSummaryCard extends StatelessWidget {
  const RoutineSummaryCard({
    super.key,
    required this.habitCount,
    required this.dueToday,
  });

  final int habitCount;

  /// Active habits that have not been checked in today.
  final int dueToday;

  String get _headline {
    if (habitCount == 0) return 'Small steps\nmake a big difference.';
    if (dueToday > 0) {
      return dueToday == 1
          ? '1 check-in\nwaiting for you.'
          : '$dueToday check-ins\nwaiting for you.';
    }
    return 'All caught up.\nSee you tomorrow.';
  }

  String get _subtitle {
    if (habitCount == 0) return 'Pick one thing you’d like to change.';
    if (dueToday > 0) return 'Open a habit and log how today went.';
    return 'Keep showing up, one day at a time.';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: context.palette.inkSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'YOUR ROUTINE',
                  style: TextStyle(
                    color: Color(0xFFB9D4C8),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lime,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$habitCount ${habitCount == 1 ? 'HABIT' : 'HABITS'}',
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            _headline,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              height: 1.18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _subtitle,
            style: const TextStyle(
              color: Color(0xFFD1DED8),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
