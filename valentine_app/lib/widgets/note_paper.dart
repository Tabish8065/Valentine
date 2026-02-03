import 'package:flutter/material.dart';

class NotePaper extends StatefulWidget {
  final String? content;
  const NotePaper({super.key, this.content});

  @override
  State<NotePaper> createState() => _NotePaperState();
}

class _NotePaperState extends State<NotePaper> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _slideUpAnimation;
  late final Animation<double> _rotateAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _unfoldAnimation;
  late final Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    // Paper slides up from bottom as if coming out of envelope
    _slideUpAnimation = Tween<double>(begin: 80, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
    );

    // Initial rotation as paper emerges, then settles
    _rotateAnimation = Tween<double>(begin: 0.25, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic)),
    );

    // Scale up for prominence
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack)),
    );

    // Content unfold/reveal
    _unfoldAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.35, 1.0, curve: Curves.easeInOutCubic)),
    );

    // Fade in for smoothness
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.3, curve: Curves.easeIn)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideUpAnimation.value),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..scale(_scaleAnimation.value, _scaleAnimation.value)
              ..rotateZ(_rotateAnimation.value),
            child: Opacity(
              opacity: _fadeInAnimation.value,
              child: _VintagePaper(
                content: widget.content,
                unfoldProgress: _unfoldAnimation.value,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _VintagePaper extends StatelessWidget {
  final String? content;
  final double unfoldProgress;

  const _VintagePaper({
    required this.content,
    required this.unfoldProgress,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final paperHeight = screenHeight * 0.75;

    return SingleChildScrollView(
      child: Transform.translate(
        offset: Offset(0, (1 - unfoldProgress) * 40),
        child: Opacity(
          opacity: unfoldProgress.clamp(0.0, 1.0),
          child: Column(
            children: [
              // Torn paper effect wrapper
              ClipPath(
                clipper: _TornEdgesClipper(),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateZ((unfoldProgress - 0.5) * 0.05), // Slight rotation for organic feel
                  child: Container(
                    width: 280,
                    height: paperHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFFFBF0),
                          Color(0xFFEDE4D3),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 25,
                          spreadRadius: 6,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: Colors.brown.withValues(alpha: 0.1),
                          blurRadius: 15,
                          offset: const Offset(-5, 5),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Authentic paper texture
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _AuthenticPaperTexturePainter(),
                          ),
                        ),
                        // Aged stains and spots
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _PaperAgingPainter(),
                          ),
                        ),
                        // Main content
                        Positioned.fill(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 50 + (1 - unfoldProgress) * 25,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Decorative top flourish
                                  if (unfoldProgress > 0.3) ...[
                                    Opacity(
                                      opacity: ((unfoldProgress - 0.3) / 0.7).clamp(0.0, 1.0),
                                      child: Column(
                                        children: [
                                          const Text(
                                            '~ ✦ ~',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xFFAB7042),
                                              letterSpacing: 6,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            width: 60,
                                            height: 1.5,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.transparent,
                                                  Color(0xFFAB7042),
                                                  Colors.transparent,
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                  // Main handwritten content
                                  if (unfoldProgress > 0.5)
                                    Opacity(
                                      opacity: (unfoldProgress > 0.5
                                          ? ((unfoldProgress - 0.5) / 0.5).clamp(0.0, 1.0)
                                          : 0.0).clamp(0.0, 1.0),
                                      child: Text(
                                        content ?? 'My dearest Zainab,\n\nYou make every day special.\n\nLove,',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          height: 1.85,
                                          fontFamily: 'Handwritten',
                                          color: Color(0xFF6B4423),
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.3,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  // Decorative bottom flourish
                                  if (unfoldProgress > 0.7) ...[
                                    const SizedBox(height: 24),
                                    Opacity(
                                      opacity: ((unfoldProgress - 0.7) / 0.3).clamp(0.0, 1.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 1.5,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.transparent,
                                                  Color(0xFFAB7042),
                                                  Colors.transparent,
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            '~ ✦ ~',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xFFAB7042),
                                              letterSpacing: 6,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _TornEdgesClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final random = List<double>.generate(20, (i) => (i * 0.1 - 0.45) * 8);

    path.moveTo(0, 0);

    // Top edge - torn/jagged
    for (int i = 0; i < 10; i++) {
      final x = (i / 10) * size.width;
      final nextX = ((i + 1) / 10) * size.width;
      final y = random[i].abs() * 0.5;
      path.lineTo(x + (nextX - x) * 0.5, y);
      path.lineTo(nextX, y * 0.3);
    }

    // Right edge - torn/jagged
    path.lineTo(size.width, 0);
    for (int i = 0; i < 10; i++) {
      final y = (i / 10) * size.height;
      final nextY = ((i + 1) / 10) * size.height;
      final x = size.width - (random[i].abs() * 0.6);
      path.lineTo(x, y + (nextY - y) * 0.5);
      path.lineTo(x * 0.99, nextY);
    }

    // Bottom edge - torn/jagged
    path.lineTo(size.width, size.height);
    for (int i = 10; i > 0; i--) {
      final x = (i / 10) * size.width;
      final prevX = ((i - 1) / 10) * size.width;
      final y = size.height - (random[i].abs() * 0.5);
      path.lineTo(x - (x - prevX) * 0.5, y);
      path.lineTo(prevX, y * 0.995);
    }

    // Left edge - torn/jagged
    path.lineTo(0, size.height);
    for (int i = 10; i > 0; i--) {
      final y = (i / 10) * size.height;
      final prevY = ((i - 1) / 10) * size.height;
      final x = random[i].abs() * 0.6;
      path.lineTo(x, y - (y - prevY) * 0.5);
      path.lineTo(x * 1.01, prevY);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _AuthenticPaperTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Fine paper grain
    final grainPaint = Paint()
      ..color = Colors.brown.withValues(alpha: 0.02)
      ..strokeWidth = 0.5;

    for (int i = 0; i < 40; i++) {
      final y = (i * size.height) / 40;
      if (i % 2 == 0) {
        canvas.drawLine(
          Offset(0, y),
          Offset(size.width, y),
          grainPaint,
        );
      }
    }

    // Horizontal texture lines
    final linePaint = Paint()
      ..color = Colors.brown.withValues(alpha: 0.015)
      ..strokeWidth = 1;

    for (int i = 0; i < 30; i++) {
      final x = (i * size.width) / 30;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_AuthenticPaperTexturePainter oldDelegate) => false;
}

class _PaperAgingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final spotPaint = Paint()
      ..color = Colors.brown.withValues(alpha: 0.04);

    // Random aging spots throughout paper
    final spots = [
      (Offset(size.width * 0.15, size.height * 0.2), 12.0),
      (Offset(size.width * 0.8, size.height * 0.15), 8.0),
      (Offset(size.width * 0.2, size.height * 0.65), 10.0),
      (Offset(size.width * 0.85, size.height * 0.7), 14.0),
      (Offset(size.width * 0.3, size.height * 0.85), 9.0),
      (Offset(size.width * 0.7, size.height * 0.5), 11.0),
    ];

    for (final spot in spots) {
      canvas.drawCircle(spot.$1, spot.$2, spotPaint);
    }

    // Edge darkening (vignette effect)
    final edgePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.transparent,
          Colors.brown.withValues(alpha: 0.08),
        ],
        radius: 0.8,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), edgePaint);
  }

  @override
  bool shouldRepaint(_PaperAgingPainter oldDelegate) => false;
}
