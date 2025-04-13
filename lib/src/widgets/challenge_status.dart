import 'package:flutter/material.dart';
import '../models/challenge.dart';
import '../theme/teqani_rewards_theme.dart';

class ChallengeStatus extends StatelessWidget {
  final Challenge challenge;
  final double progress;
  final TeqaniRewardsTheme? theme;
  final bool showReward;

  const ChallengeStatus({
    super.key,
    required this.challenge,
    required this.progress,
    this.theme,
    this.showReward = true,
  });

  @override
  Widget build(BuildContext context) {
    final rewardsTheme = theme ?? TeqaniRewardsTheme.defaultTheme;
    final challengeColor = _getChallengeColor(challenge, rewardsTheme);
    
    return Container(
      padding: rewardsTheme.padding,
      decoration: BoxDecoration(
        color: challenge.isCompleted 
            ? challengeColor.withValues(alpha:0.1)
            : rewardsTheme.inactiveColor.withValues(alpha:0.05),
        borderRadius: BorderRadius.circular(rewardsTheme.borderRadius),
        border: Border.all(
          color: challenge.isCompleted 
              ? challengeColor.withValues(alpha:0.3)
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
              Expanded(
                child: Text(
                  challenge.title,
                  style: rewardsTheme.textStyles?.challengeTitleStyle ?? 
                    Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: challenge.isCompleted ? challengeColor : rewardsTheme.textColor,
                      fontFamily: rewardsTheme.fontFamily,
                    ),
                ),
              ),
              if (challenge.isCompleted)
                Icon(
                  Icons.check_circle,
                  color: challengeColor,
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            challenge.description,
            style: rewardsTheme.textStyles?.challengeDescriptionStyle ?? 
              Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: rewardsTheme.secondaryTextColor,
                fontFamily: rewardsTheme.fontFamily,
              ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(rewardsTheme.borderRadius),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: rewardsTheme.inactiveColor.withValues(alpha:0.2),
              valueColor: AlwaysStoppedAnimation<Color>(challengeColor),
              minHeight: 6,
            ),
          ),
          if (showReward) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.stars,
                  size: 16,
                  color: challengeColor,
                ),
                const SizedBox(width: 4),
                Text(
                  '${challenge.points} points',
                  style: rewardsTheme.textStyles?.challengePointsStyle ?? 
                    Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: challengeColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: rewardsTheme.fontFamily,
                    ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
  
  Color _getChallengeColor(Challenge challenge, TeqaniRewardsTheme theme) {
    if (theme.challengeTypeColors != null && 
        theme.challengeTypeColors!.containsKey(challenge.type)) {
      return theme.challengeTypeColors![challenge.type]!;
    }
    return theme.primaryColor;
  }
} 