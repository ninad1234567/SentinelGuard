class WebsiteCategory {
  final String id;
  final String name;
  final String icon;
  final int blockedCount;
  final bool isEnabled;
  final String description;
  final List<String> domains;
  
  WebsiteCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.blockedCount,
    required this.isEnabled,
    required this.description,
    this.domains = const [],
  });
  
  WebsiteCategory copyWith({
    bool? isEnabled,
    int? blockedCount,
  }) {
    return WebsiteCategory(
      id: id,
      name: name,
      icon: icon,
      blockedCount: blockedCount ?? this.blockedCount,
      isEnabled: isEnabled ?? this.isEnabled,
      description: description,
      domains: domains,
    );
  }
}

class BrowsingHistoryItem {
  final String id;
  final String childId;
  final String url;
  final String title;
  final DateTime timestamp;
  final String riskLevel; // safe, warning, blocked
  
  BrowsingHistoryItem({
    required this.id,
    required this.childId,
    required this.url,
    required this.title,
    required this.timestamp,
    required this.riskLevel,
  });
}

class YouTubeVideo {
  final String videoId;
  final String title;
  final String channelName;
  final String thumbnailUrl;
  final int durationMinutes;
  final DateTime watchedAt;
  final String childId;
  
  YouTubeVideo({
    required this.videoId,
    required this.title,
    required this.channelName,
    required this.thumbnailUrl,
    required this.durationMinutes,
    required this.watchedAt,
    required this.childId,
  });
  
  String get durationFormatted {
    if (durationMinutes < 60) {
      return '$durationMinutes min';
    }
    final hours = durationMinutes ~/ 60;
    final mins = durationMinutes % 60;
    return '${hours}h ${mins}m';
  }
}
