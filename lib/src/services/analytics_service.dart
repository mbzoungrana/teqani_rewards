import 'package:firebase_analytics/firebase_analytics.dart';

/// Service to handle analytics events for Teqani Rewards
class TeqaniAnalyticsService {
  final FirebaseAnalytics? _analytics;
  
  TeqaniAnalyticsService({FirebaseAnalytics? analytics}) : _analytics = analytics;

  /// Log achievement unlocked event
  Future<void> logAchievementUnlocked({
    required String achievementId,
    required String achievementTitle,
  }) async {
    await _analytics?.logEvent(
      name: 'teqani_achievement_unlocked',
      parameters: {
        'achievement_id': achievementId,
        'achievement_title': achievementTitle,
      },
    );
  }

  /// Log streak updated event
  Future<void> logStreakUpdated({
    required int currentStreak,
    required int longestStreak,
  }) async {
    await _analytics?.logEvent(
      name: 'teqani_streak_updated',
      parameters: {
        'current_streak': currentStreak,
        'longest_streak': longestStreak,
      },
    );
  }

  /// Log onboarding started event
  Future<void> logOnboardingStarted() async {
    await _analytics?.logEvent(
      name: 'teqani_onboarding_started',
    );
  }

  /// Log onboarding completed event
  Future<void> logOnboardingCompleted() async {
    await _analytics?.logEvent(
      name: 'teqani_onboarding_completed',
    );
  }

  /// Log onboarding button clicked event
  Future<void> logOnboardingButtonClicked({
    required String onboardingType,
  }) async {
    await _analytics?.logEvent(
      name: 'teqani_onboarding_button_clicked',
      parameters: {
        'onboarding_type': onboardingType,
      },
    );
  }

  /// Log navigation event
  Future<void> logNavigation({
    required String section,
  }) async {
    await _analytics?.logEvent(
      name: 'teqani_navigation',
      parameters: {
        'section': section,
      },
    );
  }

  /// Log reset event
  Future<void> logReset() async {
    await _analytics?.logEvent(
      name: 'teqani_reset',
    );
  }
} 