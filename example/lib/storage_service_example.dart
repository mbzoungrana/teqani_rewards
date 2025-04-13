import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:teqani_rewards/teqani_rewards.dart';
import 'dart:convert';

class StorageServiceExample extends StatefulWidget {
  const StorageServiceExample({super.key});

  @override
  State<StorageServiceExample> createState() => _StorageServiceExampleState();
}

class _StorageServiceExampleState extends State<StorageServiceExample> {
  String _result = '';
  bool _isLoading = false;
  StorageType _selectedStorageType = StorageType.sharedPreferences;
  List<Achievement> _achievements = [];
  List<Streak> _streaks = [];
  List<Challenge> _challenges = [];
  bool _hasSeenOnboarding = false;

  @override
  void initState() {
    super.initState();
    _initializeSampleData();
    _loadCurrentStorageType();
  }

  void _initializeSampleData() {
    // Initialize sample achievements
    _achievements = [
      Achievement(
        id: 'first_login',
        title: 'First Login',
        description: 'Welcome to the app!',
        points: 100,
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      ),
    ];

    // Initialize sample streaks
    _streaks = [
      Streak(
        id: 'daily_login',
        currentStreak: 5,
        longestStreak: 10,
        lastActivityDate: DateTime.now(),
        streakType: 'daily',
      ),
    ];

    // Initialize sample challenges with unique IDs
    _challenges = [
      Challenge(
        id: 'challenge_7_day_streak',
        title: '7 Day Streak Challenge',
        description: 'Maintain a 7-day streak to earn bonus points!',
        points: 500,
        isCompleted: false,
        progress: 0.0,
        type: 'streak',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
      ),
      Challenge(
        id: 'challenge_14_day_streak',
        title: '14 Day Streak Challenge',
        description: 'Maintain a 14-day streak to earn bonus points!',
        points: 1000,
        isCompleted: false,
        progress: 0.0,
        type: 'streak',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 14)),
      ),
    ];
  }

  Future<void> _saveAllData() async {
    setState(() => _isLoading = true);
    try {
      final storageManager = TeqaniRewards.storageManager;
      
      // Clear existing data
      await storageManager.clearAll();
      
      // Save achievements
      for (var achievement in _achievements) {
        await storageManager.saveAchievement(achievement.toJson());
      }
      
      // Save streaks
      for (var streak in _streaks) {
        await storageManager.saveStreak({
          'id': streak.id,
          'currentStreak': streak.currentStreak,
          'longestStreak': streak.longestStreak,
          'lastActivityDate': streak.lastActivityDate.toIso8601String(),
          'streakType': streak.streakType,
          'type': 'streak',
        });
      }
      
      // Save challenges
      for (var challenge in _challenges) {
        final metadata = {
          'title': challenge.title,
          'description': challenge.description,
          'points': challenge.points,
          'startDate': challenge.startDate.toIso8601String(),
          'endDate': challenge.endDate.toIso8601String(),
          'isCompleted': challenge.isCompleted,
          'progress': challenge.progress,
        };
        
        await storageManager.saveStreak({
          'id': challenge.id,
          'currentStreak': (challenge.progress * 100).toInt(),
          'longestStreak': 100,
          'lastActivityDate': challenge.lastUpdated.toIso8601String(),
          'streakType': challenge.type,
          'type': 'challenge',
          'metadata': jsonEncode(metadata), // Convert metadata to JSON string
        });
      }
      
      // Save onboarding status
      await storageManager.saveStreak({
        'id': 'onboarding_status',
        'currentStreak': _hasSeenOnboarding ? 1 : 0,
        'longestStreak': 1,
        'lastActivityDate': DateTime.now().toIso8601String(),
        'streakType': 'onboarding',
        'type': 'onboarding',
      });
      
      setState(() => _result = 'All data saved successfully!');
    } catch (e) {
      setState(() => _result = 'Error saving data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getAllData() async {
    setState(() => _isLoading = true);
    try {
      final storageManager = TeqaniRewards.storageManager;
      
      // Get achievements
      final achievementMaps = await storageManager.getAchievements();
      _achievements = achievementMaps.map((a) {
        try {
          return Achievement(
            id: a['id']?.toString() ?? 'default_achievement',
            title: a['title']?.toString() ?? 'Default Achievement',
            description: a['description']?.toString() ?? 'Default Description',
            points: (a['points'] as num?)?.toInt() ?? 0,
            isUnlocked: a['isUnlocked'] == 1 || a['isUnlocked'] == true,
            unlockedAt: a['unlockedAt'] != null 
                ? DateTime.tryParse(a['unlockedAt'].toString()) 
                : null,
          );
        } catch (e) {
          if (kDebugMode) {
            print('Error parsing achievement: $e');
          }
          return null;
        }
      }).where((a) => a != null).cast<Achievement>().toList();
      
      // Get streaks and challenges
      final allStreaks = await storageManager.getStreaks();
      
      // Initialize empty lists
      _streaks = [];
      _challenges = [];
      _hasSeenOnboarding = false;
      
      for (var data in allStreaks) {
        if (data['type'] == 'challenge') {
          try {
            // For SQLite, the data is already in the correct format
            if (TeqaniRewards.storageManager.storageType == StorageType.sqlite) {
              final challenge = Challenge(
                id: data['id']?.toString() ?? 'default_challenge',
                title: data['title']?.toString() ?? 'Default Challenge',
                description: data['description']?.toString() ?? 'Default Description',
                points: (data['points'] as num?)?.toInt() ?? 0,
                type: data['streakType']?.toString() ?? 'daily',
                startDate: data['startDate'] != null 
                    ? DateTime.tryParse(data['startDate'].toString()) ?? DateTime.now()
                    : DateTime.now(),
                endDate: data['endDate'] != null 
                    ? DateTime.tryParse(data['endDate'].toString()) ?? DateTime.now().add(const Duration(days: 7))
                    : DateTime.now().add(const Duration(days: 7)),
                progress: (data['progress'] as num?)?.toDouble() ?? 0.0,
                isCompleted: data['isCompleted'] == 1,
                lastUpdated: data['lastUpdated'] != null 
                    ? DateTime.tryParse(data['lastUpdated'].toString()) ?? DateTime.now()
                    : DateTime.now(),
              );
              _challenges.add(challenge);
            } else {
              // For other storage types, use the metadata field
              final metadata = data['metadata'] != null 
                  ? jsonDecode(data['metadata'] as String) as Map<String, dynamic>
                  : <String, dynamic>{};
                  
              final challenge = Challenge(
                id: data['id']?.toString() ?? 'default_challenge',
                title: metadata['title']?.toString() ?? 'Default Challenge',
                description: metadata['description']?.toString() ?? 'Default Description',
                points: (metadata['points'] as num?)?.toInt() ?? 0,
                type: data['streakType']?.toString() ?? 'daily',
                startDate: metadata['startDate'] != null 
                    ? DateTime.tryParse(metadata['startDate'].toString()) ?? DateTime.now()
                    : DateTime.now(),
                endDate: metadata['endDate'] != null 
                    ? DateTime.tryParse(metadata['endDate'].toString()) ?? DateTime.now().add(const Duration(days: 7))
                    : DateTime.now().add(const Duration(days: 7)),
                progress: (data['progress'] as num?)?.toDouble() ?? 0.0,
                isCompleted: metadata['isCompleted'] as bool? ?? false,
                lastUpdated: data['lastUpdated'] != null 
                    ? DateTime.tryParse(data['lastUpdated'].toString()) ?? DateTime.now()
                    : DateTime.now(),
              );
              _challenges.add(challenge);
            }
          } catch (e) {
            if (kDebugMode) {
              print('Error parsing challenge: $e');
            }
          }
        } else if (data['type'] == 'onboarding') {
          _hasSeenOnboarding = (data['currentStreak'] as num?)?.toInt() == 1;
        } else if (data['type'] == 'streak' || data['type'] == null) {
          try {
            final streak = Streak(
              id: data['id']?.toString() ?? 'default_streak',
              currentStreak: (data['currentStreak'] as num?)?.toInt() ?? 0,
              longestStreak: (data['longestStreak'] as num?)?.toInt() ?? 0,
              lastActivityDate: data['lastActivityDate'] != null 
                  ? DateTime.tryParse(data['lastActivityDate'].toString()) ?? DateTime.now()
                  : DateTime.now(),
              streakType: data['streakType']?.toString() ?? 'daily',
            );
            _streaks.add(streak);
          } catch (e) {
            if (kDebugMode) {
              print('Error parsing streak: $e');
            }
          }
        }
      }
      
      setState(() => _result = 'All data loaded successfully!');
    } catch (e) {
      setState(() => _result = 'Error loading data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Add interaction methods
  Future<void> _updateStreak(String streakType) async {
    try {
      final streakIndex = _streaks.indexWhere((s) => s.streakType == streakType);
      if (streakIndex != -1) {
        final updatedStreak = _streaks[streakIndex].updateStreak();
        _streaks[streakIndex] = updatedStreak;
        
        // Save only the updated streak
        await TeqaniRewards.storageManager.saveStreak(updatedStreak.toJson());
        
        // Update only the streaks list in state
        setState(() {
          _streaks = List<Streak>.from(_streaks);
        });
      }
    } catch (e) {
      setState(() => _result = 'Error updating streak: $e');
    }
  }

  Future<void> _unlockAchievement(String achievementId) async {
    try {
      final achievementIndex = _achievements.indexWhere((a) => a.id == achievementId);
      if (achievementIndex != -1) {
        final updatedAchievement = _achievements[achievementIndex].unlock();
        _achievements[achievementIndex] = updatedAchievement;
        
        // Save only the updated achievement
        await TeqaniRewards.storageManager.saveAchievement({
          'id': updatedAchievement.id,
          'title': updatedAchievement.title,
          'description': updatedAchievement.description,
          'points': updatedAchievement.points,
          'isUnlocked': updatedAchievement.isUnlocked,
          'unlockedAt': updatedAchievement.unlockedAt?.toIso8601String(),
        });
        
        // Update only the achievements list in state
        setState(() {
          _achievements = List<Achievement>.from(_achievements);
        });
      }
    } catch (e) {
      setState(() => _result = 'Error unlocking achievement: $e');
    }
  }

  Future<void> _updateChallengeProgress(String challengeId, double progress) async {
    try {
      // Find the specific challenge
      final challengeIndex = _challenges.indexWhere((c) => c.id == challengeId);
      if (challengeIndex != -1) {
        // Create a new list to avoid state mutation
        final updatedChallenges = List<Challenge>.from(_challenges);
        
        // Update only the specific challenge
        updatedChallenges[challengeIndex] = updatedChallenges[challengeIndex].copyWith(
          progress: progress,
          lastUpdated: DateTime.now(),
          isCompleted: progress >= 1.0,
        );
        
        // Update state with the new list
        setState(() {
          _challenges = updatedChallenges;
        });
        
        // Save the updated challenge
        final challenge = updatedChallenges[challengeIndex];
        
        if (TeqaniRewards.storageManager.storageType == StorageType.sqlite) {
          // For SQLite, save directly to the table
          await TeqaniRewards.storageManager.saveStreak({
            'id': challenge.id,
            'title': challenge.title,
            'description': challenge.description,
            'points': challenge.points,
            'type': challenge.type,
            'progress': progress,
            'startDate': challenge.startDate.toIso8601String(),
            'endDate': challenge.endDate.toIso8601String(),
            'isCompleted': progress >= 1.0 ? 1 : 0,
            'lastUpdated': DateTime.now().toIso8601String(),
            'currentStreak': (progress * 100).toInt(),
            'longestStreak': 100,
            'streakType': challenge.type,
          });
        } else {
          // For other storage types, use metadata
          final metadata = {
            'title': challenge.title,
            'description': challenge.description,
            'points': challenge.points,
            'startDate': challenge.startDate.toIso8601String(),
            'endDate': challenge.endDate.toIso8601String(),
            'isCompleted': progress >= 1.0,
            'progress': progress,
          };
          
          await TeqaniRewards.storageManager.saveStreak({
            'id': challenge.id,
            'currentStreak': (progress * 100).toInt(),
            'longestStreak': 100,
            'lastActivityDate': DateTime.now().toIso8601String(),
            'streakType': challenge.type,
            'type': 'challenge',
            'metadata': jsonEncode(metadata),
          });
        }
      }
    } catch (e) {
      setState(() => _result = 'Error updating challenge: $e');
    }
  }

  Future<void> _clearStorage() async {
    setState(() => _isLoading = true);
    try {
      final storageManager = TeqaniRewards.storageManager;
      await storageManager.clearAll();
      
      // Clear local state
      _achievements = [];
      _streaks = [];
      _challenges = [];
      _hasSeenOnboarding = false;
      
      setState(() => _result = 'Storage cleared successfully!');
    } catch (e) {
      setState(() => _result = 'Error clearing storage: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadCurrentStorageType() async {
    try {
      final storageManager = TeqaniRewards.storageManager;
      _selectedStorageType = storageManager.storageType;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading current storage type: $e');
      }
    }
  }

  Future<void> _changeStorageType(StorageType newType) async {
    setState(() => _isLoading = true);
    try {
      // Save current data before switching
      await _saveAllData();
      
      // Switch storage type using TeqaniRewards.init
      await TeqaniRewards.init(
        storageType: newType,
        enableAnalytics: true,
      );
      
      // Load data from new storage
      await _getAllData();
      
      setState(() {
        _selectedStorageType = newType;
        _result = 'Storage type changed to ${newType.toString().split('.').last}';
      });
    } catch (e) {
      setState(() => _result = 'Error changing storage type: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage Service Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Storage Type',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<StorageType>(
                      value: _selectedStorageType,
                      items: StorageType.values.map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.toString().split('.').last),
                      )).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _changeStorageType(value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _saveAllData,
                            child: const Text('Save All Data'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _getAllData,
                            child: const Text('Get All Data'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _clearStorage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Clear Storage'),
                    ),
                    const SizedBox(height: 8),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_result.isNotEmpty)
                      Text(
                        _result,
                        style: TextStyle(
                          color: _result.contains('Error') ? Colors.red : Colors.green,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: 'Achievements'),
                        Tab(text: 'Streaks'),
                        Tab(text: 'Challenges'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildList(_achievements),
                          _buildList(_streaks),
                          _buildList(_challenges),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<dynamic> items) {
    if (items.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        
        if (item is Achievement) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
            child: ListTile(
              title: Text(item.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${item.id}'),
                  Text('Description: ${item.description}'),
                  Text('Points: ${item.points}'),
                  Text('Unlocked: ${item.isUnlocked}'),
                  if (item.unlockedAt != null)
                    Text('Unlocked At: ${item.unlockedAt}'),
                ],
              ),
              trailing: !item.isUnlocked
                  ? ElevatedButton(
                      onPressed: () => _unlockAchievement(item.id),
                      child: const Text('Unlock'),
                    )
                  : null,
            ),
          );
        } else if (item is Streak) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
            child: ListTile(
              title: Text('${item.streakType} Streak'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Current Streak: ${item.currentStreak}'),
                  Text('Longest Streak: ${item.longestStreak}'),
                  Text('Last Activity: ${item.lastActivityDate}'),
                  Text('Active: ${item.isStreakActive()}'),
                  Text('Days Since Last Activity: ${item.getDaysSinceLastActivity()}'),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () => _updateStreak(item.streakType),
                child: const Text('Update'),
              ),
            ),
          );
        } else if (item is Challenge) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
            child: ListTile(
              title: Text(item.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${item.id}'),
                  Text('Description: ${item.description}'),
                  Text('Points: ${item.points}'),
                  Text('Progress: ${(item.progress * 100).toInt()}%'),
                  Text('Start Date: ${item.startDate}'),
                  Text('End Date: ${item.endDate}'),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  // Calculate new progress for this specific challenge
                  final newProgress = (item.progress + 0.1).clamp(0.0, 1.0);
                  _updateChallengeProgress(item.id, newProgress);
                },
                child: const Text('Update Progress'),
              ),
            ),
          );
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
          child: ListTile(
            title: const Text('Unknown Type'),
            subtitle: Text(item.toString()),
          ),
        );
      },
    );
  }
} 