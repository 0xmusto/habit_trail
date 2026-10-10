import 'habit_mode.dart';

enum DayState { success, failed, today, pending, locked }

class HabitTracker {
  const HabitTracker({
    required this.id,
    required this.name,
    required this.mode,
    required this.totalDays,
    required this.reminderHour,
    required this.reminderMinute,
    required this.startDate,
    this.results = const {},
  });

  factory HabitTracker.fromJson(Map<String, dynamic> json) => HabitTracker(
    id: json['id'] as int,
    name: json['name'] as String,
    mode: HabitMode.values.byName(json['mode'] as String),
    totalDays: json['totalDays'] as int,
    reminderHour: json['reminderHour'] as int,
    reminderMinute: json['reminderMinute'] as int,
    startDate: DateTime.parse(json['startDate'] as String),
    results: {
      for (final e in (json['results'] as Map<String, dynamic>).entries)
        int.parse(e.key): e.value as bool,
    },
  );

  final int id;
  final String name;
  final HabitMode mode;
  final int totalDays;
  final int reminderHour;
  final int reminderMinute;
  final DateTime startDate;

  /// Day number (1-based) to whether the day was a success for this mode.
  final Map<int, bool> results;

  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'mode': mode.name,
    'totalDays': totalDays,
    'reminderHour': reminderHour,
    'reminderMinute': reminderMinute,
    'startDate': startDate.toIso8601String(),
    'results': {for (final e in results.entries) '${e.key}': e.value},
  };

  HabitTracker withResult(int day, {required bool success}) => HabitTracker(
    id: id,
    name: name,
    mode: mode,
    totalDays: totalDays,
    reminderHour: reminderHour,
    reminderMinute: reminderMinute,
    startDate: startDate,
    results: {...results, day: success},
  );

  String get title => mode.displayName(name);

  HabitTracker withReminder(int hour, int minute) => HabitTracker(
    id: id,
    name: name,
    mode: mode,
    totalDays: totalDays,
    reminderHour: hour,
    reminderMinute: minute,
    startDate: startDate,
    results: results,
  );

  /// False when today is already answered or today's reminder time has passed.
  bool nextReminderIsToday(DateTime now) {
    if (!isActive(now) || isCheckedIn(now)) return false;
    final today = DateTime(
      now.year,
      now.month,
      now.day,
      reminderHour,
      reminderMinute,
    );
    return today.isAfter(now);
  }

  // UTC dates avoid DST making a calendar day 23 or 25 hours long.
  int _rawDay(DateTime now) =>
      DateTime.utc(now.year, now.month, now.day)
          .difference(
            DateTime.utc(startDate.year, startDate.month, startDate.day),
          )
          .inDays +
      1;

  int currentDay(DateTime now) => _rawDay(now).clamp(1, totalDays).toInt();

  bool hasEnded(DateTime now) => _rawDay(now) > totalDays;

  bool get isCompleted => results.length >= totalDays;

  bool isActive(DateTime now) => !isCompleted && !hasEnded(now);

  bool isCheckedIn(DateTime now) => results.containsKey(currentDay(now));

  int get successCount => results.values.where((r) => r).length;

  int get failedCount => results.values.where((r) => !r).length;

  double get progress => results.length / totalDays;

  int streak(DateTime now) {
    final today = currentDay(now);
    var count = 0;
    for (var day = today; day >= 1; day--) {
      final result = results[day];
      if (result == true) {
        count++;
      } else if (result == null && day == today) {
        continue;
      } else {
        break;
      }
    }
    return count;
  }

  DayState dayState(int day, DateTime now) {
    final result = results[day];
    if (result != null) return result ? DayState.success : DayState.failed;
    if (hasEnded(now)) return DayState.pending;
    final today = currentDay(now);
    if (day == today) return DayState.today;
    return day < today ? DayState.pending : DayState.locked;
  }
}
