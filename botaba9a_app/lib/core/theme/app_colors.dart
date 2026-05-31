import 'dart:ui';

/// BOTABA9A Design System — Color Palette
///
/// Professional IoT monitoring color system designed for
/// clear status communication and premium aesthetics.
class AppColors {
  AppColors._();

  // ── Primary ──────────────────────────────────────────────
  static const Color primaryNavy = Color(0xFF1A3C5E);
  static const Color primaryNavyLight = Color(0xFF2A5580);
  static const Color primaryNavyDark = Color(0xFF0F2640);

  // ── Accent ───────────────────────────────────────────────
  static const Color accentOrange = Color(0xFFE8761A);
  static const Color accentOrangeLight = Color(0xFFF09040);
  static const Color accentOrangeDark = Color(0xFFC05E10);

  // ── Status Colors ────────────────────────────────────────
  static const Color success = Color(0xFF1E7D4F);
  static const Color successLight = Color(0xFF2DA366);
  static const Color danger = Color(0xFFB32626);
  static const Color dangerLight = Color(0xFFD44040);
  static const Color warning = Color(0xFFB07D00);
  static const Color warningLight = Color(0xFFD4A020);

  // ── Surfaces — Light Mode ────────────────────────────────
  static const Color surfaceLight = Color(0xFFF5F7FA);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF0F2F5);

  // ── Surfaces — Dark Mode ─────────────────────────────────
  static const Color surfaceDark = Color(0xFF0F1923);
  static const Color cardDark = Color(0xFF1A2836);
  static const Color backgroundDark = Color(0xFF0A1219);

  // ── Text Colors ──────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1F36);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textOnDark = Color(0xFFE5E7EB);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Gas Gauge Colors ─────────────────────────────────────
  static const Color gaugeFull = Color(0xFF1E7D4F);
  static const Color gaugeGood = Color(0xFF3BA55D);
  static const Color gaugeAttention = Color(0xFFE8A317);
  static const Color gaugeLow = Color(0xFFE87C1A);
  static const Color gaugeCritical = Color(0xFFB32626);
  static const Color gaugeEmpty = Color(0xFF6B7280);
  static const Color gaugeBackground = Color(0xFFE5E7EB);
  static const Color gaugeBackgroundDark = Color(0xFF2A3A4A);

  // ── Misc ─────────────────────────────────────────────────
  static const Color divider = Color(0xFFE5E7EB);
  static const Color dividerDark = Color(0xFF2A3A4A);
  static const Color shimmer = Color(0xFFE5E7EB);
  static const Color overlay = Color(0x80000000);
}
