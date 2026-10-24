import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'providers/app_provider.dart';
import 'providers/game_provider.dart';
import 'models/app_settings.dart';
import 'models/user_stats.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/game_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/history_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };
  
  ui.PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Platform Error: $error');
    debugPrint('Stack trace: $stack');
    return true;
  };
  
  final appProvider = AppProvider();
  await _initializeApp(appProvider);
  
  final gameProvider = GameProvider();
  gameProvider.initializeFromSettings(appProvider.settings);
  
  // Sync GameProvider when AppProvider settings change
  appProvider.addListener(() {
    gameProvider.initializeFromSettings(appProvider.settings);
  });
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appProvider),
        ChangeNotifierProvider.value(value: gameProvider),
      ],
      child: const BrainBoosterApp(),
    ),
  );
}

Future<void> _initializeApp(AppProvider appProvider) async {
  try {
    await appProvider.initialize();
    debugPrint('App initialized successfully');
  } catch (e, stack) {
    debugPrint('App initialization failed: $e');
    debugPrint('Stack trace: $stack');
    // AppProvider handles the error internally, just ensure it's not loading
    // The AppProvider will set isLoading to false and notify listeners
  }
}

class BrainBoosterApp extends StatelessWidget {
  const BrainBoosterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, _) {
        // Show loading screen while initializing
        if (appProvider.isLoading) {
          return MaterialApp(
            title: 'Brain Booster',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            home: const _LoadingScreen(),
          );
        }
        
        return MaterialApp(
          title: 'Brain Booster',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appProvider.settings?.isDarkMode == true ? ThemeMode.dark : ThemeMode.light,
          home: const MainNavigation(),
          routes: {
            '/game': (context) => const GameScreen(),
            '/dashboard': (context) => const DashboardScreen(),
            '/history': (context) => const HistoryScreen(),
            '/settings': (context) => const SettingsScreen(),
          },
        );
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              'Loading Brain Booster...',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const GameScreen(),
    const DashboardScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.games_outlined),
            selectedIcon: Icon(Icons.games),
            label: 'Play',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}