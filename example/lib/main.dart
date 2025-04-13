import 'package:flutter/material.dart';
import 'package:teqani_rewards/teqani_rewards.dart';
import 'storage_service_example.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Teqani Rewards with Firebase Analytics
  await TeqaniRewards.init(
    theme: const TeqaniRewardsTheme(
      primaryColor: Colors.blue,
      secondaryColor: Colors.green,
    ),
    storageType: StorageType.sqlite,
    enableAnalytics: false,
  );

  runApp(const TeqaniRewardsDemoApp());
}

class TeqaniRewardsDemoApp extends StatelessWidget {
  const TeqaniRewardsDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teqani Rewards Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TeqaniRewardsDemoScreen(),
    );
  }
}

class TeqaniRewardsDemoScreen extends StatefulWidget {
  const TeqaniRewardsDemoScreen({super.key});

  @override
  State<TeqaniRewardsDemoScreen> createState() =>
      _TeqaniRewardsDemoScreenState();
}

class _TeqaniRewardsDemoScreenState extends State<TeqaniRewardsDemoScreen> {
  late Map<String, Streak> _streaks;

  int _selectedSection = 0;
  late Map<String, Achievement> _achievements;
  late Map<String, Challenge> _challenges;

  @override
  void initState() {
    super.initState();
    _initializeStreaks();
    _initializeAchievements();
    _initializeChallenges();
    // _checkOnboarding();
  }

