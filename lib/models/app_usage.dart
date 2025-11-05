class AppUsage {
  final String appId;
  final String appName;
  final String packageName;
  final String iconPath;
  final String category;
  final List<int> weeklyUsageMinutes;
  final int todayUsageMinutes;
  final bool isBlocked;
  final int? timeLimitMinutes;
  final DateTime? lastUsed;
  
  AppUsage({
    required this.appId,
    required this.appName,
    required this.packageName,
    required this.iconPath,
    required this.category,
    required this.weeklyUsageMinutes,
    this.todayUsageMinutes = 0,
    this.isBlocked = false,
    this.timeLimitMinutes,
    this.lastUsed,
  });
  
  int get totalWeeklyUsage => weeklyUsageMinutes.reduce((a, b) => a + b);
  
  String get todayUsageFormatted {
    final hours = todayUsageMinutes ~/ 60;
    final minutes = todayUsageMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
  
  String get totalWeeklyUsageFormatted {
    final total = totalWeeklyUsage;
    final hours = total ~/ 60;
    final minutes = total % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
  
  bool get hasTimeLimit => timeLimitMinutes != null;
  
  bool get isTimeLimitReached => 
      hasTimeLimit && todayUsageMinutes >= timeLimitMinutes!;
  
  AppUsage copyWith({
    String? appName,
    String? category,
    List<int>? weeklyUsageMinutes,
    int? todayUsageMinutes,
    bool? isBlocked,
    int? timeLimitMinutes,
    DateTime? lastUsed,
  }) {
    return AppUsage(
      appId: appId,
      appName: appName ?? this.appName,
      packageName: packageName,
      iconPath: iconPath,
      category: category ?? this.category,
      weeklyUsageMinutes: weeklyUsageMinutes ?? this.weeklyUsageMinutes,
      todayUsageMinutes: todayUsageMinutes ?? this.todayUsageMinutes,
      isBlocked: isBlocked ?? this.isBlocked,
      timeLimitMinutes: timeLimitMinutes ?? this.timeLimitMinutes,
      lastUsed: lastUsed ?? this.lastUsed,
    );
  }
}

class AppInstallRequest {
  final String requestId;
  final String childId;
  final String childName;
  final String appName;
  final String appIcon;
  final String reason;
  final DateTime requestedAt;
  final String status; // pending, approved, denied
  
  AppInstallRequest({
    required this.requestId,
    required this.childId,
    required this.childName,
    required this.appName,
    required this.appIcon,
    required this.reason,
    required this.requestedAt,
    this.status = 'pending',
  });
}
