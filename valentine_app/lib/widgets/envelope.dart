import 'package:flutter/material.dart';
import '../core/constants.dart';

class Envelope extends StatefulWidget {
  final VoidCallback? onOpen;
  const Envelope({super.key, this.onOpen});

  @override
  State<Envelope> createState() => _EnvelopeState();
}

class _EnvelopeState extends State<Envelope>
    with TickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _flapAnim;

  late final AnimationController _scaleCtrl;
  late final Animation<double> _scaleAnim;

  bool _opened = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Anim.envelopeOpen,
    );
    _flapAnim = Tween<double>(begin: 0, end: -0.7).animate(
      CurvedAnimation(parent: _ctrl, curve: Anim.bounce),
    );

    // Subtle press feedback.
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: Anim.snap),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scaleCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (!_opened) {
      await _scaleCtrl.forward();
      await _scaleCtrl.reverse();
      setState(() => _opened = true);
      await _ctrl.forward();
      widget.onOpen?.call();
    } else {
      await _ctrl.reverse();
      setState(() => _opened = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnim.value, child: child);
        },
        child: SizedBox(
          width: 220,
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Base envelope.
              Positioned.fill(
                child: Container(
                  margin: const EdgeInsets.only(top: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
              // Flap.
              Positioned(
                top: 0,
                child: AnimatedBuilder(
                  animation: _flapAnim,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0.0, _flapAnim.value * 6),
                      child: Transform(
                        alignment: Alignment.topCenter,
                        transform: Matrix4.rotationX(_flapAnim.value),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    width: 220,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        _opened
                            ? Icons.mark_email_read
                            : Icons.mark_email_unread,
                        color: Colors.pink[300],
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
