import 'package:firebase_analytics/firebase_analytics.dart';
import 'theme/teqani_rewards_theme.dart';
import 'services/analytics_service.dart';
import 'services/storage_service.dart';
import 'models/storage_type.dart';

/// Main class for Teqani Rewards package
class TeqaniRewards {
  static TeqaniRewardsTheme? _theme;
  static TeqaniAnalyticsService? _analyticsService;
  static TeqaniStorageService? _storageService;
  static bool _isInitialized = false;

  /// Initialize Teqani Rewards
  static Future<void> init({
    TeqaniRewardsTheme? theme,
    StorageType storageType = StorageType.sharedPreferences,
    Map<String, dynamic>? storageOptions,
    bool enableAnalytics = false,
    FirebaseAnalytics? analytics,
    String? userId,
  }) async {
    _theme = theme ?? TeqaniRewardsTheme.defaultTheme;
    
    // Initialize storage service
    _storageService = TeqaniStorageService(
      storageType: storageType,
      options: storageOptions,
    );
    await _storageService!.initialize(userId: userId);
    
    // Initialize analytics service
    if (enableAnalytics) {
      _analyticsService = TeqaniAnalyticsService(analytics: analytics);
    }
    
    _isInitialized = true;
  }

  /// Get the current theme
  static TeqaniRewardsTheme get theme => _theme ?? TeqaniRewardsTheme.defaultTheme;

  /// Get the analytics service
  static TeqaniAnalyticsService? get analyticsService => _analyticsService;

  /// Get the storage service
  static TeqaniStorageService? get storageService => _storageService;

  /// Check if the package is initialized
  static bool get isInitialized => _isInitialized;
} 