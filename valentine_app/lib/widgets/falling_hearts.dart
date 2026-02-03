import 'dart:math';
import 'package:flutter/material.dart';

class FallingHearts extends StatefulWidget {
  final int count;
  const FallingHearts({super.key, this.count = 18});

  @override
  State<FallingHearts> createState() => _FallingHeartsState();
}

class _FallingHeartsState extends State<FallingHearts> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<double> _xOffsets;
  late final List<double> _speed;
  final _rnd = Random(42);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
    _xOffsets = List.generate(widget.count, (_) => _rnd.nextDouble());
    _speed = List.generate(widget.count, (_) => 0.4 + _rnd.nextDouble() * 1.4);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            return CustomPaint(
              painter: _HeartsPainter(_ctrl.value, _xOffsets, _speed),
            );
          },
        ),
      ),
    );
  }
}

class _HeartsPainter extends CustomPainter {
  final double t;
  final List<double> xs;
  final List<double> speed;
  _HeartsPainter(this.t, this.xs, this.speed);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < xs.length; i++) {
      final x = xs[i] * size.width;
      final progress = (t * speed[i]) % 1.0;
      final y = progress * size.height;
      final scale = 0.6 + 0.8 * (1 - progress);
      final radius = 6.0 * scale + (i % 3) * 1.5;
      paint.color = Colors.pink.withOpacity(0.18 + (i % 4) * 0.08);
      canvas.drawCircle(Offset(x, y), radius, paint);
      // small sparkle
      if ((i + (t * 1000).toInt()) % 17 == 0) {
        paint.color = Colors.white.withOpacity(0.4);
        canvas.drawCircle(Offset(x + radius, y - radius * 0.6), radius * 0.25, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HeartsPainter old) => old.t != t;
}
