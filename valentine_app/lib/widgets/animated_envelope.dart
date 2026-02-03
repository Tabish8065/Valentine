import 'package:flutter/material.dart';

class AnimatedEnvelope extends StatefulWidget {
  final VoidCallback? onOpen;
  final Color accentColor;
  const AnimatedEnvelope({this.onOpen, this.accentColor = Colors.pink});

  @override
  State<AnimatedEnvelope> createState() => _AnimatedEnvelopeState();
}

class _AnimatedEnvelopeState extends State<AnimatedEnvelope> with SingleTickerProviderStateMixin {
  late final AnimationController _openCtrl;
  late final AnimationController _wiggleCtrl;
  late final Animation<double> _flapAnim;
  bool _opened = false;

  @override
  void initState() {
    super.initState();
    _openCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _flapAnim = Tween<double>(begin: 0, end: -0.75).animate(CurvedAnimation(parent: _openCtrl, curve: Curves.easeOutBack));
    
    _wiggleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400))..repeat();
  }

  @override
  void dispose() {
    _openCtrl.dispose();
    _wiggleCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (!_opened) {
      setState(() => _opened = true);
      _wiggleCtrl.stop();
      await _openCtrl.forward();
      widget.onOpen?.call();
    } else {
      _wiggleCtrl.forward();
      await _openCtrl.reverse();
      setState(() => _opened = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _wiggleCtrl,
        builder: (context, child) {
          final wiggle = _opened ? 0.0 : ((_wiggleCtrl.value - 0.5).abs() - 0.5) * 0.08;
          return Transform.rotate(angle: wiggle, child: child);
        },
        child: SizedBox(
          width: 240,
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // base envelope
              Positioned.fill(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 12)],
                  ),
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
                      transform: Matrix4.rotationX(_flapAnim.value)..translate(0.0, _flapAnim.value * 8),
                      child: child,
                    );
                  },
                  child: Container(
                    width: 240,
                    height: 90,
                    decoration: BoxDecoration(
                      color: widget.accentColor.withOpacity(0.15),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      border: Border.all(color: widget.accentColor.withOpacity(0.3), width: 1),
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
