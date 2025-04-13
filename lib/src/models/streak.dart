import 'package:flutter/foundation.dart';

@immutable
class Streak {
  final String id;
  final int currentStreak;
  final int longestStreak;
  final DateTime lastActivityDate;
  final String streakType;
  final Map<String, dynamic>? metadata;

  const Streak({
    required this.id,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastActivityDate,
    required this.streakType,
    this.metadata,
  });

  Streak copyWith({
    String? id,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActivityDate,
    String? streakType,
    Map<String, dynamic>? metadata,
  }) {
    return Streak(
      id: id ?? this.id,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      streakType: streakType ?? this.streakType,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastActivityDate': lastActivityDate.toIso8601String(),
      'streakType': streakType,
      'metadata': metadata,
    };
  }

  factory Streak.fromJson(Map<String, dynamic> json) {
    return Streak(
      id: json['id'] as String,
      currentStreak: json['currentStreak'] as int,
      longestStreak: json['longestStreak'] as int,
      lastActivityDate: DateTime.parse(json['lastActivityDate'] as String),
      streakType: json['streakType'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  bool isStreakActive() {
    final now = DateTime.now();
    final difference = now.difference(lastActivityDate);
    return difference.inDays <= 1;
  }

  int getDaysSinceLastActivity() {
    final now = DateTime.now();
    return now.difference(lastActivityDate).inDays;
  }

  Streak updateStreak() {
    final now = DateTime.now();
    final daysSinceLastActivity = getDaysSinceLastActivity();

    if (daysSinceLastActivity == 0) {
      // Already updated today
      return this;
    }

    int newCurrentStreak = currentStreak;
    if (daysSinceLastActivity == 1) {
      // Consecutive day
      newCurrentStreak++;
    } else {
      // Streak broken
      newCurrentStreak = 1;
    }

    return Streak(
      id: id,
      currentStreak: newCurrentStreak,
      longestStreak: newCurrentStreak > longestStreak ? newCurrentStreak : longestStreak,
      lastActivityDate: now,
      streakType: streakType,
      metadata: metadata,
    );
  }
} 