import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../theme/teqani_rewards_theme.dart';

class AchievementProgress extends StatelessWidget {
  final Achievement achievement;
  final double progress;
  final TeqaniRewardsTheme? theme;
  final bool showPercentage;

  const AchievementProgress({
    super.key,
    required this.achievement,
    required this.progress,
    this.theme,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final rewardsTheme = theme ?? TeqaniRewardsTheme.defaultTheme;
    final progressColor = _getAchievementColor(achievement, rewardsTheme);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              achievement.title,
              style: rewardsTheme.textStyles?.achievementTitleStyle ?? 
                Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: rewardsTheme.textColor,
                  fontFamily: rewardsTheme.fontFamily,
                ),
            ),
            if (showPercentage)
              Text(
                '${(progress * 100).toInt()}%',
                style: rewardsTheme.textStyles?.achievementPointsStyle ?? 
                  Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: progressColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: rewardsTheme.fontFamily,
                  ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(rewardsTheme.borderRadius),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: rewardsTheme.inactiveColor.withValues(alpha:0.2),
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
  
  Color _getAchievementColor(Achievement achievement, TeqaniRewardsTheme theme) {
    if (theme.achievementTypeColors != null && 
        theme.achievementTypeColors!.containsKey(achievement.id)) {
      return theme.achievementTypeColors![achievement.id]!;
    }
    return theme.primaryColor;
  }
} 