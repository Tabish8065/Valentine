import 'package:flutter/material.dart';

class DayIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  const DayIcon({required this.icon, required this.color});

  @override
  State<DayIcon> createState() => _DayIconState();
}

class _DayIconState extends State<DayIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scale = Tween<double>(begin: 0.6, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _glow = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -80 * (1 - _scale.value)),
          child: Transform.scale(
            scale: _scale.value,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.6 * _glow.value),
                    blurRadius: 20 * _glow.value,
                  ),
                ],
              ),
              child: Icon(widget.icon, size: 64, color: widget.color),
            ),
          ),
        );
      },
    );
  }
}
