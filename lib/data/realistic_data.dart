import 'package:flutter/material.dart';

// Device Information
class DeviceInfo {
  final String name;
  final String model;
  final String androidVersion;
  final DateTime lastSync;
  
  DeviceInfo({
    required this.name,
    required this.model,
    required this.androidVersion,
    required this.lastSync,
  });
  
  String get lastSyncFormatted {
    final diff = DateTime.now().difference(lastSync);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }
}

final deviceInfo = DeviceInfo(
  name: "Alex's Phone",
  model: 'Samsung Galaxy S24 Ultra',
  androidVersion: 'Android 15',
  lastSync: DateTime.now().subtract(const Duration(minutes: 2)),
);

// Today's Summary
final todaySummary = {
  'screenTime': const Duration(minutes: 5),
  'appsUsed': 4,
  'websitesVisited': 8,
  'blockedAttempts': 2,
  'pendingRequests': 1,
};

// Weekly Usage Data (minutes per day)
final Map<String, Map<String, double>> weeklyUsage = {
  'Mon': {'total': 5, 'youtube': 2, 'games': 2, 'social': 1},
  'Tue': {'total': 8, 'youtube': 3, 'games': 3, 'social': 2},
  'Wed': {'total': 3, 'youtube': 1, 'games': 1, 'social': 1},
  'Thu': {'total': 12, 'youtube': 5, 'games': 4, 'social': 3},
  'Fri': {'total': 15, 'youtube': 6, 'games': 5, 'social': 4},
  'Sat': {'total': 18, 'youtube': 7, 'games': 6, 'social': 5},
  'Sun': {'total': 20, 'youtube': 8, 'games': 7, 'social': 5},
};

// Activity Types
enum ActivityType {
  blocked,
  usage,
  request,
  limit,
  system,
}

// Recent Activity
class Activity {
  final String message;
  final DateTime timestamp;
  final ActivityType type;
  final IconData icon;
  final Color color;
  
  Activity(
    this.message,
    this.timestamp,
    this.type, {
    IconData? icon,
    Color? color,
  })  : icon = icon ?? _getIconForType(type),
        color = color ?? _getColorForType(type);
  
  static IconData _getIconForType(ActivityType type) {
    switch (type) {
      case ActivityType.blocked:
        return Icons.block;
      case ActivityType.usage:
        return Icons.schedule;
      case ActivityType.request:
        return Icons.notifications;
      case ActivityType.limit:
        return Icons.timer_off;
      case ActivityType.system:
        return Icons.info_outline;
    }
  }
  
  static Color _getColorForType(ActivityType type) {
    switch (type) {
      case ActivityType.blocked:
        return Colors.red;
      case ActivityType.usage:
        return Colors.blue;
      case ActivityType.request:
        return Colors.orange;
      case ActivityType.limit:
        return Colors.purple;
      case ActivityType.system:
        return Colors.grey;
    }
  }
  
  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }
}

final recentActivity = [
  Activity(
    '🚫 BLOCKED: pornhub.com detected and blocked',
    DateTime.now().subtract(const Duration(minutes: 5)),
    ActivityType.blocked,
  ),
  Activity(
    'Alex tried to access blocked website: pornhub.com',
    DateTime.now().subtract(const Duration(minutes: 10)),
    ActivityType.blocked,
  ),
  Activity(
    'Alex tried to access blocked website: gambling-site.com',
    DateTime.now().subtract(const Duration(minutes: 25)),
    ActivityType.blocked,
  ),
  Activity(
    'YouTube opened (45 min today)',
    DateTime.now().subtract(const Duration(hours: 1)),
    ActivityType.usage,
  ),
  Activity(
    'YouTube time limit reached (2h)',
    DateTime.now().subtract(const Duration(hours: 2)),
    ActivityType.limit,
  ),
  Activity(
    'Bedtime reminder sent',
    DateTime.now().subtract(const Duration(hours: 5)),
    ActivityType.system,
  ),
  Activity(
    'TikTok blocked - time limit exceeded',
    DateTime.now().subtract(const Duration(hours: 6)),
    ActivityType.blocked,
  ),
  Activity(
    'Requested extra time: 30 minutes',
    DateTime.now().subtract(const Duration(hours: 8)),
    ActivityType.request,
  ),
];

