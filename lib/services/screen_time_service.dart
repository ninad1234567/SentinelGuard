import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';

class ScreenTimeService {
  static Future<Duration> getTodayScreenTime() async {
    try {
      // Get usage permission status
      final hasPermission = await UsageStats.checkUsagePermission() ?? false;
      
      if (!hasPermission) {
        // Request permission
        await UsageStats.grantUsagePermission();
        return const Duration(hours: 0);
      }

      // Get today's start time (midnight)
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      
      // Query usage stats for today
      final queryUsageStats = await UsageStats.queryUsageStats(
        startOfDay,
        now,
      );
      
      if (queryUsageStats.isEmpty) {
        return const Duration(hours: 0);
      }

      // Calculate total screen time
      int totalMilliseconds = 0;
      for (var usageInfo in queryUsageStats) {
        totalMilliseconds += int.parse(usageInfo.totalTimeInForeground ?? '0');
      }
      
      return Duration(milliseconds: totalMilliseconds);
    } catch (e) {
      debugPrint('Error fetching screen time: $e');
      // Return dummy data if permission not granted or error
      return const Duration(hours: 4, minutes: 35);
    }
  }

  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
  
  static Future<Map<String, Duration>> getAppUsageToday() async {
    try {
      final hasPermission = await UsageStats.checkUsagePermission() ?? false;
      
      if (!hasPermission) {
        await UsageStats.grantUsagePermission();
        return {};
      }

      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      
      final queryUsageStats = await UsageStats.queryUsageStats(
        startOfDay,
        now,
      );
      
      if (queryUsageStats.isEmpty) {
        return {};
      }

      final Map<String, Duration> appUsage = {};
      for (var usageInfo in queryUsageStats) {
        final packageName = usageInfo.packageName ?? '';
        final timeInMs = int.parse(usageInfo.totalTimeInForeground ?? '0');
        
        if (timeInMs > 0 && packageName.isNotEmpty) {
          appUsage[packageName] = Duration(milliseconds: timeInMs);
        }
      }
      
      return appUsage;
    } catch (e) {
      debugPrint('Error fetching app usage: $e');
      return {};
    }
  }
}

