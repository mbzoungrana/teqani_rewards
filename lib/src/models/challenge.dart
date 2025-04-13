import 'package:flutter/foundation.dart';

@immutable
class Challenge {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int points;
  final int bonusPoints;
  final DateTime? bonusDeadline;
  final bool isCompleted;
  final double progress;
  final DateTime lastUpdated;
  final Map<String, dynamic>? metadata;
  final String type;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.points,
    this.bonusPoints = 0,
    this.bonusDeadline,
    this.isCompleted = false,
    this.progress = 0.0,
    required this.type,
    DateTime? lastUpdated,
    this.metadata,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  Challenge copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    int? points,
    int? bonusPoints,
    DateTime? bonusDeadline,
    bool? isCompleted,
    double? progress,
    String? type,
    DateTime? lastUpdated,
    Map<String, dynamic>? metadata,
  }) {
    return Challenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      points: points ?? this.points,
      bonusPoints: bonusPoints ?? this.bonusPoints,
      bonusDeadline: bonusDeadline ?? this.bonusDeadline,
      isCompleted: isCompleted ?? this.isCompleted,
      progress: progress ?? this.progress,
      type: type ?? this.type,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'points': points,
      'bonusPoints': bonusPoints,
      'bonusDeadline': bonusDeadline?.toIso8601String(),
      'isCompleted': isCompleted,
      'progress': progress,
      'type': type,
      'lastUpdated': lastUpdated.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      points: json['points'] as int,
      type: json['type'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      progress: (json['progress'] as num).toDouble(),
      isCompleted: json['isCompleted'] as bool? ?? false,
      lastUpdated: json['lastUpdated'] != null ? DateTime.parse(json['lastUpdated'] as String) : null,
    );
  }

  Challenge updateProgress(double newProgress) {
    return Challenge(
      id: id,
      title: title,
      description: description,
      points: points,
      type: type,
      startDate: startDate,
      endDate: endDate,
      progress: newProgress.clamp(0.0, 1.0),
      isCompleted: newProgress >= 1.0,
      lastUpdated: DateTime.now(),
    );
  }

  bool isActive() {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  bool isBonusAvailable() {
    if (bonusDeadline == null) return false;
    final now = DateTime.now();
    return now.isBefore(bonusDeadline!);
  }

  Duration getRemainingTime() {
    final now = DateTime.now();
    return endDate.difference(now);
  }

  Duration? getBonusRemainingTime() {
    if (bonusDeadline == null) return null;
    final now = DateTime.now();
    return bonusDeadline!.difference(now);
  }
} 