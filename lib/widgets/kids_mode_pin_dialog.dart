import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/premium_colors.dart';
import '../theme/spacing.dart';

class KidsModePinDialog extends StatefulWidget {
  final Function(String) onPinEntered;
  final VoidCallback? onBiometricTap;
  
  const KidsModePinDialog({
    super.key,
    required this.onPinEntered,
    this.onBiometricTap,
  });
  
  @override
  State<KidsModePinDialog> createState() => _KidsModePinDialogState();
}

class _KidsModePinDialogState extends State<KidsModePinDialog>
    with SingleTickerProviderStateMixin {
  String _enteredPin = '';
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  
  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }
  
  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }
  
  void _onNumberPressed(String number) {
    HapticFeedback.lightImpact();
    
    if (_enteredPin.length < 6) {
      setState(() {
        _enteredPin += number;
      });
      
      if (_enteredPin.length == 6) {
        Future.delayed(const Duration(milliseconds: 200), () {
          widget.onPinEntered(_enteredPin);
          _enteredPin = '';
          setState(() {});
        });
      }
    }
  }
  
  void _onDeletePressed() {
    HapticFeedback.mediumImpact();
    
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
      ),
      child: Container(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(Spacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(Spacing.radiusSm),
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    color: AppColors.warning,
                    size: 24,
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Parent PIN',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Enter your 6-digit PIN',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            
            const SizedBox(height: Spacing.xl),
            
            // PIN Display
            AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_shakeAnimation.value, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: 40,
                        height: 50,
                        decoration: BoxDecoration(
                          color: index < _enteredPin.length
                              ? AppColors.primary
                              : AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(Spacing.radiusSm),
                        ),
                        child: Center(
                          child: Text(
                            index < _enteredPin.length ? '•' : '',
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
            
            const SizedBox(height: Spacing.xl),
            
            // Number Pad
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              childAspectRatio: 1.5,
              mainAxisSpacing: Spacing.sm,
              crossAxisSpacing: Spacing.sm,
              children: [
                ...[1, 2, 3, 4, 5, 6, 7, 8, 9].map((number) {
                  return _NumberButton(
                    text: number.toString(),
                    onPressed: () => _onNumberPressed(number.toString()),
                  );
                }),
                const SizedBox(), // Empty space
                _NumberButton(
                  text: '0',
                  onPressed: () => _onNumberPressed('0'),
                ),
                _NumberButton(
                  icon: Icons.backspace_outlined,
                  onPressed: _onDeletePressed,
                ),
              ],
            ),
            
            const SizedBox(height: Spacing.md),
            
            // Biometric Option
            if (widget.onBiometricTap != null)
              Column(
                children: [
                  const Divider(),
                  const SizedBox(height: Spacing.sm),
                  InkWell(
                    onTap: widget.onBiometricTap,
                    borderRadius: BorderRadius.circular(Spacing.radiusSm),
                    child: Padding(
                      padding: const EdgeInsets.all(Spacing.md),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.fingerprint, color: AppColors.primary, size: 28),
                          const SizedBox(width: Spacing.sm),
                          Text(
                            'Use Fingerprint',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _NumberButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onPressed;
  
  const _NumberButton({
    this.text,
    this.icon,
    required this.onPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(Spacing.radiusSm),
          ),
          child: Center(
            child: text != null
                ? Text(
                    text!,
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  )
                : Icon(
                    icon,
                    color: AppColors.textSecondary,
                    size: 24,
                  ),
          ),
        ),
      ),
    );
  }
}
