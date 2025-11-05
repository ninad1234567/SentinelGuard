import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/spacing.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final EdgeInsets? padding;
  
  const GlassCard({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.padding,
  });
  
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Spacing.radiusMd),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(Spacing.radiusMd),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
