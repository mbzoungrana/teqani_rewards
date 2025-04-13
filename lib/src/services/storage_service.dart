import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import '../models/achievement.dart';
import '../models/streak.dart';
import '../models/challenge.dart';
import '../models/storage_type.dart';

/// Service to handle all storage operations for Teqani Rewards
class TeqaniStorageService {
  final StorageType _storageType;
  
  SharedPreferences? _prefs;
  Database? _database;
  Box? _hiveBox;
  FirebaseFirestore? _firestore;
  FirebaseAuth? _auth;
  String? _userId;

  TeqaniStorageService({
    required StorageType storageType,
    Map<String, dynamic>? options,
  }) : _storageType = storageType;

  /// Initialize the storage service
  Future<void> initialize({String? userId}) async {
    _userId = userId;
    
    switch (_storageType) {
      case StorageType.sharedPreferences:
        _prefs = await SharedPreferences.getInstance();
        break;
      case StorageType.sqlite:
        final dbPath = await getDatabasesPath();
        _database = await openDatabase(
          join(dbPath, 'teqani_rewards.db'),
          onCreate: (db, version) async {
            await db.execute('''
              CREATE TABLE achievements(
                id TEXT PRIMARY KEY,
                title TEXT,
                description TEXT,
                points INTEGER,
                isUnlocked INTEGER,
                unlockedAt TEXT
              )
            ''');
            await db.execute('''
              CREATE TABLE streaks(
                streakType TEXT PRIMARY KEY,
                currentStreak INTEGER,
                longestStreak INTEGER,
                lastActivityDate TEXT
              )
            ''');
            await db.execute('''
              CREATE TABLE challenges(
                id TEXT PRIMARY KEY,
                title TEXT,
                description TEXT,
                points INTEGER,
                type TEXT,
                progress REAL,
                startDate TEXT,
                endDate TEXT,
                isCompleted INTEGER,
                lastUpdated TEXT
              )
            ''');
          },
          version: 1,
        );
        break;
      case StorageType.hive:
        await Hive.initFlutter();
        _hiveBox = await Hive.openBox('teqani_rewards');
        break;
      case StorageType.firebase:
        _firestore = FirebaseFirestore.instance;
        _auth = FirebaseAuth.instance;
        _userId ??= _auth?.currentUser?.uid;
        break;
    }
  }

  // Achievement Methods
  Future<List<Achievement>> getAchievements() async {
    switch (_storageType) {
      case StorageType.sharedPreferences:
        final achievementsJson = _prefs?.getString('achievements_$_userId');
        if (achievementsJson == null) return [];
        final List<dynamic> decoded = jsonDecode(achievementsJson);
        return decoded.map((json) => Achievement.fromJson(json)).toList();
        
      case StorageType.sqlite:
        final List<Map<String, dynamic>> maps = await _database!.query('achievements');
        return maps.map((map) => Achievement.fromJson(map)).toList();
        
      case StorageType.hive:
        final achievementsJson = _hiveBox?.get('achievements_$_userId');
        if (achievementsJson == null) return [];
        final List<dynamic> decoded = jsonDecode(achievementsJson);
        return decoded.map((json) => Achievement.fromJson(json)).toList();
        
      case StorageType.firebase:
        if (_userId == null) throw Exception('User not authenticated');
        final snapshot = await _firestore!
            .collection('users')
            .doc(_userId)
            .collection('achievements')
            .get();
        return snapshot.docs.map((doc) => Achievement.fromJson(doc.data())).toList();
    }
  }

