import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../theme/teqani_rewards_theme.dart';

class AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final VoidCallback? onTap;
  final TeqaniRewardsTheme? theme;

  const AchievementCard({
    super.key,
    required this.achievement,
    this.onTap,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final rewardsTheme = theme ?? TeqaniRewardsTheme.defaultTheme;
    
    return Card(
      elevation: achievement.isUnlocked ? rewardsTheme.cardElevation * 2 : rewardsTheme.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(rewardsTheme.borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(rewardsTheme.borderRadius),
        child: Padding(
          padding: rewardsTheme.padding,
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: achievement.isUnlocked
                      ? _getAchievementColor(achievement, rewardsTheme)
                      : rewardsTheme.inactiveColor.withValues(alpha:0.2),
                ),
                child: Center(
                  child: Icon(
                    _getIconForAchievement(achievement),
                    size: rewardsTheme.iconSize,
                    color: achievement.isUnlocked
                        ? Colors.white
                        : rewardsTheme.inactiveColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      achievement.title,
                      style: rewardsTheme.textStyles?.achievementTitleStyle ?? 
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: achievement.isUnlocked
                              ? _getAchievementColor(achievement, rewardsTheme)
                              : rewardsTheme.textColor.withValues(alpha:0.7),
                          fontFamily: rewardsTheme.fontFamily,
                        ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      achievement.description,
                      style: rewardsTheme.textStyles?.achievementDescriptionStyle ?? 
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: rewardsTheme.secondaryTextColor,
                          fontFamily: rewardsTheme.fontFamily,
                        ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.stars,
                          size: 16,
                          color: _getAchievementColor(achievement, rewardsTheme),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${achievement.points} points',
                          style: rewardsTheme.textStyles?.achievementPointsStyle ?? 
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _getAchievementColor(achievement, rewardsTheme),
                              fontWeight: FontWeight.bold,
                              fontFamily: rewardsTheme.fontFamily,
                            ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (achievement.isUnlocked)
                Icon(
                  Icons.check_circle,
                  color: _getAchievementColor(achievement, rewardsTheme),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForAchievement(Achievement achievement) {
    // Map achievement IDs to appropriate icons
    switch (achievement.id) {
      case 'first_login':
        return Icons.login;
      case 'complete_profile':
        return Icons.person;
      case 'share_app':
        return Icons.share;
      default:
        return Icons.emoji_events;
    }
  }
  
  Color _getAchievementColor(Achievement achievement, TeqaniRewardsTheme theme) {
    if (theme.achievementTypeColors != null && 
        theme.achievementTypeColors!.containsKey(achievement.id)) {
      return theme.achievementTypeColors![achievement.id]!;
    }
    return theme.primaryColor;
  }
} 