  void _initializeAchievements() {
    _achievements = {
      'first_streak': Achievement(
        id: 'first_streak',
        title: 'First Streak',
        description: 'Complete your first streak',
        points: 100,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      'seven_day_streak': Achievement(
        id: 'seven_day_streak',
        title: '7 Day Streak',
        description: 'Maintain a streak for 7 days',
        points: 200,
        isUnlocked: _streaks['floating_streak']!.currentStreak >= 7,
      ),
      'fourteen_day_streak': Achievement(
        id: 'fourteen_day_streak',
        title: '14 Day Streak',
        description: 'Maintain a streak for 14 days',
        points: 300,
        isUnlocked: _streaks['floating_streak']!.currentStreak >= 14,
      ),
      'twenty_one_day_streak': Achievement(
        id: 'twenty_one_day_streak',
        title: '21 Day Streak',
        description: 'Maintain a streak for 21 days',
        points: 400,
        isUnlocked: _streaks['floating_streak']!.currentStreak >= 21,
      ),
      'twenty_eight_day_streak': Achievement(
        id: 'twenty_eight_day_streak',
        title: '28 Day Streak',
        description: 'Maintain a streak for 28 days',
        points: 500,
        isUnlocked: _streaks['floating_streak']!.currentStreak >= 28,
      ),
      'thirty_day_streak': Achievement(
        id: 'thirty_day_streak',
        title: '30 Day Streak',
        description: 'Maintain a streak for 30 days',
        points: 600,
        isUnlocked: _streaks['floating_streak']!.currentStreak >= 30,
      ),
    };
  }

  void _initializeStreaks() {
    _streaks = {
      'floating_streak': Streak(
        id: 'floating_streak',
        currentStreak: 5,
        longestStreak: 10,
        lastActivityDate: DateTime.now(),
        streakType: 'daily',
      ),
      'modern_streak': Streak(
        id: 'modern_streak',
        currentStreak: 3,
        longestStreak: 7,
        lastActivityDate: DateTime.now().subtract(const Duration(days: 1)),
        streakType: 'daily',
      ),
      'circular_streak': Streak(
        id: 'circular_streak',
        currentStreak: 7,
        longestStreak: 14,
        lastActivityDate: DateTime.now(),
        streakType: 'daily',
      ),
      'calendar_streak': Streak(
        id: 'calendar_streak',
        currentStreak: 2,
        longestStreak: 5,
        lastActivityDate: DateTime.now().subtract(const Duration(days: 2)),
        streakType: 'daily',
      ),
      'pulsating_streak': Streak(
        id: 'pulsating_streak',
        currentStreak: 10,
        longestStreak: 15,
        lastActivityDate: DateTime.now(),
        streakType: 'daily',
      ),
      'count_up_streak': Streak(
        id: 'count_up_streak',
        currentStreak: 1,
        longestStreak: 3,
        lastActivityDate: DateTime.now().subtract(const Duration(days: 3)),
        streakType: 'daily',
      ),
    };
  }

  void _initializeChallenges() {
    _challenges = {
      'daily_login': Challenge(
        id: 'daily_login',
        title: 'Daily Login',
        description: 'Log in every day for a week',
        points: 100,
        type: 'daily',
        progress: _streaks['floating_streak']!.currentStreak / 7,
        startDate: DateTime.now().subtract(const Duration(days: 7)),
        endDate: DateTime.now().add(const Duration(days: 7)),
        isCompleted: _streaks['floating_streak']!.currentStreak >= 7,
        lastUpdated: DateTime.now(),
      ),
      'two_week_streak': Challenge(
        id: 'two_week_streak',
        title: 'Two Week Streak',
        description: 'Maintain your streak for 14 days',
        points: 200,
        type: 'streak',
        progress: _streaks['floating_streak']!.currentStreak / 14,
        startDate: DateTime.now().subtract(const Duration(days: 14)),
        endDate: DateTime.now().add(const Duration(days: 14)),
        isCompleted: _streaks['floating_streak']!.currentStreak >= 14,
        lastUpdated: DateTime.now(),
      ),
      'three_week_streak': Challenge(
        id: 'three_week_streak',
        title: 'Three Week Streak',
        description: 'Maintain your streak for 21 days',
        points: 300,
        type: 'streak',
        progress: _streaks['floating_streak']!.currentStreak / 21,
        startDate: DateTime.now().subtract(const Duration(days: 21)),
        endDate: DateTime.now().add(const Duration(days: 21)),
        isCompleted: _streaks['floating_streak']!.currentStreak >= 21,
        lastUpdated: DateTime.now(),
      ),
      'four_week_streak': Challenge(
        id: 'four_week_streak',
        title: 'Four Week Streak',
        description: 'Maintain your streak for 28 days',
        points: 400,
        type: 'streak',
        progress: _streaks['floating_streak']!.currentStreak / 28,
        startDate: DateTime.now().subtract(const Duration(days: 28)),
        endDate: DateTime.now().add(const Duration(days: 28)),
        isCompleted: _streaks['floating_streak']!.currentStreak >= 28,
        lastUpdated: DateTime.now(),
      ),
      'monthly_master': Challenge(
        id: 'monthly_master',
        title: 'Monthly Master',
        description: 'Complete a 30-day streak',
        points: 500,
        type: 'streak',
        progress: _streaks['floating_streak']!.currentStreak / 30,
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now().add(const Duration(days: 30)),
        isCompleted: _streaks['floating_streak']!.currentStreak >= 30,
        lastUpdated: DateTime.now(),
      ),
      'ultimate_streak': Challenge(
        id: 'ultimate_streak',
        title: 'Ultimate Streak',
        description: 'Complete a 100-day streak',
        points: 1000,
        type: 'streak',
        progress: _streaks['floating_streak']!.currentStreak / 100,
        startDate: DateTime.now().subtract(const Duration(days: 100)),
        endDate: DateTime.now().add(const Duration(days: 100)),
        isCompleted: _streaks['floating_streak']!.currentStreak >= 100,
        lastUpdated: DateTime.now(),
      ),
    };
  }

  void _unlockAchievement(String achievementId) {
    setState(() {
      _achievements[achievementId] = _achievements[achievementId]!.copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
    });
    
    // Save the updated achievement to storage
    TeqaniRewards.storageManager.saveAchievement(_achievements[achievementId]!.toJson());
    
    TeqaniRewards.analyticsService?.logAchievementUnlocked(
      achievementId: achievementId,
      achievementTitle: _achievements[achievementId]!.title,
    );
  }

  void _updateStreak(String streakId) {
    setState(() {
      _streaks[streakId] = _streaks[streakId]!.copyWith(
        currentStreak: _streaks[streakId]!.currentStreak + 1,
        longestStreak: _streaks[streakId]!.currentStreak + 1 > _streaks[streakId]!.longestStreak
            ? _streaks[streakId]!.currentStreak + 1
            : _streaks[streakId]!.longestStreak,
        lastActivityDate: DateTime.now(),
      );
    });
    
    // Save the updated streak to storage
    TeqaniRewards.storageManager.saveStreak(_streaks[streakId]!.toJson());
    
    TeqaniRewards.analyticsService?.logStreakUpdated(
      currentStreak: _streaks[streakId]!.currentStreak,
      longestStreak: _streaks[streakId]!.longestStreak,
    );
  }

  void _updateChallenge(String challengeId) {
    setState(() {
      final challenge = _challenges[challengeId]!;
      final newProgress = (challenge.progress + 0.1).clamp(0.0, 1.0);
      _challenges[challengeId] = challenge.copyWith(
        progress: newProgress,
        lastUpdated: DateTime.now(),
        isCompleted: newProgress >= 1.0,
      );
    });
    
    // Save the updated challenge
    TeqaniRewards.storageManager.saveStreak({
      ..._challenges[challengeId]!.toJson(),
      'type': 'challenge',
    });
  }

  void _updateFloatingStreak() {
    _updateStreak('floating_streak');
  }

  void _updateModernStreak() {
    _updateStreak('modern_streak');
  }

  void _updateCircularStreak() {
    _updateStreak('circular_streak');
  }

  void _updateCalendarStreak() {
    _updateStreak('calendar_streak');
  }

  void _updatePulsatingStreak() {
    _updateStreak('pulsating_streak');
  }

  void _updateCountUpStreak() {
    _updateStreak('count_up_streak');
  }

  void _updateDailyLoginChallenge() {
    _updateChallenge('daily_login');
  }

  void _updateTwoWeekChallenge() {
    _updateChallenge('two_week_streak');
  }

  void _updateThreeWeekChallenge() {
    _updateChallenge('three_week_streak');
  }

  void _updateFourWeekChallenge() {
    _updateChallenge('four_week_streak');
  }

  void _updateMonthlyChallenge() {
    _updateChallenge('monthly_master');
  }

  void _updateUltimateChallenge() {
    _updateChallenge('ultimate_streak');
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildOnboardingSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionTitle('Gamified Onboarding'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Interactive onboarding with game-like elements',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      GamifiedOnboardingDialog.showGamifiedOnboarding(
                        context,
                        title: 'Welcome to Teqani Rewards',
                        subtitle: 'Your journey to success begins here',
                        onComplete: () {},
                        steps: [
                          const OnboardingStep(
                            title: 'Welcome to Teqani Rewards',
                            description: 'Track your progress and earn rewards',
                            icon: Icons.star,
                          ),
                          const OnboardingStep(
                            title: 'Streaks',
                            description: 'Maintain your daily streaks',
                            icon: Icons.local_fire_department,
                          ),
                          const OnboardingStep(
                            title: 'Achievements',
                            description: 'Unlock achievements as you progress',
                            icon: Icons.emoji_events,
                          ),
                          const OnboardingStep(
                            title: 'Challenges',
                            description: 'Complete challenges to earn rewards',
                            icon: Icons.flag,
                          ),
                        ],
                      );
                    },
                    child: const Text('Show Gamified Onboarding'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Quest Onboarding'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Adventure-style onboarding with quests',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      QuestOnboardingDialog.showQuestOnboarding(
                        context,
                        title: 'Your Quest Begins',
                        subtitle: 'Embark on an adventure of achievement',
                        onComplete: () {},
                        steps: [
                          const OnboardingStep(
                            title: 'Begin Your Journey',
                            description: 'Start your path to greatness',
                            icon: Icons.map,
                          ),
                          const OnboardingStep(
                            title: 'Track Your Progress',
                            description: 'Watch your streaks grow',
                            icon: Icons.trending_up,
                          ),
                          const OnboardingStep(
                            title: 'Collect Achievements',
                            description: 'Unlock badges and rewards',
                            icon: Icons.workspace_premium,
                          ),
                          const OnboardingStep(
                            title: 'Complete Challenges',
                            description: 'Test your dedication',
                            icon: Icons.flag,
                          ),
                        ],
                      );
                    },
                    child: const Text('Show Quest Onboarding'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Pulse Onboarding'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Animated onboarding with pulsing effects',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      PulseOnboardingDialog.showPulseOnboarding(
                        context,
                        title: 'Get Started with Teqani',
                        subtitle: 'Experience the power of consistent progress',
                        onComplete: () {},
                        steps: [
                          const OnboardingStep(
                            title: 'Welcome to Teqani',
                            description: 'Your journey begins here',
                            icon: Icons.rocket_launch,
                          ),
                          const OnboardingStep(
                            title: 'Build Your Streak',
                            description: 'Consistency is key to success',
                            icon: Icons.local_fire_department,
                          ),
                          const OnboardingStep(
                            title: 'Earn Achievements',
                            description: 'Reach milestones and unlock rewards',
                            icon: Icons.emoji_events,
                          ),
                          const OnboardingStep(
                            title: 'Take on Challenges',
                            description: 'Push yourself to new heights',
                            icon: Icons.flag,
                          ),
                        ],
                      );
                    },
                    child: const Text('Show Pulse Onboarding'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Custom Onboarding'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create your own custom onboarding experience',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      GamifiedOnboardingDialog.showGamifiedOnboarding(
                        context,
                        title: 'Customize Your Experience',
                        subtitle: 'Tailor Teqani Rewards to your needs',
                        onComplete: () {},
                        steps: [
                          const OnboardingStep(
                            title: 'Custom Onboarding',
                            description: 'Tailored to your needs',
                            icon: Icons.settings,
                          ),
                          const OnboardingStep(
                            title: 'Flexible Design',
                            description: 'Adapt to your app\'s style',
                            icon: Icons.palette,
                          ),
                          const OnboardingStep(
                            title: 'Easy Integration',
                            description: 'Simple to implement',
                            icon: Icons.code,
                          ),
                          const OnboardingStep(
                            title: 'User Friendly',
                            description: 'Intuitive and engaging',
                            icon: Icons.people,
                          ),
                        ],
                      );
                    },
                    child: const Text('Show Custom Onboarding'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionTitle('Floating Streak'),
          TeqaniStreakWidgets.floating(
            streak: _streaks['floating_streak']!,
            onUpdate: _updateFloatingStreak,
          ),
          _buildSectionTitle('Modern Streak'),
          TeqaniStreakWidgets.modern(
            streak: _streaks['modern_streak']!,
            onUpdate: _updateModernStreak,
          ),
          _buildSectionTitle('Circular Progress'),
          TeqaniStreakWidgets.circularProgress(
            streak: _streaks['circular_streak']!,
            onUpdate: _updateCircularStreak,
          ),
          _buildSectionTitle('Calendar View'),
          TeqaniStreakWidgets.calendar(
            streak: _streaks['calendar_streak']!,
            onUpdate: _updateCalendarStreak,
          ),
          _buildSectionTitle('Pulsating Streak'),
          TeqaniStreakWidgets.pulsating(
            streak: _streaks['pulsating_streak']!,
            onUpdate: _updatePulsatingStreak,
          ),
          _buildSectionTitle('Count Up Streak'),
          TeqaniStreakWidgets.countUp(
            streak: _streaks['count_up_streak']!,
            onUpdate: _updateCountUpStreak,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionTitle('Cube Achievement'),
          Center(
            child: SizedBox(
              width: 250,
              height: 250,
              child: Center(
                child: CubeAchievementCard(
                  achievement: _achievements['first_streak']!,
                  onComplete: () => _unlockAchievement('first_streak'),
                ),
              ),
            ),
          ),
          _buildSectionTitle('Prism Achievement'),
          Center(
            child: SizedBox(
              width: 250,
              height: 250,
              child: Center(
                child: PrismAchievementCard(
                  achievement: _achievements['seven_day_streak']!,
                  onComplete: () => _unlockAchievement('seven_day_streak'),
                ),
              ),
            ),
          ),
          _buildSectionTitle('Pyramid Achievement'),
          Center(
            child: SizedBox(
              width: 250,
              height: 250,
              child: Center(
                child: PyramidAchievementCard(
                  achievement: _achievements['fourteen_day_streak']!,
                  onComplete: () => _unlockAchievement('fourteen_day_streak'),
                ),
              ),
            ),
          ),
          _buildSectionTitle('Modern Achievement'),
          Center(
            child: ModernAchievementCard(
              achievement: _achievements['twenty_one_day_streak']!,
              onComplete: () => _unlockAchievement('twenty_one_day_streak'),
            ),
          ),
          _buildSectionTitle('Minimalist Achievement'),
          Center(
            child: MinimalistAchievementCard(
              achievement: _achievements['twenty_eight_day_streak']!,
              onComplete: () => _unlockAchievement('twenty_eight_day_streak'),
            ),
          ),
          _buildSectionTitle('Gradient Achievement'),
          Center(
            child: SizedBox(
              width: 250,
              height: 250,
              child: Center(
                child: GradientAchievementCard(
                  achievement: _achievements['thirty_day_streak']!,
                  onComplete: () => _unlockAchievement('thirty_day_streak'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionTitle('Circular Challenge'),
          CircularChallengeCard(
            challenge: _challenges['daily_login']!,
            onComplete: _updateDailyLoginChallenge,
          ),
          _buildSectionTitle('Timeline Challenge'),
          TimelineChallengeCard(
            challenge: _challenges['two_week_streak']!,
            onComplete: _updateTwoWeekChallenge,
          ),
          _buildSectionTitle('Flip Challenge'),
          FlipChallengeCard(
            challenge: _challenges['three_week_streak']!,
            onComplete: _updateThreeWeekChallenge,
          ),
          _buildSectionTitle('Pulse Challenge'),
          PulseChallengeCard(
            challenge: _challenges['four_week_streak']!,
            onComplete: _updateFourWeekChallenge,
          ),
          _buildSectionTitle('Wave Challenge'),
          WaveChallengeCard(
            challenge: _challenges['monthly_master']!,
            onComplete: _updateMonthlyChallenge,
          ),
          _buildSectionTitle('Gradient Challenge'),
          GradientChallengeCard(
            challenge: _challenges['ultimate_streak']!,
            onComplete: _updateUltimateChallenge,
          ),
        ],
      ),
    );
  }

  Widget _buildStorageServiceSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionTitle('Storage Service'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Demonstration of the Storage Service functionality',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StorageServiceExample(),
                        ),
                      );
                    },
                    child: const Text('Open Storage Service Example'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teqani Rewards Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _streaks = {
                  'floating_streak': Streak(
                    id: 'floating_streak',
                    currentStreak: 5,
                    longestStreak: 10,
                    lastActivityDate: DateTime.now(),
                    streakType: 'daily',
                  ),
                  'modern_streak': Streak(
                    id: 'modern_streak',
                    currentStreak: 3,
                    longestStreak: 7,
                    lastActivityDate: DateTime.now().subtract(const Duration(days: 1)),
                    streakType: 'daily',
                  ),
                  'circular_streak': Streak(
                    id: 'circular_streak',
                  currentStreak: 7,
                  longestStreak: 14,
                  lastActivityDate: DateTime.now(),
                  streakType: 'daily',
                  ),
                  'calendar_streak': Streak(
                    id: 'calendar_streak',
                    currentStreak: 2,
                    longestStreak: 5,
                    lastActivityDate: DateTime.now().subtract(const Duration(days: 2)),
                    streakType: 'daily',
                  ),
                  'pulsating_streak': Streak(
                    id: 'pulsating_streak',
                    currentStreak: 10,
                    longestStreak: 15,
                    lastActivityDate: DateTime.now(),
                    streakType: 'daily',
                  ),
                  'count_up_streak': Streak(
                    id: 'count_up_streak',
                    currentStreak: 1,
                    longestStreak: 3,
                    lastActivityDate: DateTime.now().subtract(const Duration(days: 3)),
                    streakType: 'daily',
                  ),
                };
              });
              
              // Save the reset streaks to storage
              for (var streak in _streaks.values) {
                TeqaniRewards.storageManager.saveStreak(streak.toJson());
              }
              
              TeqaniRewards.analyticsService?.logReset();
            },
          ),
        ],
      ),
      body: _selectedSection == 0
          ? _buildOnboardingSection()
          : _selectedSection == 1
              ? _buildStorageServiceSection()
              : _selectedSection == 2
                  ? _buildStreakSection()
                  : _selectedSection == 3
                      ? _buildAchievementSection()
                      : _buildChallengeSection(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedSection,
        onTap: (index) {
          setState(() {
            _selectedSection = index;
          });
          
          TeqaniRewards.analyticsService?.logNavigation(
            section: ['Onboarding', 'Storage', 'Streaks', 'Achievements', 'Challenges'][index],
          );
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.tour),
            label: 'Onboarding',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: 'Storage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department),
            label: 'Streaks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Achievements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Challenges',
          ),
        ],
      ),
    );
  }
}
