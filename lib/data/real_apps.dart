import 'package:flutter/material.dart';

class AppData {
  final String packageName;
  final String appName;
  final IconData icon;
  final String category;
  final Color color;
  final bool isInstalled;
  final bool isAllowed;
  final int usageMinutes;
  final int? timeLimitMinutes;
  final bool isPremium;
  
  AppData({
    required this.packageName,
    required this.appName,
    required this.icon,
    required this.category,
    required this.color,
    this.isInstalled = true,
    this.isAllowed = true,
    this.usageMinutes = 0,
    this.timeLimitMinutes,
    this.isPremium = false,
  });
  
  AppData copyWith({
    bool? isAllowed,
    int? usageMinutes,
    int? timeLimitMinutes,
    bool? isPremium,
  }) {
    return AppData(
      packageName: packageName,
      appName: appName,
      icon: icon,
      category: category,
      color: color,
      isInstalled: isInstalled,
      isAllowed: isAllowed ?? this.isAllowed,
      usageMinutes: usageMinutes ?? this.usageMinutes,
      timeLimitMinutes: timeLimitMinutes,
      isPremium: isPremium ?? this.isPremium,
    );
  }
  
  // Compatibility getters
  int get todayUsageMinutes => usageMinutes;
  String get iconPath => appName;
  String get todayUsageFormatted {
    final hours = usageMinutes ~/ 60;
    final minutes = usageMinutes % 60;
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }
}

