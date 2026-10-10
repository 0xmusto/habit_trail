import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../domain/habit_tracker.dart';

class TrackerHeader extends StatelessWidget {
  const TrackerHeader({
    super.key,
    required this.tracker,
    required this.onBack,
    required this.onDelete,
  });

  final HabitTracker tracker;
  final VoidCallback onBack;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: [
        IconButton.filled(
          onPressed: onBack,
          style: IconButton.styleFrom(
            backgroundColor: palette.sage,
            foregroundColor: palette.ink,
          ),
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Back',
        ),
        const SizedBox(width: 12),
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
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${tracker.mode.title} · ${tracker.totalDays} days',
                style: TextStyle(color: palette.muted, fontSize: 12),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          tooltip: 'More',
          icon: Icon(Icons.more_horiz_rounded, color: palette.ink),
          onSelected: (_) => onDelete(),
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'delete', child: Text('Delete habit')),
          ],
        ),
      ],
    );
  }
}
