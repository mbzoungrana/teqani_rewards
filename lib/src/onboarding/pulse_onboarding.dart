import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';
import 'onboarding_screen.dart';
import '../theme/teqani_rewards_theme.dart';

/// A pulse-themed onboarding screen with rhythmic animations
class PulseOnboarding extends TeqaniOnboardingScreen {
  const PulseOnboarding({
    super.key,
    super.theme,
    required super.onComplete,
    required super.steps,
    super.title,
    super.subtitle,
  });

  @override
  State<PulseOnboarding> createState() => _PulseOnboardingState();
}

class _PulseOnboardingState extends TeqaniOnboardingState<PulseOnboarding>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );


    _floatAnimation = Tween<double> (begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void nextStep() {
    _animationController.stop();
    _animationController.forward(from: 0.0);
    super.nextStep();
  }

  @override
  void previousStep() {
    _animationController.stop();
    _animationController.forward(from: 0.0);
    super.previousStep();
  }

  @override
  Widget buildStepContent(OnboardingStep step) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 5 * sin(_floatAnimation.value * 2 * pi)),
          child: child,
        );
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: rewardsTheme.primaryColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: rewardsTheme.primaryColor.withValues(alpha: 0.2),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: rewardsTheme.primaryColor.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildParticleIcon(step),
              const SizedBox(height: 32),
              _buildPulseTitle(step),
              const SizedBox(height: 16),
              _buildPulseDescription(step),
              const SizedBox(height: 32),
              if (step.customWidget != null) step.customWidget!,
              const SizedBox(height: 10),
              _buildPulseProgress(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParticleIcon(OnboardingStep step) {
    final iconColor = step.iconColor ?? rewardsTheme.primaryColor;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Particle animation
        ...List.generate(12, (index) {
          final angle = (index / 12) * 2 * pi;
          const radius = 60.0;
          
          // Use a fixed approach with hardcoded intervals based on index
          // This ensures we never exceed 1.0 and end is always greater than start
          final intervals = [
            const Interval(0.0, 0.25, curve: Curves.easeInOut),
            const Interval(0.2, 0.45, curve: Curves.easeInOut),
            const Interval(0.4, 0.65, curve: Curves.easeInOut),
            const Interval(0.6, 0.85, curve: Curves.easeInOut),
          ];
          
          // Use modulo to cycle through intervals if index is out of range
          final intervalIndex = index % intervals.length;
          final interval = intervals[intervalIndex];
          
          // Ensure the interval is valid (end > start and end <= 1.0)
          final start = interval.begin;
          final end = interval.end.clamp(start + 0.01, 0.99);
          final validInterval = Interval(start, end, curve: interval.curve);
          
          final particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: validInterval,
            ),
          );

          return AnimatedBuilder(
            animation: particleAnimation,
            builder: (context, child) {
              final distance = radius * particleAnimation.value;
              final x = cos(angle) * distance;
              final y = sin(angle) * distance;
              final size = 8.0 * (1 - particleAnimation.value * 0.7);
              final opacity = 0.7 * (1 - particleAnimation.value);

              return Positioned(
                left: 80 + x,
                top: 80 + y,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: opacity),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          );
        }),

        // Central icon container
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: iconColor.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: iconColor.withValues(alpha: 0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(
            step.icon,
            size: 40,
            color: iconColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPulseTitle(OnboardingStep step) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: rewardsTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: rewardsTheme.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Text(
        step.title,
        style: rewardsTheme.textStyles?.achievementTitleStyle ??
            Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: rewardsTheme.textColor,
                  fontFamily: rewardsTheme.fontFamily,
                ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPulseDescription(OnboardingStep step) {
    return Text(
      step.description,
      style: rewardsTheme.textStyles?.achievementDescriptionStyle ??
          Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: rewardsTheme.secondaryTextColor,
                fontFamily: rewardsTheme.fontFamily,
              ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPulseProgress() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.steps.length,
            (index) => Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: index <= currentStep
                    ? rewardsTheme.primaryColor
                    : rewardsTheme.inactiveColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Step ${currentStep + 1}/${widget.steps.length}',
          style: rewardsTheme.textStyles?.streakDescriptionStyle ??
              Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: rewardsTheme.secondaryTextColor,
                    fontFamily: rewardsTheme.fontFamily,
                  ),
        ),
      ],
    );
  }
}

class PulseOnboardingDialog {
  static Future<void> showPulseOnboarding(
    BuildContext context, {
    required List<OnboardingStep> steps,
    TeqaniRewardsTheme? theme,
    String? title,
    String? subtitle,
    bool barrierDismissible = true,
    VoidCallback? onComplete,
  }) {
    // Store context in a local variable to avoid async gap issues
    final modalBarrierLabel =
        MaterialLocalizations.of(context).modalBarrierDismissLabel;

    return showGeneralDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: modalBarrierLabel,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation1, animation2) {
        return Container(); // This is required but won't be used
      },
    ).then((_) {
      // Check if the context is still valid
      if (!context.mounted) return Future<void>.value();

      return showDialog<void>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext dialogContext) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              contentPadding: EdgeInsets.zero,
              content: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutBack,
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.95,
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                    minWidth: MediaQuery.of(context).size.width * 0.8,
                  ),
                  decoration: BoxDecoration(
                    color: theme?.cardBackgroundColor ?? Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (title != null || subtitle != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: theme?.primaryColor.withValues(alpha: 0.1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                            border: Border.all(
                              color: (theme?.primaryColor ?? Colors.blue)
                                  .withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (title != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    title,
                                    style: theme
                                            ?.textStyles?.achievementTitleStyle ??
                                        Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: theme?.textColor,
                                              fontFamily: theme?.fontFamily,
                                            ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              if (subtitle != null) ...[
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    subtitle,
                                    style: theme?.textStyles
                                            ?.achievementDescriptionStyle ??
                                        Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: theme?.secondaryTextColor,
                                              fontFamily: theme?.fontFamily,
                                            ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                     
                      Expanded(
                        child: PulseOnboarding(
                          theme: theme,
                          steps: steps,
                          onComplete: () {
                            Navigator.of(dialogContext).pop();
                            onComplete?.call();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