// Blocked Websites
final blockedSites = [
  'bet365.com',
  'pornhub.com',
  '4chan.org/b/',
  'gore-site.net',
  'darkweb-marketplace.onion',
  'casino-online.bet',
  'adult-dating.xxx',
  'torrent-download.ru',
  'gambling-site.com',
  'explicit-content.xxx',
  'dark-web.onion',
  'illegal-streaming.net',
];

// App Install Requests
class AppRequest {
  final String appName;
  final String packageName;
  final String reason;
  final DateTime requestedAt;
  final IconData icon;
  
  AppRequest(
    this.appName,
    this.packageName,
    this.reason,
    this.requestedAt, {
    this.icon = Icons.apps,
  });
  
  String get timeAgo {
    final diff = DateTime.now().difference(requestedAt);
    if (diff.inHours < 1) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }
}

final pendingRequests = [
  AppRequest(
    'Among Us',
    'com.innersloth.amongus',
    'All my friends play it!',
    DateTime.now().subtract(const Duration(hours: 2)),
    icon: Icons.gamepad,
  ),
  AppRequest(
    'Discord',
    'com.discord',
    'Need it for school project',
    DateTime.now().subtract(const Duration(hours: 5)),
    icon: Icons.discord,
  ),
  AppRequest(
    'Netflix',
    'com.netflix.mediaclient',
    'Want to watch movies',
    DateTime.now().subtract(const Duration(days: 1)),
    icon: Icons.movie,
  ),
];

// YouTube Watch History
class VideoData {
  final String channelName;
  final String title;
  final String duration;
  final String timeAgo;
  final String thumbnailUrl;
  
  VideoData({
    required this.channelName,
    required this.title,
    required this.duration,
    required this.timeAgo,
    this.thumbnailUrl = '',
  });
  
  String get durationFormatted => duration;
}

final youtubeHistory = [
  VideoData(
    channelName: 'MrBeast',
    title: 'I Survived 7 Days In Abandoned City',
    duration: '15:42',
    timeAgo: '2 hours ago',
  ),
  VideoData(
    channelName: 'PewDiePie',
    title: 'This Game Is Actually Scary...',
    duration: '12:34',
    timeAgo: '4 hours ago',
  ),
  VideoData(
    channelName: 'Mark Rober',
    title: 'World\'s Largest Jello Pool',
    duration: '16:23',
    timeAgo: 'Yesterday',
  ),
  VideoData(
    channelName: 'Dude Perfect',
    title: 'Extreme Water Bottle Flip Edition',
    duration: '11:28',
    timeAgo: 'Yesterday',
  ),
  VideoData(
    channelName: 'Preston',
    title: 'Minecraft But Everything is RANDOM',
    duration: '18:45',
    timeAgo: '2 days ago',
  ),
  VideoData(
    channelName: 'SSSniperWolf',
    title: 'Funniest TikToks Ever',
    duration: '10:15',
    timeAgo: '2 days ago',
  ),
  VideoData(
    channelName: 'Technoblade',
    title: 'I Destroyed Everyone at Bedwars',
    duration: '14:32',
    timeAgo: '3 days ago',
  ),
  VideoData(
    channelName: 'Dream',
    title: 'Minecraft Speedrunner VS 5 Hunters',
    duration: '42:17',
    timeAgo: '3 days ago',
  ),
  VideoData(
    channelName: 'Aphmau',
    title: 'I Became a BABY in Minecraft!',
    duration: '24:18',
    timeAgo: '4 days ago',
  ),
  VideoData(
    channelName: 'Unspeakable',
    title: '100 LEVELS of IMPOSSIBLE PARKOUR',
    duration: '16:55',
    timeAgo: '4 days ago',
  ),
  VideoData(
    channelName: 'Collins Key',
    title: 'Mystery Wheel of Candy Challenge',
    duration: '13:27',
    timeAgo: '5 days ago',
  ),
  VideoData(
    channelName: 'Like Nastya',
    title: 'Nastya and her Magical Playtime',
    duration: '8:42',
    timeAgo: '5 days ago',
  ),
  VideoData(
    channelName: 'Ryan\'s World',
    title: 'Giant Egg Surprise with Ryan!',
    duration: '12:05',
    timeAgo: '6 days ago',
  ),
  VideoData(
    channelName: 'FGTeeV',
    title: 'ROBLOX Piggy but We\'re ALL IMPOSTERS',
    duration: '19:33',
    timeAgo: '6 days ago',
  ),
  VideoData(
    channelName: 'LankyBox',
    title: 'ZERO BUDGET Roblox Movies!',
    duration: '15:41',
    timeAgo: '1 week ago',
  ),
  VideoData(
    channelName: 'CoryxKenshin',
    title: 'The Scariest Game I\'ve Ever Played',
    duration: '22:14',
    timeAgo: '1 week ago',
  ),
  VideoData(
    channelName: 'DanTDM',
    title: 'I Found the RAREST Minecraft Block',
    duration: '17:28',
    timeAgo: '1 week ago',
  ),
  VideoData(
    channelName: 'Jelly',
    title: 'Playing Among Us in REAL LIFE!',
    duration: '14:09',
    timeAgo: '1 week ago',
  ),
  VideoData(
    channelName: 'The Game Theorists',
    title: 'Game Theory: The TRUTH About Minecraft',
    duration: '18:52',
    timeAgo: '2 weeks ago',
  ),
  VideoData(
    channelName: 'Vsauce',
    title: 'What if Everyone JUMPED at Once?',
    duration: '21:37',
    timeAgo: '2 weeks ago',
  ),
];

