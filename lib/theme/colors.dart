import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Trust & Security
  static const Color primaryPurple = Color(0xFF6750A4);
  static const Color primaryPurpleLight = Color(0xFF9A82DB);
  static const Color primaryPurpleDark = Color(0xFF4A3780);
  
  // Secondary Colors - Growth & Safety
  static const Color secondaryTeal = Color(0xFF26A69A);
  static const Color secondaryTealLight = Color(0xFF64D8CB);
  static const Color secondaryTealDark = Color(0xFF00766C);
  
  // Tertiary Colors - Kids Mode
  static const Color tertiaryAmber = Color(0xFFFFA726);
  static const Color tertiaryAmberLight = Color(0xFFFFD95B);
  static const Color tertiaryAmberDark = Color(0xFFC77800);
  
  // Semantic Colors
  static const Color errorRed = Color(0xFFEF5350);
  static const Color successGreen = Color(0xFF66BB6A);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color infoBlue = Color(0xFF42A5F5);
  
  // Neutral Colors
  static const Color textPrimary = Color(0xFF1C1B1F);
  static const Color textSecondary = Color(0xFF49454F);
  static const Color textTertiary = Color(0xFF79747E);
  
  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF1C1B1F);
  static const Color darkSurface = Color(0xFF2B2930);
  static const Color darkTextPrimary = Color(0xFFE6E1E5);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPurple, primaryPurpleLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryTeal, secondaryTealLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient kidsGradient = LinearGradient(
    colors: [
      Color(0xFFFF9A9E),
      Color(0xFFFAD0C4),
      Color(0xFFFAD0C4),
      Color(0xFFFFD1FF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [
      Color(0xFFFFD700),
      Color(0xFFFFA500),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF6750A4),
    Color(0xFF26A69A),
    Color(0xFFFFA726),
    Color(0xFFEF5350),
    Color(0xFF42A5F5),
    Color(0xFF66BB6A),
    Color(0xFFFF9800),
    Color(0xFF9C27B0),
  ];
  
  // Risk Level Colors
  static const Color riskSafe = Color(0xFF66BB6A);
  static const Color riskWarning = Color(0xFFFF9800);
  static const Color riskBlocked = Color(0xFFEF5350);
}
