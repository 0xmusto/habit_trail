import 'package:flutter/widgets.dart';

import '../../../../core/home_widget/home_widget_service.dart';
import '../../../../core/notifications/notification_service.dart';
import '../../../rewards/domain/reward.dart';
import '../../data/tracker_repository.dart';
import '../../domain/habit_mode.dart';
import '../../domain/habit_tracker.dart';

class TrackerController extends ChangeNotifier {
  TrackerController({required this.repository, required this.notifications});

  final TrackerRepository repository;
  final NotificationService notifications;

  List<HabitTracker> _trackers = [];
  List<Reward> _rewards = [];

  List<HabitTracker> get trackers => List.unmodifiable(_trackers);

  List<Reward> get rewards => List.unmodifiable(_rewards);

  HabitTracker? byId(int id) {
    for (final tracker in _trackers) {
      if (tracker.id == id) return tracker;
    }
    return null;
  }

  Future<void> load() async {
    _trackers = await repository.load();
    _rewards = await repository.loadRewards();
    notifyListeners();
    for (final tracker in _trackers) {
      await _syncReminder(tracker);
    }
    await _syncWidget();
  }

  Future<HabitTracker> create({
    required String name,
    required HabitMode mode,
    required int totalDays,
    required int reminderHour,
    required int reminderMinute,
  }) async {
    final tracker = HabitTracker(
      id: DateTime.now().millisecondsSinceEpoch % 2147483647,
      name: name.trim(),
      mode: mode,
      totalDays: totalDays,
      reminderHour: reminderHour,
      reminderMinute: reminderMinute,
      startDate: HabitTracker.dateOnly(DateTime.now()),
    );
    _trackers = [..._trackers, tracker];
    await repository.save(_trackers);
    await notifications.requestPermission();
    await _syncReminder(tracker);
    await _syncWidget();
    notifyListeners();
    return tracker;
  }

  /// Returns the reward if this check-in finished the goal.
  Future<Reward?> checkIn({
    required int id,
    required int day,
    required bool success,
  }) async {
    final index = _trackers.indexWhere((t) => t.id == id);
    if (index == -1) return null;
    final updated = _trackers[index].withResult(day, success: success);
    _trackers = [..._trackers]..[index] = updated;
    await repository.save(_trackers);

    Reward? earned;
    if (updated.isCompleted && !_rewards.any((r) => r.trackerId == id)) {
      earned = Reward.fromTracker(updated, DateTime.now());
      _rewards = [..._rewards, earned];
      await repository.saveRewards(_rewards);
    }

    await _syncReminder(updated);
    await _syncWidget();
    notifyListeners();
    return earned;
  }

  Future<void> updateReminder({
    required int id,
    required int hour,
    required int minute,
  }) async {
    final index = _trackers.indexWhere((t) => t.id == id);
    if (index == -1) return;
    final updated = _trackers[index].withReminder(hour, minute);
    _trackers = [..._trackers]..[index] = updated;
    await repository.save(_trackers);
    await notifications.cancel(id);
    await _syncReminder(updated);
    notifyListeners();
  }

  Future<void> delete(int id) async {
    _trackers = _trackers.where((t) => t.id != id).toList();
    await repository.save(_trackers);
    await notifications.cancel(id);
    await _syncWidget();
    notifyListeners();
  }

  Future<void> _syncWidget() =>
      HomeWidgetService.update(_trackers, DateTime.now());

  Future<void> _syncReminder(HabitTracker tracker) async {
    final now = DateTime.now();
    if (tracker.isActive(now)) {
      await notifications.scheduleDaily(
        id: tracker.id,
        title: 'Time to check in',
        body: tracker.mode.question(tracker.name),
        hour: tracker.reminderHour,
        minute: tracker.reminderMinute,
        skipToday: tracker.isCheckedIn(now),
      );
    } else {
      await notifications.cancel(tracker.id);
    }
  }
}

class TrackerScope extends InheritedNotifier<TrackerController> {
  const TrackerScope({
    super.key,
    required TrackerController controller,
    required super.child,
  }) : super(notifier: controller);

  /// Rebuilds the caller whenever trackers change.
  static TrackerController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TrackerScope>()!.notifier!;

  /// For callbacks and handlers that should not trigger rebuilds.
  static TrackerController read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<TrackerScope>()!.notifier!;
}
