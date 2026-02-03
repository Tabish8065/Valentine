import 'package:flutter/material.dart';

class Envelope extends StatefulWidget {
  final VoidCallback? onOpen;
  const Envelope({this.onOpen});

  @override
  State<Envelope> createState() => _EnvelopeState();
}

class _EnvelopeState extends State<Envelope> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _flapAnim;
  bool _opened = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _flapAnim = Tween<double>(begin: 0, end: -0.7).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (!_opened) {
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
      child: SizedBox(
        width: 220,
        height: 140,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // base envelope
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.only(top: 18),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10)]),
              ),
            ),
            // flap
            Positioned(
              top: 0,
              child: AnimatedBuilder(
                animation: _flapAnim,
                builder: (context, child) {
                  return Transform(
                    alignment: Alignment.topCenter,
                    transform: Matrix4.rotationX(_flapAnim.value)..translate(0.0, _flapAnim.value * 6),
                    child: child,
                  );
                },
                child: Container(
                  width: 220,
                  height: 80,
                  decoration: BoxDecoration(color: Colors.pink[50], borderRadius: const BorderRadius.vertical(top: Radius.circular(10))),
                  child: Center(child: Icon(_opened ? Icons.mark_email_read : Icons.mark_email_unread, color: Colors.pink[300])),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
