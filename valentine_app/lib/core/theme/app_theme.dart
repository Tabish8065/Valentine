import 'package:flutter/material.dart';

/// Centralised romantic theme palette.
///
/// The palette is built around deep rose, burgundy, rose-gold, and
/// warm champagne tones — designed to feel intimate, warm, and
/// irresistibly romantic.
class AppTheme {
  AppTheme._();

  // ── Primary & accent colours ─────────────────────────────────────────────
  static const Color primary = Color(0xFFC2185B); // Deep rose
  static const Color primaryLight = Color(0xFFE91E73); // Vibrant rose
  static const Color primaryDark = Color(0xFF880E4F); // Burgundy/wine

  // ── Rose-gold family ─────────────────────────────────────────────────────
  static const Color roseGold = Color(0xFFB76E79);
  static const Color roseGoldLight = Color(0xFFD4A0A7);
  static const Color roseGoldDark = Color(0xFF8E4A55);

  // ── Warm neutrals ────────────────────────────────────────────────────────
  static const Color champagne = Color(0xFFF7E7CE);
  static const Color warmCream = Color(0xFFFFF5EE);
  static const Color blush = Color(0xFFFFE4E9);
  static const Color softRose = Color(0xFFFFD1DC);
  static const Color deepCoral = Color(0xFFE74C6F);

  // ── Gold accents (for treasure / highlights) ─────────────────────────────
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFE8C547);
  static const Color goldDark = Color(0xFFBF9B30);

  // ── Text colours ─────────────────────────────────────────────────────────
  static const Color textDark = Color(0xFF3D0E21); // Deep wine
  static const Color textMedium = Color(0xFF5C1A34); // Warm burgundy
  static const Color textLight = Color(0xFF8E4A65); // Muted rose
  static const Color textOnPrimary = Color(0xFFFFF5F7); // Soft white-pink

  // ── Background gradients ─────────────────────────────────────────────────
  static const List<Color> backgroundGradient = [
    Color(0xFFFFF0F3), // lightest blush
    Color(0xFFFFE4EB), // warm pink
    Color(0xFFFFD6E0), // soft rose
  ];

  static const List<Color> homeGradient = [
    Color(0xFFFFF0F3),
    Color(0xFFFFDDE5),
  ];

  static const List<Color> valentineGradient = [
    Color(0xFFFFF5F0), // warm cream-blush
    Color(0xFFFFE8EF), // rose blush
    Color(0xFFFFF0E8), // peach glow
  ];

  static const List<Color> noteCardGradient = [
    Color(0xFFFFF8F2),
    Color(0xFFFFEDE3),
  ];

  // ── Paper / Note colours ─────────────────────────────────────────────────
  static const Color paperLight = Color(0xFFFFFBF5);
  static const Color paperDark = Color(0xFFF5E6D8);
  static const Color paperText = Color(0xFF5C2A1A);
  static const Color flourish = Color(0xFFB76E79); // rose-gold flourishes

  // ── Pin / Milestone colours ──────────────────────────────────────────────
  static const List<Color> pinGradient = [
    Color(0xFFE74C6F), // deep coral
    Color(0xFFC2185B), // deep rose
  ];

  // ── Dotted path / border ─────────────────────────────────────────────────
  static const Color pathColor = Color(0xFFD4A0A7); // rose-gold muted

  // ── Envelope colours ─────────────────────────────────────────────────────
  static const Color envelopeBody = Color(0xFFFFF8F5);
  static const Color envelopeShadow = Color(0xFF88344A);
  static const Color envelopeFlap = Color(0xFFFFE0E6);

  // ── Day-specific accent colours (richer, more romantic) ──────────────────
  static const Color roseDay = Color(0xFFE53E6B); // vivid rose
  static const Color proposeDay = Color(0xFFC2185B); // deep rose
  static const Color chocolateDay = Color(0xFF6D4C41); // warm chocolate
  static const Color teddyDay = Color(0xFF9C27B0); // rich purple
  static const Color promiseDay = Color(0xFFE91E73); // vibrant pink
  static const Color hugDay = Color(0xFFE57373); // warm coral
  static const Color kissDay = Color(0xFFD32F2F); // passionate red

  // ── Theme data ───────────────────────────────────────────────────────────
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: primary,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: roseGold,
      surface: warmCream,
    ),
    scaffoldBackgroundColor: const Color(0xFFFFF0F3),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: textDark),
      titleTextStyle: TextStyle(
        fontFamily: 'Handwritten',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textDark,
      ),
    ),
    textTheme: TextTheme(
      headlineSmall: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: textDark,
        letterSpacing: 0.3,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textDark,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: textMedium,
        height: 1.5,
      ),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: warmCream,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: textOnPrimary,
    ),
    useMaterial3: true,
  );
}
