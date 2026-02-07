import 'dart:math';
import 'package:flutter/material.dart';
import '../core/constants.dart';

class AnimatedEnvelope extends StatefulWidget {
  final VoidCallback? onOpen;
  final Color accentColor;
  const AnimatedEnvelope({
    super.key,
    this.onOpen,
    this.accentColor = Colors.pink,
  });

  @override
  State<AnimatedEnvelope> createState() => _AnimatedEnvelopeState();
}

class _AnimatedEnvelopeState extends State<AnimatedEnvelope>
    with TickerProviderStateMixin {
  late final AnimationController _openCtrl;
  late final Animation<double> _flapAnim;

  late final AnimationController _wiggleCtrl;
  late final CurvedAnimation _wiggleCurved;

  late final AnimationController _scaleCtrl;
  late final Animation<double> _scaleAnim;

  bool _opened = false;

  @override
  void initState() {
    super.initState();

    // Flap open with a satisfying overshoot.
    _openCtrl = AnimationController(
      vsync: this,
      duration: Anim.envelopeOpen,
    );
    _flapAnim = Tween<double>(begin: 0, end: -0.75).animate(
      CurvedAnimation(parent: _openCtrl, curve: Anim.bounce),
    );

    // Smooth sine‑wave wiggle (replaces the linear 400ms repeat).
    _wiggleCtrl = AnimationController(
      vsync: this,
      duration: Anim.wiggle,
    )..repeat();
    _wiggleCurved = CurvedAnimation(
      parent: _wiggleCtrl,
      curve: Anim.gentle,
    );

    // Subtle scale bounce on tap.
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: Anim.snap),
    );
  }

  @override
  void dispose() {
    _openCtrl.dispose();
    _wiggleCtrl.dispose();
    _scaleCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (!_opened) {
      // Scale‑down press feedback → scale back → open.
      await _scaleCtrl.forward();
      await _scaleCtrl.reverse();
      setState(() => _opened = true);
      _wiggleCtrl.stop();
      await _openCtrl.forward();
      widget.onOpen?.call();
    } else {
      await _openCtrl.reverse();
      _wiggleCtrl.repeat();
      setState(() => _opened = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_wiggleCurved, _scaleAnim]),
        builder: (context, child) {
          // Smooth sine‑based wiggle.
          final wiggle = _opened
              ? 0.0
              : sin(_wiggleCurved.value * 2 * pi) * 0.045;
          return Transform.scale(
            scale: _scaleAnim.value,
            child: Transform.rotate(angle: wiggle, child: child),
          );
        },
        child: SizedBox(
          width: 240,
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Base envelope body.
              Positioned.fill(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                ),
              ),
              // Flap with smooth 3D rotation.
              Positioned(
                top: 0,
                child: AnimatedBuilder(
                  animation: _flapAnim,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0.0, _flapAnim.value * 8),
                      child: Transform(
                        alignment: Alignment.topCenter,
                        transform: Matrix4.rotationX(_flapAnim.value),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    width: 240,
                    height: 90,
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(alpha: 0.15),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      border: Border.all(
                        color: widget.accentColor.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        _opened ? Icons.mark_email_read : Icons.mail,
                        color: widget.accentColor,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
