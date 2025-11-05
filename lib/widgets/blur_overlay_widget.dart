import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class BlurOverlayWidget extends StatelessWidget {
  final Widget child;
  final bool isBlurred;
  final String? message;
  final VoidCallback? onTap;
  
  const BlurOverlayWidget({
    super.key,
    required this.child,
    this.isBlurred = true,
    this.message,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    if (!isBlurred) return child;
    
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: InkWell(
                  onTap: onTap,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.warning_amber_rounded,
                            size: 48,
                            color: AppColors.warningOrange,
                          ),
                        ),
                        if (message != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              message!,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
