import 'package:flutter/material.dart';

/// AppColours tailored for MathMatric.
/// Combines an ultra-clean, low-strain study canvas with high-energy 
/// accents built for matriculants tackling past papers and quizzes.
class AppColours {
  // --- Workspace & Canvas Backgrounds ---
  static const background = Color(0xFFF1F5F9);       // Crisp ice-slate background for zero eye strain
  static const surface = Color(0xFFFFFFFF);          // Pure white for past paper cards & quiz containers
  static const surfaceSecondary = Color(0xFFE2E8F0); // Subtle tint for hover, search inputs, & chips
  static const surfaceElevated = Color(0xFFF8FAFC);  // Soft contrast for secondary section cards

  // --- MathMatric Signature Gradient Tones ---
  static const cobaltBlue = Color(0xFF2563EB);       // Deep electric blue for focus & confidence
  static const electricViolet = Color(0xFF7C3AED);   // Vibrant purple for high achievement & streaks
  static const neonCoral = Color(0xFFF43F5E);       // High-energy accent for CTA highlights & badges

  // --- Core UI Interactive Accents ---
  static const primaryAccent = Color(0xFF3B82F6);    // Main buttons, active navigation, paper selectors
  static const secondaryAccent = Color(0xFF8B5CF6);  // Secondary actions, tag pills, mark allocators

  // --- Quiz & Assessment Feedback (Automated Grading) ---
  static const correctGreen = Color(0xFF10B981);     // Correct answer highlights & passed paper indicators
  static const warningAmber = Color(0xFFF59E0B);     // Quiz timer ticking, flagged questions, hints
  static const errorRed = Color(0xFFEF4444);         // Incorrect answer highlights & review alerts

  // --- Typography (Optimized for High-Density Formulas & Text) ---
  static const textPrimary = Color(0xFF0F172A);      // Deep slate-black for maximum formula contrast
  static const textSecondary = Color(0xFF475569);    // Mid-tone grey for exam metadata (Year, Marks, Time)
  static const textMuted = Color(0xFF94A3B8);        // Subtext, placeholder hints, disabled states

  // --- Structural & Ambient Glow Effects ---
  static const border = Color(0xFFE2E8F0);           // Fine divider borders between paper items
  static const ambientGlow = Color(0x1A3B82F6);      // Soft blue glow for top score cards & active focus

  // --- MathMatric Gradients ---
  static const List<Color> mathMatricGradientColors = [
    cobaltBlue,
    electricViolet,
    neonCoral,
  ];

  // Signature vibrant gradient for primary badges, streak meters, & top headers
  static const Gradient mathMatricGradient = LinearGradient(
    colors: mathMatricGradientColors,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  //Ultra-soft ambient gradient for quiz result cards and hero background banners
  static const Gradient softHeaderGradient = LinearGradient(
    colors: [
      Color(0xFFE0F2FE),
      Color(0xFFEFF6FF),
      Color(0xFFF5F3FF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
