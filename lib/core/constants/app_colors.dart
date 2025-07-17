import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color primaryLightColor = Color(0xFF9C94FF);
  static const Color primaryDarkColor = Color(0xFF4A47CC);

  // Secondary Colors
  static const Color secondaryColor = Color(0xFFFF6B6B);
  static const Color secondaryLightColor = Color(0xFFFF9999);
  static const Color secondaryDarkColor = Color(0xFFCC5555);

  // Background Colors
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);

  // Dark Theme Colors
  static const Color darkBackgroundColor = Color(0xFF1A1A1A);
  static const Color darkSurfaceColor = Color(0xFF2D2D2D);
  static const Color darkCardColor = Color(0xFF3A3A3A);

  // Text Colors
  static const Color textPrimaryColor = Color(0xFF2D3436);
  static const Color textSecondaryColor = Color(0xFF636E72);
  static const Color textLightColor = Color(0xFF9CA3AF);

  // Status Colors
  static const Color successColor = Color(0xFF00B894);
  static const Color warningColor = Color(0xFFFFB347);
  static const Color errorColor = Color(0xFFE17055);

  // Task Status Colors
  static const Color completedColor = Color(0xFF00B894);
  static const Color pendingColor = Color(0xFF6C63FF);
  static const Color overdueColor = Color(0xFFE17055);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryLightColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}