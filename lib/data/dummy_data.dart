import '../models/child_profile.dart';
import '../models/app_usage.dart';
import '../models/website_category.dart';
import '../models/activity_report.dart';

class DummyDataService {
  static final DummyDataService _instance = DummyDataService._internal();
  factory DummyDataService() => _instance;
  DummyDataService._internal();
  
  // Child Profiles
  static final List<ChildProfile> children = [
    ChildProfile(
      id: '1',
      name: 'Emma',
      age: 7,
      avatarIcon: '👧',
      deviceName: "Emma's Tablet",
      dailyLimitMinutes: 120,
      bedtime: '8:00 PM',
      wakeTime: '7:00 AM',
      todayUsageMinutes: 75,
      avatarColor: '#FF6B9D',
      isDeviceActive: true,
    ),
    ChildProfile(
      id: '2',
      name: 'Liam',
      age: 12,
      avatarIcon: '👦',
      deviceName: "Liam's Phone",
      dailyLimitMinutes: 180,
      bedtime: '9:30 PM',
      wakeTime: '6:30 AM',
      todayUsageMinutes: 145,
      avatarColor: '#4A90E2',
      isDeviceActive: true,
    ),
    ChildProfile(
      id: '3',
      name: 'Sophia',
      age: 5,
      avatarIcon: '👧',
      deviceName: "Sophia's Tab",
      dailyLimitMinutes: 90,
      bedtime: '7:00 PM',
      wakeTime: '7:30 AM',
      todayUsageMinutes: 45,
      avatarColor: '#FFA726',
      isDeviceActive: false,
    ),
  ];
  
