import 'package:flutter/material.dart';

/// Single source of truth for every color in the app.
/// Never hardcode a Color(...) inside a widget — add it here instead,
/// so light/dark theming and future rebranding stay a one-file change.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF2F6FED); // accent blue (buttons, links)
  static const Color success = Color(0xFF1FA971); // pass / correct
  static const Color error = Color(0xFFE0503A); // fail / incorrect
  static const Color warning = Color(0xFFF2A93B); // pending review

  // Light theme surfaces
  static const Color lightBackground = Color(0xFFF7F8FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE7E9EC);
  static const Color lightTextPrimary = Color(0xFF16181D);
  static const Color lightTextSecondary = Color(0xFF6B7280);

  // Dark theme surfaces (true dark grey, not pure black — easier on OLED glow)
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1F22);
  static const Color darkBorder = Color(0xFF2C2D30);
  static const Color darkTextPrimary = Color(0xFFEDEDED);
  static const Color darkTextSecondary = Color(0xFFA3A6AC);
}
