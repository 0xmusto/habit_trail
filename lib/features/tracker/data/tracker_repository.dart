import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../rewards/domain/reward.dart';
import '../domain/habit_tracker.dart';

class TrackerRepository {
  static const _key = 'habit_trackers';
  static const _rewardsKey = 'habit_rewards';

  Future<List<HabitTracker>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    return (jsonDecode(raw) as List<dynamic>)
        .map((e) => HabitTracker.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> save(List<HabitTracker> trackers) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(trackers.map((t) => t.toJson()).toList()),
    );
  }

  Future<List<Reward>> loadRewards() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_rewardsKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List<dynamic>)
        .map((e) => Reward.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveRewards(List<Reward> rewards) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _rewardsKey,
      jsonEncode(rewards.map((r) => r.toJson()).toList()),
    );
  }
}
