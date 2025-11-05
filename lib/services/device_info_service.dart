import 'dart:io';
import 'package:flutter/services.dart';

class DeviceInfoService {
  static const MethodChannel _channel = MethodChannel('device_info');
  
  static Future<Map<String, String>> getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        final Map<dynamic, dynamic> result = await _channel.invokeMethod('getAndroidDeviceInfo');
        return {
          'model': result['model'] ?? 'Unknown Device',
          'brand': result['brand'] ?? 'Unknown Brand',
          'androidVersion': result['androidVersion'] ?? 'Unknown Version',
          'deviceName': result['deviceName'] ?? 'Android Device',
        };
      }
    } catch (e) {
      print('Error getting device info: $e');
    }
    
    // Fallback to default values
    return {
      'model': 'Samsung Galaxy S24 Ultra',
      'brand': 'Samsung',
      'androidVersion': 'Android 15',
      'deviceName': 'Galaxy S24 Ultra',
    };
  }
  
  static String getDeviceDescription(Map<String, String> deviceInfo) {
    return '${deviceInfo['brand']} ${deviceInfo['model']} - ${deviceInfo['androidVersion']}';
  }
}
