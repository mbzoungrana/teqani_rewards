import 'package:flutter/material.dart';

/// Theme configuration for TeqaniRewards components
class TeqaniRewardsTheme {
  /// Primary color used for unlocked achievements, active streaks, and completed challenges
  final Color primaryColor;
  
  /// Secondary color used for backgrounds and accents
  final Color secondaryColor;
  
  /// Color used for locked achievements, inactive streaks, and incomplete challenges
  final Color inactiveColor;
  
  /// Color used for text in the rewards components
  final Color textColor;
  
  /// Color used for secondary text in the rewards components
  final Color secondaryTextColor;
  
  /// Border radius for cards and containers
  final double borderRadius;
  
  /// Elevation for cards
  final double cardElevation;
  
  /// Padding for cards
  final EdgeInsets padding;
  
  /// Icon size for achievement icons
  final double iconSize;
  
  /// Animation duration for progress indicators
  final Duration animationDuration;
  
  /// Custom font family for text
  final String? fontFamily;
  
  /// Custom text styles for different components
  final TeqaniRewardsTextStyles? textStyles;
  
  /// Custom colors for different achievement types
  final Map<String, Color>? achievementTypeColors;
  
  /// Custom colors for different streak types
  final Map<String, Color>? streakTypeColors;
  
  /// Custom colors for different challenge types
  final Map<String, Color>? challengeTypeColors;

  final Color cardBackgroundColor;

  const TeqaniRewardsTheme({
    this.primaryColor = Colors.blue,
    this.secondaryColor = Colors.blueGrey,
    this.inactiveColor = Colors.grey,
    this.textColor = Colors.black87,
    this.secondaryTextColor = Colors.black54,
    this.borderRadius = 12.0,
    this.cardElevation = 2.0,
    this.padding = const EdgeInsets.all(16.0),
    this.iconSize = 24.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.fontFamily,
    this.textStyles,
    this.achievementTypeColors,
    this.streakTypeColors,
    this.challengeTypeColors,
    this.cardBackgroundColor = Colors.white,
  });

  /// Default theme with blue color scheme
  static const TeqaniRewardsTheme defaultTheme = TeqaniRewardsTheme();

  /// Dark theme with dark color scheme
  static const TeqaniRewardsTheme darkTheme = TeqaniRewardsTheme(
    primaryColor: Colors.blueAccent,
    secondaryColor: Colors.blueGrey,
    inactiveColor: Colors.grey,
    textColor: Colors.white,
    secondaryTextColor: Colors.white70,
    cardElevation: 4.0,
  );

  /// Custom theme with green color scheme
  static const TeqaniRewardsTheme greenTheme = TeqaniRewardsTheme(
    primaryColor: Colors.green,
    secondaryColor: Colors.lightGreen,
    inactiveColor: Colors.grey,
  );

  /// Custom theme with purple color scheme
  static const TeqaniRewardsTheme purpleTheme = TeqaniRewardsTheme(
    primaryColor: Colors.purple,
    secondaryColor: Colors.deepPurple,
    inactiveColor: Colors.grey,
  );

  /// Custom theme with orange color scheme
  static const TeqaniRewardsTheme orangeTheme = TeqaniRewardsTheme(
    primaryColor: Colors.orange,
    secondaryColor: Colors.deepOrange,
    inactiveColor: Colors.grey,
  );

  /// Create a copy of this theme with the given fields replaced with the new values
  TeqaniRewardsTheme copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? inactiveColor,
    Color? textColor,
    Color? secondaryTextColor,
    double? borderRadius,
    double? cardElevation,
    EdgeInsets? padding,
    double? iconSize,
    Duration? animationDuration,
    String? fontFamily,
    TeqaniRewardsTextStyles? textStyles,
    Map<String, Color>? achievementTypeColors,
    Map<String, Color>? streakTypeColors,
    Map<String, Color>? challengeTypeColors,
    Color? cardBackgroundColor,
  }) {
    return TeqaniRewardsTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      textColor: textColor ?? this.textColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      borderRadius: borderRadius ?? this.borderRadius,
      cardElevation: cardElevation ?? this.cardElevation,
      padding: padding ?? this.padding,
      iconSize: iconSize ?? this.iconSize,
      animationDuration: animationDuration ?? this.animationDuration,
      fontFamily: fontFamily ?? this.fontFamily,
      textStyles: textStyles ?? this.textStyles,
      achievementTypeColors: achievementTypeColors ?? this.achievementTypeColors,
      streakTypeColors: streakTypeColors ?? this.streakTypeColors,
      challengeTypeColors: challengeTypeColors ?? this.challengeTypeColors,
      cardBackgroundColor: cardBackgroundColor ?? this.cardBackgroundColor,
    );
  }
}

/// Custom text styles for TeqaniRewards components
class TeqaniRewardsTextStyles {
  /// Text style for achievement titles
  final TextStyle? achievementTitleStyle;
  
  /// Text style for achievement descriptions
  final TextStyle? achievementDescriptionStyle;
  
  /// Text style for achievement points
  final TextStyle? achievementPointsStyle;
  
  /// Text style for streak titles
  final TextStyle? streakTitleStyle;
  
  /// Text style for streak counts
  final TextStyle? streakCountStyle;
  
  /// Text style for streak descriptions
  final TextStyle? streakDescriptionStyle;
  
  /// Text style for challenge titles
  final TextStyle? challengeTitleStyle;
  
  /// Text style for challenge descriptions
  final TextStyle? challengeDescriptionStyle;
  
  /// Text style for challenge progress
  final TextStyle? challengeProgressStyle;
  
  /// Text style for challenge points
  final TextStyle? challengePointsStyle;

  const TeqaniRewardsTextStyles({
    this.achievementTitleStyle,
    this.achievementDescriptionStyle,
    this.achievementPointsStyle,
    this.streakTitleStyle,
    this.streakCountStyle,
    this.streakDescriptionStyle,
    this.challengeTitleStyle,
    this.challengeDescriptionStyle,
    this.challengeProgressStyle,
    this.challengePointsStyle,
  });
} 