import 'package:flutter/material.dart';
import 'dart:ui';
import 'onboarding_screen.dart';
import '../theme/teqani_rewards_theme.dart';

/// A dialog class for showing the gamified onboarding screen
class GamifiedOnboardingDialog {
  static Future<void> showGamifiedOnboarding(
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
      barrierColor: Colors.black.withValues(alpha:0.7),
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
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                  ),
                  decoration: BoxDecoration(
                    color: theme?.cardBackgroundColor ?? Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.2),
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
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: theme?.primaryColor.withValues(alpha:0.1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                            border: Border.all(
                              color: (theme?.primaryColor ?? Colors.blue)
                                  .withValues(alpha:0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              if (title != null)
                                Text(
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
                              if (subtitle != null) ...[
                                const SizedBox(height: 8),
                                Text(
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
                              ],
                            ],
                          ),
                        ),
                      Expanded(
                        child: GamifiedOnboarding(
                          theme: theme,
                          onComplete: onComplete ?? () {},
                          steps: steps,
                          title: title,
                          subtitle: subtitle,
                        ),
                      )
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

/// A gamified onboarding screen with scale and fade animations
class GamifiedOnboarding extends TeqaniOnboardingScreen {
  const GamifiedOnboarding({
    super.key,
    super.theme,
    required super.onComplete,
    required super.steps,
    super.title,
    super.subtitle,
  });

  @override
  State<GamifiedOnboarding> createState() => _GamifiedOnboardingState();
}

class _GamifiedOnboardingState extends TeqaniOnboardingState<GamifiedOnboarding>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void nextStep() {
    _animationController.reverse().then((_) {
      super.nextStep();
      _animationController.forward();
    });
  }

  @override
  void previousStep() {
    _animationController.reverse().then((_) {
      super.previousStep();
      _animationController.forward();
    });
  }

  @override
  Widget buildStepContent(OnboardingStep step) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: rewardsTheme.primaryColor.withValues(alpha:0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconContainer(step),
              const SizedBox(height: 32),
              _buildTitle(step),
              const SizedBox(height: 16),
              _buildDescription(step),
              const SizedBox(height: 32),
              if (step.customWidget != null) step.customWidget!,
              const SizedBox(height: 10),
              _buildProgressBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(OnboardingStep step) {
    final iconColor = step.iconColor ?? rewardsTheme.primaryColor;

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha:0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: iconColor.withValues(alpha:0.3),
          width: 2,
        ),
      ),
      child: Icon(
        step.icon,
        size: 40,
        color: iconColor,
      ),
    );
  }

  Widget _buildTitle(OnboardingStep step) {
    return Text(
      step.title,
      style: rewardsTheme.textStyles?.achievementTitleStyle ??
          Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: rewardsTheme.textColor,
                fontFamily: rewardsTheme.fontFamily,
              ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(OnboardingStep step) {
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

  Widget _buildProgressBar() {
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
                    : rewardsTheme.inactiveColor.withValues(alpha:0.2),
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
