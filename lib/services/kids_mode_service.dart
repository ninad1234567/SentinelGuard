import 'dart:async';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'database_service.dart';

class KidsModeService extends ChangeNotifier {
  bool _isKidsModeActive = false;
  int _remainingSeconds = 7200; // 2 hours default
  int _elapsedSeconds = 0;
  Timer? _timer;
  final LocalAuthentication _localAuth = LocalAuthentication();
  
  bool get isKidsModeActive => _isKidsModeActive;
  int get remainingSeconds => _remainingSeconds;
  int get elapsedSeconds => _elapsedSeconds;
  
  String get remainingTimeFormatted {
    final hours = _remainingSeconds ~/ 3600;
    final minutes = (_remainingSeconds % 3600) ~/ 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
  
  double get remainingProgress {
    return _remainingSeconds / 7200;
  }
  
  void activateKidsMode({int durationMinutes = 120}) async {
    _isKidsModeActive = true;
    _remainingSeconds = durationMinutes * 60;
    _elapsedSeconds = 0;
    
    // Start screen time tracking
    await DatabaseService.instance.startScreenTime();
    
    _startTimer();
    notifyListeners();
  }
  
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        _elapsedSeconds++;
        notifyListeners();
      } else {
        _lockDevice();
      }
    });
  }
  
  void _lockDevice() {
    _timer?.cancel();
    // In production, this would trigger device lock
    notifyListeners();
  }
  
  Future<bool> exitKidsMode(String pin) async {
    final isValid = await DatabaseService.instance.verifyPin(pin);
    
    if (isValid) {
      // Save screen time before exiting
      if (_elapsedSeconds > 0) {
        await DatabaseService.instance.updateScreenTime(_elapsedSeconds);
      }
      
      _isKidsModeActive = false;
      _timer?.cancel();
      _elapsedSeconds = 0;
      notifyListeners();
      return true;
    }
    return false;
  }
  
  Future<bool> authenticateWithBiometric() async {
    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      
      if (!canCheckBiometrics || !isDeviceSupported) {
        return false;
      }
      
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Authenticate to exit Kids Mode',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
      
      if (didAuthenticate) {
        // Save screen time before exiting
        if (_elapsedSeconds > 0) {
          await DatabaseService.instance.updateScreenTime(_elapsedSeconds);
        }
        
        _isKidsModeActive = false;
        _timer?.cancel();
        _elapsedSeconds = 0;
        notifyListeners();
      }
      
      return didAuthenticate;
    } catch (e) {
      debugPrint('Biometric auth error: $e');
      return false;
    }
  }
  
  void addBonusTime(int minutes) {
    _remainingSeconds += minutes * 60;
    notifyListeners();
  }
  
  void requestMoreTime(BuildContext context, int minutes, String reason) {
    // In production, this would send a notification to parent
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request sent to parent: $minutes extra minutes'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
