class ScreenTimeLimit {
  final String limitId;
  final String childId;
  final int dailyLimitMinutes;
  final String bedtime;
  final String wakeTime;
  final List<TimeBlock> techFreeBlocks;
  final int bonusMinutes;
  
  ScreenTimeLimit({
    required this.limitId,
    required this.childId,
    required this.dailyLimitMinutes,
    required this.bedtime,
    required this.wakeTime,
    this.techFreeBlocks = const [],
    this.bonusMinutes = 0,
  });
  
  int get totalAvailableMinutes => dailyLimitMinutes + bonusMinutes;
  
  ScreenTimeLimit copyWith({
    int? dailyLimitMinutes,
    String? bedtime,
    String? wakeTime,
    List<TimeBlock>? techFreeBlocks,
    int? bonusMinutes,
  }) {
    return ScreenTimeLimit(
      limitId: limitId,
      childId: childId,
      dailyLimitMinutes: dailyLimitMinutes ?? this.dailyLimitMinutes,
      bedtime: bedtime ?? this.bedtime,
      wakeTime: wakeTime ?? this.wakeTime,
      techFreeBlocks: techFreeBlocks ?? this.techFreeBlocks,
      bonusMinutes: bonusMinutes ?? this.bonusMinutes,
    );
  }
}

class TimeBlock {
  final String id;
  final String name;
  final String startTime;
  final String endTime;
  final List<int> daysOfWeek; // 1-7 (Monday-Sunday)
  
  TimeBlock({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.daysOfWeek,
  });
}

class AppTimeLimit {
  final String limitId;
  final String childId;
  final String appId;
  final int dailyLimitMinutes;
  final bool isEnabled;
  
  AppTimeLimit({
    required this.limitId,
    required this.childId,
    required this.appId,
    required this.dailyLimitMinutes,
    this.isEnabled = true,
  });
  
  AppTimeLimit copyWith({
    int? dailyLimitMinutes,
    bool? isEnabled,
  }) {
    return AppTimeLimit(
      limitId: limitId,
      childId: childId,
      appId: appId,
      dailyLimitMinutes: dailyLimitMinutes ?? this.dailyLimitMinutes,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