  Future<void> saveAchievement(Achievement achievement) async {
    switch (_storageType) {
      case StorageType.sharedPreferences:
        final achievements = await getAchievements();
        final index = achievements.indexWhere((a) => a.id == achievement.id);
        if (index != -1) {
          achievements[index] = achievement;
        } else {
          achievements.add(achievement);
        }
        await _prefs?.setString(
          'achievements_$_userId',
          jsonEncode(achievements.map((a) => a.toJson()).toList()),
        );
        break;
        
      case StorageType.sqlite:
        await _database!.insert(
          'achievements',
          achievement.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        break;
        
      case StorageType.hive:
        final achievements = await getAchievements();
        final index = achievements.indexWhere((a) => a.id == achievement.id);
        if (index != -1) {
          achievements[index] = achievement;
        } else {
          achievements.add(achievement);
        }
        await _hiveBox?.put(
          'achievements_$_userId',
          jsonEncode(achievements.map((a) => a.toJson()).toList()),
        );
        break;
        
      case StorageType.firebase:
        if (_userId == null) throw Exception('User not authenticated');
        await _firestore!
            .collection('users')
            .doc(_userId)
            .collection('achievements')
            .doc(achievement.id)
            .set(achievement.toJson());
        break;
    }
  }

  // Streak Methods
  Future<Streak> getStreak(String streakType) async {
    switch (_storageType) {
      case StorageType.sharedPreferences:
        final streakJson = _prefs?.getString('streak_${_userId}_$streakType');
        if (streakJson == null) {
          return Streak(
            id: streakType,
            currentStreak: 0,
            longestStreak: 0,
            lastActivityDate: DateTime.now(),
            streakType: streakType,
          );
        }
        return Streak.fromJson(jsonDecode(streakJson));
        
      case StorageType.sqlite:
        final List<Map<String, dynamic>> maps = await _database!.query(
          'streaks',
          where: 'streakType = ?',
          whereArgs: [streakType],
        );
        if (maps.isEmpty) {
          return Streak(
            id: streakType,
            currentStreak: 0,
            longestStreak: 0,
            lastActivityDate: DateTime.now(),
            streakType: streakType,
          );
        }
        return Streak.fromJson(maps.first);
        
      case StorageType.hive:
        final streakJson = _hiveBox?.get('streak_${_userId}_$streakType');
        if (streakJson == null) {
          return Streak(
            id: streakType,
            currentStreak: 0,
            longestStreak: 0,
            lastActivityDate: DateTime.now(),
            streakType: streakType,
          );
        }
        return Streak.fromJson(jsonDecode(streakJson));
        
      case StorageType.firebase:
        if (_userId == null) throw Exception('User not authenticated');
        final doc = await _firestore!
            .collection('users')
            .doc(_userId)
            .collection('streaks')
            .doc(streakType)
            .get();
        if (!doc.exists) {
          return Streak(
            id: streakType,
            currentStreak: 0,
            longestStreak: 0,
            lastActivityDate: DateTime.now(),
            streakType: streakType,
          );
        }
        return Streak.fromJson(doc.data()!);
    }
  }

  Future<void> saveStreak(Streak streak) async {
    if (_storageType == StorageType.sqlite) {
      final db = _database;
      await db!.insert(
        'streaks',
        {
          'id': streak.id,
          'currentStreak': streak.currentStreak,
          'longestStreak': streak.longestStreak,
          'lastActivityDate': streak.lastActivityDate.toIso8601String(),
          'streakType': streak.streakType,
          'metadata': jsonEncode(streak.metadata ?? {}),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await _hiveBox?.put(
        'streak_${_userId}_${streak.streakType}',
        jsonEncode(streak.toJson()),
      );
    }
  }

  Future<List<Streak>> getStreaks() async {
    if (_storageType == StorageType.sqlite) {
      final db = _database;
      final List<Map<String, dynamic>> maps = await db!.query('streaks');
      return maps.map((map) {
        return Streak(
          id: map['id'],
          currentStreak: map['currentStreak'],
          longestStreak: map['longestStreak'],
          lastActivityDate: DateTime.parse(map['lastActivityDate']),
          streakType: map['streakType'],
          metadata: map['metadata'] != null ? jsonDecode(map['metadata']) : null,
        );
      }).toList();
    } else {
      final List<Streak> streaks = await getStreaks();
      return streaks;
    }
  }

  // Challenge Methods
  Future<List<Challenge>> getChallenges() async {
    if (_storageType == StorageType.sqlite) {
      final db = _database;
      final List<Map<String, dynamic>> maps = await db!.query('challenges');
      return maps.map((map) {
        return Challenge(
          id: map['id'],
          title: map['title'],
          description: map['description'],
          points: map['points'],
          type: map['type'],
          progress: map['progress'],
          startDate: map['startDate'] != null ? DateTime.parse(map['startDate']) : DateTime.now(),
          endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : DateTime.now(),
          isCompleted: map['isCompleted'] == 1,
        );
      }).toList();
    } else {
      switch (_storageType) {
        case StorageType.sharedPreferences:
          final challengesJson = _prefs?.getString('challenges_$_userId');
          if (challengesJson == null) return [];
          final List<dynamic> decoded = jsonDecode(challengesJson);
          return decoded.map((json) => Challenge.fromJson(json)).toList();
            
        case StorageType.hive:
          final challengesJson = _hiveBox?.get('challenges_$_userId');
          if (challengesJson == null) return [];
          final List<dynamic> decoded = jsonDecode(challengesJson);
          return decoded.map((json) => Challenge.fromJson(json)).toList();
            
        case StorageType.firebase:
          if (_userId == null) throw Exception('User not authenticated');
          final snapshot = await _firestore!
              .collection('users')
              .doc(_userId)
              .collection('challenges')
              .get();
          return snapshot.docs.map((doc) => Challenge.fromJson(doc.data())).toList();
            
        case StorageType.sqlite:
          return []; // This case is already handled above
      }
    }
  }

  Future<void> saveChallenge(Challenge challenge) async {
    if (_storageType == StorageType.sqlite) {
      final db = _database;
      await db!.insert(
        'challenges',
        {
          'id': challenge.id,
          'title': challenge.title,
          'description': challenge.description,
          'points': challenge.points,
          'type': challenge.type,
          'progress': challenge.progress,
          'startDate': challenge.startDate.toIso8601String(),
          'endDate': challenge.endDate.toIso8601String(),
          'isCompleted': challenge.isCompleted ? 1 : 0,
          'lastUpdated': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await _hiveBox?.put(
        'challenge_${_userId}_${challenge.id}',
        jsonEncode(challenge.toJson()),
      );
    }
  }
} 