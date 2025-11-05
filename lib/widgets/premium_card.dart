import 'package:flutter/material.dart';
import '../theme/spacing.dart';
import '../theme/premium_colors.dart';

class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final Color? color;
  
  const PremiumCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.gradient,
    this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: color ?? AppColors.surface,
          gradient: gradient,
          borderRadius: BorderRadius.circular(Spacing.radiusMd),
          boxShadow: Spacing.shadowMd,
          border: Border.all(
            color: Colors.white.withOpacity(0.8),
            width: 1.5,
          ),
        ),
        child: child,
      ),
    );
  }
}
