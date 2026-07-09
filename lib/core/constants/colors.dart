import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

  // Primary Theme Colors (IMDb-like cinematic dark theme)
  static const Color background = Color(0xFF0F0F13);
  static const Color cardBackground = Color(0xFF1C1C24);
  static const Color primary = Color(0xFFE50914); // Cinematic Red Accent
  static const Color secondary = Color(0xFFF5C518); // Golden highlights
  
  // Neutral Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E9F);
  static const Color border = Color(0xFF2C2C35);
  static const Color error = Color(0xFFCF6679);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
}
