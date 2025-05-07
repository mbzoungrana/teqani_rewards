import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../../teqani_rewards.dart';
import '../services/encryption_service.dart';

/// Manages data persistence for the Teqani Rewards package
class StorageManager {
  final StorageType storageType;
  final Map<String, dynamic>? options;

  late SharedPreferences _prefs;
  late Database _database;
  late Box _hiveBox;
  late FirebaseFirestore _firestore;
  late dynamic _customStorage;
  late EncryptionService _encryptionService;

  StorageManager({
    required this.storageType,
    this.options,
  });

  /// Initialize the storage manager based on the selected storage type
  Future<void> initialize() async {
    _encryptionService = EncryptionService();
    await _encryptionService.initialize();

    switch (storageType) {
      case StorageType.sharedPreferences:
        _prefs = await SharedPreferences.getInstance();
        _logStorageInitialized('shared_preferences');
        break;

      case StorageType.sqlite:
        final dbPath = await getDatabasesPath();
        final path = join(dbPath, 'teqani_rewards.db');
        _database = await openDatabase(
          path,
          version: 5,
          onCreate: (db, version) async {
            await db.execute('''
              CREATE TABLE achievements (
                id TEXT PRIMARY KEY,
                title TEXT,
                description TEXT,
                points INTEGER,
                isUnlocked INTEGER,
                unlockedAt TEXT,
                metadata TEXT
              )
            ''');
            await db.execute('''
              CREATE TABLE streaks (
                id TEXT PRIMARY KEY,
                currentStreak INTEGER,
                longestStreak INTEGER,
                lastActivityDate TEXT,
                streakType TEXT,
                type TEXT,
                metadata TEXT,
                title TEXT,
                description TEXT,
                startDate TEXT,
                endDate TEXT,
                points INTEGER,
                bonusPoints INTEGER,
                bonusDeadline TEXT,
                isCompleted INTEGER,
                progress REAL,
                lastUpdated TEXT
              )
            ''');
            await db.execute('''
              CREATE TABLE challenges (
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
          onUpgrade: (db, oldVersion, newVersion) async {
            // Drop all tables and recreate them
            await db.execute('DROP TABLE IF EXISTS achievements');
            await db.execute('DROP TABLE IF EXISTS streaks');
            await db.execute('DROP TABLE IF EXISTS challenges');

            // Recreate tables with new schema
            await db.execute('''
              CREATE TABLE achievements (
                id TEXT PRIMARY KEY,
                title TEXT,
                description TEXT,
                points INTEGER,
                isUnlocked INTEGER,
                unlockedAt TEXT,
                metadata TEXT
              )
            ''');
            await db.execute('''
              CREATE TABLE streaks (
                id TEXT PRIMARY KEY,
                currentStreak INTEGER,
                longestStreak INTEGER,
                lastActivityDate TEXT,
                streakType TEXT,
                type TEXT,
                metadata TEXT,
                title TEXT,
                description TEXT,
                startDate TEXT,
                endDate TEXT,
                points INTEGER,
                bonusPoints INTEGER,
                bonusDeadline TEXT,
                isCompleted INTEGER,
                progress REAL,
                lastUpdated TEXT
              )
            ''');
            await db.execute('''
              CREATE TABLE challenges (
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
        );
        _logStorageInitialized('sqlite');
        break;

      case StorageType.hive:
        await Hive.initFlutter();
        _hiveBox = await Hive.openBox('teqani_rewards');
        _logStorageInitialized('hive');
        break;

      case StorageType.firebase:
        _firestore = FirebaseFirestore.instance;
        _logStorageInitialized('firebase');
        break;

      case StorageType.custom:
        if (options == null || !options!.containsKey('storage')) {
          throw Exception(
              'Custom storage implementation must be provided in options');
        }
        _customStorage = options!['storage'];
        _logStorageInitialized('custom');
        break;
    }
  }

  /// Log storage initialization event
  Future<void> _logStorageInitialized(String storageType) async {
    try {
      final analytics = FirebaseAnalytics.instance;
      await analytics.logEvent(
        name: 'storage_initialized',
        parameters: {
          'storage_type': storageType,
        },
      );
    } catch (e) {
      // Ignore analytics errors
    }
  }

  /// Save an achievement
  Future<void> saveAchievement(Map<String, dynamic> achievement) async {
    // Encrypt sensitive data for local storage
    if (storageType == StorageType.sharedPreferences ||
        storageType == StorageType.sqlite ||
        storageType == StorageType.hive) {
      achievement = _encryptionService.encryptMap(achievement);
    }

    switch (storageType) {
      case StorageType.sharedPreferences:
        final achievements = _prefs.getStringList('achievements') ?? [];
        final achievementId = achievement['id'] as String;

        // Find and update existing achievement if it exists
        bool found = false;
        for (int i = 0; i < achievements.length; i++) {
          final existingAchievement =
              jsonDecode(achievements[i]) as Map<String, dynamic>;
          if (existingAchievement['id'] == achievementId) {
            achievements[i] = jsonEncode(achievement);
            found = true;
            break;
          }
        }

        // If achievement doesn't exist, add it
        if (!found) {
          achievements.add(jsonEncode(achievement));
        }

        await _prefs.setStringList('achievements', achievements);
        break;

      case StorageType.sqlite:
        // Convert boolean to integer for SQLite and prepare data
        final achievementData = {
          'id': achievement['id'],
          'title': achievement['title'],
          'description': achievement['description'],
          'points': achievement['points'],
          'isUnlocked': achievement['isUnlocked'] ? 1 : 0,
          'unlockedAt': achievement['unlockedAt'] is DateTime
              ? achievement['unlockedAt'].toIso8601String()
              : achievement['unlockedAt'] ?? DateTime.now().toIso8601String(),
        };

        // Only add metadata if it exists and is not null
        if (achievement['metadata'] != null) {
          achievementData['metadata'] = jsonEncode(achievement['metadata']);
        }

        await _database.insert(
          'achievements',
          achievementData,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        break;

      case StorageType.hive:
        final achievementId = achievement['id'] as String;
        // Hive automatically updates if key exists
        await _hiveBox.put('achievement_$achievementId', {
          'id': achievement['id'],
          'title': achievement['title'],
          'description': achievement['description'],
          'points': achievement['points'],
          'isUnlocked': achievement['isUnlocked'],
          'unlockedAt': achievement['unlockedAt'],
        });
        break;

      case StorageType.firebase:
        final achievementId = achievement['id'] as String;
        // Firebase automatically updates if document exists
        await _firestore
            .collection('achievements')
            .doc(achievementId)
            .set(achievement);
        break;

      case StorageType.custom:
        // For custom storage, we'll try to get existing achievements first
        try {
          final existingAchievements = await _customStorage.getAchievements();
          final achievementId = achievement['id'] as String;
          bool found = false;

          for (int i = 0; i < existingAchievements.length; i++) {
            if (existingAchievements[i]['id'] == achievementId) {
              existingAchievements[i] = achievement;
              found = true;
              break;
            }
          }

          if (!found) {
            existingAchievements.add(achievement);
          }

          // Save the updated list back
          await _customStorage.saveAchievement(achievement);
        } catch (e) {
          // If custom storage doesn't support getAchievements, just save the new achievement
          await _customStorage.saveAchievement(achievement);
        }
        break;
    }

    // Log achievement saved event
    _logStorageEvent('achievement_saved',
        {'achievement_id': achievement['id'] ?? 'unknown'});
  }

  /// Get all achievements
  Future<List<Map<String, dynamic>>> getAchievements() async {
    List<Map<String, dynamic>> achievements;

    switch (storageType) {
      case StorageType.sharedPreferences:
        final achievementStrings = _prefs.getStringList('achievements') ?? [];
        achievements = achievementStrings
            .map((a) => jsonDecode(a) as Map<String, dynamic>)
            .toList();
        break;

      case StorageType.sqlite:
        achievements = await _database.query('achievements');
        break;

      case StorageType.hive:
        final achievementKeys = _hiveBox.keys
            .where((key) => key.toString().startsWith('achievement_'))
            .toList();
        achievements = achievementKeys.map((key) {
          final data = _hiveBox.get(key) as Map<String, dynamic>;
          return {
            'id': data['id'],
            'title': data['title'],
            'description': data['description'],
            'points': data['points'],
            'isUnlocked': data['isUnlocked'],
            'unlockedAt': data['unlockedAt'],
          };
        }).toList();
        break;

      case StorageType.firebase:
        final snapshot = await _firestore.collection('achievements').get();
        achievements = snapshot.docs.map((doc) => doc.data()).toList();
        break;

      case StorageType.custom:
        achievements = await _customStorage.getAchievements();
        break;
    }

    // Decrypt data for local storage
    if (storageType == StorageType.sharedPreferences ||
        storageType == StorageType.sqlite ||
        storageType == StorageType.hive) {
      achievements =
          achievements.map((a) => _encryptionService.decryptMap(a)).toList();
    }

    return achievements;
  }

  /// Save a streak
  Future<void> saveStreak(Map<String, dynamic> streak) async {
    switch (storageType) {
      case StorageType.sharedPreferences:
        final streaks = _prefs.getStringList('streaks') ?? [];
        final streakId = streak['id'] as String;

        // Find and update existing streak if it exists
        bool found = false;
        for (int i = 0; i < streaks.length; i++) {
          final existingStreak = jsonDecode(streaks[i]) as Map<String, dynamic>;
          if (existingStreak['id'] == streakId) {
            streaks[i] = jsonEncode(streak);
            found = true;
            break;
          }
        }

        // If streak doesn't exist, add it
        if (!found) {
          streaks.add(jsonEncode(streak));
        }

        await _prefs.setStringList('streaks', streaks);
        break;

      case StorageType.sqlite:
        // Convert boolean to integer for SQLite
        final streakData = Map<String, dynamic>.from(streak);
        if (streakData.containsKey('isCompleted')) {
          streakData['isCompleted'] = streakData['isCompleted'] ? 1 : 0;
        }

        await _database.insert(
          'streaks',
          streakData,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        break;

      case StorageType.hive:
        final streakId = streak['id'] as String;
        // Hive automatically updates if key exists
        await _hiveBox.put('streak_$streakId', {
          'id': streak['id'],
          'currentStreak': streak['currentStreak'],
          'longestStreak': streak['longestStreak'],
          'lastActivityDate': streak['lastActivityDate'],
          'streakType': streak['streakType'],
          'type': streak['type'],
          'metadata': streak['metadata'],
          'title': streak['title'],
          'description': streak['description'],
          'startDate': streak['startDate'],
          'endDate': streak['endDate'],
          'points': streak['points'],
          'bonusPoints': streak['bonusPoints'],
          'bonusDeadline': streak['bonusDeadline'],
          'isCompleted': streak['isCompleted'],
          'progress': streak['progress'],
          'lastUpdated': streak['lastUpdated'],
        });
        break;

      case StorageType.firebase:
        final streakId = streak['id'] as String;
        // Firebase automatically updates if document exists
        await _firestore.collection('streaks').doc(streakId).set(streak);
        break;

      case StorageType.custom:
        // For custom storage, we'll try to get existing streaks first
        try {
          final existingStreaks = await _customStorage.getStreaks();
          final streakId = streak['id'] as String;
          bool found = false;

          for (int i = 0; i < existingStreaks.length; i++) {
            if (existingStreaks[i]['id'] == streakId) {
              existingStreaks[i] = streak;
              found = true;
              break;
            }
          }

          if (!found) {
            existingStreaks.add(streak);
          }

          // Save the updated list back
          await _customStorage.saveStreak(streak);
        } catch (e) {
          // If custom storage doesn't support getStreaks, just save the new streak
          await _customStorage.saveStreak(streak);
        }
        break;
    }

    // Log streak saved event
    _logStorageEvent('streak_saved', {'streak_id': streak['id'] ?? 'unknown'});
  }

  /// Get all streaks
  Future<List<Map<String, dynamic>>> getStreaks() async {
    switch (storageType) {
      case StorageType.sharedPreferences:
        final streaks = _prefs.getStringList('streaks') ?? [];
        return streaks
            .map((s) => jsonDecode(s) as Map<String, dynamic>)
            .toList();

      case StorageType.sqlite:
        final List<Map<String, dynamic>> maps =
            await _database.query('streaks');
        return maps;

      case StorageType.hive:
        final streakKeys = _hiveBox.keys
            .where((key) => key.toString().startsWith('streak_'))
            .toList();
        return streakKeys.map((key) {
          final data = _hiveBox.get(key) as Map<String, dynamic>;
          return {
            'id': data['id'],
            'currentStreak': data['currentStreak'],
            'longestStreak': data['longestStreak'],
            'lastActivityDate': data['lastActivityDate'],
            'streakType': data['streakType'],
            'type': data['type'],
            'metadata': data['metadata'],
            'title': data['title'],
            'description': data['description'],
            'startDate': data['startDate'],
            'endDate': data['endDate'],
            'points': data['points'],
            'bonusPoints': data['bonusPoints'],
            'bonusDeadline': data['bonusDeadline'],
            'isCompleted': data['isCompleted'],
            'progress': data['progress'],
            'lastUpdated': data['lastUpdated'],
          };
        }).toList();

      case StorageType.firebase:
        final snapshot = await _firestore.collection('streaks').get();
        return snapshot.docs.map((doc) => doc.data()).toList();

      case StorageType.custom:
        return _customStorage.getStreaks();
    }
  }

  /// Clear all stored data
  Future<void> clearAll() async {
    switch (storageType) {
      case StorageType.sharedPreferences:
        await _prefs.clear();
        break;

      case StorageType.sqlite:
        await _database.delete('achievements');
        await _database.delete('streaks');
        break;

      case StorageType.hive:
        await _hiveBox.clear();
        break;

      case StorageType.firebase:
        final achievements = await _firestore.collection('achievements').get();
        final streaks = await _firestore.collection('streaks').get();

        for (var doc in achievements.docs) {
          await doc.reference.delete();
        }
        for (var doc in streaks.docs) {
          await doc.reference.delete();
        }
        break;

      case StorageType.custom:
        await _customStorage.clearAll();
        break;
    }

    // Log data cleared event
    _logStorageEvent('data_cleared', {});
  }

  /// Log storage event
  Future<void> _logStorageEvent(
      String eventName, Map<String, Object>? parameters) async {
    try {
      final analytics = FirebaseAnalytics.instance;
      await analytics.logEvent(
        name: eventName,
        parameters: parameters?.cast<String, Object>(),
      );
    } catch (e) {
      // Ignore analytics errors
    }
  }
}
