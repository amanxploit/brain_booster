# Brain Booster 🧠

A powerful brain training Flutter app for fast mental calculations with comprehensive dashboard tracking. Built with modern Flutter architecture using Provider for state management.

## ✨ Features

### 🎮 Game Modes
- **Daily Challenge** - 10 mixed questions to start your day
- **Speed Run** - 20 questions, 15 seconds each for quick thinking
- **Practice Mode** - No time limit, learn at your own pace
- **Custom Game** - Configure your own operation, difficulty, and settings

### 🧮 Mathematical Operations
- Addition (+)
- Subtraction (−)
- Multiplication (×)
- Division (÷)
- Mixed Operations

### 📊 Difficulty Levels
- **Easy** - Single digit numbers, generous time
- **Medium** - Double digits, moderate time
- **Hard** - Triple digits, tight time limit
- **Expert** - Complex calculations, minimal time

### 📈 Dashboard & Analytics
- Real-time accuracy tracking
- Performance charts (14-day trend)
- Operation-wise breakdown
- Difficulty progression
- GitHub-style contribution calendar
- Brain strength score (0-100%)

### ⚙️ Customization
- Dark/Light theme toggle
- Sound & vibration settings
- Default game preferences
- Questions per session (5-50)
- Time limit per question (0-60s)

### 📜 History & Progress
- Complete game session history
- Detailed question-by-question review
- Export data functionality
- Streak tracking (current & best)

## 🏗️ Architecture

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── math_question.dart    # Question generation & validation
│   ├── user_stats.dart       # User statistics & brain strength
│   ├── app_settings.dart     # App preferences
│   └── game_session.dart     # Game session & results
├── providers/                # State management (Provider)
│   └── app_provider.dart     # AppProvider + GameProvider
├── screens/                  # UI screens
│   ├── home_screen.dart      # Main dashboard
│   ├── game_screen.dart      # Active gameplay
│   ├── dashboard_screen.dart # Analytics & charts
│   ├── settings_screen.dart  # App preferences
│   └── history_screen.dart   # Game history
├── services/                 # Persistence layer
│   └── storage_service.dart  # SharedPreferences wrapper
├── theme/                    # Theming
│   └── app_theme.dart        # Light/Dark themes
└── widgets/                  # Reusable components
    ├── stat_card.dart
    ├── operation_card.dart
    ├── difficulty_card.dart
    ├── answer_button.dart
    ├── timer_widget.dart
    └── widgets.dart          # Barrel export
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.5.0+
- Dart 3.5.0+
- Android Studio / VS Code / IntelliJ

### Installation

```bash
# Clone the repository
git clone https://github.com/amanxploit/brain_booster.git
cd brain_booster

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Platforms Supported
- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 📦 Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `provider` | ^6.1.1 | State management |
| `shared_preferences` | ^2.2.2 | Local data persistence |
| `fl_chart` | ^0.66.2 | Charts & graphs |
| `intl` | ^0.19.0 | Date formatting |
| `uuid` | ^4.3.3 | Unique ID generation |

## 🎯 Brain Strength Algorithm

Your brain strength is calculated from three factors:

```
Brain Strength = (Accuracy × 0.4) + (Streak × 0.3) + (Consistency × 0.3)
```

| Score Range | Level |
|-------------|-------|
| 90-100% | 🧠 Genius |
| 75-89% | ⭐ Expert |
| 60-74% | 🚀 Advanced |
| 40-59% | 📈 Intermediate |
| 20-39% | 🌱 Beginner |
| 0-19% | 👶 Novice |

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'feat: add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**amanxploit** - [GitHub](https://github.com/amanxploit)

---

⭐ Star this repo if you found it helpful!