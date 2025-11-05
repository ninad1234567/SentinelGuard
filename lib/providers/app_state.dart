import 'package:flutter/material.dart';
import '../models/website_category.dart';
import '../data/realistic_data.dart';
import '../data/real_apps.dart';
import '../services/premium_service.dart';
import '../services/kids_mode_service.dart';

class AppState extends ChangeNotifier {
  // Services
  final PremiumService premiumService = PremiumService();
  final KidsModeService kidsModeService = KidsModeService();
  
  // Device info (single device)
  DeviceInfo _deviceInfo = deviceInfo;
  
  // Apps data
  List<AppData> _apps = [];
  List<WebsiteCategory> _websiteCategories = [];
  List<Activity> _recentActivities = [];
  List<BrowseHistory> _browsingHistory = [];
  List<VideoData> _youtubeHistory = [];
  List<AppRequest> _pendingRequests = [];
  
  ThemeMode _themeMode = ThemeMode.light;
  bool _isLoading = false;
  String? _error;
  
  // Getters
  DeviceInfo get device => _deviceInfo;
  List<AppData> get apps => _apps;
  List<WebsiteCategory> get websiteCategories => _websiteCategories;
  List<Activity> get recentActivities => _recentActivities;
  List<BrowseHistory> get browsingHistory => _browsingHistory;
  List<VideoData> get youtubeHistory => _youtubeHistory;
  List<AppRequest> get pendingRequests => _pendingRequests;
  
  ThemeMode get themeMode => _themeMode;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Statistics
  int get alertsCount => _pendingRequests.length;
  
  int get todayScreenTimeMinutes =>
      (todaySummary['screenTime']! as Duration).inMinutes;
  
  String get todayScreenTimeFormatted {
    final duration = todaySummary['screenTime'] as Duration;
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }
  
  int get blockedAttemptsToday => todaySummary['blockedAttempts'] as int;
  
  int get appsUsedToday => todaySummary['appsUsed'] as int;
  
  int get websitesVisitedToday => todaySummary['websitesVisited'] as int;
  
  // Initialize data
  Future<void> loadAllData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      // Simulate loading delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Load data from realistic_data.dart
      _apps = List.from(installedApps);
      _recentActivities = List.from(recentActivity);
      _browsingHistory = List.from(browsingHistory);
      _youtubeHistory = List.from(youtubeHistory);
      _pendingRequests = List.from(pendingRequests);
      
      // Load website categories from dummy data
      _websiteCategories = await _loadWebsiteCategories();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<List<WebsiteCategory>> _loadWebsiteCategories() async {
    return [
      WebsiteCategory(
        id: '1',
        name: 'Adult Content',
        description: 'Pornography and explicit content',
        isEnabled: true,
        icon: '🔞',
        blockedCount: 234,
      ),
      WebsiteCategory(
        id: '2',
        name: 'Gambling',
        description: 'Online casinos and betting',
        isEnabled: true,
        icon: '🎰',
        blockedCount: 45,
      ),
      WebsiteCategory(
        id: '3',
        name: 'Violence & Gore',
        description: 'Graphic violent content',
        isEnabled: true,
        icon: '⚠️',
        blockedCount: 12,
      ),
      WebsiteCategory(
        id: '4',
        name: 'Drugs',
        description: 'Drug-related content',
        isEnabled: true,
        icon: '💊',
        blockedCount: 8,
      ),
      WebsiteCategory(
        id: '5',
        name: 'Weapons',
        description: 'Weapons and ammunition',
        isEnabled: true,
        icon: '🔫',
        blockedCount: 5,
      ),
      WebsiteCategory(
        id: '6',
        name: 'Hate Speech',
        description: 'Discriminatory content',
        isEnabled: true,
        icon: '🚫',
        blockedCount: 19,
      ),
      WebsiteCategory(
        id: '7',
        name: 'Social Media',
        description: 'Facebook, Twitter, etc.',
        isEnabled: false,
        icon: '📱',
        blockedCount: 0,
      ),
      WebsiteCategory(
        id: '8',
        name: 'Gaming',
        description: 'Online gaming sites',
        isEnabled: false,
        icon: '🎮',
        blockedCount: 0,
      ),
      WebsiteCategory(
        id: '9',
        name: 'Streaming',
        description: 'Video streaming sites',
        isEnabled: false,
        icon: '📺',
        blockedCount: 0,
      ),
      WebsiteCategory(
        id: '10',
        name: 'Shopping',
        description: 'E-commerce websites',
        isEnabled: false,
        icon: '🛒',
        blockedCount: 0,
      ),
    ];
  }
  
  // App management
  void toggleAppBlock(String packageName) {
    final index = _apps.indexWhere((a) => a.packageName == packageName);
    if (index != -1) {
      _apps[index] = _apps[index].copyWith(
        isAllowed: !_apps[index].isAllowed,
      );
      notifyListeners();
    }
  }
  
  void setAppTimeLimit(String packageName, int? minutes) {
    final index = _apps.indexWhere((a) => a.packageName == packageName);
    if (index != -1) {
      _apps[index] = _apps[index].copyWith(
        timeLimitMinutes: minutes,
      );
      notifyListeners();
    }
  }
  
  // Web filtering
  void toggleCategoryFilter(String categoryId) {
    final index = _websiteCategories.indexWhere((c) => c.id == categoryId);
    if (index != -1) {
      _websiteCategories[index] = _websiteCategories[index].copyWith(
        isEnabled: !_websiteCategories[index].isEnabled,
      );
      notifyListeners();
    }
  }
  
  // App install requests
  void approveInstallRequest(String packageName) {
    _pendingRequests.removeWhere((r) => r.packageName == packageName);
    
    // Add activity
    _recentActivities.insert(
      0,
      Activity(
        'Install request approved: $packageName',
        DateTime.now(),
        ActivityType.system,
      ),
    );
    notifyListeners();
  }
  
  void denyInstallRequest(String packageName) {
    _pendingRequests.removeWhere((r) => r.packageName == packageName);
    
    // Add activity
    _recentActivities.insert(
      0,
      Activity(
        'Install request denied: $packageName',
        DateTime.now(),
        ActivityType.blocked,
      ),
    );
    notifyListeners();
  }
  
  // Theme management
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    print('Theme changed to: ${mode.name}');
    notifyListeners();
  }
  
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
  
  // Get top apps by usage
  List<AppData> getTopApps(int limit) {
    final sorted = List<AppData>.from(_apps);
    sorted.sort((a, b) => b.usageMinutes.compareTo(a.usageMinutes));
    return sorted.take(limit).toList();
  }
  
  // Get apps by category
  List<AppData> getAppsByCategory(String category) {
    if (category == 'All') return _apps;
    return _apps.where((app) => app.category == category).toList();
  }
  
  // Weekly usage data
  List<Map<String, dynamic>> getWeeklyChartData() {
    return weeklyUsage.entries.map((entry) {
      return {
        'day': entry.key,
        'total': entry.value['total'],
        'youtube': entry.value['youtube'],
        'games': entry.value['games'],
        'social': entry.value['social'],
      };
    }).toList();
  }
  
  // Compatibility getters for old screens
  List<dynamic> get children => []; // Empty list for compatibility
  String get totalScreenTimeTodayFormatted => todayScreenTimeFormatted;
  
  // Compatibility method
  void selectChild(dynamic child) {}
  void toggleDevicePause(String id) {}
  void updateChildLimit(String id, int minutes) {}
}