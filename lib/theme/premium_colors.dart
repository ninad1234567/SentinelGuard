import 'package:flutter/material.dart';

class AppColors {
  // Primary - Trust & Security (Soft Purple)
  static const primary = Color(0xFF7C6FDC);
  static const primaryLight = Color(0xFFB8AEFF);
  static const primaryDark = Color(0xFF5541D7);
  
  // Secondary - Growth & Safety (Calm Teal)
  static const secondary = Color(0xFF4ECDC4);
  static const secondaryLight = Color(0xFF8EEAE4);
  static const secondaryDark = Color(0xFF24A19C);
  
  // Kids Mode (Playful & Friendly)
  static const kidsYellow = Color(0xFFFFC857);
  static const kidsOrange = Color(0xFFFF8B5A);
  static const kidsPink = Color(0xFFFF6B9D);
  static const kidsBlue = Color(0xFF6BAAFF);
  static const kidsGreen = Color(0xFF6BCF8E);
  
  // Neutrals (Soft & Warm)
  static const background = Color(0xFFF8F9FE);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF3F4F8);
  static const textPrimary = Color(0xFF2D3142);
  static const textSecondary = Color(0xFF6B7280);
  static const textTertiary = Color(0xFF9CA3AF);
  
  // Functional Colors
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const info = Color(0xFF3B82F6);
  
  // Gradients
  static const parentGradient = LinearGradient(
    colors: [Color(0xFF7C6FDC), Color(0xFF4ECDC4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const kidsGradient = LinearGradient(
    colors: [Color(0xFFFFC857), Color(0xFFFF8B5A), Color(0xFFFF6B9D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const premiumGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