  // App Usage Data
  static final List<AppUsage> apps = [
    // Educational Apps
    AppUsage(
      appId: 'youtube_kids',
      appName: 'YouTube Kids',
      packageName: 'com.google.android.apps.youtube.kids',
      iconPath: '📺',
      category: 'Educational',
      weeklyUsageMinutes: [20, 25, 30, 20, 15, 25, 30],
      todayUsageMinutes: 30,
      isBlocked: false,
      timeLimitMinutes: 60,
    ),
    AppUsage(
      appId: 'khan_academy',
      appName: 'Khan Academy Kids',
      packageName: 'org.khanacademy.kids',
      iconPath: '📚',
      category: 'Educational',
      weeklyUsageMinutes: [15, 20, 25, 30, 20, 15, 25],
      todayUsageMinutes: 25,
    ),
    AppUsage(
      appId: 'duolingo',
      appName: 'Duolingo',
      packageName: 'com.duolingo',
      iconPath: '🦉',
      category: 'Educational',
      weeklyUsageMinutes: [10, 15, 10, 20, 15, 10, 15],
      todayUsageMinutes: 15,
    ),
    AppUsage(
      appId: 'abc_mouse',
      appName: 'ABCmouse',
      packageName: 'com.ageoflearning.abcmouse',
      iconPath: '🖱️',
      category: 'Educational',
      weeklyUsageMinutes: [20, 25, 15, 20, 30, 25, 20],
      todayUsageMinutes: 20,
    ),
    AppUsage(
      appId: 'starfall',
      appName: 'Starfall',
      packageName: 'air.com.starfall.learningtools',
      iconPath: '⭐',
      category: 'Educational',
      weeklyUsageMinutes: [15, 10, 20, 15, 10, 15, 20],
      todayUsageMinutes: 20,
    ),
    
    // Games
    AppUsage(
      appId: 'minecraft',
      appName: 'Minecraft',
      packageName: 'com.mojang.minecraftpe',
      iconPath: '⛏️',
      category: 'Games',
      weeklyUsageMinutes: [45, 60, 30, 55, 70, 40, 50],
      todayUsageMinutes: 50,
      timeLimitMinutes: 90,
    ),
    AppUsage(
      appId: 'roblox',
      appName: 'Roblox',
      packageName: 'com.roblox.client',
      iconPath: '🎮',
      category: 'Games',
      weeklyUsageMinutes: [30, 40, 25, 35, 50, 30, 45],
      todayUsageMinutes: 45,
      timeLimitMinutes: 60,
    ),
    AppUsage(
      appId: 'pokemon_go',
      appName: 'Pokémon GO',
      packageName: 'com.nianticlabs.pokemongo',
      iconPath: '🎯',
      category: 'Games',
      weeklyUsageMinutes: [20, 30, 15, 25, 40, 20, 30],
      todayUsageMinutes: 30,
    ),
    AppUsage(
      appId: 'among_us',
      appName: 'Among Us',
      packageName: 'com.innersloth.spacemafia',
      iconPath: '🚀',
      category: 'Games',
      weeklyUsageMinutes: [25, 35, 20, 30, 45, 25, 35],
      todayUsageMinutes: 35,
      isBlocked: false,
    ),
    
    // Social Media
    AppUsage(
      appId: 'youtube',
      appName: 'YouTube',
      packageName: 'com.google.android.youtube',
      iconPath: '▶️',
      category: 'Social',
      weeklyUsageMinutes: [60, 75, 50, 80, 90, 70, 65],
      todayUsageMinutes: 65,
      timeLimitMinutes: 120,
    ),
    AppUsage(
      appId: 'tiktok',
      appName: 'TikTok',
      packageName: 'com.zhiliaoapp.musically',
      iconPath: '🎵',
      category: 'Social',
      weeklyUsageMinutes: [40, 50, 35, 45, 60, 40, 50],
      todayUsageMinutes: 50,
      isBlocked: true,
    ),
    AppUsage(
      appId: 'instagram',
      appName: 'Instagram',
      packageName: 'com.instagram.android',
      iconPath: '📷',
      category: 'Social',
      weeklyUsageMinutes: [30, 40, 25, 35, 50, 30, 40],
      todayUsageMinutes: 40,
      isBlocked: true,
    ),
    AppUsage(
      appId: 'snapchat',
      appName: 'Snapchat',
      packageName: 'com.snapchat.android',
      iconPath: '👻',
      category: 'Social',
      weeklyUsageMinutes: [25, 35, 20, 30, 45, 25, 35],
      todayUsageMinutes: 35,
      isBlocked: true,
    ),
    AppUsage(
      appId: 'whatsapp',
      appName: 'WhatsApp',
      packageName: 'com.whatsapp',
      iconPath: '💬',
      category: 'Social',
      weeklyUsageMinutes: [15, 20, 10, 15, 25, 15, 20],
      todayUsageMinutes: 20,
    ),
    
    // Utilities
    AppUsage(
      appId: 'chrome',
      appName: 'Chrome',
      packageName: 'com.android.chrome',
      iconPath: '🌐',
      category: 'Utilities',
      weeklyUsageMinutes: [20, 25, 15, 20, 30, 20, 25],
      todayUsageMinutes: 25,
    ),
    AppUsage(
      appId: 'gallery',
      appName: 'Gallery',
      packageName: 'com.android.gallery3d',
      iconPath: '🖼️',
      category: 'Utilities',
      weeklyUsageMinutes: [10, 15, 10, 10, 15, 10, 15],
      todayUsageMinutes: 15,
    ),
    AppUsage(
      appId: 'camera',
      appName: 'Camera',
      packageName: 'com.android.camera',
      iconPath: '📸',
      category: 'Utilities',
      weeklyUsageMinutes: [5, 10, 5, 10, 15, 10, 10],
      todayUsageMinutes: 10,
    ),
    AppUsage(
      appId: 'calculator',
      appName: 'Calculator',
      packageName: 'com.android.calculator2',
      iconPath: '🔢',
      category: 'Utilities',
      weeklyUsageMinutes: [5, 5, 10, 5, 5, 5, 10],
      todayUsageMinutes: 10,
    ),
  ];
  
