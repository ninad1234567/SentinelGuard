class ChildProfile {
  final String id;
  final String name;
  final int age;
  final String avatarIcon;
  final String deviceName;
  final int dailyLimitMinutes;
  final String bedtime;
  final String wakeTime;
  final bool isDeviceActive;
  final int todayUsageMinutes;
  final String avatarColor;
  
  ChildProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.avatarIcon,
    required this.deviceName,
    required this.dailyLimitMinutes,
    required this.bedtime,
    required this.wakeTime,
    this.isDeviceActive = true,
    this.todayUsageMinutes = 0,
    this.avatarColor = '#6750A4',
  });
  
  double get usageProgress => todayUsageMinutes / dailyLimitMinutes;
  
  String get remainingTime {
    final remaining = dailyLimitMinutes - todayUsageMinutes;
    if (remaining <= 0) return '0m';
    final hours = remaining ~/ 60;
    final minutes = remaining % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
  
  String get dailyLimitFormatted {
    final hours = dailyLimitMinutes ~/ 60;
    final minutes = dailyLimitMinutes % 60;
    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    }
    return '${minutes}m';
  }
  
  ChildProfile copyWith({
    String? name,
    int? age,
    String? avatarIcon,
    String? deviceName,
    int? dailyLimitMinutes,
    String? bedtime,
    String? wakeTime,
    bool? isDeviceActive,
    int? todayUsageMinutes,
    String? avatarColor,
  }) {
    return ChildProfile(
      id: id,
      name: name ?? this.name,
      age: age ?? this.age,
      avatarIcon: avatarIcon ?? this.avatarIcon,
      deviceName: deviceName ?? this.deviceName,
      dailyLimitMinutes: dailyLimitMinutes ?? this.dailyLimitMinutes,
      bedtime: bedtime ?? this.bedtime,
      wakeTime: wakeTime ?? this.wakeTime,
      isDeviceActive: isDeviceActive ?? this.isDeviceActive,
      todayUsageMinutes: todayUsageMinutes ?? this.todayUsageMinutes,
      avatarColor: avatarColor ?? this.avatarColor,
    );
  }
}
