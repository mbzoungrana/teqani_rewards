import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/achievement.dart';
import '../theme/teqani_rewards_theme.dart';

/// Widget factory for achievement-related widgets
class TeqaniAchievementWidgets {
  /// Create a cube achievement card
  static Widget cube({
    required Achievement achievement,
    VoidCallback? onComplete,
    TeqaniRewardsTheme? theme,
  }) {
    return CubeAchievementCard(
      achievement: achievement,
      onComplete: onComplete,
      theme: theme,
    );
  }

  /// Create a prism achievement card
  static Widget prism({
    required Achievement achievement,
    VoidCallback? onComplete,
    TeqaniRewardsTheme? theme,
  }) {
    return PrismAchievementCard(
      achievement: achievement,
      onComplete: onComplete,
      theme: theme,
    );
  }

  /// Create a pyramid achievement card
  static Widget pyramid({
    required Achievement achievement,
    VoidCallback? onComplete,
    TeqaniRewardsTheme? theme,
  }) {
    return PyramidAchievementCard(
      achievement: achievement,
      onComplete: onComplete,
      theme: theme,
    );
  }

  /// Create a modern achievement card
  static Widget modern({
    required Achievement achievement,
    VoidCallback? onComplete,
    TeqaniRewardsTheme? theme,
  }) {
    return ModernAchievementCard(
      achievement: achievement,
      onComplete: onComplete ?? () {},
      theme: theme,
    );
  }

  /// Create a minimalist achievement card
  static Widget minimalist({
    required Achievement achievement,
    VoidCallback? onComplete,
    TeqaniRewardsTheme? theme,
  }) {
    return MinimalistAchievementCard(
      achievement: achievement,
      onComplete: onComplete,
      theme: theme,
    );
  }

  /// Create a gradient achievement card
  static Widget gradient({
    required Achievement achievement,
    VoidCallback? onComplete,
    TeqaniRewardsTheme? theme,
  }) {
    return GradientAchievementCard(
      achievement: achievement,
      onComplete: onComplete,
      theme: theme,
    );
  }
}

/// A 3D rotating cube achievement card
class CubeAchievementCard extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback? onComplete;
  final TeqaniRewardsTheme? theme;

  const CubeAchievementCard({
    super.key,
    required this.achievement,
    this.onComplete,
    this.theme,
  });

  @override
  State<CubeAchievementCard> createState() => _CubeAchievementCardState();
}

