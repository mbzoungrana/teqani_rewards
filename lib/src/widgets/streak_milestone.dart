import 'package:flutter/material.dart';
import '../theme/teqani_rewards_theme.dart';

class StreakMilestone extends StatelessWidget {
  final int targetDays;
  final int currentDays;
  final String reward;
  final TeqaniRewardsTheme? theme;
  final bool isCompleted;

  const StreakMilestone({
    super.key,
    required this.targetDays,
    required this.currentDays,
    required this.reward,
    this.theme,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final rewardsTheme = theme ?? TeqaniRewardsTheme.defaultTheme;
    final progress = (currentDays / targetDays).clamp(0.0, 1.0);
    final streakColor = _getStreakColor(rewardsTheme);
    
    return Container(
      padding: rewardsTheme.padding,
      decoration: BoxDecoration(
        color: isCompleted 
            ? streakColor.withValues(alpha:0.1)
            : rewardsTheme.inactiveColor.withValues(alpha:0.05),
        borderRadius: BorderRadius.circular(rewardsTheme.borderRadius),
        border: Border.all(
          color: isCompleted 
              ? streakColor.withValues(alpha:0.3)
              : rewardsTheme.inactiveColor.withValues(alpha:0.1),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: isCompleted ? streakColor : rewardsTheme.inactiveColor,
                    size: rewardsTheme.iconSize,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$targetDays Days',
                    style: rewardsTheme.textStyles?.streakCountStyle ?? 
                      Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? streakColor : rewardsTheme.textColor,
                        fontFamily: rewardsTheme.fontFamily,
                      ),
                  ),
                ],
              ),
              if (isCompleted)
                Icon(
                  Icons.check_circle,
                  color: streakColor,
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            reward,
            style: rewardsTheme.textStyles?.streakDescriptionStyle ?? 
              Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: rewardsTheme.secondaryTextColor,
                fontFamily: rewardsTheme.fontFamily,
              ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(rewardsTheme.borderRadius),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: rewardsTheme.inactiveColor.withValues(alpha:0.2),
              valueColor: AlwaysStoppedAnimation<Color>(streakColor),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$currentDays / $targetDays days',
            style: rewardsTheme.textStyles?.streakDescriptionStyle ?? 
              Theme.of(context).textTheme.bodySmall?.copyWith(
                color: rewardsTheme.secondaryTextColor,
                fontFamily: rewardsTheme.fontFamily,
              ),
          ),
        ],
      ),
    );
  }
  
  Color _getStreakColor(TeqaniRewardsTheme theme) {
    return theme.primaryColor;
  }
} 