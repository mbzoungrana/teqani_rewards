<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# 🏆 Teqani Rewards for Flutter

The **most powerful and flexible gamification system** for Flutter applications, developed by [Teqani.org](https://teqani.org).

[![Pub](https://img.shields.io/pub/v/teqani_rewards.svg)](https://pub.dev/packages/teqani_rewards)
[![Flutter Platform](https://img.shields.io/badge/Platform-Flutter-02569B?logo=flutter)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-Support-yellow.svg)](https://www.buymeacoffee.com/Teqani)

A complete solution for implementing **engaging gamification** in your Flutter apps with **unmatched flexibility**, **superior performance**, and **advanced features** not available in other packages.

> **💡 MULTIPLE STORAGE OPTIONS!** Unlike other gamification packages, Teqani Rewards supports multiple storage backends (SharedPreferences, SQLite, Hive, Firebase) with zero configuration needed.

## ☕ Support This Project

If you find this package helpful, consider buying us a coffee to support ongoing development and maintenance!

<p align="center">
  <a href="https://www.buymeacoffee.com/Teqani" target="_blank">
    <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" height="50px">
  </a>
</p>

> **🤝 Need a custom Flutter package?** Don't hesitate to reach out! We're passionate about building solutions that help the Flutter community. [Contact us](mailto:contact@teqani.org) to discuss your ideas!

---

## ✨ Key Features

- ✅ **Multiple Storage Options** - Choose from SharedPreferences, SQLite, Hive, or Firebase
- ✅ **Achievement System** - Track and reward user accomplishments
- ✅ **Streak Tracking** - Motivate users with daily engagement
- ✅ **Time-Limited Challenges** - Create urgency and excitement
- ✅ **Customizable Themes** - Match your app's design perfectly
- ✅ **Firebase Analytics** - Track user engagement and behavior
- ✅ **Pre-built Widgets** - Quick integration with beautiful UI
- ✅ **Cross-Platform Support** - Works flawlessly on iOS, Android, and Web
- ✅ **Localization Support** - Reach a global audience
- ✅ **Dark/Light Mode** - Perfect for any app theme
- ✅ **Comprehensive API** - Full control over all features

## 🔒 Advanced Security Features

**Teqani Rewards ensures your data is always secure and protected!**

- 🔐 **Data Encryption** - All local data is encrypted using AES-256 encryption
- 🛡️ **Secure Storage** - Protected storage implementation for sensitive data
- 🔑 **Key Management** - Secure key generation and management system
- 🔄 **Data Integrity** - Automatic data validation and integrity checks
- 🚫 **Anti-Tampering** - Protection against unauthorized modifications
- 📱 **Platform Security** - Leverages platform-specific security features
- 🔍 **Audit Logging** - Track all data access and modifications
- 🧹 **Secure Cleanup** - Proper data sanitization when removing data

> **💡 SECURITY FIRST!** Unlike other gamification packages, Teqani Rewards implements enterprise-grade security measures to protect your users' data and achievements.

## 🔑 Zero Configuration Storage

**Teqani Rewards works right out of the box with multiple storage options!**

This means:
- No complex database setup
- No server configuration needed
- Choose the storage that fits your needs
- Switch between storage types easily
- Simple setup without complex configurations

Simply add the package and start implementing gamification in minutes!

## 🚀 PREMIUM FEATURE: Advanced Analytics Integration

> **[SPECIAL HIGHLIGHT]** Unlike other gamification packages, Teqani Rewards offers **built-in analytics capabilities** for tracking user engagement!

Our advanced analytics system supports:

* 📊 **User Engagement Tracking** - monitor achievement unlocks and streak progress
* ⏱️ **Time-Based Analytics** - track user activity patterns
* 💰 **Reward Impact Analysis** - measure the effectiveness of your rewards
* 🎯 **Custom Event Tracking** - log any user interaction
* 📱 **Cross-Platform Analytics** - consistent tracking on all devices
* 📈 **Performance Metrics** - monitor system performance

No other Flutter gamification package offers such comprehensive analytics capabilities!

## 📦 Installation

Add this top-rated package to your `pubspec.yaml` file:

```yaml
dependencies:
  teqani_rewards: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## 🔍 Basic Usage

Get started quickly with this simple implementation:

```dart
import 'package:flutter/material.dart';
import 'package:teqani_rewards/teqani_rewards.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Teqani Rewards
  await TeqaniRewards.init(
    theme: TeqaniRewardsTheme.defaultTheme,
    storageType: StorageType.firebase,
    enableAnalytics: true,
  );
  
  runApp(MyApp());
}
```

## ⚙️ Advanced Configuration Options

### Storage Configuration

Choose and configure your preferred storage:

```dart
// SharedPreferences
final storage = StorageManager(type: StorageType.sharedPreferences);

// SQLite
final storage = StorageManager(type: StorageType.sqlite);

// Hive
final storage = StorageManager(type: StorageType.hive);

// Firebase
final storage = StorageManager(type: StorageType.firebase);
```

### Achievement System

Create and manage achievements:

```dart
// Save achievements
await storage.saveAchievements([
  Achievement(
    id: '1',
    title: 'First Login',
    description: 'Logged in for the first time',
    points: 100,
  ),
]);

// Get achievements
final achievements = await storage.getAchievements();
```

### Streak Management

Track and update user streaks:

```dart
// Save streaks
await storage.saveStreaks([
  Streak(
    id: '1',
    currentStreak: 5,
    longestStreak: 10,
    lastActivityDate: DateTime.now(),
  ),
]);

// Get streaks
final streaks = await storage.getStreaks();
```

## 📱 Complete Implementation Example

Create a fully-featured gamification system with just a few lines of code:

```dart
import 'package:flutter/material.dart';
import 'package:teqani_rewards/teqani_rewards.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await TeqaniRewards.init(
    theme: TeqaniRewardsTheme.defaultTheme,
    storageType: StorageType.firebase,
    enableAnalytics: true,
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teqani Rewards Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RewardsDemo(),
    );
  }
}

class RewardsDemo extends StatefulWidget {
  @override
  _RewardsDemoState createState() => _RewardsDemoState();
}

class _RewardsDemoState extends State<RewardsDemo> {
  late StorageManager _storage;
  
  @override
  void initState() {
    super.initState();
    _storage = StorageManager(type: StorageType.firebase);
    _initializeStorage();
  }
  
  Future<void> _initializeStorage() async {
    await _storage.initialize();
    await _loadData();
  }
  
  Future<void> _loadData() async {
    final achievements = await _storage.getAchievements();
    final streaks = await _storage.getStreaks();
    // Update UI with loaded data
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teqani Rewards'),
      ),
      body: Column(
        children: [
          // Add your widgets here
        ],
      ),
    );
  }
}
```

## 🎨 Widget Examples

### 🎯 Onboarding Widgets

#### Gamified Onboarding
<p align="center">
  <img src="https://s6.gifyu.com/images/bp2yW.gif" alt="Gamified Onboarding Demo" width="300">
</p>

```dart
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
```

#### Quest Onboarding
<p align="center">
  <img src="https://s6.gifyu.com/images/bp2yg.gif" alt="Quest Onboarding Demo" width="300">
</p>

```dart
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
```

#### Pulse Onboarding
<p align="center">
  <img src="https://s6.gifyu.com/images/bp2y8.gif" alt="Pulse Onboarding Demo" width="300">
</p>

```dart
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
```

### 🔥 Streak Widgets

#### Floating Streak
<p align="center">
  <img src="https://s6.gifyu.com/images/bp2yc.gif" alt="Floating Streak Demo" width="300">
</p>

```dart
TeqaniStreakWidgets.floating(
  streak: Streak(
    id: 'floating_streak',
    currentStreak: 5,
    longestStreak: 10,
    lastActivityDate: DateTime.now(),
    streakType: 'daily',
  ),
  onUpdate: () {
    // Handle streak update
  },
);
```

#### Modern Streak
<p align="center">
  <img src="https://s6.gifyu.com/images/bp2yQ.gif" alt="Modern Streak Demo" width="300">
</p>

```dart
TeqaniStreakWidgets.modern(
  streak: Streak(
    id: 'modern_streak',
    currentStreak: 3,
    longestStreak: 7,
    lastActivityDate: DateTime.now(),
    streakType: 'daily',
  ),
  onUpdate: () {
    // Handle streak update
  },
);
```

#### Circular Progress Streak
<p align="center">
  <img src="https://s6.gifyu.com/images/bp2y4.gif" alt="Circular Progress Streak Demo" width="300">
</p>

```dart
TeqaniStreakWidgets.circularProgress(
  streak: Streak(
    id: 'circular_streak',
    currentStreak: 7,
    longestStreak: 14,
    lastActivityDate: DateTime.now(),
    streakType: 'daily',
  ),
  onUpdate: () {
    // Handle streak update
  },
);
```

#### Calendar View Streak
<p align="center">
  <img src="https://s6.gifyu.com/images/bp2y6.gif" alt="Calendar View Streak Demo" width="300">
</p>

```dart
TeqaniStreakWidgets.calendar(
  streak: Streak(
    id: 'calendar_streak',
    currentStreak: 2,
    longestStreak: 5,
    lastActivityDate: DateTime.now(),
    streakType: 'daily',
  ),
  onUpdate: () {
    // Handle streak update
  },
);
```

#### Pulsating Streak
<p align="center">
  <img src="https://s6.gifyu.com/images/bp2yi.gif" alt="Pulsating Streak Demo" width="300">
</p>

```dart
TeqaniStreakWidgets.pulsating(
  streak: Streak(
    id: 'pulsating_streak',
    currentStreak: 10,
    longestStreak: 15,
    lastActivityDate: DateTime.now(),
    streakType: 'daily',
  ),
  onUpdate: () {
    // Handle streak update
  },
);
```

#### Count Up Streak
<p align="center">
  <img src="https://s6.gifyu.com/images/bp2yR.gif" alt="Count Up Streak Demo" width="300">
</p>

```dart
TeqaniStreakWidgets.countUp(
  streak: Streak(
    id: 'count_up_streak',
    currentStreak: 1,
    longestStreak: 3,
    lastActivityDate: DateTime.now(),
    streakType: 'daily',
  ),
  onUpdate: () {
    // Handle streak update
  },
);
```

### 🏆 Achievement Widgets

#### Cube Achievement
<p align="center">
  <img src="https://s6.gifyu.com/images/bp2yj.gif" alt="Cube Achievement Demo" width="300">
</p>

```dart
CubeAchievementCard(
  achievement: Achievement(
    id: 'first_streak',
    title: 'First Streak',
    description: 'Complete your first streak',
    points: 100,
    isUnlocked: true,
    unlockedAt: DateTime.now(),
  ),
  onComplete: () {
    // Handle achievement completion
  },
);
```

#### Prism Achievement
<p align="center">
  <img src="https://s6.gifyu.com/images/bp2yF.gif" alt="Prism Achievement Demo" width="300">
</p>

```dart
PrismAchievementCard(
  achievement: Achievement(
    id: 'seven_day_streak',
    title: '7 Day Streak',
    description: 'Maintain a streak for 7 days',
    points: 200,
    isUnlocked: false,
  ),
  onComplete: () {
    // Handle achievement completion
  },
);
```

#### Pyramid Achievement
<p align="center">
  <img src="https://s6.gifyu.com/images/bp2yC.gif" alt="Pyramid Achievement Demo" width="300">
</p>

```dart
PyramidAchievementCard(
  achievement: Achievement(
    id: 'fourteen_day_streak',
    title: '14 Day Streak',
    description: 'Maintain a streak for 14 days',
    points: 300,
    isUnlocked: false,
  ),
  onComplete: () {
    // Handle achievement completion
  },
);
```

#### Modern Achievement
<p align="center">
  <img src="https://s6.gifyu.com/images/bp2y0.gif" alt="Modern Achievement Demo" width="300">
</p>

```dart
ModernAchievementCard(
  achievement: Achievement(
    id: 'twenty_one_day_streak',
    title: '21 Day Streak',
    description: 'Maintain a streak for 21 days',
    points: 400,
    isUnlocked: false,
  ),
  onComplete: () {
    // Handle achievement completion
  },
);
```

#### Minimalist Achievement
<p align="center">
  <img src="https://s6.gifyu.com/images/bp2yU.gif" alt="Minimalist Achievement Demo" width="300">
</p>

```dart
MinimalistAchievementCard(
  achievement: Achievement(
    id: 'twenty_eight_day_streak',
    title: '28 Day Streak',
    description: 'Maintain a streak for 28 days',
    points: 500,
    isUnlocked: false,
  ),
  onComplete: () {
    // Handle achievement completion
  },
);
```

#### Gradient Achievement
<p align="center">
  <img src="https://s6.gifyu.com/images/bp2yr.gif" alt="Gradient Achievement Demo" width="300">
</p>

```dart
GradientAchievementCard(
  achievement: Achievement(
    id: 'thirty_day_streak',
    title: '30 Day Streak',
    description: 'Maintain a streak for 30 days',
    points: 600,
    isUnlocked: false,
  ),
  onComplete: () {
    // Handle achievement completion
  },
);
```

### 🎯 Challenge Widgets

#### Circular Challenge
<p align="center">
  <img src="https://s6.gifyu.com/images/bp2yV.gif" alt="Circular Challenge Demo" width="300">
</p>

```dart
CircularChallengeCard(
  challenge: Challenge(
    id: 'daily_login',
    title: 'Daily Login',
    description: 'Log in every day for a week',
    points: 100,
    type: 'daily',
    progress: 0.5,
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 7)),
    isCompleted: false,
    lastUpdated: DateTime.now(),
  ),
  onComplete: () {
    // Handle challenge completion
  },
);
```

#### Timeline Challenge
<p align="center">
  <img src="https://s6.gifyu.com/images/bp2yZ.gif" alt="Timeline Challenge Demo" width="300">
</p>

```dart
TimelineChallengeCard(
  challenge: Challenge(
    id: 'two_week_streak',
    title: 'Two Week Streak',
    description: 'Maintain your streak for 14 days',
    points: 200,
    type: 'streak',
    progress: 0.3,
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 14)),
    isCompleted: false,
    lastUpdated: DateTime.now(),
  ),
  onComplete: () {
    // Handle challenge completion
  },
);
```

#### Flip Challenge
<p align="center">
  <img src="https://s6.gifyu.com/images/bp2ya.gif" alt="Flip Challenge Demo" width="300">
</p>

```dart
FlipChallengeCard(
  challenge: Challenge(
    id: 'three_week_streak',
    title: 'Three Week Streak',
    description: 'Maintain your streak for 21 days',
    points: 300,
    type: 'streak',
    progress: 0.2,
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 21)),
    isCompleted: false,
    lastUpdated: DateTime.now(),
  ),
  onComplete: () {
    // Handle challenge completion
  },
);
```

#### Pulse Challenge
<p align="center">
  <img src="https://s6.gifyu.com/images/bp2y5.gif" alt="Pulse Challenge Demo" width="300">
</p>

```dart
PulseChallengeCard(
  challenge: Challenge(
    id: 'four_week_streak',
    title: 'Four Week Streak',
    description: 'Maintain your streak for 28 days',
    points: 400,
    type: 'streak',
    progress: 0.1,
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 28)),
    isCompleted: false,
    lastUpdated: DateTime.now(),
  ),
  onComplete: () {
    // Handle challenge completion
  },
);
```

#### Wave Challenge
<p align="center">
  <img src="https://s6.gifyu.com/images/bp2yf.gif" alt="Wave Challenge Demo" width="300">
</p>

```dart
WaveChallengeCard(
  challenge: Challenge(
    id: 'monthly_master',
    title: 'Monthly Master',
    description: 'Complete a 30-day streak',
    points: 500,
    type: 'streak',
    progress: 0.05,
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 30)),
    isCompleted: false,
    lastUpdated: DateTime.now(),
  ),
  onComplete: () {
    // Handle challenge completion
  },
);
```

#### Gradient Challenge
<p align="center">
  <img src="https://s6.gifyu.com/images/bp2yY.gif" alt="Gradient Challenge Demo" width="300">
</p>

```dart
GradientChallengeCard(
  challenge: Challenge(
    id: 'ultimate_streak',
    title: 'Ultimate Streak',
    description: 'Complete a 100-day streak',
    points: 1000,
    type: 'streak',
    progress: 0.01,
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 100)),
    isCompleted: false,
    lastUpdated: DateTime.now(),
  ),
  onComplete: () {
    // Handle challenge completion
  },
);
```

## 📋 System Requirements

- Flutter: >=3.0.0
- Dart: >=3.0.0
- Android: minSdkVersion 17 or higher
- iOS: iOS 9.0 or higher

## 🏢 About Teqani.org

This premium package is developed and maintained by [Teqani.org](https://teqani.org), a leading company specializing in innovative digital solutions and advanced Flutter applications. With years of experience creating high-performance gamification systems, our team ensures you get the best user engagement tools possible.

## 📢 Why Choose Teqani Rewards?

- **Multiple Storage Options**: Choose the perfect storage for your needs
- **Superior Performance**: Optimized for smooth operation on all devices
- **Advanced Features**: More capabilities than any other gamification package
- **Analytics Ready**: Built-in tracking for user engagement
- **Professional Support**: Backed by Teqani.org's expert team
- **Regular Updates**: Continuous improvements and new features

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

Copyright © 2025 Teqani.org. All rights reserved.