class _CubeAchievementCardState extends State<CubeAchievementCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: -0.1, end: 0.1).animate(
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
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onComplete,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateX(_rotationAnimation.value)
                    ..rotateY(_rotationAnimation.value),
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.identity()
                      ..translate(0.0, _isHovered ? -5.0 : 0.0),
                    child: Card(
                      elevation: _isHovered ? 12 : 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.achievement.isUnlocked 
                                  ? rewardsTheme.primaryColor
                                  : rewardsTheme.inactiveColor,
                              widget.achievement.isUnlocked 
                                  ? rewardsTheme.primaryColor.withValues(alpha: 0.8)
                                  : rewardsTheme.inactiveColor.withValues(alpha: 0.8),
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            if (!widget.achievement.isUnlocked)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black.withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        widget.achievement.isUnlocked 
                                            ? Icons.star
                                            : Icons.lock,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      widget.achievement.title,
                                      style: rewardsTheme.textStyles?.achievementTitleStyle?.copyWith(
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      widget.achievement.description,
                                      style: rewardsTheme.textStyles?.achievementDescriptionStyle?.copyWith(
                                        color: Colors.white.withValues(alpha: 0.9),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    if (!widget.achievement.isUnlocked) ...[
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: widget.onComplete,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: rewardsTheme.primaryColor,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: const Text('Unlock Achievement'),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

/// A 3D floating prism achievement card
class PrismAchievementCard extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback? onComplete;
  final TeqaniRewardsTheme? theme;

  const PrismAchievementCard({
    super.key,
    required this.achievement,
    this.onComplete,
    this.theme,
  });

  @override
  State<PrismAchievementCard> createState() => _PrismAchievementCardState();
}

class _PrismAchievementCardState extends State<PrismAchievementCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _floatAnimation = Tween<double>(begin: 0, end: 1).animate(
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
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onComplete,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, math.sin(_floatAnimation.value * math.pi) * 5),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.identity()
                      ..translate(0.0, _isHovered ? -5.0 : 0.0),
                    child: Card(
                      elevation: _isHovered ? 16 : 12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.achievement.isUnlocked 
                                  ? rewardsTheme.primaryColor.withValues(alpha: 0.9)
                                  : rewardsTheme.inactiveColor.withValues(alpha: 0.9),
                              widget.achievement.isUnlocked 
                                  ? rewardsTheme.primaryColor.withValues(alpha: 0.7)
                                  : rewardsTheme.inactiveColor.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            if (!widget.achievement.isUnlocked)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black.withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                            Positioned.fill(
                              child: CustomPaint(
                                painter: PrismPainter(
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        widget.achievement.isUnlocked 
                                            ? Icons.star
                                            : Icons.lock,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      widget.achievement.title,
                                      style: rewardsTheme.textStyles?.achievementTitleStyle?.copyWith(
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      widget.achievement.description,
                                      style: rewardsTheme.textStyles?.achievementDescriptionStyle?.copyWith(
                                        color: Colors.white.withValues(alpha: 0.9),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    if (!widget.achievement.isUnlocked) ...[
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: widget.onComplete,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: rewardsTheme.primaryColor,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: const Text('Unlock Achievement'),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class PrismPainter extends CustomPainter {
  final Color color;

  PrismPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    for (var i = 0; i < 6; i++) {
      final angle = (i * math.pi * 2) / 6;
      final nextAngle = ((i + 1) * math.pi * 2) / 6;

      final point1 = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      final point2 = Offset(
        center.dx + radius * math.cos(nextAngle),
        center.dy + radius * math.sin(nextAngle),
      );

      canvas.drawLine(point1, point2, paint);
    }
  }

  @override
  bool shouldRepaint(PrismPainter oldDelegate) => false;
}

/// A 3D pyramid achievement card
class PyramidAchievementCard extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback? onComplete;
  final TeqaniRewardsTheme? theme;

  const PyramidAchievementCard({
    super.key,
    required this.achievement,
    this.onComplete,
    this.theme,
  });

  @override
  State<PyramidAchievementCard> createState() => _PyramidAchievementCardState();
}

class _PyramidAchievementCardState extends State<PyramidAchievementCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
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
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onComplete,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.identity()
                      ..translate(0.0, _isHovered ? -5.0 : 0.0),
                    child: Card(
                      elevation: _isHovered ? 14 : 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.achievement.isUnlocked 
                                  ? rewardsTheme.primaryColor.withValues(alpha: 0.9)
                                  : rewardsTheme.inactiveColor.withValues(alpha: 0.9),
                              widget.achievement.isUnlocked 
                                  ? rewardsTheme.primaryColor.withValues(alpha: 0.7)
                                  : rewardsTheme.inactiveColor.withValues(alpha: 0.7),
                              widget.achievement.isUnlocked 
                                  ? rewardsTheme.primaryColor.withValues(alpha: 0.9)
                                  : rewardsTheme.inactiveColor.withValues(alpha: 0.9),
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            if (!widget.achievement.isUnlocked)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black.withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                            Positioned.fill(
                              child: CustomPaint(
                                painter: PyramidPainter(
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        widget.achievement.isUnlocked 
                                            ? Icons.workspace_premium
                                            : Icons.lock,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      widget.achievement.title,
                                      style: rewardsTheme.textStyles?.achievementTitleStyle?.copyWith(
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      widget.achievement.description,
                                      style: rewardsTheme.textStyles?.achievementDescriptionStyle?.copyWith(
                                        color: Colors.white.withValues(alpha: 0.9),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    if (!widget.achievement.isUnlocked) ...[
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: widget.onComplete,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: rewardsTheme.primaryColor,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: const Text('Unlock Achievement'),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class PyramidPainter extends CustomPainter {
  final Color color;

  PyramidPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final baseSize = size.width * 0.4;

    // Draw base square
    final baseRect = Rect.fromCenter(
      center: center,
      width: baseSize,
      height: baseSize,
    );
    canvas.drawRect(baseRect, paint);

    // Draw pyramid lines
    final top = Offset(center.dx, center.dy - baseSize);
    final bottomLeft = Offset(center.dx - baseSize / 2, center.dy + baseSize / 2);
    final bottomRight = Offset(center.dx + baseSize / 2, center.dy + baseSize / 2);
    final bottomTop = Offset(center.dx, center.dy + baseSize / 2);

    canvas.drawLine(top, bottomLeft, paint);
    canvas.drawLine(top, bottomRight, paint);
    canvas.drawLine(top, bottomTop, paint);
  }

  @override
  bool shouldRepaint(PyramidPainter oldDelegate) => false;
}

/// A modern achievement card with interactive elements
class ModernAchievementCard extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback onComplete;
  final TeqaniRewardsTheme? theme;

  const ModernAchievementCard({
    super.key,
    required this.achievement,
    required this.onComplete,
    this.theme,
  });

  @override
  State<ModernAchievementCard> createState() => _ModernAchievementCardState();
}

class _ModernAchievementCardState extends State<ModernAchievementCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
            if (_isExpanded) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: widget.achievement.isUnlocked
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.achievement.isUnlocked
                  ? Colors.green.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Background pattern
                Positioned.fill(
                  child: CustomPaint(
                    painter: DotsPatternPainter(
                      color: widget.achievement.isUnlocked
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                // Lock overlay for locked achievements
                if (!widget.achievement.isUnlocked)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                // Content
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(13),
                                child: Icon(
                                  widget.achievement.isUnlocked
                                      ? Icons.emoji_events
                                      : Icons.lock,
                                  color: widget.achievement.isUnlocked
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.achievement.title,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.achievement.isUnlocked
                                        ? 'Achievement Unlocked'
                                        : 'Locked Achievement',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: widget.achievement.isUnlocked
                                              ? Colors.green
                                              : Colors.grey,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: widget.achievement.isUnlocked ? 1.0 : 0.0,
                            backgroundColor: Colors.grey.withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              widget.achievement.isUnlocked
                                  ? Colors.green
                                  : Colors.blue,
                            ),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Description
                        Text(
                          widget.achievement.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        // Expandable content
                        SizeTransition(
                          sizeFactor: _controller,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Points: ${widget.achievement.points}',
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                  if (widget.achievement.unlockedAt != null)
                                    Text(
                                      'Unlocked: ${widget.achievement.unlockedAt!.toString().split(' ')[0]}',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (!widget.achievement.isUnlocked)
                                Center(
                                  child: ElevatedButton(
                                    onPressed: widget.onComplete,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Unlock Achievement'),
                                  ),
                                ),
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
        ),
      ),
    );
  }
}

/// A minimalist achievement card with clean design
class MinimalistAchievementCard extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback? onComplete;
  final TeqaniRewardsTheme? theme;

  const MinimalistAchievementCard({
    super.key,
    required this.achievement,
    this.onComplete,
    this.theme,
  });

  @override
  State<MinimalistAchievementCard> createState() => _MinimalistAchievementCardState();
}

class _MinimalistAchievementCardState extends State<MinimalistAchievementCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rewardsTheme = widget.theme ?? TeqaniRewardsTheme.defaultTheme;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onComplete,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.identity()
              ..translate(0.0, _isHovered ? -3.0 : 0.0),
            child: Card(
              elevation: _isHovered ? 6 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: widget.achievement.isUnlocked 
                      ? rewardsTheme.primaryColor.withValues(alpha: 0.1)
                      : rewardsTheme.inactiveColor.withValues(alpha: 0.1),
                  border: Border.all(
                    color: widget.achievement.isUnlocked 
                        ? rewardsTheme.primaryColor.withValues(alpha: 0.3)
                        : rewardsTheme.inactiveColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: widget.achievement.isUnlocked 
                              ? rewardsTheme.primaryColor.withValues(alpha: 0.1)
                              : rewardsTheme.inactiveColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: widget.achievement.isUnlocked 
                                ? rewardsTheme.primaryColor.withValues(alpha: 0.3)
                                : rewardsTheme.inactiveColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          widget.achievement.isUnlocked 
                              ? Icons.check_circle
                              : Icons.lock_outline,
                          size: 24,
                          color: widget.achievement.isUnlocked 
                              ? rewardsTheme.primaryColor
                              : rewardsTheme.inactiveColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.achievement.title,
                              style: rewardsTheme.textStyles?.achievementTitleStyle?.copyWith(
                                color: widget.achievement.isUnlocked 
                                    ? rewardsTheme.primaryColor
                                    : rewardsTheme.inactiveColor,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.achievement.description,
                              style: rewardsTheme.textStyles?.achievementDescriptionStyle?.copyWith(
                                color: widget.achievement.isUnlocked 
                                    ? rewardsTheme.primaryColor.withValues(alpha: 0.8)
                                    : rewardsTheme.inactiveColor.withValues(alpha: 0.8),
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (!widget.achievement.isUnlocked)
                        IconButton(
                          onPressed: widget.onComplete,
                          icon: Icon(
                            Icons.arrow_forward,
                            color: rewardsTheme.inactiveColor,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A gradient achievement card with animated background
class GradientAchievementCard extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback? onComplete;
  final TeqaniRewardsTheme? theme;

  const GradientAchievementCard({
    super.key,
    required this.achievement,
    this.onComplete,
    this.theme,
  });

  @override
  State<GradientAchievementCard> createState() => _GradientAchievementCardState();
}

class _GradientAchievementCardState extends State<GradientAchievementCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _gradientAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _gradientAnimation = Tween<double>(begin: 0, end: 1).animate(
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
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onComplete,
            child: AnimatedBuilder(
              animation: _gradientAnimation,
              builder: (context, child) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.identity()
                    ..translate(0.0, _isHovered ? -5.0 : 0.0),
                  child: Card(
                    elevation: _isHovered ? 10 : 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment(
                            math.cos(_gradientAnimation.value * math.pi * 2),
                            math.sin(_gradientAnimation.value * math.pi * 2),
                          ),
                          end: Alignment(
                            -math.cos(_gradientAnimation.value * math.pi * 2),
                            -math.sin(_gradientAnimation.value * math.pi * 2),
                          ),
                          colors: widget.achievement.isUnlocked
                              ? [
                                  rewardsTheme.primaryColor,
                                  rewardsTheme.primaryColor.withValues(alpha: 0.7),
                                  rewardsTheme.primaryColor.withValues(alpha: 0.5),
                                ]
                              : [
                                  rewardsTheme.inactiveColor,
                                  rewardsTheme.inactiveColor.withValues(alpha: 0.7),
                                  rewardsTheme.inactiveColor.withValues(alpha: 0.5),
                                ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          if (!widget.achievement.isUnlocked)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black.withValues(alpha: 0.3),
                                ),
                              ),
                            ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      widget.achievement.isUnlocked 
                                          ? Icons.auto_awesome
                                          : Icons.lock,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    widget.achievement.title,
                                    style: rewardsTheme.textStyles?.achievementTitleStyle?.copyWith(
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.achievement.description,
                                    style: rewardsTheme.textStyles?.achievementDescriptionStyle?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.9),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  if (!widget.achievement.isUnlocked) ...[
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: widget.onComplete,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: rewardsTheme.primaryColor,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: const Text('Unlock Achievement'),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
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
    final rows = (size.height / spacing).ceil();
    final cols = (size.width / spacing).ceil();

    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        final x = j * spacing;
        final y = i * spacing;
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DotsPatternPainter oldDelegate) => false;
} 