// Real apps database with actual package names and appropriate icons
final List<AppData> installedApps = [
  // Social Media (8 apps)
  AppData(
    packageName: 'com.google.android.youtube',
    appName: 'YouTube',
    icon: Icons.play_circle_fill,
    category: 'Social',
    color: Colors.red,
    usageMinutes: 145,
  ),
  AppData(
    packageName: 'com.instagram.android',
    appName: 'Instagram',
    icon: Icons.camera_alt,
    category: 'Social',
    color: Colors.purple,
    usageMinutes: 67,
  ),
  AppData(
    packageName: 'com.zhiliaoapp.musically',
    appName: 'TikTok',
    icon: Icons.music_note,
    category: 'Social',
    color: Colors.black,
    usageMinutes: 52,
  ),
  AppData(
    packageName: 'com.whatsapp',
    appName: 'WhatsApp',
    icon: Icons.chat,
    category: 'Social',
    color: Colors.green,
    usageMinutes: 34,
  ),
  AppData(
    packageName: 'com.snapchat.android',
    appName: 'Snapchat',
    icon: Icons.photo_camera,
    category: 'Social',
    color: Colors.yellow,
    usageMinutes: 28,
  ),
  AppData(
    packageName: 'com.facebook.katana',
    appName: 'Facebook',
    icon: Icons.facebook,
    category: 'Social',
    color: Colors.blue,
    usageMinutes: 19,
  ),
  AppData(
    packageName: 'com.twitter.android',
    appName: 'Twitter',
    icon: Icons.flutter_dash,
    category: 'Social',
    color: Colors.lightBlue,
    usageMinutes: 15,
  ),
  AppData(
    packageName: 'com.discord',
    appName: 'Discord',
    icon: Icons.discord,
    category: 'Social',
    color: Colors.indigo,
    usageMinutes: 0,
    isAllowed: false,
  ),
  
  // Games (15 apps)
  AppData(
    packageName: 'com.roblox.client',
    appName: 'Roblox',
    icon: Icons.gamepad,
    category: 'Games',
    color: Colors.red,
    usageMinutes: 98,
  ),
  AppData(
    packageName: 'com.mojang.minecraftpe',
    appName: 'Minecraft',
    icon: Icons.view_in_ar,
    category: 'Games',
    color: Colors.green,
    usageMinutes: 87,
  ),
  AppData(
    packageName: 'com.supercell.clashofclans',
    appName: 'Clash of Clans',
    icon: Icons.castle,
    category: 'Games',
    color: Colors.orange,
    usageMinutes: 45,
  ),
  AppData(
    packageName: 'com.pubg.imobile',
    appName: 'PUBG Mobile',
    icon: Icons.military_tech,
    category: 'Games',
    color: Colors.orange,
    usageMinutes: 112,
  ),
  AppData(
    packageName: 'com.ea.gp.fifamobile',
    appName: 'FIFA Mobile',
    icon: Icons.sports_soccer,
    category: 'Games',
    color: Colors.green,
    usageMinutes: 56,
  ),
  AppData(
    packageName: 'com.gameloft.android.ANMP',
    appName: 'Asphalt 9',
    icon: Icons.directions_car,
    category: 'Games',
    color: Colors.blue,
    usageMinutes: 34,
  ),
  AppData(
    packageName: 'com.king.candycrushsaga',
    appName: 'Candy Crush',
    icon: Icons.emoji_events,
    category: 'Games',
    color: Colors.pink,
    usageMinutes: 23,
  ),
  AppData(
    packageName: 'com.kiloo.subwaysurf',
    appName: 'Subway Surfers',
    icon: Icons.train,
    category: 'Games',
    color: Colors.yellow,
    usageMinutes: 19,
  ),
  AppData(
    packageName: 'com.ea.gp.apexlegendsmobilefps',
    appName: 'Apex Legends',
    icon: Icons.sports_esports,
    category: 'Games',
    color: Colors.red,
    usageMinutes: 67,
  ),
  AppData(
    packageName: 'com.activision.callofduty.shooter',
    appName: 'COD Mobile',
    icon: Icons.album,
    category: 'Games',
    color: Colors.black,
    usageMinutes: 89,
  ),
  AppData(
    packageName: 'com.epicgames.fortnite',
    appName: 'Fortnite',
    icon: Icons.games,
    category: 'Games',
    color: Colors.purple,
    usageMinutes: 0,
    isAllowed: false,
  ),
  AppData(
    packageName: 'com.miHoYo.GenshinImpact',
    appName: 'Genshin Impact',
    icon: Icons.explore,
    category: 'Games',
    color: Colors.cyan,
    usageMinutes: 78,
  ),
  AppData(
    packageName: 'com.garena.game.freefire',
    appName: 'Free Fire',
    icon: Icons.local_fire_department,
    category: 'Games',
    color: Colors.deepOrange,
    usageMinutes: 54,
  ),
  AppData(
    packageName: 'com.tencent.ig',
    appName: 'BGMI',
    icon: Icons.shield,
    category: 'Games',
    color: Colors.blue,
    usageMinutes: 43,
  ),
  AppData(
    packageName: 'com.supercell.brawlstars',
    appName: 'Brawl Stars',
    icon: Icons.star,
    category: 'Games',
    color: Colors.yellow,
    usageMinutes: 31,
  ),
  
  // Educational (12 apps)
  AppData(
    packageName: 'org.khanacademy.android',
    appName: 'Khan Academy',
    icon: Icons.school,
    category: 'Education',
    color: Colors.teal,
    usageMinutes: 23,
  ),
  AppData(
    packageName: 'com.duolingo',
    appName: 'Duolingo',
    icon: Icons.translate,
    category: 'Education',
    color: Colors.green,
    usageMinutes: 18,
  ),
  AppData(
    packageName: 'com.google.earth',
    appName: 'Google Earth',
    icon: Icons.public,
    category: 'Education',
    color: Colors.blue,
    usageMinutes: 12,
  ),
  AppData(
    packageName: 'com.photomath.app',
    appName: 'Photomath',
    icon: Icons.functions,
    category: 'Education',
    color: Colors.red,
    usageMinutes: 15,
  ),
  AppData(
    packageName: 'com.quizlet.quizletandroid',
    appName: 'Quizlet',
    icon: Icons.quiz,
    category: 'Education',
    color: Colors.blue,
    usageMinutes: 27,
  ),
  AppData(
    packageName: 'com.coursera.android',
    appName: 'Coursera',
    icon: Icons.cast_for_education,
    category: 'Education',
    color: Colors.blue,
    usageMinutes: 34,
  ),
  AppData(
    packageName: 'com.brainly',
    appName: 'Brainly',
    icon: Icons.psychology,
    category: 'Education',
    color: Colors.orange,
    usageMinutes: 19,
  ),
  AppData(
    packageName: 'com.google.android.apps.classroom',
    appName: 'Google Classroom',
    icon: Icons.class_,
    category: 'Education',
    color: Colors.green,
    usageMinutes: 45,
  ),
  AppData(
    packageName: 'us.zoom.videomeetings',
    appName: 'Zoom',
    icon: Icons.video_call,
    category: 'Education',
    color: Colors.blue,
    usageMinutes: 67,
  ),
  AppData(
    packageName: 'com.microsoft.teams',
    appName: 'Teams',
    icon: Icons.groups,
    category: 'Education',
    color: Colors.purple,
    usageMinutes: 34,
  ),
  AppData(
    packageName: 'com.wolfram.android.alpha',
    appName: 'Wolfram Alpha',
    icon: Icons.science,
    category: 'Education',
    color: Colors.red,
    usageMinutes: 8,
  ),
  AppData(
    packageName: 'com.simplemind.free',
    appName: 'SimpleMind',
    icon: Icons.account_tree,
    category: 'Education',
    color: Colors.orange,
    usageMinutes: 11,
  ),
  
  // Utilities (10 apps)
  AppData(
    packageName: 'com.google.android.apps.photos',
    appName: 'Google Photos',
    icon: Icons.photo_library,
    category: 'Utilities',
    color: Colors.blue,
    usageMinutes: 16,
  ),
  AppData(
    packageName: 'com.google.android.gm',
    appName: 'Gmail',
    icon: Icons.email,
    category: 'Utilities',
    color: Colors.red,
    usageMinutes: 21,
  ),
  AppData(
    packageName: 'com.google.android.apps.maps',
    appName: 'Google Maps',
    icon: Icons.map,
    category: 'Utilities',
    color: Colors.green,
    usageMinutes: 12,
  ),
  AppData(
    packageName: 'com.android.chrome',
    appName: 'Chrome',
    icon: Icons.language,
    category: 'Utilities',
    color: Colors.blue,
    usageMinutes: 29,
  ),
  AppData(
    packageName: 'com.android.camera2',
    appName: 'Camera',
    icon: Icons.camera,
    category: 'Utilities',
    color: Colors.grey,
    usageMinutes: 7,
  ),
  AppData(
    packageName: 'com.android.gallery3d',
    appName: 'Gallery',
    icon: Icons.image,
    category: 'Utilities',
    color: Colors.purple,
    usageMinutes: 14,
  ),
  AppData(
    packageName: 'com.android.calculator2',
    appName: 'Calculator',
    icon: Icons.calculate,
    category: 'Utilities',
    color: Colors.blueGrey,
    usageMinutes: 5,
  ),
  AppData(
    packageName: 'com.android.settings',
    appName: 'Settings',
    icon: Icons.settings,
    category: 'Utilities',
    color: Colors.grey,
    usageMinutes: 9,
  ),
  AppData(
    packageName: 'com.android.vending',
    appName: 'Play Store',
    icon: Icons.shopping_bag,
    category: 'Utilities',
    color: Colors.teal,
    usageMinutes: 18,
  ),
  AppData(
    packageName: 'com.spotify.music',
    appName: 'Spotify',
    icon: Icons.music_video,
    category: 'Utilities',
    color: Colors.green,
    usageMinutes: 41,
  ),
];

// Get apps by category
List<AppData> getAppsByCategory(String category) {
  return installedApps.where((app) => app.category == category).toList();
}

// Get top used apps
List<AppData> getTopUsedApps(int limit) {
  final sorted = List<AppData>.from(installedApps);
  sorted.sort((a, b) => b.usageMinutes.compareTo(a.usageMinutes));
  return sorted.take(limit).toList();
}

// Get blocked apps
List<AppData> getBlockedApps() {
  return installedApps.where((app) => !app.isAllowed).toList();
}

// Get allowed apps for kids mode
List<AppData> getAllowedApps() {
  return installedApps.where((app) => app.isAllowed && app.isInstalled).toList();
}

// Categories
final List<String> appCategories = [
  'All',
  'Social',
  'Games',
  'Education',
  'Utilities',
];
