import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/theme/app_theme.dart';

class DayIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  const DayIcon({super.key, required this.icon, required this.color});

  @override
  State<DayIcon> createState() => _DayIconState();
}

class _DayIconState extends State<DayIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _glow;
  late final Animation<double> _dropIn;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Anim.bounce),
    );

    _glow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    // Smooth drop from above.
    _dropIn = Tween<double>(begin: -80.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _dropIn.value),
            child: Transform.scale(
              scale: _scale.value,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withValues(
                        alpha: 0.55 * _glow.value,
                      ),
                      blurRadius: 22 * _glow.value,
                      spreadRadius: 2 * _glow.value,
                    ),
                    BoxShadow(
                      color: AppTheme.roseGold.withValues(
                        alpha: 0.2 * _glow.value,
                      ),
                      blurRadius: 36 * _glow.value,
                      spreadRadius: 4 * _glow.value,
                    ),
                  ],
                ),
                child: child,
              ),
            ),
          );
        },
        child: Icon(widget.icon, size: 64, color: widget.color),
      ),
    );
  }
}
