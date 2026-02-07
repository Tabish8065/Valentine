import 'package:flutter/animation.dart';

/// Shared animation constants used across the Valentine app.
/// Centralises durations and curves so the entire app feels cohesive.
class Anim {
  Anim._();

  // ── Durations ──────────────────────────────────────────────────────────────
  static const Duration fast = Duration(milliseconds: 300);
  static const Duration medium = Duration(milliseconds: 500);
  static const Duration slow = Duration(milliseconds: 800);
  static const Duration pageTransition = Duration(milliseconds: 450);
  static const Duration envelopeOpen = Duration(milliseconds: 700);
  static const Duration noteReveal = Duration(milliseconds: 1400);
  static const Duration cardFlip = Duration(milliseconds: 600);
  static const Duration heartBob = Duration(seconds: 3);
  static const Duration heartGlow = Duration(milliseconds: 1800);
  static const Duration fallingHearts = Duration(seconds: 14);
  static const Duration wiggle = Duration(milliseconds: 1200);
  static const Duration staggerDelay = Duration(milliseconds: 120);

  // ── Curves ─────────────────────────────────────────────────────────────────
  static const Curve defaultIn = Curves.easeInCubic;
  static const Curve defaultOut = Curves.easeOutCubic;
  static const Curve defaultInOut = Curves.easeInOutCubic;
  static const Curve bounce = Curves.easeOutBack;
  static const Curve gentle = Curves.easeInOutSine;
  static const Curve snap = Curves.fastOutSlowIn;
  static const Curve pageIn = Curves.easeOutCubic;
  static const Curve cardFlipCurve = Curves.easeInOutBack;
}
