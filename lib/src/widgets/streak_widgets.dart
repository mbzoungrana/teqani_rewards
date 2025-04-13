import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/streak.dart';
import '../theme/teqani_rewards_theme.dart';

/// A collection of pre-built streak widgets for displaying user achievements
class TeqaniStreakWidgets {
  /// Creates a pulsating streak widget with fire animation
  static Widget pulsating({
    required Streak streak,
    VoidCallback? onUpdate,
    TeqaniRewardsTheme? theme,
  }) {
    return PulsatingStreakWidget(
      streak: streak,
      onUpdate: onUpdate,
      theme: theme,
    );
  }

  /// Creates a counting up streak widget with animation
  static Widget countUp({
    required Streak streak,
    VoidCallback? onUpdate,
    TeqaniRewardsTheme? theme,
  }) {
    return CountUpStreakWidget(
      streak: streak,
      onUpdate: onUpdate,
      theme: theme,
    );
  }

  /// Creates a modern non-animated streak card
  static Widget modern({
    required Streak streak,
    VoidCallback? onUpdate,
    TeqaniRewardsTheme? theme,
  }) {
    return ModernStreakCard(
      streak: streak,
      onUpdate: onUpdate,
      theme: theme,
    );
  }

  /// Creates a streak calendar view showing weekly progress
  static Widget calendar({
    required Streak streak,
    VoidCallback? onUpdate,
    TeqaniRewardsTheme? theme,
  }) {
    return StreakCalendarView(
      streak: streak,
      onUpdate: onUpdate,
      theme: theme,
    );
  }

  /// Creates a streak widget with circular progress animation
  static Widget circularProgress({
    required Streak streak,
    VoidCallback? onUpdate,
    TeqaniRewardsTheme? theme,
  }) {
    return CircularProgressStreakWidget(
      streak: streak,
      onUpdate: onUpdate,
      theme: theme,
    );
  }

  /// Creates a streak widget with floating elements animation
  static Widget floating({
    required Streak streak,
    VoidCallback? onUpdate,
    TeqaniRewardsTheme? theme,
  }) {
    return FloatingStreakWidget(
      streak: streak,
      onUpdate: onUpdate,
      theme: theme,
    );
  }
}

/// A pulsating streak widget with fire animation
class PulsatingStreakWidget extends StatefulWidget {
  final Streak streak;
  final VoidCallback? onUpdate;
  final TeqaniRewardsTheme? theme;

  const PulsatingStreakWidget({
    super.key,
    required this.streak,
    this.onUpdate,
    this.theme,
  });

  @override
  State<PulsatingStreakWidget> createState() => _PulsatingStreakWidgetState();
}

class _PulsatingStreakWidgetState extends State<PulsatingStreakWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
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
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              boxShadow: _isHovered ? [
                BoxShadow(
                  color: rewardsTheme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ] : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Current Streak',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer circle
                    Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              rewardsTheme.primaryColor.withValues(alpha: _opacityAnimation.value),
                              rewardsTheme.primaryColor.withValues(alpha: 0.1),
                            ],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                    // Middle circle
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: rewardsTheme.primaryColor.withValues(alpha: 0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    // Flames
                    _buildFlames(rewardsTheme.primaryColor),
                    // Content
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          size: 40,
                          color: rewardsTheme.primaryColor,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${widget.streak.currentStreak}',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: rewardsTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'DAYS',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: rewardsTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Longest',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.streak.longestStreak} days',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Last Active',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.streak.lastActivityDate.toString().split(' ')[0],
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: widget.onUpdate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rewardsTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Update Streak'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFlames(Color color) {
    return CustomPaint(
      size: const Size(160, 160),
      painter: FlamePainter(
        color: color,
        progress: _controller.value,
      ),
    );
  }
}

class FlamePainter extends CustomPainter {
  final Color color;
  final double progress;

  FlamePainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Draw flame particles
    for (int i = 0; i < 15; i++) {
      final angle = (i / 15) * 2 * math.pi;
      final offset = 0.1 * math.sin(progress * math.pi * 2 + i);
      final x = center.dx + (radius + offset * 20) * math.cos(angle);
      final y = center.dy + (radius + offset * 20) * math.sin(angle);
      
      final paint = Paint()
        ..color = color.withValues(alpha: 0.3 + (0.7 * progress))
        ..style = PaintingStyle.fill
        ..strokeWidth = 2;
        
      canvas.drawCircle(Offset(x, y), 4 + (progress * 3), paint);
    }
  }

  @override
  bool shouldRepaint(FlamePainter oldDelegate) => true;
}

