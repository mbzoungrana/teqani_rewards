import 'package:flutter/material.dart';
import '../theme/teqani_rewards_theme.dart';
import 'gamified_onboarding.dart';
import 'quest_onboarding.dart';
import 'pulse_onboarding.dart';

/// Base class for all onboarding screens in TeqaniRewards
abstract class TeqaniOnboardingScreen extends StatefulWidget {
  final TeqaniRewardsTheme? theme;
  final VoidCallback onComplete;
  final List<OnboardingStep> steps;
  final String? title;
  final String? subtitle;

  const TeqaniOnboardingScreen({
    super.key,
    this.theme,
    required this.onComplete,
    required this.steps,
    this.title,
    this.subtitle,
  });

  @override
  State<TeqaniOnboardingScreen> createState();
}

/// Represents a single step in the onboarding process
class OnboardingStep {
  final String title;
  final String description;
  final IconData icon;
  final Color? iconColor;
  final Widget? customWidget;

  const OnboardingStep({
    required this.title,
    required this.description,
    required this.icon,
    this.iconColor,
    this.customWidget,
  });
}

/// Base state class for onboarding screens
abstract class TeqaniOnboardingState<T extends TeqaniOnboardingScreen>
    extends State<T> {
  int currentStep = 0;
  late PageController pageController;
  late TeqaniRewardsTheme rewardsTheme;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    rewardsTheme = widget.theme ?? TeqaniRewardsTheme.defaultTheme;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void nextStep() {
    if (currentStep < widget.steps.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        currentStep++;
      });
    } else {
      widget.onComplete();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        currentStep--;
      });
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step < widget.steps.length) {
      pageController.animateToPage(
        step,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        currentStep = step;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  itemCount: widget.steps.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentStep = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return buildStepContent(widget.steps[index]);
                  },
                ),
              ),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }


  /// Builds the content for a single onboarding step.
  /// This method must be implemented by subclasses to provide custom step content.
  @protected
  Widget buildStepContent(OnboardingStep step);

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (currentStep > 0)
            TextButton(
              onPressed: previousStep,
              child: Text(
                'Back',
                style: TextStyle(
                  color: rewardsTheme.primaryColor,
                  fontFamily: rewardsTheme.fontFamily,
                ),
              ),
            )
          else
            const SizedBox(width: 80),
          _buildStepIndicators(),
          ElevatedButton(
            onPressed: nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: rewardsTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(rewardsTheme.borderRadius),
              ),
            ),
            child: Text(
              currentStep < widget.steps.length - 1 ? 'Next' : 'Get Started',
              style: TextStyle(
                fontFamily: rewardsTheme.fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicators() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        widget.steps.length,
        (index) => Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentStep
                ? rewardsTheme.primaryColor
                : rewardsTheme.inactiveColor.withValues(alpha:0.3),
          ),
        ),
      ),
    );
  }
}

/// Widget factory for onboarding-related widgets
class TeqaniOnboardingWidgets {
  /// Show a gamified onboarding dialog
  static Future<void> showGamifiedOnboarding(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<OnboardingStep> steps,
    required VoidCallback onComplete,
    TeqaniRewardsTheme? theme,
  }) async {
    return GamifiedOnboardingDialog.showGamifiedOnboarding(
      context,
      title: title,
      subtitle: subtitle,
      steps: steps,
      onComplete: onComplete,
      theme: theme,
    );
  }

  /// Show a quest-style onboarding dialog
  static Future<void> showQuestOnboarding(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<OnboardingStep> steps,
    required VoidCallback onComplete,
    TeqaniRewardsTheme? theme,
  }) async {
    return QuestOnboardingDialog.showQuestOnboarding(
      context,
      title: title,
      subtitle: subtitle,
      steps: steps,
      onComplete: onComplete,
      theme: theme,
    );
  }

  /// Show a pulse-style onboarding dialog
  static Future<void> showPulseOnboarding(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<OnboardingStep> steps,
    required VoidCallback onComplete,
    TeqaniRewardsTheme? theme,
  }) async {
    return PulseOnboardingDialog.showPulseOnboarding(
      context,
      title: title,
      subtitle: subtitle,
      steps: steps,
      onComplete: onComplete,
      theme: theme,
    );
  }
}
