class ActivityReport {
  final String reportId;
  final String childId;
  final DateTime startDate;
  final DateTime endDate;
  final int totalScreenTimeMinutes;
  final int appsUsedCount;
  final int websitesVisitedCount;
  final int blockedAttemptsCount;
  final Map<String, int> topApps;
  final List<int> dailyUsageMinutes;
  
  ActivityReport({
    required this.reportId,
    required this.childId,
    required this.startDate,
    required this.endDate,
    required this.totalScreenTimeMinutes,
    required this.appsUsedCount,
    required this.websitesVisitedCount,
    required this.blockedAttemptsCount,
    required this.topApps,
    required this.dailyUsageMinutes,
  });
  
  String get totalScreenTimeFormatted {
    final hours = totalScreenTimeMinutes ~/ 60;
    final minutes = totalScreenTimeMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
  
  double get averageDailyMinutes {
    if (dailyUsageMinutes.isEmpty) return 0;
    return dailyUsageMinutes.reduce((a, b) => a + b) / dailyUsageMinutes.length;
  }
}

class ActivityTimelineItem {
  final String id;
  final String childId;
  final String childName;
  final String activityType; // app_opened, website_blocked, time_limit_reached, device_paused
  final String title;
  final String description;
  final DateTime timestamp;
  final String icon;
  
  ActivityTimelineItem({
    required this.id,
    required this.childId,
    required this.childName,
    required this.activityType,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.icon,
  });
  
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class NSFWDetection {
  final String detectionId;
  final String childId;
  final String filePath;
  final String thumbnailPath;
  final DateTime detectedAt;
  final double confidenceScore;
  final bool isReviewed;
  final bool isFalsePositive;
  
  NSFWDetection({
    required this.detectionId,
    required this.childId,
    required this.filePath,
    required this.thumbnailPath,
    required this.detectedAt,
    required this.confidenceScore,
    this.isReviewed = false,
    this.isFalsePositive = false,
  });
  
  NSFWDetection copyWith({
    bool? isReviewed,
    bool? isFalsePositive,
  }) {
    return NSFWDetection(
      detectionId: detectionId,
      childId: childId,
      filePath: filePath,
      thumbnailPath: thumbnailPath,
      detectedAt: detectedAt,
      confidenceScore: confidenceScore,
      isReviewed: isReviewed ?? this.isReviewed,
      isFalsePositive: isFalsePositive ?? this.isFalsePositive,
    );
  }
}
