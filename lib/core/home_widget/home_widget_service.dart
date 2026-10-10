import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

import '../../features/tracker/domain/habit_tracker.dart';

/// Pushes every active tracker to the Android home-screen widget, which lets the user flip between them.
abstract final class HomeWidgetService {
  static const _androidName = 'HabitWidgetProvider';
  static const _windowSize = 7;

  static bool get _supported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// Calls [onOpen] with the tracker id when the user taps the widget.
  static void listenForTaps(void Function(int id) onOpen) {
    if (!_supported) return;
    void handle(Uri? uri) {
      final id = int.tryParse(uri?.queryParameters['id'] ?? '');
      if (id != null) onOpen(id);
    }

    HomeWidget.initiallyLaunchedFromHomeWidget().then(handle).catchError((
      Object e,
    ) {
      debugPrint('Home widget launch check failed: $e');
    });
    HomeWidget.widgetClicked.listen(handle);
  }

  static Future<void> update(List<HabitTracker> trackers, DateTime now) async {
    if (!_supported) return;
    try {
      final active = trackers.where((t) => t.isActive(now)).toList();
      final firstPending = active.indexWhere((t) => !t.isCheckedIn(now));

      await HomeWidget.saveWidgetData<int>('hw_count', active.length);
      await HomeWidget.saveWidgetData<int>(
        'hw_default',
        firstPending < 0 ? 0 : firstPending,
      );
      for (var i = 0; i < active.length; i++) {
        await _saveTracker(i, active[i], now);
      }
      await HomeWidget.updateWidget(androidName: _androidName);
    } catch (e) {
      // Widgets are optional; never let them break the app.
      debugPrint('Home widget update failed: $e');
    }
  }

  static Future<void> _saveTracker(
    int index,
    HabitTracker tracker,
    DateTime now,
  ) async {
    final today = tracker.currentDay(now);
    final maxFirst = math.max(1, tracker.totalDays - _windowSize + 1);
    final firstDay = (today - 3).clamp(1, maxFirst).toInt();
    final lastDay = math.min(tracker.totalDays, firstDay + _windowSize - 1);

    final days = StringBuffer();
    for (var d = firstDay; d <= lastDay; d++) {
      days.write(switch (tracker.dayState(d, now)) {
        DayState.success => 's',
        DayState.failed => 'f',
        DayState.today => 't',
        DayState.pending => 'p',
        DayState.locked => 'l',
      });
    }

    final p = 'hw_${index}_';
    await HomeWidget.saveWidgetData<String>('${p}id', '${tracker.id}');
    await HomeWidget.saveWidgetData<String>('${p}title', tracker.title);
    await HomeWidget.saveWidgetData<int>('${p}streak', tracker.streak(now));
    await HomeWidget.saveWidgetData<String>(
      '${p}status',
      'Day $today of ${tracker.totalDays}',
    );
    await HomeWidget.saveWidgetData<bool>(
      '${p}checked',
      tracker.isCheckedIn(now),
    );
    await HomeWidget.saveWidgetData<int>('${p}first_day', firstDay);
    await HomeWidget.saveWidgetData<String>('${p}days', days.toString());
    await HomeWidget.saveWidgetData<int>(
      '${p}percent',
      (tracker.progress * 100).round(),
    );
    await HomeWidget.saveWidgetData<String>('${p}date', _dateKey(now));
  }

  static String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