/// A counting up streak widget with animation
class CountUpStreakWidget extends StatefulWidget {
  final Streak streak;
  final VoidCallback? onUpdate;
  final TeqaniRewardsTheme? theme;

  const CountUpStreakWidget({
    super.key,
    required this.streak,
    this.onUpdate,
    this.theme,
  });

  @override
  State<CountUpStreakWidget> createState() => _CountUpStreakWidgetState();
}

class _CountUpStreakWidgetState extends State<CountUpStreakWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _countAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _countAnimation = IntTween(begin: 0, end: widget.streak.currentStreak).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CountUpStreakWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.streak.currentStreak != widget.streak.currentStreak) {
      _countAnimation = IntTween(
        begin: oldWidget.streak.currentStreak,
        end: widget.streak.currentStreak,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final rewardsTheme = widget.theme ?? TeqaniRewardsTheme.defaultTheme;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -5.0 : 0.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              rewardsTheme.primaryColor.withValues(alpha: 0.1),
              rewardsTheme.primaryColor.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isHovered ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ] : null,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Streak',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: rewardsTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Keep it going!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: rewardsTheme.primaryColor.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    Icons.local_fire_department,
                    color: rewardsTheme.primaryColor,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            AnimatedBuilder(
              animation: _countAnimation,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${_countAnimation.value}',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: rewardsTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        ' days',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: rewardsTheme.primaryColor.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 30),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: widget.streak.currentStreak / (widget.streak.longestStreak > 0 ? widget.streak.longestStreak : 10),
                minHeight: 8,
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(rewardsTheme.primaryColor),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Longest: ${widget.streak.longestStreak} days',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: widget.onUpdate,
              icon: const Icon(Icons.add),
              label: const Text('Check In Today'),
              style: ElevatedButton.styleFrom(
                backgroundColor: rewardsTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A modern non-animated streak card
class ModernStreakCard extends StatelessWidget {
  final Streak streak;
  final VoidCallback? onUpdate;
  final TeqaniRewardsTheme? theme;

  const ModernStreakCard({
    super.key,
    required this.streak,
    this.onUpdate,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final rewardsTheme = theme ?? TeqaniRewardsTheme.defaultTheme;
    
    return Card(
      elevation: 4,
      shadowColor: rewardsTheme.primaryColor.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Streak Stats',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: rewardsTheme.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${streak.currentStreak} days',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    title: 'Current',
                    value: '${streak.currentStreak}',
                    icon: Icons.trending_up,
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    title: 'Longest',
                    value: '${streak.longestStreak}',
                    icon: Icons.emoji_events,
                    color: Colors.amber,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    title: 'Last Active',
                    value: streak.lastActivityDate.toString().split(' ')[0],
                    icon: Icons.calendar_today,
                    color: Colors.blue,
                    isDate: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: streak.currentStreak / (streak.longestStreak > 0 ? streak.longestStreak : 10),
                minHeight: 8,
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(rewardsTheme.primaryColor),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onUpdate,
              style: ElevatedButton.styleFrom(
                backgroundColor: rewardsTheme.primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Update Streak'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool isDate = false,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        isDate
          ? FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
      ],
    );
  }
}

/// A streak calendar view showing weekly progress
class StreakCalendarView extends StatelessWidget {
  final Streak streak;
  final VoidCallback? onUpdate;
  final TeqaniRewardsTheme? theme;

  const StreakCalendarView({
    super.key,
    required this.streak,
    this.onUpdate,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final rewardsTheme = theme ?? TeqaniRewardsTheme.defaultTheme;
    final today = DateTime.now();
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: rewardsTheme.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Streak',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Current Streak: ${streak.currentStreak} days',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: rewardsTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.calendar_month,
                    color: rewardsTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (index) {
                final date = weekStart.add(Duration(days: index));
                final isToday = date.day == today.day && 
                               date.month == today.month && 
                               date.year == today.year;
                final isBeforeToday = date.isBefore(today);
                final isActive = isBeforeToday &&
                               DateTime.now().difference(date).inDays <= streak.currentStreak;
                
                return _buildDayColumn(
                  context,
                  day: _getWeekdayName(date.weekday),
                  date: date.day.toString(),
                  isActive: isActive,
                  isToday: isToday,
                  rewardsTheme: rewardsTheme,
                );
              }),
            ),
            const SizedBox(height: 30),
            Text(
              'Longest Streak',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: streak.currentStreak / (streak.longestStreak > 0 ? streak.longestStreak : 10),
                minHeight: 8,
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(rewardsTheme.primaryColor),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current: ${streak.currentStreak}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Goal: ${streak.longestStreak}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onUpdate,
                icon: const Icon(Icons.check),
                label: const Text('Check In Today'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: rewardsTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayColumn(
    BuildContext context, {
    required String day,
    required String date,
    required bool isActive,
    required bool isToday,
    required TeqaniRewardsTheme rewardsTheme,
  }) {
    return Column(
      children: [
        Text(
          day,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isToday
                ? rewardsTheme.primaryColor
                : isActive
                    ? rewardsTheme.primaryColor.withValues(alpha: 0.2)
                    : Colors.grey.withValues(alpha: 0.1),
            border: isToday
                ? null
                : Border.all(
                    color: isActive
                        ? rewardsTheme.primaryColor
                        : Colors.grey.withValues(alpha: 0.3),
                    width: 1,
                  ),
          ),
          child: Center(
            child: Text(
              date,
              style: TextStyle(
                color: isToday
                    ? Colors.white
                    : isActive
                        ? rewardsTheme.primaryColor
                        : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (isActive)
          Icon(
            Icons.check_circle,
            color: rewardsTheme.primaryColor,
            size: 16,
          )
        else
          const SizedBox(height: 16),
      ],
    );
  }

  String _getWeekdayName(int day) {
    switch (day) {
      case 1: return 'M';
      case 2: return 'T';
      case 3: return 'W';
      case 4: return 'T';
      case 5: return 'F';
      case 6: return 'S';
      case 7: return 'S';
      default: return '';
    }
  }
}

/// A streak widget with circular progress animation
class CircularProgressStreakWidget extends StatefulWidget {
  final Streak streak;
  final VoidCallback? onUpdate;
  final TeqaniRewardsTheme? theme;

  const CircularProgressStreakWidget({
    super.key,
    required this.streak,
    this.onUpdate,
    this.theme,
  });

  @override
  State<CircularProgressStreakWidget> createState() => _CircularProgressStreakWidgetState();
}

class _CircularProgressStreakWidgetState extends State<CircularProgressStreakWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.streak.currentStreak / (widget.streak.longestStreak > 0 ? widget.streak.longestStreak : 10),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CircularProgressStreakWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.streak.currentStreak != widget.streak.currentStreak) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: widget.streak.currentStreak / (widget.streak.longestStreak > 0 ? widget.streak.longestStreak : 10),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rewardsTheme = widget.theme ?? TeqaniRewardsTheme.defaultTheme;
    
    return Card(
      elevation: 8,
      shadowColor: rewardsTheme.primaryColor.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              rewardsTheme.primaryColor.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Streak Progress',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: rewardsTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: rewardsTheme.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.streak.currentStreak} days',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: rewardsTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return SizedBox(
                  height: 180,
                  width: 180,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background circle
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withValues(alpha: 0.1),
                        ),
                      ),
                      // Progress circle
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: CircularProgressIndicator(
                          value: _progressAnimation.value,
                          strokeWidth: 12,
                          backgroundColor: Colors.grey.withValues(alpha: 0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(rewardsTheme.primaryColor),
                        ),
                      ),
                      // Center content
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${widget.streak.currentStreak}',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: rewardsTheme.primaryColor,
                            ),
                          ),
                          Text(
                            'of ${widget.streak.longestStreak > 0 ? widget.streak.longestStreak : 10}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'DAYS',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      // Animated dots
                      ..._buildAnimatedDots(rewardsTheme.primaryColor),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStat(
                  context,
                  label: 'Longest',
                  value: '${widget.streak.longestStreak} days',
                ),
                _buildStat(
                  context,
                  label: 'Last Active',
                  value: widget.streak.lastActivityDate.toString().split(' ')[0],
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: widget.onUpdate,
                icon: const Icon(Icons.add),
                label: const Text('Continue Streak'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: rewardsTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAnimatedDots(Color color) {
    const int dotCount = 8;
    final List<Widget> dots = [];
    
    for (int i = 0; i < dotCount; i++) {
      final double angle = (i / dotCount) * 2 * math.pi;
      const double radius = 80;
      
      dots.add(
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final double animationProgress = (_controller.value * 2 + i / dotCount) % 1.0;
            final double dotSize = 10 * (animationProgress > 0.5 ? 1 - animationProgress : animationProgress);
            
            return Positioned(
              left: 90 + radius * math.cos(angle) - dotSize / 2,
              top: 90 + radius * math.sin(angle) - dotSize / 2,
              child: Opacity(
                opacity: _progressAnimation.value >= (i + 1) / dotCount ? 1.0 : 0.2,
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
    
    return dots;
  }

  Widget _buildStat(BuildContext context, {required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// A streak widget with floating elements animation
class FloatingStreakWidget extends StatefulWidget {
  final Streak streak;
  final VoidCallback? onUpdate;
  final TeqaniRewardsTheme? theme;

  const FloatingStreakWidget({
    super.key,
    required this.streak,
    this.onUpdate,
    this.theme,
  });

  @override
  State<FloatingStreakWidget> createState() => _FloatingStreakWidgetState();
}

class _FloatingStreakWidgetState extends State<FloatingStreakWidget> with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _rotateController;
  late List<Animation<double>> _iconAnimations;
  final List<Color> _iconColors = [
    Colors.red.shade300,
    Colors.orange.shade300,
    Colors.amber.shade300,
    Colors.green.shade300,
    Colors.blue.shade300,
    Colors.purple.shade300,
  ];
  final List<IconData> _icons = [
    Icons.star,
    Icons.local_fire_department,
    Icons.emoji_events,
    Icons.bolt,
    Icons.rocket_launch,
    Icons.favorite,
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 8000),
      vsync: this,
    );
    
    
    // Create animations for each floating icon
    _iconAnimations = List.generate(6, (index) {
      final startDelay = index * 0.15;
      // Ensure endDelay is always greater than startDelay and never exceeds 1.0
      final endDelay = (startDelay + 0.7).clamp(0.0, 0.99);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _floatController,
          curve: Interval(startDelay, endDelay, curve: Curves.easeOutBack),
        ),
      );
    });
    
    _floatController.repeat(reverse: true);
    _rotateController.repeat();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rewardsTheme = widget.theme ?? TeqaniRewardsTheme.defaultTheme;
    
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate the size for the central circle and floating icons
          final maxSize = constraints.maxWidth;
          final circleSize = maxSize * 0.5; // 50% of the container width
          final iconSize = circleSize * 0.2; // 20% of the circle size
          
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  rewardsTheme.primaryColor.withValues(alpha: 0.05),
                  Colors.white,
                  rewardsTheme.secondaryColor.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Achievement Streak',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: rewardsTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Keep the momentum going!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedBuilder(
                  animation: Listenable.merge([_floatController, _rotateController]),
                  builder: (context, child) {
                    return SizedBox(
                      height: circleSize,
                      width: circleSize,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Center streak count
                          Container(
                            width: circleSize * 0.8,
                            height: circleSize * 0.8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.white,
                                  rewardsTheme.primaryColor.withValues(alpha: 0.1),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: rewardsTheme.primaryColor.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${widget.streak.currentStreak}',
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: rewardsTheme.primaryColor,
                                    ),
                                  ),
                                  Text(
                                    'Days',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // Floating icons
                          ..._buildFloatingIcons(circleSize, iconSize),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _buildStatBox(
                        context, 
                        title: 'Current', 
                        value: '${widget.streak.currentStreak}',
                        icon: Icons.trending_up,
                        color: Colors.green,
                        rewardsTheme: rewardsTheme,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatBox(
                        context, 
                        title: 'Longest', 
                        value: '${widget.streak.longestStreak}',
                        icon: Icons.emoji_events,
                        color: Colors.amber,
                        rewardsTheme: rewardsTheme,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.onUpdate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: rewardsTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Extend Your Streak',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildFloatingIcons(double circleSize, double iconSize) {
    final List<Widget> floatingIcons = [];
    final radius = circleSize * 0.35; // 35% of the circle size
    
    for (int i = 0; i < _icons.length; i++) {
      final double angle = (i / _icons.length) * 2 * math.pi;
      
      // Calculate position
      final double x = radius * math.cos(angle + _rotateController.value * 2 * math.pi);
      final double y = radius * math.sin(angle + _rotateController.value * 2 * math.pi);
      
      // Float animation - move up and down
      final double yOffset = math.sin(_floatController.value * math.pi * 2) * 8;
      
      floatingIcons.add(
        Positioned(
          left: circleSize/2 + x - iconSize/2,
          top: circleSize/2 + y - iconSize/2 + yOffset,
          child: FadeTransition(
            opacity: _iconAnimations[i],
            child: Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: _iconColors[i].withValues(alpha: 0.5),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                _icons[i],
                color: _iconColors[i],
                size: iconSize * 0.6,
              ),
            ),
          ),
        ),
      );
    }
    
    return floatingIcons;
  }

  Widget _buildStatBox(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required TeqaniRewardsTheme rewardsTheme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
} 