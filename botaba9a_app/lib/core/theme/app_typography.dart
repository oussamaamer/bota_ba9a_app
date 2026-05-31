import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// BOTABA9A Design System — Typography
///
/// - Poppins: Headlines, KPIs, and emphasis
/// - Inter: Body text and UI elements
/// - JetBrains Mono: Technical/numerical values
class AppTypography {
  AppTypography._();

  // ── Headlines (Poppins Bold) ─────────────────────────────
  static TextStyle headlineLarge = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static TextStyle headlineMedium = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static TextStyle headlineSmall = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // ── KPI Values (Poppins Bold) ────────────────────────────
  static TextStyle kpiLarge = GoogleFonts.poppins(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.1,
  );

  static TextStyle kpiMedium = GoogleFonts.poppins(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.1,
  );

  static TextStyle kpiSmall = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // ── Body (Inter) ─────────────────────────────────────────
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // ── Labels (Inter Medium) ────────────────────────────────
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.5,
  );

  // ── Technical Values (JetBrains Mono) ────────────────────
  static TextStyle monoLarge = GoogleFonts.jetBrainsMono(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static TextStyle monoMedium = GoogleFonts.jetBrainsMono(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static TextStyle monoSmall = GoogleFonts.jetBrainsMono(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  // ── Button (Inter SemiBold) ──────────────────────────────
  static TextStyle buttonLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  static TextStyle buttonMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );
}
