import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:external_app_launcher/external_app_launcher.dart' as launcher;
import '../../services/kids_mode_service.dart';
import '../../data/real_apps.dart';
import '../../theme/app_theme.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/text_styles.dart';

class KidsLauncherHome extends StatefulWidget {
  const KidsLauncherHome({super.key});
  
  @override
  State<KidsLauncherHome> createState() => _KidsLauncherHomeState();
}

class _KidsLauncherHomeState extends State<KidsLauncherHome>
    with SingleTickerProviderStateMixin {
  late AnimationController _greetingController;
  late Animation<double> _greetingAnimation;
  Timer? _timer;
  
  @override
  void initState() {
    super.initState();
    _greetingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _greetingAnimation = CurvedAnimation(
      parent: _greetingController,
      curve: Curves.elasticOut,
    );
    _greetingController.forward();
    
    // Activate kids mode if not already active
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final kidsModeService = Provider.of<KidsModeService>(
        context,
        listen: false,
      );
      if (!kidsModeService.isKidsModeActive) {
        kidsModeService.activateKidsMode();
      }
    });
    
    // Update timer every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }
  
  @override
  void dispose() {
    _greetingController.dispose();
    _timer?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<KidsModeService>(
      builder: (context, kidsModeService, child) {
        if (kidsModeService.remainingSeconds <= 0) {
          return _buildTimesUpScreen(context, kidsModeService);
        }
        
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.purple[400]!,
                  Colors.pink[300]!,
                  Colors.orange[300]!,
                ],
              ),
            ),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            _buildHeader(context, kidsModeService),
                            Expanded(
                              child: _buildAppGrid(context),
                            ),
                            _buildBottomActions(context, kidsModeService),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildHeader(BuildContext context, KidsModeService kidsModeService) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          // Mascot Avatar
          ScaleTransition(
            scale: _greetingAnimation,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '🤖',
                  style: TextStyle(fontSize: 32),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScaleTransition(
                  scale: _greetingAnimation,
                  child: const Text(
                    'Hi Alex! 🎮',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Comic Sans MS',
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Have fun! 😊',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          
          // Time Remaining Badge
          _buildTimeRemainingBadge(kidsModeService),
        ],
      ),
    );
  }
  
  Widget _buildTimeRemainingBadge(KidsModeService kidsModeService) {
    final progress = kidsModeService.remainingProgress;
    final isLowTime = kidsModeService.remainingSeconds < 600; // Less than 10 min
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: Stack(
              children: [
                Center(
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 4,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isLowTime ? Colors.red : Colors.green,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Icon(
                    Icons.timer,
                    color: isLowTime ? Colors.red : Colors.green,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            kidsModeService.remainingTimeFormatted,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isLowTime ? Colors.red : Colors.green,
            ),
          ),
          Text(
            'left',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAppGrid(BuildContext context) {
    final allowedApps = getAllowedApps();
    
    if (allowedApps.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '📱',
              style: TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              'No apps available',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ask your parent to approve apps!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: MediaQuery.of(context).size.width > 600 ? 0.9 : 0.8,
        ),
        itemCount: allowedApps.length,
        itemBuilder: (context, index) {
          final app = allowedApps[index];
          return _buildAppCard(context, app);
        },
      ),
    );
  }
  
  Widget _buildAppCard(BuildContext context, AppData app) {
    return GestureDetector(
      onTap: () {
        _launchApp(context, app);
      },
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 200),
        tween: Tween(begin: 1.0, end: 1.0),
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
               child: Stack(
                 children: [
                   Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Container(
                         width: MediaQuery.of(context).size.width > 600 ? 80 : 64,
                         height: MediaQuery.of(context).size.width > 600 ? 80 : 64,
                         decoration: BoxDecoration(
                           color: app.color.withOpacity(0.1),
                           borderRadius: BorderRadius.circular(16),
                         ),
                         child: Icon(
                           app.icon,
                           color: app.color,
                           size: MediaQuery.of(context).size.width > 600 ? 44 : 36,
                         ),
                       ),
                       const SizedBox(height: 8),
                       Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 8),
                         child: Text(
                           app.appName,
                           style: TextStyle(
                             fontSize: MediaQuery.of(context).size.width > 600 ? 15 : 13,
                             fontWeight: FontWeight.bold,
                           ),
                           textAlign: TextAlign.center,
                           maxLines: 2,
                           overflow: TextOverflow.ellipsis,
                         ),
                       ),
                     ],
                   ),
                   // PRO badge for premium apps
                   if (app.isPremium)
                     Positioned(
                       top: 8,
                       right: 8,
                       child: Container(
                         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                         decoration: BoxDecoration(
                           color: Colors.orange,
                           borderRadius: BorderRadius.circular(8),
                         ),
                         child: const Text(
                           'PRO',
                           style: TextStyle(
                             color: Colors.white,
                             fontSize: 10,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                       ),
                     ),
                 ],
               ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildBottomActions(
    BuildContext context,
    KidsModeService kidsModeService,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 1, 12, 2),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                _requestMoreTime(context, kidsModeService);
              },
              icon: const Icon(Icons.add_alarm, size: 14),
              label: const Text('More Time?', style: TextStyle(fontSize: 10)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          ElevatedButton(
            onPressed: () {
              _exitKidsMode(context, kidsModeService);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Icon(Icons.exit_to_app, size: 14),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTimesUpScreen(
    BuildContext context,
    KidsModeService kidsModeService,
  ) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange[400]!,
              Colors.red[400]!,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '⏰',
                style: TextStyle(fontSize: 100),
              ),
              const SizedBox(height: 24),
              const Text(
                'Time\'s Up!',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Ask your parent for more time',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  _exitKidsMode(context, kidsModeService);
                },
                icon: const Icon(Icons.lock_open),
                label: const Text('Exit Kids Mode'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _launchApp(BuildContext context, AppData app) async {
    // Check if it's a premium app
    if (app.isPremium) {
      _showPremiumDialog(context, app);
      return;
    }
    
    try {
      // Show launching animation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Launching ${app.appName}...'),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      // Launch the actual app with better error handling
      int result = await launcher.LaunchApp.openApp(
        androidPackageName: app.packageName,
        openStore: false,
      );
      
      if (result != 0) {
        // Try alternative package names for common apps
        String? alternativePackage = _getAlternativePackage(app.packageName);
        if (alternativePackage != null) {
          result = await launcher.LaunchApp.openApp(
            androidPackageName: alternativePackage,
            openStore: false,
          );
        }
      }
      
      if (result != 0) {
        throw Exception('App not found');
      }
    } catch (e) {
      // If app launch fails, show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open ${app.appName}. Make sure the app is installed.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
  
  String? _getAlternativePackage(String packageName) {
    // Provide alternative package names for common apps
    switch (packageName) {
      case 'com.android.camera2':
        return 'com.android.camera';
      case 'com.google.android.gm':
        return 'com.google.android.email';
      case 'com.google.android.youtube':
        return 'com.google.android.apps.youtube';
      case 'com.google.android.keep':
        return 'com.google.android.keep';
      default:
        return null;
    }
  }
  
  void _showPremiumDialog(BuildContext context, AppData app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.star, color: Colors.orange),
            const SizedBox(width: 8),
            const Text('Premium Feature'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${app.appName} is a premium feature.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Ask your parent to upgrade for ₹129/month to access this feature!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Premium includes: AI Study, Screen Time Management, NSFW Scanner, Real-Time Blur',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  void _requestMoreTime(
    BuildContext context,
    KidsModeService kidsModeService,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.add_alarm, color: Colors.purple),
            SizedBox(width: 8),
            Text('Request More Time'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('How much more time do you need?'),
            const SizedBox(height: 16),
            _buildTimeButton(context, kidsModeService, 15, '15 min'),
            const SizedBox(height: 8),
            _buildTimeButton(context, kidsModeService, 30, '30 min'),
            const SizedBox(height: 8),
            _buildTimeButton(context, kidsModeService, 60, '1 hour'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTimeButton(
    BuildContext context,
    KidsModeService kidsModeService,
    int minutes,
    String label,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          kidsModeService.requestMoreTime(
            context,
            minutes,
            'Requested by child',
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple[50],
          foregroundColor: Colors.purple,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(label),
      ),
    );
  }
  
  List<AppData> getAllowedApps() {
    // Return approved apps for kids mode
    return [
      AppData(
        packageName: 'com.android.camera2',
        appName: 'Camera',
        icon: Icons.camera_alt,
        category: 'Utilities',
        color: Colors.blue,
        isAllowed: true,
      ),
      AppData(
        packageName: 'com.google.android.gm',
        appName: 'Gmail',
        icon: Icons.email,
        category: 'Communication',
        color: Colors.red,
        isAllowed: true,
      ),
      AppData(
        packageName: 'com.google.android.youtube',
        appName: 'YouTube',
        icon: Icons.play_circle,
        category: 'Entertainment',
        color: Colors.red,
        isAllowed: true,
      ),
      AppData(
        packageName: 'com.google.android.keep',
        appName: 'Notes',
        icon: Icons.note,
        category: 'Productivity',
        color: Colors.green,
        isAllowed: true,
      ),
    ];
  }

  void _exitKidsMode(
    BuildContext context,
    KidsModeService kidsModeService,
  ) {
    showDialog(
      context: context,
      builder: (context) => KidsModePinDialog(
        onPinEntered: (pin) async {
          final success = await kidsModeService.exitKidsMode(pin);
          if (success && context.mounted) {
            Navigator.of(context).pop(); // Close PIN dialog
            Navigator.of(context).pushReplacementNamed('/dashboard');
          } else if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Incorrect PIN! Try again.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        onBiometricTap: () async {
          final success = await kidsModeService.authenticateWithBiometric();
          if (success && context.mounted) {
            Navigator.of(context).pop(); // Close PIN dialog
            Navigator.of(context).pushReplacementNamed('/dashboard');
          } else if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Biometric authentication failed'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }
}

// Kids Mode PIN Dialog Widget
class KidsModePinDialog extends StatefulWidget {
  final Function(String) onPinEntered;
  final VoidCallback onBiometricTap;

  const KidsModePinDialog({
    required this.onPinEntered,
    required this.onBiometricTap,
  });

  @override
  _KidsModePinDialogState createState() => _KidsModePinDialogState();
}

class _KidsModePinDialogState extends State<KidsModePinDialog> {
  String _pin = '';

  void _addDigit(String digit) {
    if (_pin.length < 6) {
      setState(() {
        _pin += digit;
      });
      HapticFeedback.lightImpact();
    }
  }

  void _removeDigit() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
      HapticFeedback.lightImpact();
    }
  }

  void _submitPin() {
    if (_pin.length == 6) {
      widget.onPinEntered(_pin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(Spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withOpacity(0.15),
                borderRadius: BorderRadius.circular(Spacing.radiusMd),
              ),
              child: Icon(
                Icons.lock,
                color: AppColors.primaryPurple,
                size: 48,
              ),
            ),
            SizedBox(height: Spacing.lg),
            Text(
              'Enter Parent PIN',
              style: AppTextStyles.headline2.copyWith(fontSize: 24),
            ),
            SizedBox(height: Spacing.sm),
            Text(
              'Enter the 6-digit PIN to exit Kids Mode',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Spacing.xl),
            // PIN Display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                return Container(
                  width: 20,
                  height: 20,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: index < _pin.length
                        ? AppColors.primaryPurple
                        : AppColors.textTertiary,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
            SizedBox(height: Spacing.xl),
            // Biometric Button
            if (Platform.isAndroid)
              Padding(
                padding: EdgeInsets.only(bottom: Spacing.lg),
                child: ElevatedButton.icon(
                  onPressed: widget.onBiometricTap,
                  icon: Icon(Icons.fingerprint),
                  label: Text('Use Fingerprint'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryTeal,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.lg,
                      vertical: Spacing.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Spacing.radiusMd),
                    ),
                  ),
                ),
              ),
            // Number Pad
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: Spacing.md,
              mainAxisSpacing: Spacing.md,
              childAspectRatio: 1.5,
              children: [
                // Numbers 1-9
                ...List.generate(9, (index) {
                  final number = (index + 1).toString();
                  return _NumberButton(
                    number: number,
                    onTap: () => _addDigit(number),
                  );
                }),
                // Empty space
                SizedBox(),
                // 0
                _NumberButton(
                  number: '0',
                  onTap: () => _addDigit('0'),
                ),
                // Backspace
                _NumberButton(
                  number: '⌫',
                  onTap: _removeDigit,
                  isSpecial: true,
                ),
              ],
            ),
            SizedBox(height: Spacing.lg),
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _pin.length == 6 ? _submitPin : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: Spacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Spacing.radiusMd),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: AppTextStyles.headline4.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Number Button Widget
class _NumberButton extends StatelessWidget {
  final String number;
  final VoidCallback onTap;
  final bool isSpecial;

  const _NumberButton({
    required this.number,
    required this.onTap,
    this.isSpecial = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSpecial
              ? AppColors.errorRed.withOpacity(0.1)
              : AppColors.textTertiary,
          borderRadius: BorderRadius.circular(Spacing.radiusSm),
          border: Border.all(
            color: isSpecial
                ? AppColors.errorRed.withOpacity(0.3)
                : AppColors.textTertiary,
          ),
        ),
        child: Center(
          child: Text(
            number,
            style: AppTextStyles.headline4.copyWith(
              color: isSpecial ? AppColors.errorRed : AppColors.textPrimary,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}