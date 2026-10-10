import '../../tracker/domain/habit_tracker.dart';
import 'badge_tier.dart';

class Reward {
  const Reward({
    required this.trackerId,
    required this.habitTitle,
    required this.totalDays,
    required this.successCount,
    required this.earnedAt,
  });

  factory Reward.fromTracker(HabitTracker tracker, DateTime earnedAt) => Reward(
    trackerId: tracker.id,
    habitTitle: tracker.title,
    totalDays: tracker.totalDays,
    successCount: tracker.successCount,
    earnedAt: earnedAt,
  );

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
    trackerId: json['trackerId'] as int,
    habitTitle: json['habitTitle'] as String,
    totalDays: json['totalDays'] as int,
    successCount: json['successCount'] as int,
    earnedAt: DateTime.parse(json['earnedAt'] as String),
  );

  final int trackerId;
  final String habitTitle;
  final int totalDays;
  final int successCount;
  final DateTime earnedAt;

  BadgeTier get tier => BadgeTier.forDays(totalDays);

  bool get isPerfect => successCount == totalDays;

  Map<String, dynamic> toJson() => {
    'trackerId': trackerId,
    'habitTitle': habitTitle,
    'totalDays': totalDays,
    'successCount': successCount,
    'earnedAt': earnedAt.toIso8601String(),
  };
}
