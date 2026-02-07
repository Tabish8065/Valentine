import 'dart:math';
import 'package:flutter/material.dart';
import '../core/constants.dart';

/// Particle data for a single falling heart.
class _Heart {
  final double x; // normalised 0‑1 horizontal position
  final double speed; // speed multiplier
  final double size; // base radius
  final double opacity; // base opacity
  final double drift; // horizontal sine‑wave amplitude (normalised)
  final double driftPhase; // phase offset for sine‑wave

  const _Heart({
    required this.x,
    required this.speed,
    required this.size,
    required this.opacity,
    required this.drift,
    required this.driftPhase,
  });
}

class FallingHearts extends StatefulWidget {
  final int count;
  const FallingHearts({super.key, this.count = 15});

  @override
  State<FallingHearts> createState() => _FallingHeartsState();
}

class _FallingHeartsState extends State<FallingHearts>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<_Heart> _hearts;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: Anim.fallingHearts)
      ..repeat();

    final rnd = Random(42);
    _hearts = List.generate(widget.count, (_) {
      return _Heart(
        x: rnd.nextDouble(),
        speed: 0.35 + rnd.nextDouble() * 0.65,
        size: 4.0 + rnd.nextDouble() * 5.0,
        opacity: 0.10 + rnd.nextDouble() * 0.22,
        drift: 0.008 + rnd.nextDouble() * 0.025,
        driftPhase: rnd.nextDouble() * 2 * pi,
      );
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // RepaintBoundary isolates the per‑frame repaint from the rest of the tree.
    return RepaintBoundary(
      child: Positioned.fill(
        child: IgnorePointer(
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (context, _) {
              return CustomPaint(
                painter: _HeartsPainter(_ctrl.value, _hearts),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HeartsPainter extends CustomPainter {
  final double t;
  final List<_Heart> hearts;
  _HeartsPainter(this.t, this.hearts);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var i = 0; i < hearts.length; i++) {
      final h = hearts[i];

      // Vertical progress with per‑particle speed.
      final progress = (t * h.speed + i * 0.07) % 1.0;

      // Gentle sine‑wave horizontal drift.
      final sineOffset = sin(progress * 4 * pi + h.driftPhase) * h.drift * size.width;
      final x = h.x * size.width + sineOffset;
      final y = progress * size.height;

      // Fade out near bottom edge for smooth wrapping.
      final fadeFactor = progress > 0.85 ? (1.0 - progress) / 0.15 : 1.0;
      // Fade in near top for smooth entry.
      final entryFactor = progress < 0.08 ? progress / 0.08 : 1.0;
      final alpha = (h.opacity * fadeFactor * entryFactor).clamp(0.0, 1.0);

      // Slight size shrink as particle falls further.
      final radius = h.size * (0.7 + 0.3 * (1 - progress));

      paint.color = Colors.pink.withValues(alpha: alpha);
      canvas.drawCircle(Offset(x, y), radius, paint);

      // Soft sparkle highlight.
      if (i % 3 == 0 && fadeFactor > 0.5) {
        paint.color = Colors.white.withValues(alpha: alpha * 0.45);
        canvas.drawCircle(
          Offset(x + radius * 0.6, y - radius * 0.5),
          radius * 0.22,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HeartsPainter old) => old.t != t;
}
