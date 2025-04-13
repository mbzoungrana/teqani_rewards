import 'package:flutter/foundation.dart';

@immutable
class Achievement {
  final String id;
  final String title;
  final String description;
  final int points;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final Map<String, dynamic>? metadata;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    this.isUnlocked = false,
    this.unlockedAt,
    this.metadata,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    int? points,
    bool? isUnlocked,
    DateTime? unlockedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      points: points ?? this.points,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'points': points,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      points: json['points'] as int,
      isUnlocked: json['isUnlocked'] as bool,
      unlockedAt: json['unlockedAt'] != null ? DateTime.parse(json['unlockedAt'] as String) : null,
    );
  }

  Achievement unlock() {
    return Achievement(
      id: id,
      title: title,
      description: description,
      points: points,
      isUnlocked: true,
      unlockedAt: DateTime.now(),
    );
  }
} 