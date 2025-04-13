import 'package:flutter/material.dart';
import '../models/streak.dart';
import '../theme/teqani_rewards_theme.dart';

class StreakCounter extends StatelessWidget {
  final Streak streak;
  final bool showAnimation;
  final TeqaniRewardsTheme? theme;

  const StreakCounter({
    super.key,
    required this.streak,
    this.showAnimation = true,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final rewardsTheme = theme ?? TeqaniRewardsTheme.defaultTheme;
    final streakColor = _getStreakColor(streak, rewardsTheme);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: streakColor.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(rewardsTheme.borderRadius * 2.5),
        border: Border.all(
          color: streakColor.withValues(alpha:0.3),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showAnimation && streak.isStreakActive())
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: rewardsTheme.animationDuration,
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Icon(
                    Icons.local_fire_department,
                    color: streakColor,
                    size: rewardsTheme.iconSize * 1.5,
                  ),
                );
              },
            )
          else
            Icon(
              Icons.local_fire_department,
              color: streakColor,
              size: rewardsTheme.iconSize * 1.5,
            ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${streak.currentStreak}-Day Streak',
                style: rewardsTheme.textStyles?.streakCountStyle ?? 
                  Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: streakColor,
                    fontFamily: rewardsTheme.fontFamily,
                  ),
              ),
              Text(
                'Longest: ${streak.longestStreak} days',
                style: rewardsTheme.textStyles?.streakDescriptionStyle ?? 
                  Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: rewardsTheme.secondaryTextColor,
                    fontFamily: rewardsTheme.fontFamily,
                  ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Color _getStreakColor(Streak streak, TeqaniRewardsTheme theme) {
    if (theme.streakTypeColors != null && 
        theme.streakTypeColors!.containsKey(streak.streakType)) {
      return theme.streakTypeColors![streak.streakType]!;
    }
    return theme.primaryColor;
  }
} 