import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/challenge.dart';
import '../theme/teqani_rewards_theme.dart';

/// A circular progress challenge card with animated progress
class CircularChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback? onComplete;
  final TeqaniRewardsTheme? theme;

  const CircularChallengeCard({
    super.key,
    required this.challenge,
    this.onComplete,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final rewardsTheme = theme ?? TeqaniRewardsTheme.defaultTheme;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: challenge.progress,
                    backgroundColor: rewardsTheme.inactiveColor.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(rewardsTheme.primaryColor),
                    strokeWidth: 12,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${(challenge.progress * 100).toInt()}%',
                      style: rewardsTheme.textStyles?.achievementTitleStyle?.copyWith(
                        fontSize: 24,
                        color: rewardsTheme.primaryColor,
                      ),
                    ),
                    Text(
                      'Complete',
                      style: rewardsTheme.textStyles?.streakDescriptionStyle,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              challenge.title,
              style: rewardsTheme.textStyles?.achievementTitleStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              challenge.description,
              style: rewardsTheme.textStyles?.achievementDescriptionStyle,
              textAlign: TextAlign.center,
            ),
            if (onComplete != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onComplete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: rewardsTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Update Progress'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A horizontal timeline challenge card
class TimelineChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback? onComplete;
  final TeqaniRewardsTheme? theme;

  const TimelineChallengeCard({
    super.key,
    required this.challenge,
    this.onComplete,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final rewardsTheme = theme ?? TeqaniRewardsTheme.defaultTheme;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.timer,
                  color: rewardsTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  challenge.title,
                  style: rewardsTheme.textStyles?.achievementTitleStyle,
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: challenge.progress,
              backgroundColor: rewardsTheme.inactiveColor.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(rewardsTheme.primaryColor),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Start: ${_formatDate(challenge.startDate)}',
                  style: rewardsTheme.textStyles?.streakDescriptionStyle,
                ),
                Text(
                  'End: ${_formatDate(challenge.endDate)}',
                  style: rewardsTheme.textStyles?.streakDescriptionStyle,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              challenge.description,
              style: rewardsTheme.textStyles?.achievementDescriptionStyle,
            ),
            if (onComplete != null) ...[
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onComplete,
                  icon: const Icon(Icons.add),
                  label: const Text('Update Progress'),
                  style: TextButton.styleFrom(
                    foregroundColor: rewardsTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }
}

/// A step-by-step challenge card with checkmarks
class StepChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback? onComplete;
  final TeqaniRewardsTheme? theme;

  const StepChallengeCard({
    super.key,
    required this.challenge,
    this.onComplete,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final rewardsTheme = theme ?? TeqaniRewardsTheme.defaultTheme;
    const steps = 5; // Assuming 5 steps for the challenge
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              challenge.title,
              style: rewardsTheme.textStyles?.achievementTitleStyle,
            ),
            const SizedBox(height: 16),
            ...List.generate(steps, (index) {
              final isCompleted = (index + 1) / steps <= challenge.progress;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? rewardsTheme.primaryColor
                            : rewardsTheme.inactiveColor.withValues(alpha: 0.2),
                        border: Border.all(
                          color: rewardsTheme.primaryColor,
                          width: 2,
                        ),
                      ),
                      child: isCompleted
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Step ${index + 1}',
                      style: rewardsTheme.textStyles?.achievementDescriptionStyle?.copyWith(
                        color: isCompleted
                            ? rewardsTheme.primaryColor
                            : rewardsTheme.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              );
            }),
            if (onComplete != null) ...[
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: onComplete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rewardsTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Complete Next Step'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A minimal challenge card with icon and progress
class MinimalChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback? onComplete;
  final TeqaniRewardsTheme? theme;

  const MinimalChallengeCard({
    super.key,
    required this.challenge,
    this.onComplete,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final rewardsTheme = theme ?? TeqaniRewardsTheme.defaultTheme;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onComplete,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: rewardsTheme.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.flag,
                  color: rewardsTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.title,
                      style: rewardsTheme.textStyles?.achievementTitleStyle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      challenge.description,
                      style: rewardsTheme.textStyles?.achievementDescriptionStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              CircularProgressIndicator(
                value: challenge.progress,
                backgroundColor: rewardsTheme.inactiveColor.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(rewardsTheme.primaryColor),
                strokeWidth: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A gradient challenge card with animated progress
class GradientChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback? onComplete;
  final TeqaniRewardsTheme? theme;

  const GradientChallengeCard({
    super.key,
    required this.challenge,
    this.onComplete,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final rewardsTheme = theme ?? TeqaniRewardsTheme.defaultTheme;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              rewardsTheme.primaryColor,
              rewardsTheme.primaryColor.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    challenge.title,
                    style: rewardsTheme.textStyles?.achievementTitleStyle?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${(challenge.progress * 100).toInt()}%',
                      style: rewardsTheme.textStyles?.streakDescriptionStyle?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                challenge.description,
                style: rewardsTheme.textStyles?.achievementDescriptionStyle?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: challenge.progress,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 8,
                ),
              ),
              if (onComplete != null) ...[
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: onComplete,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Update Progress'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A 3D flip challenge card with animated progress
class FlipChallengeCard extends StatefulWidget {
  final Challenge challenge;
  final VoidCallback? onComplete;
  final TeqaniRewardsTheme? theme;

  const FlipChallengeCard({
    super.key,
    required this.challenge,
    this.onComplete,
    this.theme,
  });

  @override
  State<FlipChallengeCard> createState() => _FlipChallengeCardState();
}

class _FlipChallengeCardState extends State<FlipChallengeCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rewardsTheme = widget.theme ?? TeqaniRewardsTheme.defaultTheme;
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(_animation.value * math.pi * 0.1),
          alignment: Alignment.center,
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    rewardsTheme.primaryColor,
                    rewardsTheme.primaryColor.withValues(alpha: 0.8),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      widget.challenge.title,
                      style: rewardsTheme.textStyles?.achievementTitleStyle?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            value: widget.challenge.progress,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 8,
                          ),
                        ),
                        Text(
                          '${(widget.challenge.progress * 100).toInt()}%',
                          style: rewardsTheme.textStyles?.achievementTitleStyle?.copyWith(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                    if (widget.onComplete != null) ...[
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: widget.onComplete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: rewardsTheme.primaryColor,
                        ),
                        child: const Text('Update Progress'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A pulse challenge card with animated progress
class PulseChallengeCard extends StatefulWidget {
  final Challenge challenge;
  final VoidCallback? onComplete;
  final TeqaniRewardsTheme? theme;

  const PulseChallengeCard({
    super.key,
    required this.challenge,
    this.onComplete,
    this.theme,
  });

  @override
  State<PulseChallengeCard> createState() => _PulseChallengeCardState();
}

class _PulseChallengeCardState extends State<PulseChallengeCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rewardsTheme = widget.theme ?? TeqaniRewardsTheme.defaultTheme;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    rewardsTheme.primaryColor.withValues(alpha: 0.1),
                    rewardsTheme.primaryColor.withValues(alpha: 0.05),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: rewardsTheme.primaryColor.withValues(alpha: 0.2 * _glowAnimation.value),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background pattern
                  Positioned.fill(
                    child: CustomPaint(
                      painter: DotsPatternPainter(
                        color: rewardsTheme.primaryColor.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: rewardsTheme.primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: rewardsTheme.primaryColor.withValues(alpha: 0.2),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.rocket_launch,
                                color: rewardsTheme.primaryColor,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.challenge.title,
                                    style: rewardsTheme.textStyles?.achievementTitleStyle?.copyWith(
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${(widget.challenge.progress * 100).toInt()}% Complete',
                                    style: rewardsTheme.textStyles?.streakDescriptionStyle?.copyWith(
                                      color: rewardsTheme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.challenge.description,
                          style: rewardsTheme.textStyles?.achievementDescriptionStyle,
                        ),
                        const SizedBox(height: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: widget.challenge.progress,
                            backgroundColor: rewardsTheme.inactiveColor.withValues(alpha: 0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(rewardsTheme.primaryColor),
                            minHeight: 10,
                          ),
                        ),
                        if (widget.onComplete != null) ...[
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: widget.onComplete,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: rewardsTheme.primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 4,
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add),
                                  SizedBox(width: 8),
                                  Text('Update Progress'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DotsPatternPainter extends CustomPainter {
  final Color color;

  DotsPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const spacing = 20.0;
    for (var i = 0.0; i < size.width; i += spacing) {
      for (var j = 0.0; j < size.height; j += spacing) {
        canvas.drawCircle(Offset(i, j), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DotsPatternPainter oldDelegate) => false;
}

/// A wave challenge card with animated progress
class WaveChallengeCard extends StatefulWidget {
  final Challenge challenge;
  final VoidCallback? onComplete;
  final TeqaniRewardsTheme? theme;

  const WaveChallengeCard({
    super.key,
    required this.challenge,
    this.onComplete,
    this.theme,
  });

  @override
  State<WaveChallengeCard> createState() => _WaveChallengeCardState();
}

class _WaveChallengeCardState extends State<WaveChallengeCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _waveAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_controller);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rewardsTheme = widget.theme ?? TeqaniRewardsTheme.defaultTheme;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: WavePainter(
                    animation: _waveAnimation.value,
                    color: rewardsTheme.primaryColor.withValues(alpha: 0.1),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.waves,
                      color: rewardsTheme.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.challenge.title,
                      style: rewardsTheme.textStyles?.achievementTitleStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.challenge.description,
                  style: rewardsTheme.textStyles?.achievementDescriptionStyle,
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: widget.challenge.progress,
                    backgroundColor: rewardsTheme.inactiveColor.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(rewardsTheme.primaryColor),
                    minHeight: 8,
                  ),
                ),
                if (widget.onComplete != null) ...[
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: widget.onComplete,
                      icon: const Icon(Icons.add),
                      label: const Text('Update Progress'),
                      style: TextButton.styleFrom(
                        foregroundColor: rewardsTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double animation;
  final Color color;

  WavePainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final y = size.height * 0.5;
    path.moveTo(0, y);

    for (var i = 0.0; i < size.width; i++) {
      path.lineTo(
        i,
        y + math.sin((i / 30) + animation) * 10,
      );
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}

/// Widget factory for challenge-related widgets
class TeqaniChallengeWidgets {
  /// Create a circular challenge card
  static Widget circular({
    required Challenge challenge,
    VoidCallback? onComplete,
    TeqaniRewardsTheme? theme,
  }) {
    return CircularChallengeCard(
      challenge: challenge,
      onComplete: onComplete ?? () {},
      theme: theme,
    );
  }

  /// Create a timeline challenge card
  static Widget timeline({
    required Challenge challenge,
    VoidCallback? onComplete,
    TeqaniRewardsTheme? theme,
  }) {
    return TimelineChallengeCard(
      challenge: challenge,
      onComplete: onComplete ?? () {},
      theme: theme,
    );
  }

  /// Create a flip challenge card
  static Widget flip({
    required Challenge challenge,
    VoidCallback? onComplete,
    TeqaniRewardsTheme? theme,
  }) {
    return FlipChallengeCard(
      challenge: challenge,
      onComplete: onComplete ?? () {},
      theme: theme,
    );
  }

  /// Create a pulse challenge card
  static Widget pulse({
    required Challenge challenge,
    VoidCallback? onComplete,
    TeqaniRewardsTheme? theme,
  }) {
    return PulseChallengeCard(
      challenge: challenge,
      onComplete: onComplete ?? () {},
      theme: theme,
    );
  }

  /// Create a wave challenge card
  static Widget wave({
    required Challenge challenge,
    VoidCallback? onComplete,
    TeqaniRewardsTheme? theme,
  }) {
    return WaveChallengeCard(
      challenge: challenge,
      onComplete: onComplete ?? () {},
      theme: theme,
    );
  }

  /// Create a gradient challenge card
  static Widget gradient({
    required Challenge challenge,
    VoidCallback? onComplete,
    TeqaniRewardsTheme? theme,
  }) {
    return GradientChallengeCard(
      challenge: challenge,
      onComplete: onComplete ?? () {},
      theme: theme,
    );
  }
} 