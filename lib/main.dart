import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';
import 'providers/app_state.dart';
import 'services/kids_mode_service.dart';

// Screens
import 'screens/auth/splash_screen.dart';
import 'screens/auth/onboarding_screen.dart';
import 'screens/auth/setup_screen.dart';
import 'screens/parent/parent_dashboard.dart';
import 'screens/parent/app_management_screen.dart';
import 'screens/parent/screen_time_management_screen.dart';
import 'screens/parent/web_filtering_screen.dart';
import 'screens/parent/nsfw_scanner_screen.dart';
import 'screens/parent/premium_features_screen.dart';
import 'screens/parent/activity_reports_screen.dart';
import 'screens/parent/settings_screen.dart';
import 'screens/child/kids_launcher_home.dart';
import 'screens/child/functional_kids_launcher.dart';
import 'screens/parent/functional_web_filtering_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style for edge-to-edge
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Enable edge-to-edge
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => KidsModeService()),
      ],
      child: const SentinelGuardApp(),
    ),
  );
}

class SentinelGuardApp extends StatelessWidget {
  const SentinelGuardApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return MaterialApp(
          title: 'Sentinel Guard',
          debugShowCheckedModeBanner: false,
          
          // Theme - Default to light mode only
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appState.themeMode ?? ThemeMode.light,
          
          // Routes
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/onboarding': (context) => const OnboardingScreen(),
            '/setup': (context) => const SetupScreen(),
            '/dashboard': (context) => const MainNavigationScreen(),
            '/apps': (context) => const AppManagementScreen(),
            '/screen-time': (context) => const ScreenTimeManagementScreen(),
            '/web-filtering': (context) => const WebFilteringScreen(),
            '/nsfw-scanner': (context) => const NSFWScannerScreen(),
            '/premium': (context) => const PremiumFeaturesScreen(),
            '/reports': (context) => const ActivityReportsScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/kids-mode': (context) => const KidsLauncherHome(),
            '/kids-launcher': (context) => const FunctionalKidsLauncher(),
            '/web-filtering-functional': (context) => const FunctionalWebFilteringScreen(),
          },
        );
      },
    );
  }
}

// Main Navigation Screen with Bottom Nav
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const ParentDashboard(),
    const ActivityReportsScreen(),
    const PremiumFeaturesScreen(),
    const SettingsScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('Pro'),
              child: Icon(Icons.star_outline),
            ),
            selectedIcon: Badge(
              label: Text('Pro'),
              child: Icon(Icons.star),
            ),
            label: 'Premium',
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
