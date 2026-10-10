import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/habit_tracker.dart';
import '../controllers/tracker_controller.dart';
import '../widgets/check_in_sheet.dart';
import '../widgets/day_trail.dart';
import '../widgets/reminder_time_tile.dart';
import '../widgets/tracker_header.dart';
import '../widgets/tracker_stats_card.dart';

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key, required this.trackerId});

  final int trackerId;

  void _openCheckIn(BuildContext context, HabitTracker tracker, int day) {
    final controller = TrackerScope.read(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => CheckInSheet(
        tracker: tracker,
        day: day,
        onAnswer: (success) =>
            controller.checkIn(id: tracker.id, day: day, success: success),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final controller = TrackerScope.read(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete this habit?'),
        content: const Text('Your progress and reminders will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await controller.delete(trackerId);
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final tracker = TrackerScope.of(context).byId(trackerId);
    if (tracker == null) return const Scaffold();
    final now = DateTime.now();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
              child: TrackerHeader(
                tracker: tracker,
                onBack: () => context.pop(),
                onDelete: () => _confirmDelete(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
              child: TrackerStatsCard(tracker: tracker, now: now),
            ),
            if (tracker.isActive(now))
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
                child: ReminderTimeTile(
                  time: TimeOfDay(
                    hour: tracker.reminderHour,
                    minute: tracker.reminderMinute,
                  ),
                  subtitle: tracker.nextReminderIsToday(now)
                      ? 'Next reminder: today'
                      : 'Next reminder: tomorrow',
                  onChanged: (time) => TrackerScope.read(context)
                      .updateReminder(
                        id: tracker.id,
                        hour: time.hour,
                        minute: time.minute,
                      ),
                ),
              ),
            const SizedBox(height: 8),
            Expanded(
              child: DayTrail(
                tracker: tracker,
                now: now,
                onDayTap: (day) => _openCheckIn(context, tracker, day),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