// Browsing History
class BrowseHistory {
  final String url;
  final String status;
  final String timeAgo;
  final IconData icon;
  final Color color;
  
  BrowseHistory(
    this.url,
    this.status,
    this.timeAgo,
    this.icon,
    this.color,
  );
  
  String get riskLevel => status.toLowerCase();
  String get title => url;
  DateTime get timestamp => DateTime.now();
  String get childId => '1';
}

final browsingHistory = [
  BrowseHistory('www.youtube.com', 'Safe', '10 min ago', Icons.check_circle, Colors.green),
  BrowseHistory('www.khanacademy.org', 'Safe', '35 min ago', Icons.check_circle, Colors.green),
  BrowseHistory('www.coolmathgames.com', 'Safe', '1 hour ago', Icons.check_circle, Colors.green),
  BrowseHistory('[BLOCKED] adult-site.xxx', 'Blocked', '2 hours ago', Icons.block, Colors.red),
  BrowseHistory('www.reddit.com/r/gaming', 'Warning', '3 hours ago', Icons.warning, Colors.orange),
  BrowseHistory('www.wikipedia.org', 'Safe', '4 hours ago', Icons.check_circle, Colors.green),
  BrowseHistory('[BLOCKED] gambling-site.com', 'Blocked', '5 hours ago', Icons.block, Colors.red),
  BrowseHistory('www.google.com', 'Safe', '6 hours ago', Icons.check_circle, Colors.green),
  BrowseHistory('www.stackoverflow.com', 'Safe', 'Yesterday', Icons.check_circle, Colors.green),
  BrowseHistory('www.github.com', 'Safe', 'Yesterday', Icons.check_circle, Colors.green),
];

// Time limits per app category
final Map<String, int> categoryTimeLimits = {
  'Social': 120, // 2 hours
  'Games': 180, // 3 hours
  'Education': 0, // Unlimited
  'Utilities': 0, // Unlimited
};

// Usage by category today
final Map<String, int> categoryUsageToday = {
  'Social': 95,
  'Games': 167,
  'Education': 78,
  'Utilities': 45,
};

// Screen time trends (last 30 days average)
final screenTimeTrend = {
  'average': 6.2,
  'highest': 11.5,
  'lowest': 2.8,
  'trend': 'increasing', // increasing, decreasing, stable
};

// Most productive hours
final productiveHours = {
  '09:00-12:00': 'High productivity (Educational apps)',
  '14:00-16:00': 'Moderate productivity (Mixed usage)',
  '18:00-22:00': 'Low productivity (Entertainment)',
};
