import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../../theme/premium_colors.dart';
import '../../theme/spacing.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/kids_mode_pin_dialog.dart';
import '../../services/kids_mode_service.dart';
import '../../services/database_service.dart';

class FunctionalKidsLauncher extends StatefulWidget {
  const FunctionalKidsLauncher({super.key});
  
  @override
  State<FunctionalKidsLauncher> createState() => _FunctionalKidsLauncherState();
}

class _FunctionalKidsLauncherState extends State<FunctionalKidsLauncher>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;
  String _userName = 'Alex';
  int remainingSeconds = 7200; // 2 hours
  Timer? _countdownTimer;
  
  @override
  void initState() {
    super.initState();
    _loadUserName();
    _startCountdown();
    _breathingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }
  
  Future<void> _loadUserName() async {
    final info = await DatabaseService.instance.getParentInfo();
    if (info != null && mounted) {
      setState(() {
        _userName = info['name']!.split(' ')[0]; // First name only
      });
    }
  }
  
  @override
  void dispose() {
    _countdownTimer?.cancel();
    _breathingController.dispose();
    super.dispose();
  }
  
  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (remainingSeconds > 0) {
            remainingSeconds--;
          } else {
            timer.cancel();
            _showTimeUpDialog();
          }
        });
      }
    });
  }
  
  Future<void> _launchApp(KidsApp app) async {
    HapticFeedback.mediumImpact();
    
    try {
      // Method 1: Direct package launch
      final intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        package: app.packageName,
        category: 'android.intent.category.LAUNCHER',
        flags: <int>[268435456], // FLAG_ACTIVITY_NEW_TASK
      );
      
      await intent.launch();
    } catch (e) {
      // Method 2: Try URL scheme
      try {
        await launchUrl(
          Uri.parse('https://www.youtube.com'),
          mode: LaunchMode.externalApplication,
        );
      } catch (e2) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Opening YouTube...',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Spacing.radiusSm),
              ),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      }
    }
  }
  
  void _showTimeUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.radiusLg),
        ),
        title: Text(
          '⏰ Time\'s Up!',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Your screen time is over. Ask your parent for more time!',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => _showExitDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: Text(
              'Exit Kids Mode',
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showExitDialog() {
    final kidsModeService = Provider.of<KidsModeService>(context, listen: false);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: KidsModePinDialog(
          onBiometricTap: () async {
            final success = await kidsModeService.authenticateWithBiometric();
            if (success && mounted) {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/dashboard');
            }
          },
          onPinEntered: (pin) async {
            final success = await kidsModeService.exitKidsMode(pin);
            if (success && mounted) {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/dashboard');
            } else if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Incorrect PIN! Try again.',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back button - must use PIN to exit
        _showExitDialog();
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.kidsGradient,
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Custom AppBar
                Padding(
                  padding: const EdgeInsets.all(Spacing.md),
                  child: Row(
                    children: [
                      // Animated Mascot Avatar
                      AnimatedBuilder(
                        animation: _breathingController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1.0 + (_breathingController.value * 0.1),
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: Spacing.shadowMd,
                              ),
                              child: const Center(
                                child: Text('🤖', style: TextStyle(fontSize: 32)),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: Spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi $_userName! 🎮',
                              style: GoogleFonts.fredoka(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Choose an app to play!',
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withOpacity(0.95),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Apps Grid - 4 Apps
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(Spacing.md),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: _approvedApps.length,
                      itemBuilder: (context, index) {
                        return _KidsAppCard(
                          app: _approvedApps[index],
                          onTap: () => _launchApp(_approvedApps[index]),
                          delay: index * 100,
                          isLarge: false,
                        );
                      },
                    ),
                  ),
                ),
                
                // Bottom Actions
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.md,
                      vertical: Spacing.sm,
                    ),
                    child: GlassCard(
                      blur: 10,
                      child: InkWell(
                        onTap: _showExitDialog,
                        borderRadius: BorderRadius.circular(Spacing.radiusMd),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.exit_to_app, color: Colors.white, size: 24),
                              const SizedBox(width: Spacing.sm),
                              Text(
                                'Exit Kids Mode',
                                style: GoogleFonts.fredoka(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // ONLY YOUTUBE - Single approved app
  final List<KidsApp> _approvedApps = [
    KidsApp('Camera', 'com.android.camera2', Icons.camera_alt, AppColors.kidsBlue),
    KidsApp('Gmail', 'com.google.android.gm', Icons.email, AppColors.kidsOrange),
    KidsApp('YouTube', 'com.google.android.youtube', Icons.play_circle_fill, AppColors.kidsOrange),
    KidsApp('Notes', 'com.google.android.keep', Icons.note, AppColors.kidsGreen),
  ];
}

class KidsApp {
  final String name;
  final String packageName;
  final IconData icon;
  final Color color;
  
  KidsApp(this.name, this.packageName, this.icon, this.color);
}

// Kids App Card Widget
class _KidsAppCard extends StatefulWidget {
  final KidsApp app;
  final VoidCallback onTap;
  final int delay;
  final bool isLarge;
  
  const _KidsAppCard({
    required this.app,
    required this.onTap,
    required this.delay,
    this.isLarge = false,
  });
  
  @override
  State<_KidsAppCard> createState() => __KidsAppCardState();
}

class __KidsAppCardState extends State<_KidsAppCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.elasticOut),
      ),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final size = widget.isLarge ? 200.0 : 80.0;
    final iconSize = widget.isLarge ? 100.0 : 40.0;
    final fontSize = widget.isLarge ? 28.0 : 17.0;
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            constraints: widget.isLarge 
                ? const BoxConstraints(maxWidth: 300, maxHeight: 300)
                : null,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(widget.isLarge ? Spacing.radiusXl : Spacing.radiusLg),
              boxShadow: Spacing.shadowLg,
            ),
            padding: EdgeInsets.all(widget.isLarge ? Spacing.xl : Spacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.app.color,
                        widget.app.color.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(widget.isLarge ? Spacing.radiusLg : Spacing.radiusMd),
                    boxShadow: [
                      BoxShadow(
                        color: widget.app.color.withOpacity(0.4),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.app.icon,
                    color: Colors.white,
                    size: iconSize,
                  ),
                ),
                SizedBox(height: widget.isLarge ? Spacing.lg : Spacing.sm),
                Text(
                  widget.app.name,
                  style: GoogleFonts.fredoka(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}