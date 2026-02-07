import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../core/constants.dart';
import '../../core/state/app_providers.dart';

class ValentinePage extends ConsumerStatefulWidget {
  const ValentinePage({super.key});

  @override
  ConsumerState<ValentinePage> createState() => _ValentinePageState();
}

class _ValentinePageState extends ConsumerState<ValentinePage> {
  @override
  void initState() {
    super.initState();
    final player = ref.read(audioPlayerProvider);
    () async {
      try {
        await player.setAsset('assets/audio/valentine.wav');
        player.setLoopMode(LoopMode.one);
        player.setVolume(0.3);
        player.play();
      } catch (_) {}
    }();
  }

  @override
  void dispose() {
    try {
      ref.read(audioPlayerProvider).stop();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final memories = List.generate(
      6,
      (i) => 'assets/images/valentine_memory${i + 1}.png',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Love Journey'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            const SizedBox(height: 16),
            _JourneyPath(memories: memories),
            const SizedBox(height: 48),
            const _FadeInText(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ── "I love you" text with fade‑in entrance ─────────────────────────────────
class _FadeInText extends StatefulWidget {
  const _FadeInText();

  @override
  State<_FadeInText> createState() => _FadeInTextState();
}

class _FadeInTextState extends State<_FadeInText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Anim.defaultIn);
    _slide = Tween<double>(begin: 20, end: 0).animate(
      CurvedAnimation(parent: _ctrl, curve: Anim.defaultOut),
    );
    // Delay so it appears after the journey path starts.
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _ctrl.forward();
    });
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
        return Opacity(
          opacity: _fade.value,
          child: Transform.translate(
            offset: Offset(0, _slide.value),
            child: child,
          ),
        );
      },
      child: const Text(
        'I love you \u2665',
        style: TextStyle(
          fontSize: 36,
          fontFamily: 'Handwritten',
          color: Colors.pink,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// ── Journey path with staggered photo card entrances ────────────────────────
class _JourneyPath extends StatelessWidget {
  final List<String> memories;
  const _JourneyPath({required this.memories});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(memories.length, (index) {
        final isOdd = index % 2 == 1;
        return Padding(
          padding: const EdgeInsets.only(bottom: 48),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isOdd) ...[
                const Expanded(child: SizedBox.shrink()),
                const SizedBox(width: 16),
              ],
              _PathNode(index: index, isOdd: isOdd),
              const SizedBox(width: 16),
              if (!isOdd) const Expanded(child: SizedBox.shrink()),
              Expanded(
                child: _StaggeredPhotoCard(
                  imagePath: memories[index],
                  index: index,
                ),
              ),
              if (isOdd) const Expanded(child: SizedBox.shrink()),
            ],
          ),
        );
      }),
    );
  }
}

// ── Staggered entrance wrapper for each photo card ──────────────────────────
class _StaggeredPhotoCard extends StatefulWidget {
  final String imagePath;
  final int index;
  const _StaggeredPhotoCard({required this.imagePath, required this.index});

  @override
  State<_StaggeredPhotoCard> createState() => _StaggeredPhotoCardState();
}

class _StaggeredPhotoCardState extends State<_StaggeredPhotoCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final Animation<double> _fade;
  late final Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: Anim.slow,
    );
    _fade = CurvedAnimation(parent: _entranceCtrl, curve: Anim.defaultIn);
    _slide = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(parent: _entranceCtrl, curve: Anim.defaultOut),
    );

    // Staggered delay based on card index.
    Future.delayed(Anim.staggerDelay * (widget.index + 1), () {
      if (mounted) _entranceCtrl.forward();
    });
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _entranceCtrl,
      builder: (context, child) {
        return Opacity(
          opacity: _fade.value,
          child: Transform.translate(
            offset: Offset(0, _slide.value),
            child: child,
          ),
        );
      },
      child: _PhotoCard(imagePath: widget.imagePath, index: widget.index),
    );
  }
}

// ── Path node ───────────────────────────────────────────────────────────────
class _PathNode extends StatelessWidget {
  final int index;
  final bool isOdd;
  const _PathNode({required this.index, required this.isOdd});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (index > 0)
          SizedBox(
            height: 48,
            width: 2,
            child: CustomPaint(
              painter: _CurvePathPainter(isOdd: isOdd),
            ),
          ),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.pink, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.pink.withValues(alpha: 0.4),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.pink,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Photo card with smooth eased flip ───────────────────────────────────────
class _PhotoCard extends StatefulWidget {
  final String imagePath;
  final int index;
  const _PhotoCard({required this.imagePath, required this.index});

  @override
  State<_PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<_PhotoCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curved;
  bool _flipped = false;

  final List<String> _notes = const [
    'Our first moment together...',
    'You made me smile that day \u{1F495}',
    'One of my favorite memories',
    'Your laugh is my favorite sound',
    'Every moment with you is special',
    'Forever starts with you',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Anim.cardFlip,
      vsync: this,
    );
    _curved = CurvedAnimation(
      parent: _controller,
      curve: Anim.cardFlipCurve,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    if (_flipped) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    _flipped = !_flipped;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFlip,
      child: AnimatedBuilder(
        animation: _curved,
        builder: (context, child) {
          final angle = _curved.value * pi;
          final isBack = _curved.value > 0.5;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: _NoteCard(note: _notes[widget.index]),
                  )
                : _SquarePhotoCard(imagePath: widget.imagePath),
          );
        },
      ),
    );
  }
}

// ── Square photo card ───────────────────────────────────────────────────────
class _SquarePhotoCard extends StatelessWidget {
  final String imagePath;
  const _SquarePhotoCard({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withValues(alpha: 0.3),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.pink[100],
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, size: 48, color: Colors.pink),
                    SizedBox(height: 8),
                    Text(
                      'Photo',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.pink),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Note card (flip back side) ──────────────────────────────────────────────
class _NoteCard extends StatelessWidget {
  final String note;
  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.pink.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withValues(alpha: 0.3),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  note,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Handwritten',
                    height: 1.6,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('\u{1F495}', style: TextStyle(fontSize: 24)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Curve path painter (static) ─────────────────────────────────────────────
class _CurvePathPainter extends CustomPainter {
  final bool isOdd;
  _CurvePathPainter({required this.isOdd});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.pink.withValues(alpha: 0.4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.cubicTo(
      size.width / 2,
      size.height / 3,
      size.width / 2,
      (2 * size.height) / 3,
      size.width / 2,
      size.height,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CurvePathPainter oldDelegate) => false;
}
