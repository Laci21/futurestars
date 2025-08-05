import 'package:flutter/material.dart';

/// Application-wide style constants and theme configurations
/// Consolidates colors, dimensions, text styles, and common UI patterns
class AppStyles {
  AppStyles._(); // Private constructor to prevent instantiation

  // === COLORS ===
  static const Color primaryBlue = Color(0xFF4A90E2);
  static const Color darkNavy = Color(0xFF1F2951);
  static const Color lightGold = Color(0xFFFFD700);
  static const Color lightPurple = Color(0xFFAEAFFC);
  
  // Background colors
  static const Color backgroundDark = Color(0xFF1A1D29);
  static const Color overlayDark = Color(0xFF0F1438);
  
  // === DIMENSIONS ===
  static const double buttonHeight = 56.0;
  static const double buttonRadius = 28.0;
  static const double standardPadding = 24.0;
  static const double smallPadding = 16.0;
  static const double largePadding = 40.0;
  
  // Oracle avatar
  static const double oracleAvatarSize = 50.0;
  
  // === ANIMATIONS ===
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  static const Duration fadeAnimation = Duration(seconds: 2);
  
  // === TEXT STYLES ===
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.24,
    color: Colors.white,
  );
  
  static const TextStyle ctaLabelStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
  
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white70,
  );
  
  // === COMMON DECORATIONS ===
  static BoxDecoration get circularButtonDecoration => BoxDecoration(
    shape: BoxShape.circle,
    color: darkNavy,
    boxShadow: [
      BoxShadow(
        color: overlayDark.withOpacity(0.8),
        blurRadius: 16,
        spreadRadius: 2,
        offset: const Offset(0, 6),
      ),
    ],
  );
  
  // === OPACITY VALUES ===
  static const double lowOpacity = 0.05;
  static const double mediumOpacity = 0.1;
  static const double highOpacity = 0.8;
  
  // === RESPONSIVE HELPERS ===
  static const double maxContentWidth = 400.0;
}