  // Website Categories
  static final List<WebsiteCategory> websiteCategories = [
    WebsiteCategory(
      id: 'adult',
      name: 'Adult Content',
      description: 'Pornography and explicit content',
      icon: '🔞',
      blockedCount: 1245,
      isEnabled: true,
      domains: ['pornhub.com', 'xvideos.com', 'xnxx.com'],
    ),
    WebsiteCategory(
      id: 'gambling',
      name: 'Gambling',
      description: 'Online casinos and betting',
      icon: '🎰',
      blockedCount: 523,
      isEnabled: true,
      domains: ['bet365.com', 'pokerstars.com', 'casino.com'],
    ),
    WebsiteCategory(
      id: 'violence',
      name: 'Violence & Weapons',
      description: 'Graphic violent content',
      icon: '🔫',
      blockedCount: 890,
      isEnabled: true,
      domains: ['gore.com', 'bestgore.com', 'liveleak.com'],
    ),
    WebsiteCategory(
      id: 'drugs',
      name: 'Drugs & Alcohol',
      description: 'Drug-related content',
      icon: '💊',
      blockedCount: 456,
      isEnabled: true,
      domains: ['leafly.com', 'weedmaps.com'],
    ),
    WebsiteCategory(
      id: 'social_media',
      name: 'Social Media',
      description: 'Facebook, Twitter, etc.',
      icon: '📱',
      blockedCount: 12,
      isEnabled: false,
      domains: ['facebook.com', 'twitter.com', 'instagram.com', 'tiktok.com'],
    ),
    WebsiteCategory(
      id: 'gaming',
      name: 'Gaming Sites',
      description: 'Online gaming sites',
      icon: '🎮',
      blockedCount: 34,
      isEnabled: false,
      domains: ['twitch.tv', 'steam.com', 'epicgames.com'],
    ),
    WebsiteCategory(
      id: 'streaming',
      name: 'Streaming',
      description: 'Video streaming sites',
      icon: '🎬',
      blockedCount: 8,
      isEnabled: false,
      domains: ['netflix.com', 'hulu.com', 'disneyplus.com'],
    ),
    WebsiteCategory(
      id: 'dating',
      name: 'Dating',
      description: 'Online dating services',
      icon: '❤️',
      blockedCount: 234,
      isEnabled: true,
      domains: ['tinder.com', 'match.com', 'okcupid.com'],
    ),
    WebsiteCategory(
      id: 'hate_speech',
      name: 'Hate Speech',
      description: 'Discriminatory content',
      icon: '🚫',
      blockedCount: 678,
      isEnabled: true,
      domains: [],
    ),
    WebsiteCategory(
      id: 'proxy',
      name: 'Proxy & VPN',
      description: 'Proxy and VPN services',
      icon: '🔓',
      blockedCount: 345,
      isEnabled: true,
      domains: ['hidemyass.com', 'protonvpn.com'],
    ),
  ];
  
  // Browsing History
  static final List<BrowsingHistoryItem> browsingHistory = [
    BrowsingHistoryItem(
      id: 'h1',
      childId: '2',
      url: 'youtube.com',
      title: 'YouTube',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      riskLevel: 'safe',
    ),
    BrowsingHistoryItem(
      id: 'h2',
      childId: '2',
      url: 'minecraft.net',
      title: 'Minecraft Official Site',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      riskLevel: 'safe',
    ),
    BrowsingHistoryItem(
      id: 'h3',
      childId: '2',
      url: 'blocked-site.com',
      title: 'Blocked Content',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      riskLevel: 'blocked',
    ),
    BrowsingHistoryItem(
      id: 'h4',
      childId: '1',
      url: 'pbskids.org',
      title: 'PBS Kids Games',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      riskLevel: 'safe',
    ),
    BrowsingHistoryItem(
      id: 'h5',
      childId: '2',
      url: 'reddit.com',
      title: 'Reddit - Dive into anything',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      riskLevel: 'warning',
    ),
  ];
  
  // YouTube Watch History
  static final List<YouTubeVideo> youtubeHistory = [
    YouTubeVideo(
      videoId: 'v1',
      title: 'Minecraft Building Tutorial - Epic Castle',
      channelName: 'Minecraft Master',
      thumbnailUrl: '🏰',
      durationMinutes: 15,
      watchedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      childId: '2',
    ),
    YouTubeVideo(
      videoId: 'v2',
      title: 'Fun Learning Songs for Kids',
      channelName: 'Kids Learning TV',
      thumbnailUrl: '🎵',
      durationMinutes: 8,
      watchedAt: DateTime.now().subtract(const Duration(hours: 1)),
      childId: '1',
    ),
    YouTubeVideo(
      videoId: 'v3',
      title: 'Science Experiments for Children',
      channelName: 'Science Fun',
      thumbnailUrl: '🔬',
      durationMinutes: 12,
      watchedAt: DateTime.now().subtract(const Duration(hours: 2)),
      childId: '1',
    ),
  ];
  
  // Activity Timeline
  static final List<ActivityTimelineItem> recentActivities = [
    ActivityTimelineItem(
      id: 'a1',
      childId: '2',
      childName: 'Liam',
      activityType: 'app_opened',
      title: 'Opened YouTube',
      description: 'Started watching Minecraft tutorials',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      icon: '▶️',
    ),
    ActivityTimelineItem(
      id: 'a2',
      childId: '1',
      childName: 'Emma',
      activityType: 'time_limit_reached',
      title: 'Time limit reached',
      description: 'Daily limit for Khan Academy Kids',
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      icon: '⏰',
    ),
    ActivityTimelineItem(
      id: 'a3',
      childId: '2',
      childName: 'Liam',
      activityType: 'website_blocked',
      title: 'Website blocked',
      description: 'Attempted to access blocked content',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      icon: '🚫',
    ),
    ActivityTimelineItem(
      id: 'a4',
      childId: '3',
      childName: 'Sophia',
      activityType: 'device_paused',
      title: 'Device paused',
      description: 'Bedtime enforcement activated',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      icon: '⏸️',
    ),
    ActivityTimelineItem(
      id: 'a5',
      childId: '1',
      childName: 'Emma',
      activityType: 'app_opened',
      title: 'Opened ABCmouse',
      description: 'Started learning activities',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      icon: '🖱️',
    ),
  ];
  
