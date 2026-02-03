import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/state/app_providers.dart';
import 'package:just_audio/just_audio.dart';

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
      final player = ref.read(audioPlayerProvider);
      player.stop();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final memories = List.generate(6, (i) => 'assets/images/valentine_memory${i + 1}.png');
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
            const Text(
              'I love you ♥',
              style: TextStyle(fontSize: 36, fontFamily: 'Handwritten', color: Colors.pink, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _JourneyPath extends StatelessWidget {
  final List<String> memories;
  const _JourneyPath({required this.memories});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(memories.length, (index) {
        final isOdd = index % 2 == 1;
        return Padding(
          padding: EdgeInsets.only(bottom: 48),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isOdd) ...[
                Expanded(child: SizedBox.shrink()),
                const SizedBox(width: 16),
              ],
              _PathNode(index: index, isOdd: isOdd),
              const SizedBox(width: 16),
              if (!isOdd)
                Expanded(child: SizedBox.shrink()),
              Expanded(
                child: _PhotoCard(imagePath: memories[index], index: index),
              ),
              if (isOdd)
                Expanded(child: SizedBox.shrink()),
            ],
          ),
        );
      }),
    );
  }
}

class _PathNode extends StatelessWidget {
  final int index;
  final bool isOdd;
  const _PathNode({required this.index, required this.isOdd});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Connector line above
        if (index > 0)
          SizedBox(
            height: 48,
            width: 2,
            child: CustomPaint(
              painter: _CurvePathPainter(isOdd: isOdd),
            ),
          ),
        // Node circle
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

class _PhotoCard extends StatefulWidget {
  final String imagePath;
  final int index;
  const _PhotoCard({required this.imagePath, required this.index});

  @override
  State<_PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<_PhotoCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _flipped = false;

  final List<String> _notes = [
    'Our first moment together...',
    'You made me smile that day 💕',
    'One of my favorite memories',
    'Your laugh is my favorite sound',
    'Every moment with you is special',
    'Forever starts with you',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
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
        animation: _controller,
        builder: (context, child) {
          final angle = _controller.value * 3.14159;
          final isBack = _controller.value > 0.5;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(3.14159),
                    child: _NoteCard(note: _notes[widget.index]),
                  )
                : _SquarePhotoCard(imagePath: widget.imagePath),
          );
        },
      ),
    );
  }
}

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
          border: Border.all(color: Colors.pink.withValues(alpha: 0.3), width: 2),
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
                const Text(
                  '💕',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

    // Curved path connecting nodes
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