  // NSFW Detections
  static final List<NSFWDetection> nsfwDetections = [
    NSFWDetection(
      detectionId: 'n1',
      childId: '2',
      filePath: '/storage/emulated/0/DCIM/suspicious1.jpg',
      thumbnailPath: '🔍',
      detectedAt: DateTime.now().subtract(const Duration(days: 1)),
      confidenceScore: 0.89,
      isReviewed: false,
    ),
    NSFWDetection(
      detectionId: 'n2',
      childId: '2',
      filePath: '/storage/emulated/0/Downloads/image2.png',
      thumbnailPath: '🔍',
      detectedAt: DateTime.now().subtract(const Duration(days: 3)),
      confidenceScore: 0.76,
      isReviewed: false,
    ),
    NSFWDetection(
      detectionId: 'n3',
      childId: '1',
      filePath: '/storage/emulated/0/Pictures/screenshot3.jpg',
      thumbnailPath: '🔍',
      detectedAt: DateTime.now().subtract(const Duration(days: 5)),
      confidenceScore: 0.92,
      isReviewed: true,
      isFalsePositive: true,
    ),
  ];
  
  // App Install Requests
  static final List<AppInstallRequest> installRequests = [
    AppInstallRequest(
      requestId: 'r1',
      childId: '2',
      childName: 'Liam',
      appName: 'Discord',
      appIcon: '💬',
      reason: 'To chat with school friends for group project',
      requestedAt: DateTime.now().subtract(const Duration(hours: 2)),
      status: 'pending',
    ),
    AppInstallRequest(
      requestId: 'r2',
      childId: '1',
      childName: 'Emma',
      appName: 'Toca Life World',
      appIcon: '🏠',
      reason: 'All my friends have it and it looks fun!',
      requestedAt: DateTime.now().subtract(const Duration(hours: 5)),
      status: 'pending',
    ),
    AppInstallRequest(
      requestId: 'r3',
      childId: '2',
      childName: 'Liam',
      appName: 'Spotify',
      appIcon: '🎵',
      reason: 'For listening to music while studying',
      requestedAt: DateTime.now().subtract(const Duration(days: 1)),
      status: 'pending',
    ),
  ];
  
  // Methods to get data
  Future<List<ChildProfile>> getChildren() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return children;
  }
  
  Future<ChildProfile?> getChild(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return children.firstWhere((child) => child.id == id);
    } catch (e) {
      return null;
    }
  }
  
  Future<List<AppUsage>> getApps() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return apps;
  }
  
  Future<List<WebsiteCategory>> getWebsiteCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return websiteCategories;
  }
  
  Future<List<ActivityTimelineItem>> getRecentActivities() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return recentActivities;
  }
  
  Future<List<BrowsingHistoryItem>> getBrowsingHistory() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return browsingHistory;
  }
  
  Future<List<YouTubeVideo>> getYouTubeHistory() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return youtubeHistory;
  }
  
  Future<List<NSFWDetection>> getNSFWDetections() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return nsfwDetections;
  }
  
  Future<List<AppInstallRequest>> getInstallRequests() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return installRequests;
  }
  
  Future<ActivityReport> getActivityReport(String childId, DateTime startDate, DateTime endDate) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return ActivityReport(
      reportId: 'report_${childId}_${startDate.millisecondsSinceEpoch}',
      childId: childId,
      startDate: startDate,
      endDate: endDate,
      totalScreenTimeMinutes: 1458,
      appsUsedCount: 12,
      websitesVisitedCount: 34,
      blockedAttemptsCount: 5,
      topApps: {
        'YouTube': 390,
        'Minecraft': 350,
        'Roblox': 255,
        'Khan Academy': 150,
        'Chrome': 155,
      },
      dailyUsageMinutes: [185, 220, 195, 210, 240, 205, 203],
    );
  }
}
